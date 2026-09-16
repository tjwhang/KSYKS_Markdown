#import "../jsarticle.typ": jsfont, jsheading-anchor, jscjk-inline-boundaries
#import "theme.typ": *
#import "navigation.typ": pf-page-meta
#import "data.typ": pf-profile-content

#let pf-profile(pages: auto, overview: auto, background: auto, main: [], cap: []) = context {
    set page(margin: pf-profile-page-margin)
    let content = pf-profile-content(overview: overview, background: background, main: main, cap: cap)
    pf-page-meta("들어가며", short-title: "들어가며")
    jsheading-anchor("들어가며", level: 1, destination: <pf-profile>)
    [
        #set par(first-line-indent: 0em)
        #v(2em)
        #move(dx: 3em, jsfont("serif-bold", weight: "bold", size: pf-profile-title-size, fill: pf-ink)[들어가며])
        #v(1.5em)
        #if pages == auto {
            grid(columns: (pf-column-width, 1fr), column-gutter: pf-profile-gutter, align: (top, top), [
                #pf-label[개요]
                #v(0.55em)
                #jscjk-inline-boundaries(content.overview)
            ], [
                #pf-label[배경]
                #v(0.55em)
                #jscjk-inline-boundaries(content.background)
            ])
        } else {
            for (index, page) in pages.enumerate() {
                if index > 0 {
                    pagebreak()
                    pf-page-meta("들어가며", short-title: "들어가며", continuation: true)
                }
                jscjk-inline-boundaries(page)
            }
        }
    ]
}
