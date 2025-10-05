#import "@preview/bubble_custom:0.2.2": *      
#import "@preview/physica:0.9.5": *
#import "@preview/alchemist:0.1.4": *
#import "@preview/theorion:0.3.3": *
#import "@preview/rich-counters:0.2.1": *
#import "@preview/cetz:0.3.4"
#import "@preview/cetz-plot:0.1.1"
#import "@preview/mannot:0.3.0": *
#import "@preview/tyipa:0.1.0" as ipa
#import "@preview/rubby:0.10.2": get-ruby

#import cosmos.clouds: *

#import "template.typ": *

#let title = [ML과 LLM의 작동 원리]

#show: bubble.with(
  title: title,
  subtitle: "인공지능 기초 심화탐구 보고서",
  author: "황태준",
  affiliation: "중앙고등학교",
  date: datetime.today().display(),
  year: "2025",
  class: "2학년 7반 31번",
  other: ("",),
  logo: image("logo.svg"),
  color-words: ("important",),
  main-color: "872434"
)

#show: show-theorion
#set math.mat(delim: "[")
#set math.vec(delim: "[")
#set quote(block: true)

#show math.equation.where(block: false): it => math.display(it)
// show inline math as display

#set page(
  paper: "a4",
  margin: 3.7cm,
  header: [
    #align(horizon, [ \ \ \ \ #box(image("logo.svg", width: 8em, ), baseline: 3em)] ) 
    #align(right, title)
  ],
  footer: context [
    #align(right, line(length: 5em)) 
    #text(
      query(
        selector(heading.where(level: 1)).before(here())
      )
      .last().body, 
      size: 9pt
    )
    #h(1fr) #counter(page).display("1")
  ],
  numbering: "1",
  fill: rgb("c7c1a9").lighten(70%) // comment this when exporting for print
)

#set par(
  justify: false,
  leading: 1.35em,
  spacing: 2em
)

#show heading: set block(above: 2em, below: 1.3em)

#set text(
  font: (
    // "Source Han Serif K", // 가장 우선순위 폰트
    (
      name: "STIX Two Text", // 라틴 폰트
      covers: "latin-in-cjk",
    ),
    (
      name: "LXGW WenKai",
      covers: regex("[\p{scx:Han}\p{scx:Hira}\p{scx:Kana}]"),
    ), // 한자, 히라가나, 가타가나
    "Source Han Sans K", // CJK fallback 폰트
  ),
  cjk-latin-spacing: none,
)
#show math.equation: set text(
  font: (
    (
      name: "Libertinus Math",
      covers: "latin-in-cjk",
    ),
    "KoPubBatang_Pro",
  ),
  cjk-latin-spacing: none,
  weight: "thin",
  // stylistic-set: (2, 4, 6, 7, 10, 11),
  // ^ Garamond 사용시, hslash -> hbar는 6

  // stylistic-set: (2, 4),
  // ^ STIX Two 사용시, hslash -> hbar는 3
  stylistic-set: (8)
)

#show heading.where(level: 1): it => {
  counter(math.equation).update(0)
  it
}

#set math.equation(numbering: n => {
  numbering("(1.1)", counter(heading).get().first(), n)
  // if you want change the number of number of displayed
  // section numbers, modify it this way:
  /*
  let count = counter(heading).get()
  let h1 = count.first()
  let h2 = count.at(1, default: 0)
  numbering("(1.1.1)", h1, h2, n)
  */
})

#set figure(numbering: n => {
  numbering("1.1", counter(heading).get().first(), n)
  // if you want change the number of number of displayed
  // section numbers, modify it this way:
  /*
  let count = counter(heading).get()
  let h1 = count.first()
  let h2 = count.at(1, default: 0)
  numbering("(1.1.1)", h1, h2, n)
  */
})

#set math.equation(supplement: [식])
#set outline()
#show raw: set text(font: ("JetBrains Mono", "Source Han Sans K"))

#show math.equation: it => {
  let bb-font = "New Computer Modern Math" //Garamond-Math
  show regex("𝔸|𝔹|ℂ|𝔻|𝔼|𝔽|𝔾|ℍ|𝕀|𝕁|𝕂|𝕃|𝕄|ℕ|𝕆|ℙ|ℚ|ℝ|𝕊|𝕋|𝕌|𝕍|𝕎|𝕏|𝕐|ℤ|𝕒|𝕓|𝕔|𝕕|𝕖|𝕗|𝕘|𝕙|𝕚|𝕛|𝕜|𝕝|𝕞|𝕠|𝕡|𝕢|𝕣|𝕤|𝕥|𝕦|𝕧|𝕨|𝕩|𝕪|𝕫"): set text(font: bb-font)
  it
}


#outline(title: [목차], target: heading.where(level: 1))
#pagebreak()

#include "chapters/1_NeuraLNetwork.typ"