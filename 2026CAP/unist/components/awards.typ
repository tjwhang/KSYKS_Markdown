#import "theme.typ": *
#import "../jsarticle.typ": jsfont

// The exhibit and its wall label stay together. Captions live outside the frame.
#let pf-award(body, title: [], detail: [], accession: "", height: 65mm) = block(breakable: false)[
    #set par(first-line-indent: 0pt, justify: false)
    #block(width: 100%, height: height, fill: rgb("f5f4f0"), inset: 3mm)[
        #align(center + horizon, body)
    ]
    #v(1mm)
    #grid(columns: (8mm, 1fr), gutter: 2mm,
        jsfont("gothic", size: 10pt, fill: pf-muted)[#accession],
        [#jsfont("gothic", size: 11pt)[#title]
         #if detail != [] { block(above: 2mm)[#jsfont("body", size: 10pt, fill: pf-muted)[#detail]] }])
]

#let pf-award-gallery(..exhibits) = grid(columns: (1fr, 1fr), column-gutter: 5mm, row-gutter: 7mm, ..exhibits.pos())
