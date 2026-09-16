// Deterministic composition of multiple independent vertical streams.

#import "paginate.typ": paginate
#import "page.typ": render-column, column-ruby-overhang
#import "metrics.typ": prepare-layout, column-width

#let column-source-end(column) = {
    let consumed = 0
    for token in column {
        if "source-index" in token {
            consumed = calc.max(consumed, token.at("source-index") + 1)
        }
    }
    consumed
}

// A cursor may finish on an empty structural line (for example after trailing
// paragraph breaks). Store the greatest source endpoint seen so far, rather
// than each line's local endpoint, so such a line cannot reset a completed
// stream back to source index zero on its continuation page.
#let cumulative-source-ends(columns) = {
    let ends = ()
    let consumed = 0
    for column in columns {
        consumed = calc.max(consumed, column-source-end(column))
        ends.push(consumed)
    }
    ends
}

#let prepare-queues(streams, height) = streams.map(
    stream => {
        let prepared = prepare-layout(stream.tokens, stream.config, usable-height: height)
        let columns = paginate(prepared.tokens, height, prepared.config, paragraph-start: stream.at("paragraph-start", default: true))
        let protect = (
            prepared.config.layout.at("orphan-lines", default: 1) > 1 or prepared.config.layout.at("widow-lines", default: 1) > 1
        )
        let line-meta = columns.map(_ => none)
        if protect {
            // Lines retain monotonically increasing source indices, so paragraph
            // ownership can be recovered with one merge-like pass. Avoid a dictionary
            // entry and string conversion for every source token: that cost dominated
            // long plain-prose streams.
            let breaks = prepared.tokens
            .filter(token => token.type == "parbreak")
            .map(token => token.at("source-index"))
            let paragraph = 0
            let next-break = 0
            let paragraph-ids = ()
            for column in columns {
                let source-index = none
                for token in column {
                    if (not token.at("synthetic", default: false) and token.type != "heading-anchor" and "source-index" in token) {
                        source-index = token.at("source-index")
                        break
                    }
                }
                if source-index == none {
                    paragraph-ids.push(none)
                    continue
                }
                while next-break < breaks.len() and breaks.at(next-break) < source-index {
                    paragraph += 1
                    next-break += 1
                }
                paragraph-ids.push(paragraph)
            }
            let totals = range(breaks.len() + 1).map(_ => 0)
            for id in paragraph-ids {
                if id != none { totals.at(id) += 1 }
            }
            let seen = totals.map(_ => 0)
            line-meta = ()
            for id in paragraph-ids {
                if id == none {
                    line-meta.push(none)
                } else {
                    let index = seen.at(id)
                    seen.at(id) += 1
                    line-meta.push((paragraph: id, index: index, total: totals.at(id)))
                }
            }
        }
        (
            source: prepared.tokens,
            config: prepared.config,
            columns: columns,
            // Cursors consume whole vertical lines. Retain their cumulative source
            // endpoints so continuation pages do not rescan rendered tokens or revive
            // a completed stream after an empty structural line.
            source-ends: cumulative-source-ends(columns),
            widths: columns.map(col => column-width(col, prepared.config)),
            ruby-overhangs: columns.map(column-ruby-overhang),
            line-meta: line-meta,
            line-gap: measure(h(prepared.config.layout.gap)).width,
        )
    },
)

#let queues-done(queues, cursors) = {
    for (index, queue) in queues.enumerate() {
        if cursors.at(index) < queue.columns.len() { return false }
    }
    true
}

#let take-cell(
    queues,
    cursors,
    height,
    width,
    stream-gap,
    overhang-threshold,
    render: true,
    guard-boundary: false,
    allow-empty-rollback: false,
) = {
    let selected = ()
    let used = 0pt
    let stopped = false
    let admitted-overhang = false
    let previous-stream = none

    for (stream-index, queue) in queues.enumerate() {
        if stopped { break }
        let cursor = cursors.at(stream-index)
        while cursor < queue.columns.len() {
            let boundary = if selected.len() == 0 { 0pt } else {
                calc.max(if previous-stream == stream-index { queue.line-gap } else { stream-gap }, queue.ruby-overhangs.at(cursor))
            }
            let addition = boundary + queue.widths.at(cursor)
            if selected.len() > 0 and used + addition > width {
                let residual = calc.max(0pt, width - used)
                if admitted-overhang or residual < overhang-threshold {
                    stopped = true
                    break
                }
                admitted-overhang = true
            }
            if selected.len() == 0 and addition > width {
                panic("basho: one vertical line is wider than the available region")
            }
            selected.push((
                column: queue.columns.at(cursor),
                width: queue.widths.at(cursor),
                config: queue.config,
                stream-index: stream-index,
                line-meta: queue.line-meta.at(cursor),
                gap-before: boundary,
            ))
            cursors.at(stream-index) = cursor + 1
            cursor += 1
            used += addition
            previous-stream = stream-index
            if admitted-overhang {
                stopped = true
                break
            }
        }
    }

    if guard-boundary and selected.len() > 0 {
        let last = selected.last()
        let meta = last.line-meta
        let queue = queues.at(last.stream-index)
        let cursor = cursors.at(last.stream-index)
        let next-meta = if cursor < queue.columns.len() {
            queue.line-meta.at(cursor)
        } else { none }
        if (meta != none and next-meta != none and meta.paragraph == next-meta.paragraph) {
            let suffix = 0
            for entry in selected.rev() {
                if (
                    entry.stream-index == last.stream-index and entry.line-meta != none and entry.line-meta.paragraph == meta.paragraph
                ) {
                    suffix += 1
                } else { break }
            }
            let remaining = meta.total - meta.index - 1
            let widow-lines = queue.config.layout.at("widow-lines", default: 2)
            let orphan-lines = queue.config.layout.at("orphan-lines", default: 2)
            let rollback = if remaining > 0 and remaining < widow-lines {
                calc.min(suffix, widow-lines - remaining)
            } else { 0 }
            let begins-here = (suffix > 0 and selected.at(selected.len() - suffix).line-meta.index == 0)
            if begins-here and suffix - rollback < orphan-lines {
                rollback = suffix
            }
            if rollback > 0 and (allow-empty-rollback or rollback < selected.len()) {
                for _ in range(rollback) {
                    let removed = selected.pop()
                    cursors.at(removed.stream-index) -= 1
                    used -= removed.gap-before + removed.width
                }
            }
        }
    }

    let rendered = if render {
        let output = ()
        for (index, entry) in selected.enumerate() {
            let gap-after = if index + 1 < selected.len() {
                selected.at(index + 1).gap-before
            } else { 0pt }
            output.push(
                box(width: entry.width + gap-after, height: height, align(right + top, render-column(entry.column, entry.config))),
            )
        }
        output
    } else { () }
    (content: if render {
        text(
            lang: "und",
            features: (jsvm: 1),
            box(width: width, height: height, align(right + top, stack(dir: rtl, spacing: 0pt, ..rendered))),
        )
    } else { none }, cursors: cursors)
}

#let take-grid(
    queues,
    cursors,
    height,
    width,
    columns,
    rows,
    column-gap,
    row-gap,
    stream-gap,
    overhang-threshold,
    render: true,
    allow-empty-rollback: false,
) = {
    let cell-width = (width - (columns - 1) * column-gap) / columns
    let cell-height = (height - (rows - 1) * row-gap) / rows
    if cell-width <= 0pt or cell-height <= 0pt {
        panic("basho: shared vertical grid gutters leave no usable region")
    }
    let logical = ()
    let cell-count = columns * rows
    for cell-index in range(cell-count) {
        if queues-done(queues, cursors) { break }
        let cell = take-cell(
            queues,
            cursors,
            cell-height,
            cell-width,
            stream-gap,
            overhang-threshold,
            render: render,
            guard-boundary: cell-index + 1 == cell-count,
            allow-empty-rollback: allow-empty-rollback or cell-index > 0,
        )
        logical.push(cell.content)
        cursors = cell.cursors
    }
    let used-rows = calc.max(1, calc.ceil(logical.len() / columns))
    let cells = if render {
        let output = ()
        for row in range(used-rows) {
            let start = row * columns
            let count = calc.max(0, calc.min(columns, logical.len() - start))
            for _ in range(columns - count) {
                output.push([])
            }
            if count > 0 {
                for cell in logical.slice(start, start + count).rev() {
                    output.push(cell)
                }
            }
        }
        output
    } else { () }
    let used-height = used-rows * cell-height + calc.max(0, used-rows - 1) * row-gap
    (content: if render {
        box(width: width, height: used-height, grid(
            columns: range(columns).map(_ => cell-width),
            rows: range(used-rows).map(_ => cell-height),
            column-gutter: column-gap,
            row-gutter: row-gap,
            ..cells,
        ))
    } else { none }, cursors: cursors)
}

#let fitted-row-count(available, full-height, rows, row-gap, threshold) = {
    let nominal-cell = (full-height - (rows - 1) * row-gap) / rows
    let nominal = (available + row-gap) / (nominal-cell + row-gap)
    if available >= full-height {
        rows
    } else {
        calc.min(rows, calc.max(1, calc.ceil(nominal / threshold)))
    }
}

/// Each distinct row height is paginated once. Continuation pages consume
/// stored column cursors; already prepared text is never flattened or measured
/// again.
#let layout-tate-regions(
    streams,
    height,
    full-height,
    width,
    stream-gap,
    columns,
    rows,
    column-gap,
    row-gap,
    row-fit-threshold,
    line-overhang-threshold,
    part: "all",
) = context {
    if not (part in ("all", "first", "rest")) {
        panic("basho: vertical region part must be \"all\", \"first\", or \"rest\"")
    }
    let active = streams.filter(stream => stream.tokens.len() > 0)
    if active.len() == 0 { return [] }
    let minimum-height = calc.max(..active.map(stream => measure(box(height: stream.config.sizing.char-box)).height))
    if height < minimum-height {
        if part == "first" { return [] }
        let continuation = layout-tate-regions(
            active,
            full-height,
            full-height,
            width,
            stream-gap,
            columns,
            rows,
            column-gap,
            row-gap,
            row-fit-threshold,
            line-overhang-threshold,
            part: "all",
        )
        return if part == "all" {
            colbreak(weak: true) + continuation
        } else {
            continuation
        }
    }
    let column-gap = measure(h(column-gap)).width
    let row-gap = measure(v(row-gap)).height
    let stream-gap = measure(h(stream-gap)).width
    let overhang = measure(h(line-overhang-threshold)).width
    let first-rows = fitted-row-count(height, full-height, rows, row-gap, row-fit-threshold)
    let first-cell-height = (height - (first-rows - 1) * row-gap) / first-rows
    let full-cell-height = (full-height - (rows - 1) * row-gap) / rows
    let pages = ()

    let first-queues = prepare-queues(active, first-cell-height)
    let first-cursors = first-queues.map(_ => 0)
    let first = take-grid(
        first-queues,
        first-cursors,
        height,
        width,
        columns,
        first-rows,
        column-gap,
        row-gap,
        stream-gap,
        overhang,
        render: part != "rest",
        allow-empty-rollback: height < full-height,
    )
    if part != "rest" { pages.push(first.content) }

    let remaining = ()
    for (index, stream) in active.enumerate() {
        let queue = first-queues.at(index)
        let count = first.cursors.at(index)
        if count > queue.columns.len() {
            panic("basho: shared vertical paginator produced an invalid stream cursor")
        }
        // Reaching the final prepared line is authoritative completion. The
        // source can still contain trailing newline/parbreak tokens, but they do
        // not represent printable continuation content.
        if count == queue.columns.len() { continue }
        let consumed = if count == 0 { 0 } else { queue.source-ends.at(count - 1) }
        // Preserve the source-paragraph boundary while discarding structural
        // break tokens. A physical surface break by itself is not a paragraph.
        let paragraph-start = if consumed == 0 {
            stream.at("paragraph-start", default: true)
        } else { false }
        while consumed < queue.source.len() and queue.source.at(consumed).type in ("newline", "parbreak",) {
            if queue.source.at(consumed).type == "parbreak" {
                paragraph-start = true
            }
            consumed += 1
        }
        if consumed < queue.source.len() {
            remaining.push((tokens: queue.source.slice(consumed), config: stream.config, paragraph-start: paragraph-start))
        }
    }

    if part == "first" {
        return pages.sum(default: [])
    }

    if remaining.len() > 0 {
        let queues = prepare-queues(remaining, full-cell-height)
        let cursors = queues.map(_ => 0)
        while not queues-done(queues, cursors) {
            let page = take-grid(queues, cursors, full-height, width, columns, rows, column-gap, row-gap, stream-gap, overhang)
            pages.push(page.content)
            if page.cursors == cursors { panic("basho: shared vertical paginator made no progress") }
            cursors = page.cursors
        }
    }

    pages.sum(default: [])
}
