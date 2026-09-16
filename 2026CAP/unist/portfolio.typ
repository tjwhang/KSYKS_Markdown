#import "jsarticle.typ": jsarticle-book, jsarticle-options, rb, ruby, jsipa
#import "fonts.typ": document-composites
#import "components/cover.typ": pf-cover
#import "components/page.typ": pf-page-header
#import "components/specimen.typ": pf-specimen-layer
#import "components/artwork.typ": pf-project-end, pf-artwork-layer
#import "components/awards.typ": pf-award, pf-award-gallery
#import "components/profile.typ": pf-profile
#import "components/endmatter.typ": pf-appendix, pf-afterword, pf-endmatter-spec, pf-render-endmatter
#import "components/flow.typ": pf-flow
#import "components/project.typ": pf-next-page, pf-part, pf-project, pf-project-continuation
#import "components/layout.typ": (
    pf-columns,
    pf-comparison,
    pf-figure,
    pf-heading,
    pf-note,
    pf-result,
    pf-split,
    pf-topic,
    pf-vertical,
    pf-vertical-evidence,
)
#import "components/data.typ": pf-normalize-project
#import "components/theme.typ": *

#import "preamble.typ": *

// Render a project's first page and any continuations from one `pages` array.
// An empty array deliberately leaves a manifest-only project on the cover; its
// absent destination is displayed there as an em dash.
#let render-project(project, part, part-start: false) = {
    let project = pf-normalize-project(project)
    let pages = project.pages
    if pages.len() == 0 { return [] }
    pf-project(project: project, part: part, part-start: part-start)[
        #pages.at(0)
    ]
    for continuation in pages.slice(1) {
        pf-project-continuation(project: project, part: part)[
            #continuation
        ]
    }
    pf-project-end(project.id)
}

#let pf-document(title: "포트폴리오", author: "황태준", artworks: (:), body) = {
    let options = jsarticle-options(document: (title: title, author: author, title-page: "none"), page: (
        paper-size: "a4",
        bind: "none",
        // The outer edge carries the vertical marker and folio, so it receives a
        // dedicated lane rather than competing with the evidence column.
        margin: pf-page-margin,
        header: pf-page-header,
        footer: none,
        doc-type: "article",
        h1-break: "continuous",
    ), typography: (
        ambient-language: "ko",
        font-size: pf-body-size,
        // Baseline distance relative to the local outer text size.
        baseline-ratio: 1.6,
        cjk-spacing: pf-cjk-gap,
        inline-atom-particles: none,
        inline-math-display-style: false,
        inline-math-bounds: false,
        optical-profiles: (ko: (hangul: (
            // scale: 0.925em,
            // baseline: -0.07em,
            // tracking: -0.08em,
        ), han: (tracking: -0.01em), western: (tracking: 0em))),
    ), fonts: (
        composites: document-composites,
        body-family: "serif",
        strong-family: "gothic-bold",
        heading-family: "gothic-bold",
        ruby-family: "footnote",
    ), vertical: (
        page-start: false,
        unicode-fallbacks: true,
        collapse-punctuation-space: true,
        korean-fullwidth-spaces: false,
        boundary-spacing: 0.2em,
        latin-orientation: "rotate",
        heading-mode: "visual",
        tcy-max-digits: 2,
        tracking: 0pt,
        width: auto,
        height: auto,
        columns: 1,
        rows: 1,
        line-gap: 0.6em,
        column-gap: 2em,
        row-gap: 2em,
        row-fit-threshold: 1.5,
        line-overhang-threshold: 0.5em,
        min-final-line-chars: 4,
        orphan-lines: 2,
        widow-lines: 2,
        stream-gap: auto,
    ))
    jsarticle-book(options: options)[
        #set page(background: pf-artwork-layer)
        #set page(foreground: pf-specimen-layer)
        #set math.equation(numbering: none)
        #set figure(numbering: none)
        #body
        #metadata(artworks) <pf-artwork-registry>
    ]
}

// Public, single-source portfolio declaration. The cover, profile, project
// destinations, page numbers, and body all derive from the same nested data.
#let pf-book(title: "포트폴리오", subtitle: "", author: "", school: "", application: "", date: "", profile: (:), parts: (), appendix: none, afterword: none, artworks: (:)) = {
    let endmatter = (
        pf-endmatter-spec(appendix, "부록", <pf-appendix>),
        pf-endmatter-spec(afterword, "마치며", <pf-afterword>),
    ).filter(item => item != none)
    pf-document(title: title, author: author, artworks: artworks)[
        #pf-cover(
            title: title,
            subtitle: subtitle,
            author: author,
            school: school,
            application: application,
            date: date,
            parts: parts,
            endmatter: endmatter,
        )[
            #pf-profile(..profile)
            #for part in parts {
                let first-page = true
                for project in part.projects {
                    let project = pf-normalize-project(project)
                    if project.pages.len() > 0 {
                        render-project(project, part, part-start: first-page)
                        first-page = false
                    }
                }
            }
            #for section in endmatter { pf-render-endmatter(section) }
        ]
    ]
}

#let pf-portfolio = pf-book
#let _pf-render-project = render-project
