// Deterministic prepare–paginate–render entry point for one vertical stream.

#import "paginate.typ": paginate
#import "page.typ": render-page, column-ruby-overhang
#import "metrics.typ": prepare-layout, column-width

#let margin-value(primary, alternate, axis) = if type(page.margin) == dictionary {
  if primary in page.margin { page.margin.at(primary) } else if alternate in page.margin {
    page.margin.at(alternate)
  } else if axis in page.margin { page.margin.at(axis) } else { 0pt }
} else { page.margin }

#let resolve-relative(value, available, axis) = if value == auto {
  available
} else if type(value) == ratio {
  available * value
} else if axis == "x" {
  measure(box(width: value)).width
} else {
  measure(box(height: value)).height
}

#let consumed-source(columns) = {
  let consumed = 0
  for col in columns {
    for token in col {
      if "source-index" in token {
        consumed = calc.max(consumed, token.at("source-index") + 1)
      }
    }
  }
  consumed
}

#let column-boundary-gaps(lines, line-gap) = {
  let gaps = ()
  for (index, line) in lines.enumerate() {
    gaps.push(if index == 0 { 0pt } else {
      calc.max(line-gap, column-ruby-overhang(line))
    })
  }
  gaps
}

#let pack-regions(columns, widths, boundary-gaps, start, capacity, region-width, overhang-threshold) = {
  let regions = ()
  let index = start
  while index < columns.len() and regions.len() < capacity {
    let region-start = index
    let used = 0pt
    let admitted-overhang = false
    while index < columns.len() {
      let add = widths.at(index) + if index == region-start { 0pt } else {
        boundary-gaps.at(index)
      }
      if index > region-start and used + add > region-width {
        let residual = calc.max(0pt, region-width - used)
        if admitted-overhang or residual < overhang-threshold { break }
        admitted-overhang = true
      }
      used += add
      index += 1
      if admitted-overhang { break }
    }
    regions.push(columns.slice(region-start, index))
  }
  (regions: regions, next-index: index)
}

#let render-grid(regions, columns, rows, block-width, cell-width, cell-height, column-gap, row-gap, config) = {
  let cells = ()
  for row in range(rows) {
    let start = row * columns
    let count = calc.max(0, calc.min(columns, regions.len() - start))
    for _ in range(columns - count) { cells.push([]) }
    if count > 0 {
      for region in regions.slice(start, start + count).rev() {
        cells.push(box(
          width: cell-width,
          height: cell-height,
          align(right + top, render-page(region, config.layout.gap, config)),
        ))
      }
    }
  }
  box(
    width: block-width,
    grid(
      columns: range(columns).map(_ => cell-width),
      rows: range(rows).map(_ => cell-height),
      column-gutter: column-gap,
      row-gutter: row-gap,
      ..cells,
    ),
  )
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

#let page-box(lines, widths, start, rows, columns, target-width, target-height,
  column-gap, row-gap, boundary-gaps, overhang-threshold, config, render: true) = {
  let cell-width = (target-width - (columns - 1) * column-gap) / columns
  let cell-height = (target-height - (rows - 1) * row-gap) / rows
  if cell-width <= 0pt or cell-height <= 0pt {
    panic("basho: vertical grid gutters leave no usable region")
  }
  let packed = pack-regions(
    lines, widths, boundary-gaps, start, rows * columns, cell-width,
    overhang-threshold,
  )
  let used-rows = calc.max(1, calc.ceil(packed.regions.len() / columns))
  let used-height = used-rows * cell-height + calc.max(0, used-rows - 1) * row-gap
  let content = if render {
    box(
      width: target-width,
      height: used-height,
      align(center + top, render-grid(
        packed.regions, columns, used-rows, target-width, cell-width,
        cell-height, column-gap, row-gap, config,
      )),
    )
  } else { none }
  (content: content, next-index: packed.next-index)
}

#let render-pages(lines, widths, rows, columns, target-width, target-height,
  column-gap, row-gap, boundary-gaps, overhang-threshold, config, start: 0) = {
  let pages = ()
  let index = start
  while index < lines.len() {
    let page = page-box(
      lines, widths, index, rows, columns, target-width, target-height,
      column-gap, row-gap, boundary-gaps, overhang-threshold, config,
    )
    pages.push(page.content)
    if page.next-index <= index { panic("basho: vertical paginator made no progress") }
    index = page.next-index
  }
  pages
}

#let select-page-part(pages, part) = {
  if not (part in ("all", "first", "rest")) {
    panic("basho: vertical page part must be \"all\", \"first\", or \"rest\"")
  }
  let selected = if part == "first" {
    pages.slice(0, calc.min(1, pages.len()))
  } else if part == "rest" {
    pages.slice(calc.min(1, pages.len()))
  } else {
    pages
  }
  selected.sum(default: [])
}

/// Prepare source tokens once, paginate a first partial region once, then
/// paginate all continuation text once using the fixed page-body geometry.
#let layout-tate(
  tokens,
  config,
  part: "all",
  initial-height: auto,
) = {
  if tokens.len() == 0 { return [] }
  layout(size => context {
    let top = measure(box(height: margin-value("top", "top", "y"))).height
    let bottom = measure(box(height: margin-value("bottom", "bottom", "y"))).height
    let left = measure(box(width: margin-value("left", "inside", "x"))).width
    let right = measure(box(width: margin-value("right", "outside", "x"))).width
    let full-height = measure(box(height: page.height)).height - top - bottom
    let full-width = measure(box(width: page.width)).width - left - right
    let available-height = calc.max(0pt, if initial-height == auto {
      size.height
    } else {
      initial-height
    })
    let available-width = calc.min(full-width, size.width)

    let cfg = config
    let columns = cfg.layout.at("columns-per-row", default: auto)
    if columns == auto { columns = cfg.layout.at("columns", default: 1) }
    let rows = cfg.layout.at("rows", default: 1)
    if rows == auto { rows = 1 }
    let column-gap = measure(h(cfg.layout.at("column-gap", default: 2em))).width
    let row-gap = measure(v(cfg.layout.at("row-gap", default: 2em))).height
    let line-gap = measure(h(cfg.layout.at("gap", default: 0.6em))).width
    let overhang = measure(h(cfg.layout.at(
      "line-overhang-threshold", default: 0.5em,
    ))).width
    let threshold = cfg.layout.at("row-fit-threshold", default: 1.5)
    let target-width = calc.min(available-width, resolve-relative(
      cfg.layout.at("width", default: auto), available-width, "x",
    ))
    let full-target-height = calc.min(full-height, resolve-relative(
      cfg.layout.at("height", default: auto), full-height, "y",
    ))
    let first-target-height = calc.min(available-height, resolve-relative(
      cfg.layout.at("height", default: auto), available-height, "y",
    ))
    let char-box = measure(box(
      width: cfg.sizing.char-box,
      height: cfg.sizing.char-box,
    )).height
    if first-target-height < char-box {
      if part == "first" { return [] }
      let full = prepare-layout(tokens, cfg, usable-height: (
        full-target-height - (rows - 1) * row-gap
      ) / rows)
      let lines = paginate(full.tokens, full.config.at("usable-height"), full.config)
      let widths = lines.map(line => column-width(line, full.config))
      let boundary-gaps = column-boundary-gaps(lines, line-gap)
      let pages = render-pages(
        lines, widths, rows, columns, target-width, full-target-height,
        column-gap, row-gap, boundary-gaps, overhang, full.config,
      )
      if part == "rest" { return pages.sum(default: []) }
      return colbreak(weak: true) + pages.sum(default: [])
    }

    let first-rows = fitted-row-count(
      first-target-height, full-target-height, rows, row-gap, threshold,
    )
    let first-cell-height = (
      first-target-height - (first-rows - 1) * row-gap
    ) / first-rows
    let same-geometry = (
      first-rows == rows
        and first-target-height >= full-target-height
    )
    if same-geometry {
      let prepared = prepare-layout(tokens, cfg, usable-height: first-cell-height)
      let lines = paginate(prepared.tokens, first-cell-height, prepared.config)
      let widths = lines.map(line => column-width(line, prepared.config))
      let boundary-gaps = column-boundary-gaps(lines, line-gap)
      let first = page-box(
        lines, widths, 0, rows, columns, target-width, full-target-height,
        column-gap, row-gap, boundary-gaps, overhang, prepared.config,
        render: part != "rest",
      )
      if part == "first" { return first.content }
      let rest = render-pages(
        lines, widths, rows, columns, target-width, full-target-height,
        column-gap, row-gap, boundary-gaps, overhang, prepared.config,
        start: first.next-index,
      )
      if part == "rest" { return rest.sum(default: []) }
      return first.content + rest.sum(default: [])
    }

    let first-prepared = prepare-layout(tokens, cfg, usable-height: first-cell-height)
    let first-lines = paginate(first-prepared.tokens, first-cell-height, first-prepared.config)
    let first-widths = first-lines.map(line => column-width(line, first-prepared.config))
    let first-boundary-gaps = column-boundary-gaps(first-lines, line-gap)
    let first = page-box(
      first-lines, first-widths, 0, first-rows, columns, target-width,
      first-target-height, column-gap, row-gap, first-boundary-gaps, overhang,
      first-prepared.config, render: part != "rest",
    )
    let consumed = consumed-source(first-lines.slice(0, first.next-index))
    // The continuation is a new physical page, not necessarily a new source
    // paragraph. Remember whether skipped structural tokens actually include
    // a paragraph break before re-paginating the remainder.
    let paragraph-start = false
    while consumed < tokens.len() and tokens.at(consumed).type in (
      "newline", "parbreak",
    ) {
      if tokens.at(consumed).type == "parbreak" { paragraph-start = true }
      consumed += 1
    }
    if consumed >= tokens.len() {
      if part == "rest" { return [] }
      return first.content
    }
    if part == "first" { return first.content }

    let full-cell-height = (full-target-height - (rows - 1) * row-gap) / rows
    let continuation = prepare-layout(
      tokens.slice(consumed), cfg, usable-height: full-cell-height,
    )
    let lines = paginate(
      continuation.tokens,
      full-cell-height,
      continuation.config,
      paragraph-start: paragraph-start,
    )
    let widths = lines.map(line => column-width(line, continuation.config))
    let boundary-gaps = column-boundary-gaps(lines, line-gap)
    let pages = render-pages(
      lines, widths, rows, columns, target-width, full-target-height,
      column-gap, row-gap, boundary-gaps, overhang, continuation.config,
    )
    if part == "rest" { pages.sum(default: []) } else {
      first.content + pages.sum(default: [])
    }
  })
}
