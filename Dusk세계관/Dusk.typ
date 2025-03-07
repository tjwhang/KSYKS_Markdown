#import "@preview/ilm:1.4.1": *

#show: ilm.with(
  title: [Dusk],
  author: "Taejoon Whang, Dongwoo Nam",
  date: datetime(year: 2025, month: 03, day: 06),
  abstract: [#lorem(30)],
  preface: align(center + horizon)[
    = Preface
    #lorem(100)
  ],
  //bibliography: bibliography(""),
  figure-index: (enabled: false),
  table-index: (enabled: false),
  listing-index: (enabled: false)
)

#set text(font: (
  (
    name: "STIX Two Text",
    covers: "latin-in-cjk",
  ),
  "Source Han Serif K"
))
#show math.equation: set text(font: "STIX Two Math")
#set math.equation(numbering: "(1)")
#set outline()
#show raw: set text(font: ("JetBrains Mono", "D2Coding"))
#set page(
  paper: "a4",
  margin: 3.5cm,
  header: align(right)[
    Standard Template Document
  ],
  numbering: "1",
)
#set math.equation(numbering: none)

#let tag(content) = {
  math.equation(
    block: true, 
    numbering: "(1)", 
    content
  )
}

// 본문
= Prelude

