#import "@preview/physica:0.9.5": *
#import "@preview/ilm_custom:1.4.1": *
#import "@preview/alchemist:0.1.4": *
#import "@preview/theorion:0.3.3": *
#import "@preview/rich-counters:0.2.1": *
#import "@preview/cetz:0.3.4": *
#import "@preview/cetz-plot:0.1.1": *
#import cosmos.rainbow: *

// 표지
#let title = [Standard \ Template Document]

#show: ilm.with(
  title: title,
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
  listing-index: (enabled: false),
)

#set text(
  font: (
    (
      name: "STIX Two Text",
      covers: "latin-in-cjk",
    ),
    "Source Han Serif K",
  ),
)
#show math.equation: set text(font: "STIX Two Math")
#set math.equation(numbering: "(1.1)", supplement: [식. ])
#set outline()
#show raw: set text(font: ("JetBrains Mono", "D2Coding"))
#set page(
  paper: "a4",
  margin: 3.5cm,
  header: align(right, title),
  numbering: "1",
)
#set math.equation(numbering: none)

#let tag(content) = {
  math.equation(
    block: true,
    numbering: "(1.1)",
    supplement: [식. ],
    content,
  )
}

// 컴포넌트

#show: show-theorion

// #show: great-theorems-init

// #let mathcounter = rich-counter(
//   identifier: "mathblocks",
//   inherited_levels: 1
// )

// #let theorem = mathblock(
//   blocktitle: "Theorem",
//   counter: mathcounter,
// )

// #let lemma = mathblock(
//   blocktitle: "Lemma",
//   counter: mathcounter,
// )

// #let corollary = mathblock(
//   blocktitle: "Corollary",
//   counter: mathcounter,
// )

// #let definition = mathblock(
//   blocktitle: "Definition",
//   counter: mathcounter,
// )

// #let remark = mathblock(
//   blocktitle: "Remark",
//   prefix: [_Remark._],
//   inset: 5pt,
//   radius: 5pt,
// )

// #let proof = proofblock()

#set math.mat(delim: "[")

// 본문
