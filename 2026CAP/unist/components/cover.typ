#import "../jsarticle.typ": js-font-family, jsfont, jsvert
#import "theme.typ": *

#import "navigation.typ": pf-project-destination, pf-project-page

#let pf-cover-toc(parts, endmatter: ()) = context {
    let profile-destination = <pf-profile>
    let profile-title = if query(profile-destination).len() == 0 {
        [들어가며]
    } else {
        link(profile-destination)[들어가며]
    }
    let groups = (grid(
        columns: (1fr, auto),
        column-gutter: 1.2em,
        align: (left, right),
        jsfont("body", size: 12pt)[#profile-title],
        jsfont("gothic", size: pf-folio-size, fill: pf-muted)[
            #if query(profile-destination).len() == 0 [—] else [#counter(page).at(profile-destination).first()]
        ],
    ),)
    for part in parts {
        let part-label = str(part.number) + "　" + part.title
        let entries = ()
        for project in part.projects {
            let destination = pf-project-destination(project.id)
            let linked-title = if query(destination).len() == 0 {
                [#project.title]
            } else {
                link(destination)[#project.title]
            }
            entries.push(grid(
                columns: (1fr, auto),
                column-gutter: 1.2em,
                align: (left, right),
                jsfont("body", size: 12pt)[#linked-title],
                jsfont("gothic", size: pf-folio-size, fill: pf-muted)[#pf-project-page(project)],
            ))
        }
        groups.push(
            stack(spacing: 0.55em, jsfont("gothic-bold", weight: "bold", size: 11pt, fill: pf-ink)[ #part-label ], ..entries),
        )
    }
    for section in endmatter {
        groups.push(grid(
            columns: (1fr, auto), column-gutter: 1.2em, align: (left, right),
            jsfont("body", size: 12pt)[#link(section.destination)[#section.title]],
            jsfont("gothic", size: pf-folio-size, fill: pf-muted)[#counter(page).at(section.destination).first()],
        ))
    }
    stack(spacing: 1.6em, ..groups)
}

#let pf-cover(title: "", author: "", subtitle: "", school: "", application: "", date: "", parts: (), endmatter: (), body) = context {
    set page(numbering: none)
    [
        #place(top + left, dx: 2%, dy: 12%)[
            #block(width: 104mm)[
                #jsfont("serif-bold", weight: "bold", size: 12pt, fill: pf-ink)[차례]
                #v(1.15em)
                #pf-cover-toc(parts, endmatter: endmatter)
            ]
        ]
        #place(top + right, dx: -3mm, dy: 1%)[
            #text(size: 45pt, fill: pf-ink, weight: "bold")[
                #jsvert(
                    flow: "inline",
                    ruby-size: 0.3em,
                    font: ((name: "munhwa myungjo std", covers: regex("[\\p{sc:Hangul}]")),(name: "fot-tsukumin pro", covers: regex("[\\p{sc:Han}]")),) + js-font-family("serif"),
                    tracking: -0.01em,
                    _atomic-lines: true,
                )[#title]
            ]
        ]
        #if subtitle != "" [
            #place(top + right, dx: -27mm, dy: 12mm)[
                #text(size: 45pt * 1 / (2 * 1.618), fill: pf-muted)[
                    #jsvert(flow: "inline", _atomic-lines: true, tracking: 0.03em, font-family: "body")[#subtitle]
                ]
            ]
        ]
        #place(bottom + left, dx: 2%, dy: -5%)[
            #stack(
                spacing: 0.42em,
                jsfont("body", size: 14pt, fill: pf-ink)[#author],
                jsfont("body", size: 11pt, fill: pf-muted)[#school],
                jsfont("gothic", size: 11pt * 0.925, fill: pf-muted)[#application],
                jsfont("gothic", size: 11pt * 0.925, fill: pf-muted)[#date],
            )
        ]
    ]
    pagebreak()
    set page(numbering: "1")
    counter(page).update(1)
    body
}
