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

#set text(lang: "en", region: "US")

#import "preamble.typ": *
#import "jsarticle.typ": *

#show: jsarticle-book.with(
    title: "존재의 좌표계",
    subtitle: "세계의 본질에 대한 논의와 실존적 도구주의에 대한 고찰",
    date: "독서 심화탐구 보고서",
    author: "중앙고등학교",
    other: [
        30829 황태준
    ],
    logo: image("logo.svg", width: 18%),
    paper-size: "a5",
    bind: "center"
)

#pagebreak(to: "odd")

// 목차 앞부분은 로마자 페이지 번호 (vii 등)
#set page(numbering: "i")

#heading(level: 1, numbering: none, outlined: false)[]

먼저, 이걸 쓴 놈은 철학이나 인문학 같은 것을 한 번도 제대로 공부해 본 적이 없으며, 모든 철학적 지식은 기출 및 수능특강 비문학 지문 또는 친구놈 홍상\*(이하 홍 씨), 학교 선생님 수업, 인터넷 검색 등으로 얻은 것이므로 본서에 등장하는 모든 논의는 그 자료들부터 기반함을 명시합니다. 따라서 주장에 대한 해석이 부정확하거나 철학자, 학파에 대한 몰이해가 있을 수 있습니다. 분명 여기서 진행하는 논의나 주장이 기성 철학자 누군가의 그것과 일치할 가능성이 높으나 저는 한 번도 그들의 책을 읽어본 적이 없을 가능성이 높으므로 해당 철학자의 관점에서 본서를 비판하는 것도 좋지만 본서 관점 있는 그대로 보는 쪽에서도 살펴 주시길 바랍니다.

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

#include "sections/1.typ"
#include "sections/2.typ"
#include "sections/3.typ"
#include "sections/4.typ"


