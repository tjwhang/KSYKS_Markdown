#import "../jsarticle.typ": jsfont, jsheading-anchor, jsvert, jscjk-inline-boundaries
#import "theme.typ": *
#import "navigation.typ": pf-page-meta, pf-project-destination
#import "data.typ": pf-normalize-project, pf-metadata-items

#let pf-part(part) = context {
    jsheading-anchor(part.title, level: 1)
    let label = str(part.number) + "부"
    block(above: 0pt, below: 1.4em, width: 100%)[
        #jsfont("gothic", size: pf-marker-size, fill: pf-muted)[#label]
        #h(0.8em)
        #jsfont("serif-bold", weight: "bold", size: 11.5pt, fill: pf-ink)[#part.title]
        #h(1.1em)
        #jsfont("body", size: 8.6pt, fill: pf-muted)[#part.premise]
        #v(0.7em)
        #line(length: 26mm, stroke: pf-hairline)
    ]
}

#let pf-project-meta(project) = context {
    let items = pf-metadata-items(project)
    jsfont("gothic", size: pf-label-size, fill: pf-muted)[#items.join("　·　")]
}

#let pf-project(project: none, part: none, part-start: false, body) = context {
    let project = pf-normalize-project(project)
    pagebreak()
    pf-page-meta(str(part.number) + "　" + part.title, project-number: project.number, short-title: project.at("short-title"))
    if part-start { pf-part(part) }
    jsheading-anchor(project.title, level: 2, destination: pf-project-destination(project.id))
    [
        #set par(first-line-indent: 0em)
        #jsfont("gothic", size: pf-marker-size, fill: pf-muted)[#project.number]
        #v(0.45em)
        #jsfont("serif-bold", weight: "bold", size: pf-title-size, fill: pf-ink, tracking: -0.02em)[#project.title]
        #v(0.75em)
        #pf-project-meta(project)
        #v(1.65em)
        #jscjk-inline-boundaries(body)
    ]
}

#let pf-next-page(project: none, part: none, body) = context {
    let project = pf-normalize-project(project)
    pagebreak()
    pf-page-meta(
        str(part.number) + "　" + part.title,
        project-number: project.number,
        short-title: project.at("short-title"),
        continuation: true,
    )
    jscjk-inline-boundaries(body)
}

#let pf-project-continuation = pf-next-page
#import "layout.typ": *
