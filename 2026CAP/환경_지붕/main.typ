#import "@preview/physica:0.9.5": *
#import "@preview/alchemist:0.2.0": *
#import "@preview/theorion:0.5.0": *
#import "@preview/rich-counters:0.2.2": *
#import "@preview/cetz:0.5.2"
#import "@preview/cetz-plot:0.1.4"
#import "@preview/mannot:0.4.0": *
#import "@preview/codly:1.3.0": *
#import "@preview/codly-languages:0.1.10": *
#import "@preview/tyipa:0.1.1" as ipa
#import "@preview/rubby:0.10.2": get-ruby
#import "@preview/linguify:0.5.0": *
#import "@preview/parize:0.2.1": *
#import "@preview/wrap-it:0.1.1": *
#import "@preview/itemize:0.2.0" as el
#import "@preview/in-dexter:0.7.2": *
#import "@preview/metalogo:1.2.0": LaTeX, TeX


#show: show-theorion
#import cosmos.antique: *
#show: el.default-enum-list.with(
  auto-base-level: true,
)
// #show: par-indent.with(
//     exclude-elem: (
//         /*excludes specific block-level elements*/
//     ),
// )

#set text(lang: "ko", region: "kr")

#import "preamble.typ": *
#import "jsarticle.typ": *

#let title = [동아 삼국 전통가옥 지붕의 곡선 비교]

#show: jsarticle-book.with(
  title: title,
  subtitle: none,
  date: "2026년 6월 22일",
  author: "중앙고등학교",
  other: [
    30829 황태준
  ],
  paper-size: "a4",
  bind: "top",
  chapter-format: ("", "")
)

#pagebreak(to: "odd")

// 목차 앞부분은 로마자 페이지 번호 (vii 등)
#set page(numbering: "i")

#outline(
  title: "목차",
  // indent: n => n * n * 1em,
  depth: 3,
)

#pagebreak()



// ====================
// 본문 시작 (아라비아 숫자로 변경)
// ====================
#set page(numbering: "1")
#counter(page).update(1)

#include "sections/1.typ"
#include "sections/2.typ"

#bibliography("bib.yaml", title: "참고문헌")