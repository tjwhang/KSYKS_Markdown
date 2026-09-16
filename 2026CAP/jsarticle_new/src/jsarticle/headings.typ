#import "inline.typ": js-fixed-layout-features
#import "../../engine-local.typ": engine-local

#let make-heading-renderers(typo, doc-type, role-font, role-features) = {
    let render-heading(it) = {
        // Heading geometry belongs to this template, not to the surrounding
        // language's body-paragraph profile.
        set text(font: role-font("heading"), features: role-features("heading", base: js-fixed-layout-features))
        let number = if it.numbering == none { none } else { counter(heading).display(it.numbering) }
        set par(first-line-indent: 0em, justify: false, linebreaks: "optimized")
        set align(left)

        if it.level == 1 {
            if it.has("label") and it.label == <__jspart__> {
                it.body
            } else {
                let h1-size = if doc-type == "novel" { 1.7em } else { 1.8em }
                block(
                    above: 0pt,
                    below: 2 * typo.baseline,
                    breakable: false,
                    inset: (top: (if doc-type == "novel" { 4 } else { 5 }) * typo.baseline),
                    width: 100%,
                )[
                    #set par(leading: 0.48 * h1-size, justify: false, linebreaks: "optimized")
                    #align(left)[
                        #if number != none {
                            text(
                                font: role-font("maru"),
                                size: 1.15em,
                                weight: "medium",
                                features: role-features("maru", base: js-fixed-layout-features),
                            )[#number]
                            v(1.2em)
                        }
                        #text(font: role-font("heading"), size: h1-size, weight: "semibold")[#it.body]
                    ]
                ]
            }
        } else {
            let factor = if it.level == 2 { 1.22 } else if it.level == 3 { 1.08 } else { 1 }
            let above = if it.level == 2 {
                2 * typo.baseline
            } else if it.level == 3 {
                1.3 * typo.baseline
            } else {
                typo.baseline
            }
            block(
                above: above,
                below: (if it.level == 2 { 0.7 } else { 0.6 }) * typo.baseline,
                breakable: false,
                sticky: true,
                width: 100%,
            )[
                #set text(
                    font: role-font("heading"),
                    size: factor * typo.size,
                    weight: "semibold",
                    features: role-features("heading", base: js-fixed-layout-features),
                )
                #set par(leading: 0.28 * factor * typo.size, justify: false, linebreaks: "optimized")
                #if number == none {
                    it.body
                } else {
                    grid(columns: (auto, 1fr), column-gutter: 0.8em, align: (left, left), text(
                        font: role-font("heading"),
                        weight: "medium",
                        features: role-features("heading", base: js-fixed-layout-features),
                    )[#number], block(width: 100%, it.body))
                }
            ]
        }
    }

    let render-outline-entry(it) = {
        set text(features: js-fixed-layout-features)
        let part = "label" in it.element.fields() and it.element.label == <__jspart__>
        if part {
            v(1.5 * typo.baseline, weak: true)
            align(center)[
                #text(
                    font: role-font("gothic"),
                    weight: "semibold",
                    size: 1.15em,
                    features: role-features("gothic", base: js-fixed-layout-features),
                )[
                    #link(it.element.location())[#it.body()]
                ]
            ]
        } else {
            let indent = if it.level == 1 { 0em } else { (it.level - 1) * 1.2em }
            let width = if it.level == 1 { 4.5em } else { 3.6em }
            v(if it.level == 1 { typo.baseline } else { 0.55 * typo.baseline }, weak: true)
            link(it.element.location())[
                #grid(columns: (indent, 1fr), column-gutter: 0pt, [], [
                    #box(width: width, it.prefix())
                    #it.body()
                    #if it.fill != none {
                        h(0.45em)
                        box(width: 1fr, align(right, it.fill))
                    }
                    #h(0.5em)#it.page()
                ])
            ]
        }
    }

    let render-footnote-entry(it) = context {
        let is-trans = it.note.has("label") and it.note.label == <trans>
        let n = if is-trans {
            counter("trans-note").at(here()).first()
        } else {
            counter(footnote).at(here()).first()
        }
        let mark = if is-trans { "*" + numbering("i", n) } else { "*" + str(n) }

        // `par.leading` is an addition to the current text size. Keep the
        // compact footnote rhythm proportional to that reduced text style,
        // rather than reusing an absolute length derived from the body.
        let footnote-leading = engine-local.footnote-leading-factor * (typo.leading / typo.size) * 1em
        set text(font: role-font("footnote"), size: 0.94em, features: role-features("footnote"))
        set par(leading: footnote-leading, spacing: footnote-leading, first-line-indent: 0em)
        grid(columns: (1.4em, 1fr), super(mark, typographic: true, size: 0.8em), it.note.body)
    }

    (heading: render-heading, outline: render-outline-entry, footnote: render-footnote-entry)
}
