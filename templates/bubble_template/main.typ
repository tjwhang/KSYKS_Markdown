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
#import "@preview/linguify:0.5.0": *

#import cosmos.clouds: *

#import "template.typ": *

#let title = [제목 입력]

#show: bubble.with(
  title: title,
  subtitle: "부제목",
  author: "지도교사 선생님",
  affiliation: "중앙고등학교",
  date: datetime.today().display(),
  year: "20731 황태준",
  class: "",
  other: ("",),
  logo: image("logo.svg"),
  color-words: ("important",),
  main-color: "872434",
  body-font: "Source Han Serif K",
  title-font: (
    (
      name: "KoPubBatang_Pro",
      covers: regex("[「」『』《》〈〉]"),
    ),
    (
      name: "STIX Two Text", // 라틴 폰트
      covers: "latin-in-cjk",
    ),
    (
      name: "Source Han Serif",
      covers: regex("[\p{scx:Han}\p{scx:Hira}\p{scx:Kana}+]"),
    ), // 한자, 히라가나, 가타가나
    (
      name: "KoPubBatang_Pro",
      covers: regex("[\p{scx:Hangul}+]"),
    ) // CJK fallback 폰트
  ),
)

#show: show-theorion
#set math.mat(delim: "[")
#set math.vec(delim: "[")
#set quote(block: true)

#show math.equation.where(block: false): it => math.display(it)
// show inline math as display

#set page(
  paper: "a4",
  margin: 3.4cm,
  header: [
    #align(horizon, [ \ \ \ \ #box(image("logo.svg", width: 8em), baseline: 3em)])
    #align(right, title)
    #counter(footnote).update(0)
  ],

  footer: context [
    #text(
      query(
        selector(heading.where(level: 1)).before(here()),
      )
        .last()
        .body,
      size: 10pt,
    )
    #h(1fr) #counter(page).display("1")
  ],
  numbering: "1",
  // fill: rgb("c7c1a9").lighten(70%), // comment this when exporting for print
)

#set par(
  first-line-indent: (amount: 1em, all: true),
  justify: false,
  leading: 1.2em,
  spacing: 1.7em,
)

#show heading: set block(above: 2em, below: 1.3em)

#set text(
  size: 10pt,
  font: (
    // "Source Han Serif K", // 가장 우선순위 폰트
    (
      name: "STIX Two Math",
      covers: regex("[†‡§¶‖#*]"),
    ),
    (
      name: "KoPubBatang_Pro",
      covers: regex("[「」『』《》〈〉]"),
    ),
    (
      name: "STIX Two Text", // 라틴 폰트
      covers: "latin-in-cjk",
    ),
    (
      name: "LXGW WenKai",
      covers: regex("[\p{scx:Han}\p{scx:Hira}\p{scx:Kana}+]"),
    ), // 한자, 히라가나, 가타가나
    (
      name: "KoPubBatang_Pro",
      covers: regex("[\p{scx:Hangul}+]"),
    ),
    "stix two math",
    "Source Han Serif K", // CJK fallback 폰트
  ),
  cjk-latin-spacing: none,
  lang: "ko",
)
#let lang-data = toml("lang.toml")
#set-database(lang-data)

#show regex("[\p{scx:Han}\p{scx:Hira}\p{scx:Kana}\p{scx:Hangul}]+"): set text(size: 0.925em)
#show regex("[\p{scx:Hangul}]+"): set text(baseline: -0.05em)

#show math.equation: set text(
  font: (
    (
      name: "Garamond-Math",
      covers: "latin-in-cjk",
    ),
    (
      name: "Sunbatang",
      covers: regex("."),
    ),
  ),
  cjk-latin-spacing: none,
  weight: "regular",
  // stylistic-set: (2, 4, 6, 7, 10, 11),
  // ^ Garamond 사용시, hslash -> hbar는 6

  stylistic-set: (2, 4),
  // ^ STIX Two 사용시, hslash -> hbar는 3

  // stylistic-set: 8,
  // ^ Libertine 사용 시
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

#set footnote(numbering: "*")
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

#let insert-part(name) = {
    pagebreak(to: "odd", weak: true)
    v(20em)
    show heading: set text(weight: "regular", size: 2em)
    align(center)[#block(spacing: 0em, heading(depth: 1, name))]
    pagebreak()
}


#outline(title: [목차], target: heading.where(level: 1))
#pagebreak()

#include "chapters/chapter1.typ"

#bibliography("bib.yaml", title: "참고문헌 및 출처")
