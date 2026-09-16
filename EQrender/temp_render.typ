#import "@preview/physica:0.9.5": *
#import "@preview/alchemist:0.1.4": *
#import "@preview/theorion:0.3.3": *
#import "@preview/rich-counters:0.2.1": *
#import "@preview/cetz:0.3.4"
#import "@preview/cetz-plot:0.1.1"
#import "@preview/mannot:0.3.0": *
#import "@preview/tyipa:0.1.0" as ipa
#import "@preview/rubby:0.10.2": get-ruby

#set page(width: auto, height: auto, margin: 1pt, fill: none)
// typst c -f svg EQrender.typ

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

#show math.equation: set text(
    font: (
        (
            name: "new computer modern math",
            covers: "latin-in-cjk",
        ),
        (
            name: "KoPubBatang_Pro",
            covers: regex("."),
        ),
    ),
    cjk-latin-spacing: none,
    // weight: "regular",
    // stylistic-set: (2, 4, 6, 7, 10, 11),
    // ^ Garamond 사용시, hslash -> hbar는 6

    // stylistic-set: (2, 3, 4),
    // ^ STIX Two 사용시, hslash -> hbar는 3

    // stylistic-set: 8,
    // ^ Libertine 사용 시
)

#set par(
    justify: false,
    leading: 1.25em,
    spacing: 2em,
)


#let cal(it) = math.class("normal", context {
    show math.equation: set text(font: "Garamond-Math", stylistic-set: 8)

    let scaling = 100% * (1em.to-absolute() / text.size)
    let wrapper = if scaling < 60% { math.sscript } else if scaling < 100% { math.script } else { it => it }

    box(text(top-edge: "bounds", $wrapper(math.cal(it))$))
})

#let scr(it) = math.class("normal", context {
    show math.equation: set text(font: "Garamond-Math", stylistic-set: 1)

    let scaling = 100% * (1em.to-absolute() / text.size)
    let wrapper = if scaling < 60% { math.sscript } else if scaling < 100% { math.script } else { it => it }

    box(text(top-edge: "bounds", $wrapper(math.cal(it))$))
})

#show math.equation: it => {
    let bb-font = "New Computer Modern Math" //Garamond-Math
    show regex(
        "𝔸|𝔹|ℂ|𝔻|𝔼|𝔽|𝔾|ℍ|𝕀|𝕁|𝕂|𝕃|𝕄|ℕ|𝕆|ℙ|ℚ|ℝ|𝕊|𝕋|𝕌|𝕍|𝕎|𝕏|𝕐|ℤ|𝕒|𝕓|𝕔|𝕕|𝕖|𝕗|𝕘|𝕙|𝕚|𝕛|𝕜|𝕝|𝕞|𝕠|𝕡|𝕢|𝕣|𝕤|𝕥|𝕦|𝕧|𝕨|𝕩|𝕪|𝕫",
    ): set text(font: bb-font)
    it
}

#let ruby = get-ruby(
    size: 0.5em, // Ruby font size
    dy: 0pt, // Vertical offset of the ruby
    pos: top, // Ruby position (top or bottom)
    alignment: "center", // Ruby alignment ("center", "start", "between", "around")
    delimiter: "|", // The delimiter between words
    auto-spacing: true, // Automatically add necessary space around words
)

$
    Omega(N) approx mu^N N^(gamma - 1)
$