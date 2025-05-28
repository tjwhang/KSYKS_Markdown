#import "@preview/physica:0.9.5": *
#import "@preview/ilm_custom:1.4.1": *
#import "@preview/alchemist:0.1.4": *
#import "@preview/theorion:0.3.3": *
#import "@preview/rich-counters:0.2.1": *
#import "@preview/cetz:0.3.4": *
#import "@preview/cetz-plot:0.1.1": *
#import cosmos.clouds: *

//#import "../TypstTemplate/TypstTemplate.typ": *

//#show: template

#let scr(it) = text(
  features: ("ss01",),
  box($cal(it)$),
)

// 표지
#let title = [이산수학]

#show: ilm.with(
  title: title,
  author: "Taejoon Whang",
  date: datetime(year: 2025, month: 03, day: 06),
  abstract: [#lorem(30)],
  preface: align(horizon)[
    = 서 문
    \<숙지 사항>
    1. Kenneth Rosen 외, Discrete Mathematics and Its Applications 7 ed. 를 참고했습니다.
  ],
  //bibliography: bibliography(""),
  figure-index: (enabled: false),
  table-index: (enabled: false),
  listing-index: (enabled: false),
)

#set text(
  font: (
    "Gowun Dodum",
    (
      name: "LXGW Wenkai",
      covers: "latin-in-cjk",
    ),
    "LXGW Wenkai",
  ),
  cjk-latin-spacing: none,
  //weight: "medium",
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

#set math.equation(supplement: [식])
#show math.equation: set text(
  font: (
    (
      name: "STIX Two Math",
      covers: "latin-in-cjk",
    ),
    "LXGW Wenkai",
  ),
  cjk-latin-spacing: none,
  weight: "regular",
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
#include "chapters/명제.typ"

