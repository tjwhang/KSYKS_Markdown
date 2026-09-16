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

#import cosmos.antique: *
#import "template.typ": *
#import "theme.typ": *
#import "chart.typ": *

// --- 0. 문서 메타데이터 ---
#let title = [物理學Ⅰ+Ⅱ의 要諦]
#let subtitle = "2015 개정교육과정 외"
#let outline-title = [목차]
#let author-name = "황태준 著"
#let affiliation = none

// --- 1. 기술적 설정 적용 ---
#show: show-theorion
#show: setup-rules
#set document(title: title, author: author-name)

#let lang-data = toml("lang.toml")
#set-database(lang-data)

// --- 2. 페이지 서식 설정 ---
#set page(
    paper: "iso-b5",
    margin: (top: 20mm, bottom: 25mm, inside: 25mm, outside: 20mm),
    header: context {
        let is-odd = calc.odd(here().page())
        set text(size: 9pt, fill: luma(100))
        let header-content = if is-odd {
            align(right)[#stack(dir: ltr, spacing: 1em, title, line(
                length: 1em,
                angle: 90deg,
                stroke: 1.5pt + accent-color,
            ))]
        } else {
            // align(left)[#stack(dir: ltr, spacing: 1em, line(length: 1em, angle: 90deg, stroke: 1.5pt + accent-color), image("logo.svg", width: 6em))]
            align(left)[#stack(
                dir: ltr,
                spacing: 1em,
                line(length: 1em, angle: 90deg, stroke: 1.5pt + accent-color),
                [],
            )]
        }
        header-content
        v(1em)
        counter(footnote).update(0)
    },
    footer: context {
        let is-odd = calc.odd(here().page())
        let headings = query(selector(heading.where(level: 1)).before(here())).filter(it => it.body != outline-title)
        let chapter = if headings.len() > 0 { headings.last().body } else { "" }
        set text(size: 9pt)
        stack(spacing: 0.6em, line(length: 100%, stroke: 0.5pt + accent-color.lighten(50%)), if is-odd {
            grid(
                columns: (1fr, auto),
                chapter, counter(page).display("1"),
            )
        } else {
            grid(
                columns: (auto, 1fr),
                counter(page).display("1"), align(right, chapter),
            )
        })
    },
    numbering: "1",
    header-ascent: 10%,
    footer-descent: 40%,
)

// --- 3. 헤딩 디자인 (Antique Chart Style) ---
#set heading(numbering: (..args) => {
    let nums = args.pos()
    if nums.at(0) == 0 { return none }
    numbering("I.1.", ..nums)
})

#show heading: it => {
    let head-num = if it.numbering != none { counter(heading).display(it.numbering) } else { none }
    set text(fill: accent-color, font: font-heading)

    if it.level == 1 {
        context {
            let is-odd = calc.odd(here().page())
            let m-left = if is-odd { 25mm } else { 20mm }
            let m-right = if is-odd { 20mm } else { 25mm }
            v(2em)
            pad(left: -m-left, right: -m-right, block(
                width: 100% + m-left + m-right,
                fill: c-maroon,
                inset: (left: m-left, y: 0.8em),
                text(fill: white, size: 1.5em, weight: "black", {
                    if head-num != none { head-num + h(0.6em) }
                    it.body
                }),
            ))
            v(1.5em)
        }
    } else if it.level == 2 {
        context {
            let is-odd = calc.odd(here().page())
            let m-left = if is-odd { 25mm } else { 20mm }
            let m-right = if is-odd { 20mm } else { 25mm }
            v(1.5em)
            pad(left: -m-left, right: -m-right, grid(
                columns: (auto, 1fr),
                rows: auto,
                gutter: 0pt,
                rect(fill: c-navy, inset: (left: m-left, right: 1em, y: 0.815em), stroke: none, text(
                    fill: white,
                    weight: "black",
                    size: 1.4em,
                    { if head-num != none { head-num } else { "§" } },
                )),
                block(
                    width: 100%,
                    fill: c-navy.lighten(95%),
                    inset: (left: 0.8em, y: 0.7em),
                    stroke: (bottom: 2pt + c-navy),
                    align(left + horizon, text(fill: c-navy, size: 1.6em, weight: "bold", it.body)),
                ),
            ))
            v(1em)
        }
    } else if it.level == 3 {
        v(1em)
        block(spacing: 0.8em, {
            stack(dir: ltr, spacing: 0.6em, text(fill: c-forest, weight: "black", size: 1.1em, "§"), text(
                fill: c-forest.darken(10%),
                weight: "bold",
                size: 1.1em,
                {
                    if head-num != none { head-num + h(0.4em) }
                    it.body
                },
            ))
        })
        v(0.6em)
    } else { it }
}

// 수식 번호 초기화 로직
#show heading.where(level: 1): it => {
    counter(math.equation).update(0)
    it
}

// 넘버링 보완 설정
#set math.equation(numbering: n => {
    let h = counter(heading).get()
    let h1 = if type(h) == array { h.first() } else { h }
    if h1 > 0 { numbering("(1.1)", h1, n) } else { numbering("(1)", n) }

    // numbering("(1.1)", counter(heading).get().first(), n)
    // 
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
    let h = counter(heading).get()
    let h1 = if type(h) == array { h.first() } else { h }
    if h1 > 0 { numbering("1.1", h1, n) } else { numbering("1", n) }
})
#set math.equation(supplement: [식])

// --- 4. 문서 시작 (Title Page) ---
#page(numbering: none, header: none, footer: none, margin: (top: 2in, bottom: 2in))[
    #set align(center); #v(1in)
    #block(spacing: 0.5em)[
        #text(size: 2.5em, fill: accent-color, weight: "extrabold", font: font-main, title)
        #if subtitle != none [ \ #text(size: 1.5em, weight: "regular", subtitle) ]
    ]
    #v(3em); #text(size: 1.2em, author-name)
    #if affiliation != none [ \ #text(size: 1em, affiliation) ]
    #v(2em); #text(size: 1.1em, datetime.today().display())
]

#page(header: none)[#pagebreak(to: "odd")]

// --- 5. 목차 및 본문 구성 ---
#outline(title: outline-title, target: heading.where(level: 1))
#pagebreak(weak: true)

#include "chapters/0.typ"

#chapter-cover(
    number: "1",
    title: "역학과 에너지",
    description: "",
    sections: (
        [*힘과 운동* \ 물체의 운동 \ 뉴턴 운동 법칙 \ 운동량과 충격량],
        [*에너지와 열* \ 일과 에너지 \ 열역학 법칙],
        [*특수 상대성 이론* \ 특수 상대성 이론 \ 질량과 에너지],
    ),
)
#include "chapters/1-1.typ"

// #bibliography("bib.yaml", title: "참고문헌 및 출처")
