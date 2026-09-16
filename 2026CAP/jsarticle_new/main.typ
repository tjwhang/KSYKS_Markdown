#import "preamble.typ": *

#show: show-theorion
#show: el.default-enum-list.with(auto-base-level: true)
// #show: par-indent.with(
//     exclude-elem: (

//     ),
// )


#import "jsarticle.typ": *
#import "fonts.typ": document-composites

#let title = [통합 조판 체계 견본]

#show: jsarticle-book.with(
    options: jsarticle-options(
        document: (
            title: title,
            subtitle: "부제목",
            date: datetime.today().display("[year]년 [month]월 [day]일"),
            author: "저작자",
            //   authors: ([제1저작자], [제2저작자]),
            author-layout: "inline",
            other: [

            ],
            title-page: "cover",
        ),
        page: (paper-size: "a4", bind: "center", doc-type: "article", h1-break: "adaptive"),
        typography: (
            ambient-language: "ko",
            // font-size: 12pt,
            // baseline-ratio: 1.618,
            cjk-spacing: 0.2em,
            latin-tracking: -0.0em,
            marginal-outset: 2em,
            inline-math-display-style: true,
            inline-math-bounds: true,
            optical-profiles: (ko: (
                hangul: (
                    scale: 0.925em,
                    // baseline: -0.00em,
                    // tracking: -0.08em,
                ),
                han: (baseline: 0.02em, tracking: 0.00em),
                western: (tracking: 0em),
                // punctuation: (baseline: -0.07em, tracking: 0em),
            )),
        ),
        fonts: (
            composites: document-composites,
            body-family: "serif",
            strong-family: "gothic-bold",
            heading-family: "serif-bold",
            ruby-family: "footnote",
        ),
        vertical: (
            font-family: auto,
            strong-family: auto,
            heading-family: auto,
            page-start: false,
            unicode-fallbacks: true,
            collapse-punctuation-space: true,
            korean-fullwidth-spaces: false,
            boundary-spacing: 0.2em,
            latin-orientation: "rotate",
            heading-mode: "visual",
            tcy-max-digits: 2,
            tracking: 0pt,
            width: auto,
            height: auto,
            columns: 1,
            rows: 2,
            line-gap: 0.6em,
            column-gap: 2em,
            row-gap: 2em,
            row-fit-threshold: 1.5, // default 1.5
            line-overhang-threshold: 0.9em, // default 0.5
            min-final-line-chars: 2, // default 2
            min-fragment-chars: 2, // default 2; use 1 to disable balancing
            min-fragment-languages: ("ko",),
            justify: true,
            justify-languages: ("ko",),
            orphan-lines: 2,
            widow-lines: 2,
            stream-gap: auto,
        ),
        horizontal: (normalization: (enabled: false, punctuation: true, spaces: false, collapse-punctuation-space: true)),
    ),
)

// #jsicover(title, author: [저작자], subtitle: [부제목])

// #set text(region: "hj")

#set page(numbering: "i")

// #include "sections/1_Intro.typ"

#outline(
    title: "目次",
    // indent: n => n * n * 1em,
    depth: 3,
)

#pagebreak()

#jspart(num: [第1部], "SPECIMEN")
// ====================
// 본문 시작 (아라비아 숫자로 변경)
// ====================
#set page(numbering: "1")
#counter(page).update(1)

#epigraph(
    style: "line",
    scope: "page",
    align-x: center,
    attribution: [칸트, 『윤리형이상학정초』],
)[
    불운들과 희망 없는 깊은 슬픔이 생에 대한 흥미를 완전히 앗아갔더라도, 이때 이 불행한 자가 영혼의 힘#footnote[칸트는 의무를 지키고자 하는 '영혼의 힘'을 '덕'이라고 한다.]이 강해서 운명에 겁먹고 굴복하기보다는 오히려 격분하여, 죽음을 원하면서도 그의 생명을 보존한다면, 그것도 생명을 사랑해서나 경향성이나 두려움에서 그러한 것이 아니라, 의무로부터 그러하다면, 그의 준칙은 도덕적 가치를 갖는 것이다.
]

#epigraph(
    style: "dash",
    scope: "page",
    align-x: center,
    attribution: [마르크스, 『資本論』],
)[
    다수의 개별 부분 노동자로 구성되는 사회적 생산조직은 자본가에게 속한다. 그러므로 각종 노동의 결합으로부터 발생하는 생산력은 자본이 생산력으로 나타난다. 진정한 '매뉴팩처'(Manufaktur)#footnote[분업에 의거한 협업을 바탕으로 수작업으로 상품을 생산하는 공장제 수공업.]는 이전에 독립적이었던 노동자를 자본의 지휘와 규율에 복종시킬 뿐 아니라, 노동자 자신들 사이에 등급적 계층을 만들어 낸다.
]

#epigraph(style: "vert", scope: "page", align-x: center, attribution: [율곡 이이, 『七言古決』])[
    寄語世間獨覺士 須從白兎走靑林
]

// #include "sections/problems.typ"

#include "sections/test.typ"
#include "sections/font-sp.typ"
#include "sections/typography_specimen.typ"
