#import "../jsarticle.typ": jscjk-inline-boundaries, jsfont

#let pf-ink = rgb("1d1e23")
#let pf-muted = rgb("#454747")
#let pf-rule = rgb("dde7e7")
#let pf-body-size = 11pt

#let pf-column-width = 1fr
#let pf-column-gutter = 8mm
#let pf-profile-gutter = 10mm
#let pf-page-margin = (left: 19mm, right: 13mm, top: 25mm, bottom: 16mm)
#let pf-profile-page-margin = pf-page-margin + (top: pf-page-margin.top + 7mm, bottom: pf-page-margin.bottom + 12mm)
#let pf-cjk-gap = 0.12em
#let pf-hairline = 0.35pt + pf-rule
#let pf-title-size = 22pt
#let pf-profile-title-size = 22pt
#let pf-label-size = 10pt
#let pf-caption-size = 10pt
#let pf-source-size = 7.1pt
#let pf-folio-size = 10pt
#let pf-marker-size = 8pt
#let pf-marker-height = 34mm
#let pf-marker-offset = 7mm
#let pf-folio-offset = 38mm

#let pf-label(body, fill: pf-muted) = context {
    jsfont("gothic", size: pf-label-size, fill: fill, tracking: 0.015em)[#jscjk-inline-boundaries(body)]
}

#let pf-caption(body, size: pf-caption-size) = {
    metadata((pf-flow-note-source: body))
    context {
    jsfont("body", size: size, fill: pf-ink)[
        #block(above: 7pt, below: 7pt)[#jscjk-inline-boundaries(body)]
    ]
}
}

#let pf-source(body, size: pf-source-size) = {
    metadata((pf-flow-note-source: body))
    context {
    jsfont("gothic", size: size, fill: pf-muted)[
        #block(above: 5pt, below: 5pt)[#jscjk-inline-boundaries(body)]
    ]
}
}

// Reusable end-of-project reference, deliberately smaller than body text but
// still large enough to remain comfortably readable in the main column.
#let pf-repo(label: [], body) = {
    // Preserve source note visibility without evaluating contextual font/CJK
    // rendering during the flow planner's source walk. Metadata renders nothing.
    metadata((pf-flow-note-source: label + body))
    context {
    block(above: 1em, below: 0pt, breakable: false)[
        #set par(first-line-indent: 0em)
        #jsfont("gothic", size: 9pt, fill: pf-muted)[
            #block(below: 0.5em)[#jscjk-inline-boundaries(label)]
        ]
        #jsfont("body", size: 11pt, fill: pf-ink)[
            #jscjk-inline-boundaries(body)
        ]
    ]
}
}
