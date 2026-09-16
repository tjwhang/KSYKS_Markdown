#import "@preview/physica:0.9.5": *
#import "@preview/ilm_custom:1.4.1": *
#import "@preview/alchemist:0.1.4": *
#import "@preview/theorion:0.3.3": *
#import "@preview/rich-counters:0.2.1": *
#import "@preview/cetz:0.3.4": *
#import "@preview/cetz-plot:0.1.1": *
#import cosmos.fancy: *

//#import "../TypstTemplate/TypstTemplate.typ": *

//#show: template

#let scr(it) = text(
  features: ("ss01",),
  box($cal(it)$),
)

// 표지
#let title = [15 물리학 I]

#show: ilm.with(
  title: title,
  author: "황태준",
  date: datetime(year: 2025, month: 03, day: 06),
  abstract: [#lorem(30)],
  preface: align(center + horizon)[
    = 서 문
    #lorem(100)
  ],
  //bibliography: bibliography(""),
  figure-index: (enabled: false),
  table-index: (enabled: false),
  listing-index: (enabled: false),
)

#set text(
  font: (
    // "KoPubBatang",
    (
      name: "STIX Two Text",
      covers: "latin-in-cjk",
    ),
    (
      name: "LXGW WenKai",
      covers: regex("[\p{scx:Han}\p{scx:Hira}\p{scx:Kana}]"),
    ),
    // "Klee One",
    "KoPubBatang",
  ),
  cjk-latin-spacing: none,
)

#show heading.where(level: 1): it => {
  counter(math.equation).update(0)
  it
}

#set math.equation(
  numbering: n => {
    numbering("(1.1)", counter(heading).get().first(), n)
    // if you want change the number of number of displayed
    // section numbers, modify it this way:
    /*
    let count = counter(heading).get()
    let h1 = count.first()
    let h2 = count.at(1, default: 0)
    numbering("(1.1.1)", h1, h2, n)
    */
  },
)

#set math.equation(supplement: [식. ])
#show math.equation: set text(
  font: (
    (
      name: "STIX Two Math",
      covers: "latin-in-cjk",
    ),
    // "Klee One",
    "Source Han Serif K",
  ),
  cjk-latin-spacing: none,
)
#set outline()
#show raw: set text(font: "JetBrains Mono")
#set page(
  paper: "a4",
  margin: 3.5cm,
  header: align(right, title),
  numbering: "1",
)

// 컴포넌트

#show: show-theorion

#set math.mat(delim: "[")

// 본문
#include "chapters/물체의운동.typ"

#include "chapters/열역학.typ"

#include "chapters/특수상대성이론.typ"

#include "chapters/질량과에너지.typ"


= 물질과 전자기장

= 파동과 정보통신
