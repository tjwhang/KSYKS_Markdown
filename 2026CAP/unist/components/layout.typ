#import "../jsarticle.typ": jscjk-inline-boundaries, jsfont, jsvert
#import "theme.typ": *

#let pf-columns(left: [], right: [], left-width: pf-column-width, gutter: pf-column-gutter) = grid(columns: (pf-column-width, 1fr), column-gutter: gutter, align: (top, top), left, right)

#let pf-heading(body) = context {
    // Meander measures isolated prefixes, where native `sticky` has no next
    // block to protect. Reserve the following gap and two body lines inside
    // the heading's fit bounds (also respecting paragraph orphan protection),
    // then cancel that reservation in the following gap. Visible spacing stays
    // unchanged, but a heading alone cannot consume the last available line.
    let keep = 1em + 2 * (text.size + par.leading.to-absolute())
    block(width: 100%, above: 1.5em, below: 1em - keep, inset: (bottom: keep), sticky: true, breakable: false)[
        #set par(first-line-indent: 0em)
        #v(0.35em)
        #jsfont("gothic-bold", weight: "bold", size: 12.2pt, fill: pf-ink)[#jscjk-inline-boundaries(body)]
    ]
}

#let pf-result(body) = context {
    block(above: 1.1em, below: 0pt)[
        #set par(first-line-indent: 0em)
        #pf-label[결과]
        #v(0.35em)
        #jsfont("body", size: 10.5pt, fill: pf-ink)[#jscjk-inline-boundaries(body)]
    ]
}

#let pf-note(label: auto, kind: "한계", body) = context {
    let label = if label == auto { kind } else { label }
    block(above: 1.15em, below: 0.5em, inset: (left: 1.4em, y: 0.15em), stroke: (left: 0.7pt + pf-ink))[
        #pf-label[#label]
        #v(0.3em)
        #jsfont("body", size: 8.7pt, fill: pf-ink)[#jscjk-inline-boundaries(body)]
    ]
}

#let pf-figure(identifier, caption: [], source: none, frame: false, body) = {
    metadata((pf-flow-note-source: identifier + caption + (if source == none { [] } else { source }) + body))
    context {
    block(
        width: 100%,
        above: 1em,
        below: 1em,
    )[
        #if frame [#block(width: 100%, stroke: pf-hairline, inset: 2.2mm)[#jscjk-inline-boundaries(body)]] else [#jscjk-inline-boundaries(body)]
        #v(0.45em)
        #grid(
            columns: (auto, 1fr),
            column-gutter: 0.75em,
            jsfont("gothic", size: 7.4pt, fill: pf-muted)[#identifier],
            stack(spacing: 0.18em, pf-caption(caption), if source == none { [] } else {
                pf-source(source)
            }),
        )
    ]
}
}

#let pf-comparison(left-title: [], left: [], right-title: [], right: []) = grid(
    columns: (1fr, 1fr),
    column-gutter: 7mm,
    align: (top, top),
    stack(spacing: 0.55em, pf-label(left-title), left),
    stack(spacing: 0.55em, pf-label(right-title), right),
)

#let pf-vertical(width: 40mm, height: 135mm, body) = context {
    block(width: width, height: height, stroke: pf-hairline, inset: 3mm)[
        #jsfont("body", size: 9pt, fill: pf-ink)[
            #jsvert(
                flow: "region",
                language: "ko",
                region-height: height - 6mm,
                columns: 1,
                rows: 1,
                tracking: 0em,
                heading-mode: "visual",
            )[#body]
        ]
    ]
}

#let pf-split(left: pf-column-width, gutter: pf-column-gutter, left-body: [], right-body: []) = pf-columns(left: left-body, right: right-body, left-width: left, gutter: gutter)
#let pf-topic = pf-heading
#let pf-vertical-evidence = pf-vertical
