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

#import cosmos.clouds: *

#import "template.typ": *

#let title = [사용자 친화적 타이포그래피 연구]

#show: bubble.with(
    title: title,
    subtitle: "정보 취약계층과 사용자 편의를 위한 최적 디자인",
    author: "지도교사 █ █ 선생님",
    affiliation: "중앙고등학교",
    date: datetime.today().display(),
    year: "█████ ███",
    class: "███ ██ ████",
    other: ("",),
    //logo: image("logo.svg"),
    color-words: ("important",),
    main-color: "247087",
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
        //#align(horizon, [ \ \ \ \ #box(image("logo.svg", width: 8em), baseline: 3em)])
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
    leading: 1.25em,
    spacing: 2em,
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
            name: "New Computer Modern", // 라틴 폰트
            covers: "latin-in-cjk",
        ),
        (
            name: "Source Han Serif",
            covers: regex("[\p{scx:Han}\p{scx:Hira}\p{scx:Kana}]"),
        ), // 한자, 히라가나, 가타가나
        "KoPubBatang_Pro",
        "source han serif k", // CJK fallback 폰트
    ),
    cjk-latin-spacing: none,
)
#show regex("[\p{scx:Han}\p{scx:Hira}\p{scx:Kana}\p{scx:Hangul}]+"): set text(size: 0.925em)
#show regex("[\p{scx:Hangul}]+"): set text(baseline: -0.05em)

#show math.equation: set text(
    font: (
        (
            name: "New Computer Modern Math",
            covers: "latin-in-cjk",
        ),
        (
            name: "KoPubBatang_Pro",
            covers: regex("."),
        ),
    ),
    cjk-latin-spacing: none,
    weight: "regular",
    // stylistic-set: (2, 4, 6, 7, 10, 11),
    // ^ Garamond 사용시, hslash -> hbar는 6

    // stylistic-set: (2, 4),
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


#outline(title: [목차])
#pagebreak()

*초록* 컴퓨터 기술은 서양에서 발전해 서양의 언어에 맞게 개발되어 왔다. 지금은 여러 방법으로 다양한 문화권의 언어를 지원하고 있지만, 여전히 기본값은 인도유럽어에 맞추어져 있다. 여기서 제기하는 하나의 문제점은, 특히 한국어에서 영어와의 통사 구조의 차이와 문자의 표의성에서 기인하는 정보 인식의 비효율성과, 낮은 가독성과 시인성, 좁은 공간에 글을 구겨넣기 위해 사용하는 한자어 등으로 인한 낮은 접근성 등의 문제이다. 본 탐구에서는 언어학적 논증과 수치적 계산으로 최적의 文体, 字形, 글자 크기, 字間, 行間 등 수치를 도출하여 이러한 문제에 대한 해결책을 제시하고자 한다.

// #ruby[문|체][文|體], #ruby[자|형][字|形], 글자 크기, #ruby[자|간][字|間], #ruby[행|간][行|間]

#include "chapters/1.typ"
#include "chapters/2.typ"
#include "chapters/3.typ"

#bibliography("bib.yaml", title: "참고문헌 및 출처")
