#import "../../cjk.typ": *
#import "fonts.typ": *
#import "state.typ": *
#import "inline.typ": *
#import "options.typ": *
#import "defaults.typ": *
#import "geometry.typ": *

#let make-vertical-cover(title, subtitle, other, date, logo, role-font, role-features, author-line) = {
  let render-vertical-cover = context {
    layout(size => {
      let short-side = calc.min(size.width, size.height)
      let inset = calc.max(
        measure(h(1.4em)).width,
        calc.min(measure(h(4em)).width, short-side * 0.055),
      )
      let paper-title-size = calc.max(
        measure(h(2.8em)).width,
        calc.min(measure(h(4.8em)).width, short-side * 0.072),
      )
      let cover-text(node) = {
        if type(node) == str { node } else if type(node) == content {
          let name = repr(node.func())
          if name == "linebreak" { "\n" } else if node.has("text") { node.text } else if node.has(
            "children",
          ) { node.children.map(cover-text).join("") } else if node.has("body") {
            cover-text(node.body)
          } else { "" }
        } else { "" }
      }
      let title-lines = cover-text(title).split("\n")
      let longest-title-line = calc.max(1.0, ..title-lines.map(line => line
        .clusters()
        .map(char => if char == " " { 0.5 } else { 1.0 })
        .sum(default: 0.0)))
      // This is a type-size calculation, not a text region. a longer title
      // simply receives a smaller paper scaled face so its intrinsic line
      // remains inside the cover's intended vertical proportion.
      let title-size = calc.min(
        paper-title-size,
        size.height * 0.66 / longest-title-line,
      )
      let subtitle-size = title-size * 0.42
      let title-gutter = calc.max(
        measure(h(0.75em)).width,
        calc.min(measure(h(1.8em)).width, short-side * 0.025),
      )
      let title-stack = if subtitle != [] and subtitle != none {
        grid(
          columns: (auto, auto),
          column-gutter: title-gutter,
          align: right + top,
          align(right)[
            #text(
              size: subtitle-size,
              font: role-font("body"),
              fill: luma(60),
              features: role-features("body", base: js-fixed-layout-features),
            )[
              #jsvert(
                flow: "inline",
                _atomic-lines: true,
              )[「#subtitle」]
            ]
          ],
          align(right)[
            #text(
              size: title-size,
              font: role-font("title"),
              weight: "bold",
              features: role-features("title", base: js-fixed-layout-features),
            )[
              #jsvert(
                flow: "inline",
                _atomic-lines: true,
                font-family: "title",
              )[#title]
            ]
          ],
        )
      } else {
        text(
          size: title-size,
          font: role-font("title"),
          weight: "bold",
          features: role-features("title", base: js-fixed-layout-features),
        )[
          #jsvert(
            flow: "inline",
            _atomic-lines: true,
            font-family: "title",
          )[#title]
        ]
      }
      let metadata = stack(
        spacing: 0.8em,
        if author-line != [] and author-line != none [
          #text(
            size: 1.15em,
            font: role-font("body"),
            weight: "medium",
            features: role-features("body", base: js-fixed-layout-features),
          )[#author-line]
        ],
        if date != "" and date != none [
          #text(
            size: 0.95em,
            font: role-font("body"),
            features: role-features("body", base: js-fixed-layout-features),
          )[#date]
        ],
        if other != [] and other != none [
          #text(
            size: 0.9em,
            font: role-font("body"),
            features: role-features("body", base: js-fixed-layout-features),
          )[#other]
        ],
        if logo != [] and logo != none [
          #v(1.2em)
          #text(
            size: 1.05em,
            font: role-font("gothic"),
            weight: "semibold",
            features: role-features("gothic", base: js-fixed-layout-features),
          )[#logo]
        ],
      )
      block(
        width: size.width,
        height: size.height,
        inset: inset,
        [
          #align(right + top)[#title-stack]
          #v(1fr)
          #align(left + bottom)[#metadata]
        ],
      )
    })
  }


  render-vertical-cover
}
