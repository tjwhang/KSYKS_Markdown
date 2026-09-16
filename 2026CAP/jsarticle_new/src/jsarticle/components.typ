#import "../../cjk.typ": *
#import "state.typ": *
#import "inline.typ": *
#let _js-single-page(body, break-before: none) = context {
  let margin = js-single-page-margin.get()
  let options = (columns: 1)
  if margin != auto { options.insert("margin", margin) }
  let break-content = if break-before == "odd" {
    pagebreak(to: "odd", weak: true)
  } else if break-before != none {
    pagebreak(weak: true)
  } else { [] }
  [
    #break-content
    #set page(..options)
    #body
  ]
}

#let transnote(body) = {
  counter("trans-note").step()
  [#footnote(body)<trans>]
  counter(footnote).update(x => x - 1)
}

#let jspart(title, num: none) = context {
  js-running-heads.update(false)
  _js-single-page(break-before: "odd", [
    #let outline-title = if num != none { [— #num　#title —] } else { [— #title —] }
    #hide[#heading(level: 1, numbering: none, outlined: true)[#outline-title]<__jspart__>]
    #v(30%)
    #align(center)[
      #if num != none [
        #jsfont("body", size: 1.1em, tracking: 0.25em, fill: luma(80))[#num]
        #v(0.6em)
      ]
      #jsfont("serif-bold", size: 2.15em, weight: "semibold", tracking: 0.06em)[#title]
      #v(2.5em)
      #line(length: 1.8em, stroke: 0.6pt + luma(160))
    ]
    #v(1fr)
  ])
}

#let jsicover(title, subtitle: none, author: none, size: 2.7em) = context {
  js-running-heads.update(false)
  let rsize = if calc.min(page.width, page.height) <= 148mm { size * 0.82 } else { size }
  _js-single-page(break-before: "odd", [
    #v(20%)
    #align(center)[
      #jsfont("body", size: rsize, weight: "semibold", tracking: 0.06em)[#title]
      #if subtitle != none [#v(0.4em) #jsfont("gothic", size: rsize * 0.45, weight: "semibold")[#subtitle]]
      #if author != none [#v(4em) #jsfont("gothic", size: rsize * 0.42)[#author]]
    ]
    #v(1fr)
  ])
}

#let jsdinkus(sym: "*　*　*") = context {
  v(2 * 1.65em, weak: true)
  align(center)[#jsfont("body", size: 1.25em, weight: "bold")[#sym]]
  v(2 * 1.65em, weak: true)
}

#let _js-delimiter-pair(delim) = {
  if delim == none { none } else if delim == "'" { ("'", "'") } else if delim == "\"" { ("\"", "\"") } else if (
    delim == "〈"
  ) { ("〈", "〉") } else if delim == "《" { ("《", "》") } else if delim == "「" { ("「", "」") } else if (
    delim == "『"
  ) { ("『", "』") } else if delim == "【" { ("【", "】") } else if delim == "(" { ("(", ")") } else if delim == "{" {
    ("{", "}")
  } else if delim == "[" { ("[", "]") } else if delim == "〔" { ("〔", "〕") } else {
    panic("delimiter must be none, ', \", 〈, 《, 「, 『, or 【")
  }
}

#let _js-wrap-delimited(body, pair) = {
  if pair == none { body } else { [#pair.at(0)#body#pair.at(1)] }
}

#let jsepigraph(
  attribution: none,
  style: "line", // "line", "dash", "vert"
  scope: "block", // "page", "block"
  align-x: right,
  width: 70%,
  region-height: auto,
  delim: auto,
  body,
) = context {
  if not (style in ("line", "dash", "vert")) {
    panic("jsepigraph: style must be \"line\", \"dash\", or \"vert\"")
  }
  if not (scope in ("page", "block")) {
    panic("jsepigraph: scope must be \"page\" or \"block\"")
  }
  let delimiter = _js-delimiter-pair(if delim == auto {
    if style == "vert" { "「" } else { none }
  } else { delim })
  let delimited-body = _js-wrap-delimited(body, delimiter)
  let vertical-region-height = if region-height == auto {
    if scope == "page" { 44% } else { auto }
  } else { region-height }
  let vertical-region-cap = if region-height == auto and scope == "block" {
    30%
  } else { none }
  let epigraph-block = layout(size => {
    let resolved-width = if type(width) == ratio {
      size.width * width
    } else if type(width) == length {
      measure(h(width)).width
    } else {
      panic("jsepigraph: width must be a length or ratio")
    }
    if resolved-width <= 0pt {
      panic("jsepigraph: width must be greater than zero")
    }
    let horizontal-attribution = if attribution != none and attribution != [] {
      if style == "line" {
        [
          #v(0.2em)
          #line(length: 100%, stroke: 0.5pt)
          #align(right)[#text(style: "italic")[#attribution]]
        ]
      } else {
        [
          #v(0.5em)
          #align(right)[— #attribution]
        ]
      }
    } else { [] }
    block(width: resolved-width, [
      #jsfont("body")[
        #if style == "vert" [
          #let quote = align(right + top)[
            #jsvert(
              flow: "region",
              region-height: vertical-region-height,
              region-height-cap: vertical-region-cap,
              // justify: false,
              // 'Basho' owns vertical paragraph indentation. An epigraph is a
              // display gesture, so its first line begins flush with the region.
              paragraph-indent: 0em,
            )[#delimited-body]
          ]
          #if attribution != none and attribution != [] [
            #align(center + top)[
              #grid(
                columns: (auto, auto),
                column-gutter: 0.75em,
                align: right + top,
                align(right + top)[
                  #text(size: 0.74em, fill: luma(0))[
                    #jsvert(
                      flow: "inline",
                      region-height: vertical-region-height,
                    )[—#attribution]
                  ]
                ],
                quote,
              )
            ]
          ] else [
            #align(center + top)[#quote]
          ]
        ] else [
          #set par(first-line-indent: 0em)
          // The display block may itself be placed at the centre or right edge
          // of a page.  Its quotation remains ordinary start-aligned prose;
          // only the epigraph block is positioned by `align-x`.
          #align(start)[#delimited-body]
          #horizontal-attribution
        ]
      ]
    ])
  })

  if scope == "page" {
    js-running-heads.update(false)
    _js-single-page(break-before: "next", [
      #align(align-x + horizon)[#v(-25%) #epigraph-block]
    ])
  } else {
    v(1.5em)
    align(align-x)[#epigraph-block]
    v(1.5em)
  }
}

#let jsquote(attribution: none, indent: false, delim: none, body) = pad(left: 2em, top: 0.7em, bottom: 0.7em, {
  if indent {
    set par(first-line-indent: (amount: 1em, all: true))
  } else {
    set par(first-line-indent: 0em)
  }
  _js-wrap-delimited(body, _js-delimiter-pair(delim))
  if attribution != none and attribution != [] {
    v(0.4em)
    align(right)[
      #set par(first-line-indent: 0em)
      --- #attribution
    ]
  }
})

#let jsbox(body) = block(width: 100%, stroke: 0.5pt, inset: (x: 1.5em, y: 1em), {
  set par(first-line-indent: 0em)
  body
})

#let jstopic(title: [], body) = context {
  v(1.2em, weak: true)
  block(breakable: false)[
    #set par(first-line-indent: 0em)
    #jsfont("gothic", weight: "semibold")[■#h(0.35em)#title]
    #h(0.5em)#body
  ]
}

#let js-answer-box(it) = box(baseline: 25%, stroke: 0.5pt, inset: 1pt, rect(
  stroke: 0.5pt,
  inset: (x: 3pt, y: 2pt),
  radius: 0pt,
  text(size: 0.85em, weight: "semibold")[#it],
))

#let js-heading-unnumbered(title) = heading(level: 1, numbering: none)[#title]
#let js-heading-unlisted(title) = heading(level: 1, numbering: none, outlined: false)[#title]
#let js-equation-unnumbered = math.equation.with(block: true, numbering: none)

#let js-problem-number(num) = context box(
  inset: (right: 0.5em),
  move(
    dy: 0.08em,
    jsfont("serif-bold", weight: "bold", size: 1.3em)[#num],
  ),
)

#let jsnnh1 = js-heading-unnumbered

#let jsnnoh1 = js-heading-unlisted

#let jsnneq = js-equation-unnumbered

#let jspnum = js-problem-number

#let jsans = js-answer-box
