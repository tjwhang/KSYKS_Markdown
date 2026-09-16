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

#import cosmos.tjwhang: *

#import "template.typ": *

#show: show-theorion
#set math.mat(delim: "[")
#set math.vec(delim: "[")
#set math.cases(gap: 0.8em)
#set quote(block: true)

#show math.equation.where(block: false): it => math.display(it) // show inline math as display
#show math.equation.where(block: false): set math.frac(style: "skewed")

#let title = [마른얼음 혁명 로-케트]
#let subtitle = "반동 자본가들에게 마른얼음의 본떼를 보여주자!"
#let outline-title = [목차]
#let author-name = "우리는 로켓맨"
#let affiliation = ""
#let accent-color = rgb("#6c1d2a")

#set heading(numbering: (..args) => {
    let nums = args.pos()
    if nums.at(0) == 0 { return none }
    numbering("I.1.", ..nums)
})

#set page(
    paper: "iso-b5",
    margin: (top: 30mm, bottom: 25mm, inside: 25mm, outside: 20mm),
    header: context {
        let is-odd = calc.odd(here().page())
        set text(size: 9pt, fill: accent-color.lighten(20%), weight: "semibold")
        let header-content = if is-odd {
            align(right)[
                #stack(
                    dir: ltr,
                    spacing: 1em,
                    title,
                    line(length: 1em, angle: 90deg, stroke: 1.5pt + accent-color),
                )
            ]
        } else {
            align(left)[
                #stack(
                    dir: ltr,
                    spacing: 1em,
                    line(length: 1em, angle: 90deg, stroke: 1.5pt + accent-color),
                    image("logo.svg", width: 6em),
                )
            ]
        }

        header-content
        v(0.7em) // 본문과의 간격 확보
        counter(footnote).update(0)
    },

    footer: context {
        let is-odd = calc.odd(here().page())
        let headings = query(selector(heading.where(level: 1)).before(here())).filter(it => it.body != outline-title)
        let chapter = if headings.len() > 0 { headings.last().body } else { "" }

        set text(size: 9pt)
        stack(
            spacing: 0.6em,
            line(length: 100%, stroke: 0.5pt + accent-color.lighten(50%)),
            if is-odd {
                grid(
                    columns: (1fr, auto),
                    chapter, counter(page).display("1"),
                )
            } else {
                grid(
                    columns: (auto, 1fr),
                    counter(page).display("1"), align(right, chapter),
                )
            },
        )
    },
    numbering: "1",
)

#set par(
    first-line-indent: (amount: 1em, all: true),
    justify: true,
    leading: 1.2em,
    spacing: 1.7em,
)

#show heading: set text(fill: accent-color, weight: "bold", font: (
    (name: "Pretendard JP", covers: regex("[\p{Latin}\p{scx:Hangul}0-9]")),
    (name: "M PLUS 2", covers: regex("[\p{scx:Hira}\p{scx:Kana}\p{scx:Han}]")),
    "Source Han Sans",
))
#show heading: set block(above: 2em, below: 1.3em)
#show heading.where(level: 1): set text(size: 1.5em)
#show heading.where(level: 2): set text(size: 1.3em)

#set text(
    size: 10pt,
    font: (
        // "Source Han Serif K", // 가장 우선순위 폰트
        (
            name: "STIX Two Math",
            covers: regex("[†‡§¶‖#*]"),
        ),
        (
            name: "KoPubWorldBatang_Pro",
            covers: regex("[「」『』《》〈〉]"),
        ),
        (
            name: "libertinus serif", // 라틴 폰트
            covers: "latin-in-cjk",
        ),
        (
            name: "Source Han Serif",
            covers: regex("[\p{scx:Han}\p{scx:Hira}\p{scx:Kana}+]"),
        ), // 한자, 히라가나, 가타가나
        (
            name: "KoPubWorldBatang_Pro",
            covers: regex("[\p{scx:Hangul}+]"),
        ),
        // (
        //   name: "Pretendard JP",
        //   covers: regex("[\p{scx:Hira}\p{scx:Kana}\p{scx:Hangul}+]")
        // ),
        // (
        //   name: "Source Han Sans",
        //   covers: regex("[\p{scx:Han}+]")
        // ),
        "stix two math",
        "Source Han Sans", // CJK fallback 폰트
    ),
    cjk-latin-spacing: none,
    lang: "ja",
    region: "KR",
)
#let lang-data = toml("lang.toml")
#set-database(lang-data)

#show regex("[\p{scx:Han}\p{scx:Hira}\p{scx:Kana}\p{scx:Hangul}]+"): set text(size: 0.925em)
#show regex("[\p{scx:Hangul}]+"): set text(baseline: -0.03em)

#show math.equation: set text(
    font: (
        (
            name: "libertinus math",
            covers: "latin-in-cjk",
        ),
        (
            name: "KoPubWorldBatang_Pro",
            covers: regex("."),
        ),
    ),
    cjk-latin-spacing: none,
    weight: "regular",
    // stylistic-set: (2, 4, 6, 7, 10, 11),
    // ^ Garamond 사용시, hslash -> hbar는 6

    // stylistic-set: (2, 4),
    // ^ STIX Two 사용시, hslash -> hbar는 3

    stylistic-set: 8,
    // ^ Libertine 사용 시
)

#show heading.where(level: 1): it => {
    counter(math.equation).update(0)
    it
}

#set math.equation(numbering: n => {
    let h = counter(heading).get()
    let h1 = if type(h) == array { h.first() } else { h }
    if h1 > 0 {
        numbering("(I.1)", h1, n)
    } else {
        numbering("(1)", n)
    }
})

#set figure(numbering: n => {
    let h = counter(heading).get()
    let h1 = if type(h) == array { h.first() } else { h }
    if h1 > 0 {
        numbering("1.1", h1, n)
    } else {
        numbering("1", n)
    }
})
// if you want change the number of number of displayed
// section numbers, modify it this way:
/*
let count = counter(heading).get()
let h1 = count.first()
let h2 = count.at(1, default: 0)
numbering("(1.1.1)", h1, h2, n)
*/

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
#show "((": "〈"
#show "))": "〉"
#show "[(": "《"
#show ")]": "》"
#show "[[": "【"
#show "]]": "】"
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

#let author-style(name) = {
    set text(size: 1.6em)
    block(spacing: 0em, emph(name))
}

#let insert-heading(name) = {
    pagebreak(to: "even", weak: true)
    set page(header: none, footer: none, numbering: none)
    show heading: set text(fill: accent-color, weight: "regular", size: 1.5em, font: (
        (name: "Pretendard JP", covers: regex("[\p{Latin}\p{scx:Hangul}0-9]")),
        (name: "M PLUS 2", covers: regex("[\p{scx:Hira}\p{scx:Kana}\p{scx:Han}]")),
        "Source Han Sans",
    ))
    block(spacing: 0em, heading(level: 2, numbering: none, name))
    counter(heading).update(n => if type(n) == array { (n.at(0), n.at(1, default: 1) - 1, ..n.slice(2)) } else { n })
    v(10em)
}

#let insert-part(name) = {
    pagebreak(to: "odd")
    set page(header: none, footer: none, numbering: none)
    v(10em)
    show heading: set text(fill: accent-color, weight: "regular", size: 1.5em, font: (
        (name: "Pretendard JP", covers: regex("[\p{Latin}\p{scx:Hangul}0-9]")),
        (name: "M PLUS 2", covers: regex("[\p{scx:Hira}\p{scx:Kana}\p{scx:Han}]")),
        "Source Han Sans",
    ))
    align(center)[#block(spacing: 0em, heading(level: 1, numbering: none, name))]
    pagebreak()
}

#let work(title, author-name) = {
    author-style(author-name)
    v(1em)
    block(spacing: 0em)[#line()]
    v(1em)
    insert-heading(title)
    v(3em)
}

#let dinkus(with: circle(fill: black, radius: 0.1em)) = {
    v(1.5em)
    align(center, block(spacing: 0em, with))
    v(1.5em)
}


#set document(title: title, author: author-name)

// Title Page (Dusk style)
#page(numbering: none, header: none, footer: none, margin: (top: 2in, bottom: 2in))[
    #set align(center)
    #v(1in)

    #block(spacing: 0.5em)[
        #text(
            size: 2.5em,
            fill: accent-color,
            weight: "extrabold",
            font: (
                (name: "Pretendard JP", covers: regex("[\p{Latin}\p{scx:Hangul}0-9]")),
                (name: "M PLUS 2", covers: regex("[\p{scx:Hira}\p{scx:Kana}\p{scx:Han}]")),
                "Source Han Sans",
            ),
            title,
        )
        #if subtitle != none [
            \ #text(size: 1.5em, weight: "regular", subtitle)
        ]
    ]

    #v(3em)

    #text(size: 1.2em, author-name)
    #if affiliation != none [
        \ #text(size: 1em, affiliation)
    ]

    #v(2em)
    #text(size: 1.1em, datetime.today().display())
]

#pagebreak(to: "odd")


#outline(title: outline-title, target: heading.where(level: 1))
#pagebreak()

#include "chapters/0.typ"


// #bibliography("bib.yaml", title: "참고문헌 및 출처")
