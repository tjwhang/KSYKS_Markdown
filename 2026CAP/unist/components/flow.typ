#import "@preview/meander:0.4.4" as meander
#import "flow-stream.typ": pf-flow-chunks, pf-flow-normalize, pf-flow-rejoin
#import "flow-clearance.typ": pf-flow-reachable
#import "theme.typ": pf-column-gutter
#import "../src/cjk/spacing.typ": cjk-inline-fragment-spacing
#import "../src/jsarticle/state.typ": js-inline-boundary-config

#let flow-notes(value) = {
    if type(value) == array { return value.map(flow-notes).flatten() }
    if type(value) != content { return () }
    if value.func() == metadata {
        if type(value.value) == dictionary and "pf-flow-note-source" in value.value {
            return flow-notes(value.value.pf-flow-note-source)
        }
        return ()
    }
    if value.func() == footnote {
        return if type(value.body) == content { (value,) } else { () }
    }
    let found = ()
    for (_, field,) in value.fields() {
        found += flow-notes(field)
    }
    found
}

// Evidence owns the top of the right column; prose keeps a single source order.
#let pf-flow(evidence: (), gutter: pf-column-gutter, evidence-gap: 3mm, footnote-space: auto, body) = context {
    // Resolve boundaries before Meander fragments styled text into regions.
    let config = js-inline-boundary-config.get()
    let body = cjk-inline-fragment-spacing(
        config.gaps, body, inline-atom-particles: config.at("inline-atom-particles"),
    ).body
    assert(type(evidence) == array, message: "pf-flow: evidence must be an array of content blocks.")
    let gutter = gutter.to-absolute()
    let evidence-gap = evidence-gap.to-absolute()
    assert(gutter >= 0pt and evidence-gap >= 0pt, message: "pf-flow: gaps must not be negative.")
    if evidence.len() == 0 {
        columns(2, gutter: gutter, body)
    } else {
        layout(
            size => context {
                let column = (size.width - gutter) / 2
                assert(column > 0pt, message: "pf-flow: the gutter leaves no room for text.")
                let margins = page.margin
                let full-height = page.height - margins.top - margins.bottom
                let first-height = page.height - margins.bottom - here().position().y
                // Source-based fitting avoids feeding final note locations back
                // into pagination. Context-generated notes still need an override.
                let chunks = pf-flow-chunks(body)
                let evidence-notes = flow-notes(evidence)
                let body-notes = flow-notes(body)
                let notes = body-notes + evidence-notes
                let reserve(notes) = if notes.len() == 0 { 0pt } else {
                    (
                        notes.map(note => measure(footnote.entry(note), width: size.width).height + footnote.entry.gap.to-absolute()).sum() + footnote.entry.clearance.to-absolute() + text.size
                    )
                }
                let note-space = if footnote-space != auto { footnote-space.to-absolute() } else if notes.len() <= 1 { reserve(notes) } else { reserve(evidence-notes) }
                let plan(note-space) = {
                assert(
                    note-space >= 0pt and note-space < full-height,
                    message: "pf-flow: footnotes leave no room for the page; split this flow into smaller sections.",
                )
                let pages = ()
                let items = ()
                let used = 0pt
                let available = calc.max(0pt, first-height - note-space)
                for item in evidence {
                    let rendered = block(width: column, above: 0pt, below: 0pt, breakable: false, item)
                    let height = measure(rendered, width: column).height
                    assert(
                        height + evidence-gap < full-height - note-space,
                        message: "pf-flow: an evidence item is taller than the usable page; reduce its size or split it.",
                    )
                    if used + height + evidence-gap > available {
                        pages.push((items: items, used: used, height: available))
                        items = ()
                        used = 0pt
                        available = full-height - note-space
                    }
                    items.push(rendered)
                    used += height + evidence-gap
                }
                pages.push((items: items, used: used, height: available))
                pages
                }
                let pages = plan(note-space)
                if footnote-space == auto and notes.len() > 1 and body-notes.len() > 0 {
                    // Remember every note encountered, even if reserving it moves
                    // its marker to overflow. This monotone source union cannot
                    // oscillate between competing page layouts.
                    let seen = evidence-notes
                    for _ in range(notes.len() + 1) {
                        let reachable = evidence-notes + flow-notes(pf-flow-reachable(chunks, pages, column, size))
                        // Multiset union: two identical authored notes still
                        // require two entries, not a value-deduplicated entry.
                        let unmatched = seen
                        let added = ()
                        for note in reachable {
                            let index = unmatched.position(other => other == note)
                            if index == none { added.push(note) }
                            else { let _ = unmatched.remove(index) }
                        }
                        if added.len() == 0 { break }
                        seen += added
                        note-space = reserve(seen)
                        pages = plan(note-space)
                        // No unseen source note remains to be discovered.
                        if seen.len() >= notes.len() { break }
                    }
                }
                meander.reflow(
                    {
                        meander.opt.placement.spacing(both: 0pt)
                        for (index, region) in pages.enumerate() {
                            if index > 0 { meander.pagebreak() }
                            if region.items.len() > 0 {
                                meander.placed(
                                    top + right,
                                    boundary: meander.contour.phantom(),
                                    block(width: column)[
                                        #stack(dir: ttb, spacing: evidence-gap, ..region.items)
                                    ],
                                )
                            }
                            if region.height > 1pt {
                                meander.container(width: column, height: region.height - 1pt, margin: 0pt)
                            }
                            meander.container(
                                align: top + right,
                                width: column,
                                dy: region.used,
                                height: calc.max(0pt, region.height - region.used - 1pt),
                                margin: 0pt,
                            )
                        }
                        for chunk in chunks {
                            meander.content(chunk, normalize: ((repr(meander.normalize.box-refs)): pf-flow-normalize))
                        }
                        meander.opt.overflow.custom(rest => {
                            colbreak()
                            columns(2, gutter: gutter, pf-flow-rejoin(rest.styled))
                        })
                    },
                )
            },
        )
    }
}
