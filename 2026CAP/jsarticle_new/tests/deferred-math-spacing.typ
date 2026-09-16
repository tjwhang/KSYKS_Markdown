#import "../jsarticle.typ": jsarticle-book, jsarticle-options, jscjk-inline-boundaries
#let amount = if sys.inputs.at("gap", default: "large") == "zero" { 0em } else { 1em }
#show: jsarticle-book.with(options: jsarticle-options(
  page: (margin: (inside: 14mm, outside: 14mm, top: 14mm, bottom: 14mm)),
  typography: (font-size: 11pt, cjk-spacing: amount, inline-atom-particles: none,
    inline-math-display-style: true, inline-math-bounds: true),
))
#set par(justify: false, first-line-indent: 0pt)
한$x$글

#let deferred(body) = context block(jscjk-inline-boundaries(body))
#deferred[한$x$글]

#deferred[#grid(columns: (1fr, 1fr), [한$x$글], [한$x$글])]

#deferred[한 $x$ 글]

#deferred[
  한
  $ x = 2 $
  글
]
