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
        
//     ),
// )

#set text(lang: "ko", region: "kr")

#import "preamble.typ": *
#import "jsarticle.typ": *

#let title = [양자컴퓨팅 기초]


#show: jsarticle-book.with(
    title: title,
    subtitle: "Introduction to Quantum Computing",
    date: "2025 ~ 2026",
    author: "20731/30829 황태준",
    other: [

    ],
    paper-size: "a4",
    bind: "center",
    doc-type: "article",
    // font-size: 12pt,
    // baseline-ratio: 1.618,
    cjk-spacing: 0.12em,
    latin-tracking: -0.0em,
    marginal-outset: 2em,
)

#pagebreak(to: "odd")

// 목차 앞부분은 로마자 페이지 번호 (vii 등)
#set page(numbering: "i")

// #include "sections/1_Intro.typ"

#outline(
    title: "目次",
    // indent: n => n * n * 1em,
    depth: 3,
)

#pagebreak()



// ====================
// 본문 시작 (아라비아 숫자로 변경)
// ====================
#set page(numbering: "1")
#counter(page).update(1)



// #include "sections/test2.typ"
#include "sections/1_Intro.typ"
#include "sections/2_QuantumStates.typ"
#include "sections/3_Observables.typ"
#include "sections/4_UnitaryOperators.typ"
#include "sections/5_QuantumEntanglement.typ"
#include "sections/6_QuantumCryptography.typ"
#include "sections/7_DensityOperator.typ"
#include "sections/8_SchmidtDecomposition.typ"
#include "sections/22_TQC.typ"
// #include "sections/test.typ"
#include "sections/typography_specimen.typ"
