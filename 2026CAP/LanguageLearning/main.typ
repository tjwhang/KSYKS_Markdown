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
#import "@preview/wrap-it:0.1.1": *

#import cosmos.antique: *
#import "template.typ": *
#import "theme.typ": *


// --- 0. 문서 메타데이터 ---
#let title = [What Truly Drives \ Language Fluency]
#let subtitle = ""
#let outline-title = [Table of Contents]
#let author-name = "30829 황태준"
#let publisher = "30829 황태준"
#let affiliation = "2026학년도 3학년 1학기 영어 탐구보고서"

#let is-book-mode = false

// --- 1. 기술적 설정 적용 ---
#show: show-theorion
#show: setup-rules
#set document(title: title, author: author-name)

#let lang-data = toml("lang.toml")
#set-database(lang-data)

#show: codly-init.with()
#codly(languages: codly-languages)
#codly(inset: (top: 0.13em, bottom: 0.13em))

// --- 2. 동적 페이지 서식 (모드 연동) ---
// 마진 동적 계산
#let p-paper = if is-book-mode { "iso-b5" } else { "a4" }
#let m-top = if is-book-mode { 17mm } else { 40mm }
#let m-bottom = if is-book-mode { 20mm } else { 20mm }
#let m-inside = if is-book-mode { 25mm } else { 25mm }
#let m-outside = if is-book-mode { 15mm } else { 25mm }

#set page(
    paper: p-paper,
    margin: (top: m-top, bottom: m-bottom, inside: m-inside, outside: m-outside),

    header: context {
        let is-odd = calc.odd(here().page())
        let headings = query(selector(heading.where(level: 1)).before(here())).filter(it => it.body != outline-title)
        let chapter = if headings.len() > 0 { headings.last().body } else { "" }
        let pg-num = counter(page).display("1")


        set text(size: 9pt, fill: luma(120), font: font-heading)

        block(stroke: (bottom: 0.5pt + luma(255)), width: 100%, inset: (bottom: 6pt), {
            if is-book-mode {
                // 책 모드: 홀수/짝수 대칭 (로고와 단원명 표시)
                if is-odd {
                    grid(
                        columns: (1fr, auto),
                        align(left, chapter), align(right + horizon, title),
                    )
                } else {
                    grid(
                        columns: (auto, 1fr),
                        align(left, image("logo.svg", height: 1em)), align(right + horizon, chapter),
                    )
                }
            } else {
                // 보고서 모드: 항상 우측 상단에 로고와 제목
                align(right + horizon)[#stack(
                    dir: ltr,
                    spacing: 0.8em,
                    if is-book-mode {
                        // 책 모드: 홀수는 우측, 짝수는 좌측에 페이지 번호
                        // if is-odd { align(right, pg-num) } else { align(left, pg-num) }
                    } else {
                        // 보고서 모드: 항상 가운데 정렬
                        align(left, pg-num)
                    },
                    image("logo.svg", height: 1em),
                    line(length: 1em, angle: 90deg, stroke: 1pt + accent-color),
                    title,
                )]
                counter(footnote).update(0)
            }
        })
    },

    footer: context {
        let is-odd = calc.odd(here().page())
        let pg-num = counter(page).display("1")
        set text(size: 10pt, font: "Libertinus Serif", fill: luma(80))

        if is-book-mode {
            // 책 모드: 홀수는 우측, 짝수는 좌측에 페이지 번호
            if is-odd { align(right, pg-num) } else { align(left, pg-num) }
        } else {
            // 보고서 모드: 항상 가운데 정렬
            // align(center, pg-num)
        }
    },
    numbering: "1",
    header-ascent: 20%,
    footer-descent: 20%,
)

// --- 3. 헤딩 디자인 (Antique & Professional) ---
// if you want change the number of number of displayed section numbers, modify it this way:
/*
let count = counter(heading).get()
let h1 = count.first()
let h2 = count.at(1, default: 0)
numbering("(1.1.1)", h1, h2, n)
*/

#set heading(numbering: (..args) => {
    let nums = args.pos()
    if nums.at(0) == 0 { return none }
    traditional-numbering("I.1.1.i", ..nums)
})

#show heading: it => {
    let head-num = if it.numbering != none { counter(heading).display(it.numbering) } else { none }
    set text(fill: text-color, font: font-heading)

    if it.level == 1 {
        // pagebreak(weak: true)
        // v(3em)
        // align(center)[
        //     #text(size: 1.4em, weight: "bold", fill: accent-color, tracking: 0.1em, {
        //         if head-num != none { head-num }
        //     })

        //     #v(-0.3em)
        //     #text(size: 2.2em, weight: "black", it.body)
        //     #v(0.5em)
        //     #line(length: 3em, stroke: 1.5pt + accent-color)
        // ]
        // v(4em)

        pagebreak(weak: true)
        v(4em)
        align(center)[
            #block(width: 100%, {
                // 1. 워터마크 설정 리스트
                let watermark-map = (
                    "目次": (
                        keywords: ("목차", "contents", "目次", "outline", "table of contents"),
                        size: 2.5em,
                    ),
                    "參考文獻": (
                        keywords: ("참고문헌", "references", "bibliography", "출처", "引用文献"),
                        size: 2em,
                    ),
                    "附錄": (
                        keywords: ("부록", "appendix", "付録"),
                        size: 2.5em,
                    ),
                    "序文": (
                        keywords: ("머리말", "preface", "서문", "前書き", "序文"),
                        size: 2.5em,
                    ),
                    "前文": (
                        keywords: ("전문", "preamble", "前文"),
                        size: 2.5em,
                    ),
                    "跋文": (
                        keywords: ("꼬리말", "afterword", "postface", "발문", "後書き", "跋文"),
                        size: 2.5em,
                    ),
                    "序論": (
                        keywords: ("서론", "序論"),
                        size: 2.5em,
                    ),
                    "本論": (
                        keywords: ("본론", "本論"),
                        size: 2.5em,
                    ),
                )
                let bg-text = ""
                let bg-size = 3.5em // 숫자의 경우 기본 크기
                let title-str = lower(repr(it.body)) // 현재 제목을 문자열로 변환

                // if head-num != none {
                //     bg-text = head-num
                // } else {
                //     for (label, data) in watermark-map {
                //         if data.keywords.any(k => k in title-str) {
                //             bg-text = label
                //             bg-size = data.size
                //             break
                //         }
                //     }
                //     // if bg-text == "" {
                //     //     bg-text = it.body
                //     //     bg-size = 3.5em
                //     // }
                // }

                for (label, data) in watermark-map {
                    if data.keywords.any(k => k in title-str) {
                        bg-text = label
                        bg-size = data.size
                        break
                    }
                }

                if bg-text == "" {
                    if head-num != none {
                        bg-text = head-num
                        bg-size = 3.5em
                    }
                    // else {
                    //     bg-text = it.body
                    //     bg-size = 3.5em
                    // }
                }

                if bg-text != "" {
                    place(center + horizon)[
                        #text(
                            size: bg-size,
                            weight: "black",
                            font: ("Libertinus Serif", "Source Han Serif"),
                            fill: accent-color.transparentize(85%),
                            bg-text,
                        )
                    ]
                }
                move(dy: 1.2em, pad(y: 1.5em, text(size: 2em, weight: "black", it.body)))
            })
            #v(0.5em)
            #line(length: 3em, stroke: 1.5pt + accent-color)
        ]
        v(7%)
        par[]
    } else if it.level == 2 {
        v(1.5em)
        block(width: 100%, stroke: (bottom: 1.5pt + accent-color), inset: (bottom: 0.6em), {
            stack(
                dir: ltr,
                spacing: 0.8em,
                text(
                    fill: accent-color,
                    weight: "black",
                    size: 1.2em,
                    baseline: 0em,
                    bottom-edge: "baseline",
                    font: ("EB Garamond", "source han serif"),
                    {
                        if head-num != none { head-num }
                    },
                ),
                move(dy: -0.8em, align(top, box(inset: (y: -1.6em), text(
                    weight: "bold",
                    size: 1.2em,
                    baseline: 0em,
                    it.body,
                )))),
            )
        })
        // v(0.5em)
        par[]
    } else if it.level == 3 {
        v(0.5em)
        stack(dir: ltr, spacing: 0.6em, text(fill: accent-color, weight: "black", size: 1.15em, "|"), text(
            weight: "semibold",
            size: 1.15em,
            {
                if head-num != none { head-num + h(0.4em) }
                it.body
            },
        ))
        // v(0.5em)
        par[]
    } else if it.level == 4 {
        //[H4] 들여쓰기된 심플한 불릿 포인트 (•)
        v(0.8em)
        pad(left: 0.5em, stack(dir: ltr, spacing: 0.5em, text(fill: luma(120), size: 1em, "•"), text(
            weight: "semibold",
            size: 1.05em,
            fill: luma(60),
            {
                if head-num != none { head-num + h(0.4em) }
                it.body
            },
        )))
        v(0.4em)
    } else {
        it
        v(0.8em)
    }
}

// 수식 및 그림 번호 로직 복구
#show heading.where(level: 1): it => {
    counter(math.equation).update(0)
    it
}

#set math.equation(numbering: n => {
    let h = counter(heading).get()
    let h1 = if type(h) == array { h.first() } else { h }
    let h2 = if type(h) == array and h.len() >= 2 { h.at(1) } else { 0 }
    if h1 > 0 and h2 > 0 { numbering("(I.1.1)", h1, h2, n) } else if h2 <= 0 { numbering("(I.1)", h1, n) } else {
        numbering("(1)", n)
    }
})

#set figure(numbering: n => {
    let h = counter(heading).get()
    let h1 = if type(h) == array { h.first() } else { h }
    let h2 = if type(h) == array and h.len() >= 2 { h.at(1) } else { 0 }
    if h1 > 0 and h2 > 0 { numbering("I.1.1", h1, h2, n) } else if h2 <= 0 { numbering("I.1", h1, n) } else {
        numbering("1", n)
    }
})


// --- 4. 문서 시작 (Title Page) ---
#page(numbering: none, header: none, footer: none, margin: (top: 2in, bottom: 2in))[
    #set align(center); #v(1in)

    #block(spacing: 0.5em)[
        #text(size: 2.5em, fill: accent-color, weight: "extrabold", font: font-heading, title)
        #v(-2.3em)
        #if subtitle != none [ \ #text(size: 1.5em, weight: "regular", subtitle) ]
    ]
    #v(4em); #text(size: 1.2em, weight: "bold", author-name, font: (
        "Pretendard JP",
        "M PLUS 2",
        "Source han sans",
    ))
    #if affiliation != none { [ \ #v(0.5em) #text(size: 1.1em, fill: luma(50), affiliation) ] }
    #v(2em)
    #text(size: 1em, fill: luma(100), "편집 · 조판 | " + publisher)
    #v(-0.6em)
    #text(size: 1em, fill: luma(100), "최종 편집일 | " + datetime.today().display("[year].[month].[day]."))

    // 표지 하단 로고 배치 (바닥으로 밀어내기)
    #v(1fr)
    #image("logo.svg", width: 25%) // 적절한 크기로 조절
]

#page(header: none)[#pagebreak(to: "odd")]

// --- 5. 목차 및 본문 구성 ---
#outline(title: outline-title, depth: 3)
#pagebreak(weak: true)

// #heading(numbering: none)[전문]

// #heading(numbering: none)[서문]

// #include "chapters/UDHR.typ"

#include "chapters/0.typ"