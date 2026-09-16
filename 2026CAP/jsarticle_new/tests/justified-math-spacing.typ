#import "../jsarticle.typ": jsarticle-book, jsarticle-options, jscjk-inline-boundaries
#let gap = if sys.inputs.at("gap", default: "normal") == "zero" { 0em } else { 0.15em }
#show: jsarticle-book.with(options: jsarticle-options(
  typography: (font-size: 11pt, cjk-spacing: gap, inline-atom-particles: none,
    inline-math-display-style: true, inline-math-bounds: true),
))
#set par(justify: true, first-line-indent: 0pt)
#for width in (45mm, 65mm, 80mm, 100mm) {
  block(width: width)[
    한$x$글 말과 말 사이의 간격#linebreak(justify: true)
    한 $x$ 글 말과 말 사이의 간격#linebreak(justify: true)
    한$x$글 말과 말 사이의 간격
  ]
}
#let deferred(body) = context block(width: 80mm, jscjk-inline-boundaries(body))
#deferred[
  한$x$글 말과 말 사이의 간격#linebreak(justify: true)
  한$frac(a,b)$글 말과 말 사이의 간격#linebreak(justify: true)
  한$x+y$글 말과 말 사이의 간격
]
#block(width: 65mm)[한$x$글#linebreak(justify: true)끝]

#pagebreak()
#set par(justify: false)
한 $x$ 글

#strong[한 ]$x$#emph[ 글]

#link("https://example.com")[한 ]$x$#link("https://example.com")[ 글]

#text("한 ")$x$#text(" 글")

#jscjk-inline-boundaries[#jscjk-inline-boundaries[한 $x$ 글]]

// A typed word space can still break; no clearance may indent the next line.
#block(width: 8mm)[한 $x$ 글 말과 말 사이]

#block(width: 80mm)[
  #set par(justify: true)
  설명하는 식의 교양 자료와 갑자기 $g_(mu nu)$나 $Gamma_(alpha beta)^mu$ 같이 알 수 없는 개념부터 등장하는 설명을 비교한다.
]
