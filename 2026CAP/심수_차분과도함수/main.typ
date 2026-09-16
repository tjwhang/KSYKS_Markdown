#import "@preview/physica:0.9.5": *
#import "@preview/alchemist:0.1.4": *
#import "@preview/theorion:0.5.0": *
#import "@preview/rich-counters:0.2.1": *
#import "@preview/cetz:0.3.4"
#import "@preview/cetz-plot:0.1.1"
#import "@preview/mannot:0.3.0": *
#import "@preview/codly:1.3.0": *
#import "@preview/codly-languages:0.1.1": *
#import "@preview/tyipa:0.1.0" as ipa
#import "@preview/rubby:0.10.2": get-ruby
#import "@preview/linguify:0.5.0": *
#import "@preview/parize:0.1.0": *
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

#let title = [차분과 도함수의 관계]

#show: jsarticle-book.with(
    title: title,
    subtitle: [테일러 전개를 통한 『중앙차분--도함수 정리』 유도],
    date: "심화수학Ⅰ 탐구보고서",
    author: "중앙고등학교",
    other: [
        30829 황태준
    ],
    paper-size: "a4",
    bind: "center",
    logo:[
        #image("logo.svg", width: 18%)
        #text(font: font-body)[中央髙等學校]
    ]
)

#pagebreak(to: "odd")
// 목차 앞부분은 로마자 페이지 번호 (vii 등)
#set page(numbering: "i")

#include "sections/0_preface.typ"

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

// #bibliography("bib.yaml", title: "參考文献")