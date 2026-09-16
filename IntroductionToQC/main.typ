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

#import cosmos.fancy: *

#import "template.typ": *

#let title = [
  #set text(font: "Libertinus Serif", weight: "bold")
  Introduction to \ Quantum Computing
]

#show: bubble.with(
  title: title,
  subtitle: [양자컴퓨팅 기초],
  author: "황태준",
  affiliation: "중앙고등학교",
  date: datetime.today().display(),
  year: "",
  class: "2학년 7반 31번",
  other: ("",),
  // logo: image("cahs_ico.svg"),
  color-words: ("important",),
  main-color: "383218",
)

#show: show-theorion
#set math.mat(delim: "[")
#set math.vec(delim: "[")

#set quote(block: true)

// show inline math as display
#show math.equation.where(block: false): it => math.display(it)

#set page(
  paper: "a4",
  margin: 3.4cm,
  header: [
    // #align(horizon, [ \ \ \ \ #box(image("cahs_ico.svg", width: 8em), baseline: 3em)])
    #align(right, title)
    #counter(footnote).update(0)
  ],
  footer: context [
    #align(right, line(length: 5em))
    #text(
      query(
        selector(heading.where(level: 1)).before(here()),
      )
        .last()
        .body,
      size: 9pt,
    )
    #h(1fr) #counter(page).display("1")
  ],
  numbering: "1",
  // fill: rgb("c7c1a9").lighten(70%), // comment this when exporting for print
)

#set par(
  justify: false,
  leading: 1.2em,
  spacing: 1.8em,
)

#show heading: set block(above: 2em, below: 1.3em)


#set text(
  font: (
    // "Source Han Serif K", // 가장 우선순위 폰트
    (
            name: "STIX Two Math",
            covers: regex("[†‡§¶‖#*]")
    ),
    (
            name: "KoPubBatang_Pro",
            covers: regex("[「」『』《》〈〉]")
    ),
    (
      name: "source han serif",
      covers: regex("[\p{scx:Han}\p{scx:Hira}\p{scx:Kana}+]"),
    ), // 한자, 히라가나, 가타카나
    (
      name: "new computer modern", // 라틴 폰트
      covers: "latin-in-cjk",
    ),
    //"STIX Two Text",
    (
      name: "KoPubBatang_Pro",
      covers: regex("[\p{scx:Hangul}+]"),
    ),
    "new computer modern math",
    "Source Han Serif K", // CJK Fallback 폰트
  ),
  cjk-latin-spacing: none,
  // weight: "thin"
)
#show regex("[\p{scx:Han}\p{scx:Hira}\p{scx:Kana}[\u3131-\uD79D]]+"): set text(size: 0.925em)
#show regex("[\p{scx:Hangul}]"): set text(baseline: -0.045em)


#show math.equation: set text(
  font: (
    (
      name: "new computer modern Math",
      covers: "latin-in-cjk",
    ),
    (
      name: "KoPubBatang_Pro",
      covers: regex("."),
    ),
  ),
  cjk-latin-spacing: none,
  // stylistic-set: (2, 4, 6, 7, 10, 11),
  // ^ Garamond 사용시, hslash -> hbar는 6

  // stylistic-set: (2, 3, 4),
  // ^ STIX Two 사용시, hslash -> hbar는 3
  weight: "regular",
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
  let bb-font = "new computer modern math"
  show regex(
    "𝔸|𝔹|ℂ|𝔻|𝔼|𝔽|𝔾|ℍ|𝕀|𝕁|𝕂|𝕃|𝕄|ℕ|𝕆|ℙ|ℚ|ℝ|𝕊|𝕋|𝕌|𝕍|𝕎|𝕏|𝕐|ℤ|𝕒|𝕓|𝕔|𝕕|𝕖|𝕗|𝕘|𝕙|𝕚|𝕛|𝕜|𝕝|𝕞|𝕠|𝕡|𝕢|𝕣|𝕤|𝕥|𝕦|𝕧|𝕨|𝕩|𝕪|𝕫",
  ): set text(font: bb-font)
  it
}

#show math.equation: it => {
  let special-font = "stix two math"
  show regex(
    "†|\*",
  ): set text(font: special-font)
  it
}

// #set footnote(numbering: "1)")
#set footnote(numbering: (..v) => super(typographic: false, size: 0.9em, baseline: -.25em, numbering("*", ..v)))

#set smartquote(quotes: (double: ("「", "」"), single: ("『", "』")))
#show "“": "「"
#show "”": "」"
#show "‘": "『"
// #show "’": "』"
#show regex("\w’\w|’"): match => {
  if match.text.len() > 1 {
    // 길이가 1보다 크다면 "\w’\w" 패턴에 걸린 것 (아포스트로피)
    // 바꾸지 않고 그대로 둡니다.
    match.text 
  } else {
    // 그 외에는 독립적인 닫는 따옴표이므로 겹낫표로 바꿉니다.
    "』"
  }
}

#outline(title: [목차], target: heading.where(level: 1))
#pagebreak()

#include "chapters/1_Intro.typ"
#pagebreak()
#include "chapters/2_QuantumStates.typ"
#pagebreak()
#include "chapters/3_Observables.typ"
#pagebreak()
#include "chapters/4_UnitaryOperators.typ"
#pagebreak()
#include "chapters/5_QuantumEntanglement.typ"
#pagebreak()
#include "chapters/6_QuantumCryptography.typ"
#pagebreak()
#include "chapters/7_DensityOperator.typ"
#pagebreak()
#include "chapters/8_SchmidtDecomposition.typ"