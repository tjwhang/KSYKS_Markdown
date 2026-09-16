#import "../jsarticle.typ": jsfont, jsheading-anchor, jscjk-inline-boundaries
#import "theme.typ": *
#import "navigation.typ": pf-page-meta

#let pf-endmatter(body, title: "", destination: none, pages: auto,
                  body-width: auto, inset: 3em, artwork: none) = context {
    // assert(pages == auto or type(pages) == array, message: "pf-endmatter: pages must be an array.")
    // assert(pages == auto or body == [], message: "pf-endmatter: use body or pages, not both.")
    // assert(pages == auto or pages.len() > 0, message: "pf-endmatter: pages must not be empty.")
    pagebreak(weak: true)
    set page(margin: pf-profile-page-margin)
    pf-page-meta(title, short-title: title)
    jsheading-anchor(title, level: 1, destination: destination)
    set par(first-line-indent: 1em)
    v(2em)
    move(dx: inset, jsfont("serif-bold", weight: "bold", size: pf-profile-title-size, fill: pf-ink)[#title])
    v(1.5em)
    if artwork != none { place(bottom + right, artwork) }
    let entries = if pages == auto { (body,) } else { pages }
    for (index, entry) in entries.enumerate() {
        if index > 0 {
            pagebreak()
            pf-page-meta(title, short-title: title, continuation: true)
        }
        layout(size => context {
            let offset = inset.to-absolute()
            let available = size.width - offset
            assert(offset >= 0pt and available > 0pt, message: "pf-endmatter: inset leaves no room for text.")
            let width = if body-width == auto { calc.min((0.925 * 38em).to-absolute(), available) } else {
                measure(box(width: body-width), width: available).width
            }
            assert(width > 0pt and width <= available, message: "pf-endmatter: body-width exceeds the available width.")
            pad(left: offset, block(width: width, above: 0pt, below: 0pt, breakable: true)[
                #set par(first-line-indent: (all: true, amount: 1em))
                #jscjk-inline-boundaries(entry)
            ])
        })
    }
}

#let pf-appendix = pf-endmatter.with(title: "부록", destination: <pf-appendix>)
#let pf-afterword = pf-endmatter.with(title: "마치며", destination: <pf-afterword>)

#let pf-endmatter-spec(value, title, destination) = {
    if value == none { return none }
    let spec = if type(value) == content { (body: value) } else { value }
    assert(type(spec) == dictionary, message: "pf-book: end matter must be content, a dictionary, or none.")
    (title: title, destination: destination, body: []) + spec
}

#let pf-render-endmatter(spec) = {
    let options = spec
    let body = options.remove("body")
    pf-endmatter(body, ..options)
}
