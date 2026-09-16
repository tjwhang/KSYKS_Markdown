// theme.typ

#import "@preview/linguify:0.5.0": *
#import "@preview/wrap-it:0.1.1": *

// --- 1. 상태 변수 및 색상 상수 ---
#let is-chart-mode = state("is-chart-mode", false)

#let accent-color = rgb("6c1d2a")
#let c-maroon = rgb("6c1d2a")
#let c-navy = rgb("#1A3A5F")
#let c-forest = rgb("#1E4620")
#let text-color = rgb("1a1a1a")

// --- 2. 전역 폰트 프리셋 ---
// #let font-main = (
//   (name: "STIX Two Math", covers: regex("[†‡§¶‖#*]")),
//   (name: "KoPubWorldBatang_Pro", covers: regex("[() \[\] \{\}「」『』《》〈〉.,!?…·]")),
//   (name: "EB Garamond", covers: regex("[0-9]")),
//   (name: "EB Garamond", covers: "latin-in-cjk"),
//   (name: "Source Han Serif", covers: regex("[\p{scx:Hira}\p{scx:Kana}]")),
//   (name: "Shippori Mincho B1", covers: regex("[｡。､、 \p{scx:Han}+]")),
//   (name: "SunBatang", covers: regex("[\p{scx:Hangul}+]")),
//   "EB Garamond",
//   "Source Han Serif",
// )
//
#let font-main = (
    (name: "STIX Two Math", covers: regex("[†‡§¶‖#*]")),
    (name: "KoPubWorldBatang_Pro", covers: regex("[() \[\] \{\}《》〈〉.,!?…·]")),
    (name: "New Computer Modern", covers: regex("[0-9]")),
    (name: "New Computer Modern", covers: "latin-in-cjk"),
    (name: "Hiragino Mincho ProN", covers: regex("[\p{scx:Hira}\p{scx:Kana} 「」『』]")),
    (name: "Hiragino Mincho ProN", covers: regex("[｡。､、 \p{scx:Han}+]")),
    (name: "KoPubWorldBatang_Pro", covers: regex("[\p{scx:Hangul}+]")),
    "new computer modern",
    "Source Han Serif",
)

#let font-sans = (
    (name: "STIX Two Math", covers: regex("[†‡§¶‖#*]")),
    (name: "kopubworlddotum_pro", covers: regex("[() \[\] \{\}《》〈〉.,!?…·]")),
    (name: "KoPubDotum_Pro", covers: regex("[0-9]")),
    (name: "kopubworlddotum_pro", covers: "latin-in-cjk"),
    (name: "Hiragino kaku gothic ProN", covers: regex("[\p{scx:Hira}\p{scx:Kana} 「」『』]")),
    (name: "Hiragino kaku gothic ProN", covers: regex("[｡。､、 \p{scx:Han}+]")),
    (name: "kopubworlddotum_pro", covers: regex("[\p{scx:Hangul}+]")),
    "new computer modern",
    "Source Han Sans",
)

#let font-heading = (
    (name: "eb garamond", covers: regex("[\p{Latin}0-9]")),
    (name: "SunBatang", covers: regex("[\p{scx:Hangul}]")),
    (name: "Source Han Serif", covers: regex("[\p{scx:Hira}\p{scx:Kana}]")),
    (name: "shippori mincho b1", covers: regex("[\p{scx:Han}]")),
    // (name: "Source Han Serif", covers: regex("[\p{scx:Han}]")),
    "Source Han Serif",
)

// --- 일본 시험지 스타일 이중 테두리 빈칸 (복구) ---
#let ans(it) = box(baseline: 25%, stroke: 0.5pt, inset: 1pt, {
    rect(
        stroke: 0.5pt,
        inset: (x: 3pt, y: 2pt),
        radius: 0pt,
        text(size: 0.85em, weight: "bold", font: "M PLUS 2", it),
    )
})

// --- 3. 문서 전역 스타일 함수 ---
#let setup-rules(body) = {
    //[A] 기본 텍스트 및 문단 (추천 행간/자간 적용)
    set text(
        size: 11.5pt,
        fill: text-color,
        font: font-main,
        cjk-latin-spacing: auto,
        lang: "ko",
        region: "HJ",
        weight: "regular",
        number-type: "lining",
    )
    set par(
        // first-line-indent: (amount: 1em, all: true),
        justify: true,
        justification-limits: (
            spacing: (min: 80%, max: 130%), // Adjusts word spacing
            tracking: (min: -0.05em, max: 0.01em), // Adjusts character spacing
        ),
        linebreaks: "optimized",

        leading: 1em,
        spacing: 1.5em,

        first-line-indent: (amount: 1em, all: false),
    )

    // [B] CJK 미세 조정
    //\p{scx:Han}\p{scx:Hira}\p{scx:Kana}
    show regex("[｡。､、 \p{scx:Han}\p{scx:Hira}\p{scx:Kana}\p{scx:Hangul}]+"): set text(
        size: 0.925em,
    )
    show regex("\\b[｡。､、() \{\} \[\] \p{scx:Hangul}]+\\b"): set text(
        tracking: -0.03em,
    )
    show regex("\\b[\p{scx:Hira}\p{scx:Kana}\p{scx:Han}]+\\b"): set text(
        tracking: -0.05em,
    )
    // show regex("[\p{scx:Latn}\p{scx:Cyrl}\p{scx:Grek}]+"): set text(size: 1.05em)
    show regex("[\p{scx:Hangul}]+"): it => context {
        set text(baseline: -0.06em)
        it
    }

    show strong: set text(font: font-sans, weight: "regular", baseline: -0.03em)

    // 숫자 높이 보정
    show regex("[\d+]"): it => context {
        if "libertinus" in lower(repr(text.font)) {
            set text(size: 1.09em, baseline: 0.00em)
            it
        } else { it }
    }

    show footnote: it => {
        // 앞 단어와 각주 마커 사이에 zero-width joiner를 넣고 박스로 묶음
        sym.wj
        box(it)
    }


    // [C] 수식 조판 및 폰트

    set math.mat(delim: "[")
    set math.vec(delim: "[")
    set math.cases(gap: 0.8em)

    show math.sum: math.limits
    show math.product: math.limits
    show math.union: math.limits
    show math.inter: math.limits
    show math.union.big: math.limits
    show math.inter.big: math.limits

    // show math.equation.where(block: false): it => {
    //     show math.attach: a => {
    //         show math.frac: f => f
    //         a
    //     }
    //     show math.op: math.display
    //     show math.binom: math.display
    //     show math.mat: math.display
    //     show math.vec: math.display
    //     show math.cases: math.display
    //     show math.frac: math.display
    //     show math.integral: math.display
    //     show math.integral.double: math.display
    //     show math.integral.triple: math.display
    //     show math.integral.cont: math.display
    //     show math.integral.cw: math.display
    //     show math.integral.surf: math.display
    //     show math.integral.vol: math.display
    //     show math.integral.quad: math.display
    //     it
    // }

    let has-frac(element) = {
        if element.func() == math.frac { return true }


        if element.has("children") { return element.children.any(has-frac) }
        if element.has("body") { return has-frac(element.body) }
        if element.has("base") { return has-frac(element.base) }
        return false
    }

    // show math.equation.where(block: false): it => {
    //     context {
    //         let size = measure(it)
    //         if size.height >= 1em.to-absolute() * 0.8 or has-frac(it.body) {
    //             set text(top-edge: "bounds", bottom-edge: "bounds") // fill: red
    //             it
    //         } else {
    //             it
    //         }
    //     }
    // }


    // show math.equation.where(block: false): it => {
    //     show ([lim], [max], [min], [sup], [inf]).map(v => math.op.where(text: v)).reduce(selector.or): math.limits
    //     it
    // }

    // 인라인 수식을 디스플레이로 (주석 복구)
    // show math.equation.where(block: false): it => math.display(it)
    show math.equation.where(block: false): set math.frac(style: "vertical")

    show math.equation.where(block: true): set block(spacing: 1.5em)
    show math.equation.where(block: true): set par(leading: 1em)

    // 수식 폰트 키트배싱
    // show math.equation: set text(
    //   font: (
    //     // (name: "New Computer Modern Math", covers: regex("[0-9 𝑔𝒈𝜋𝝅𝜃]")),
    //     // (name: "Libertinus Math", covers: regex("[𝛼 𝛽 𝜶 𝜷 𝜽 Α-Ω 𝚨-𝛀 𝑎-𝑧 𝒂-𝒛 𝐴-𝑍 𝑨-𝒁 A-Z 𝐀-𝐙 a-z]")),
    //     (name: "STIX Two Math", covers: regex("[∑∏∐∫∬∭∮∯∰⋂⋃⋀⋁]")),
    //     (name: "Garamond-Math"),
    //     (name: "SunBatang", covers: regex("[\p{scx:Hangul}+]")),
    //     (name: "Shippori Mincho B1", covers: regex("[\p{scx:Hira}\p{scx:Kana}+]")),
    //     (name: "shippori Mincho b1", covers: regex("[\p{scx:Han}+]")),
    //     "Source Han Serif"
    //   ),
    //   cjk-latin-spacing: none,
    //   weight: "regular",
    //   stylistic-set: (2, 10)
    // )

    show math.equation: set text(
        font: (
            // (name: "New Computer Modern Math", covers: regex("[0-9 𝑔𝒈𝜋𝝅𝜃]")),
            // (name: "Libertinus Math", covers: regex("[𝛼 𝛽 𝜶 𝜷 𝜽 Α-Ω 𝚨-𝛀 𝑎-𝑧 𝒂-𝒛 𝐴-𝑍 𝑨-𝒁 A-Z 𝐀-𝐙 a-z]")),
            (name: "STIX Two Math", covers: regex("[∑∏∐∫∬∭∮∯∰⋂⋃⋀⋁]")),
            // (name: "TeX Gyre Schola Math", covers: regex("[𝒂-𝒛 𝐚-𝐳 𝜶-𝝎]")),
            (name: "New Computer Modern Math"),
            (name: "KoPubWorldBatang_Pro", covers: regex("[\p{scx:Hangul}+]")),
            (name: "Hiragino Mincho ProN", covers: regex("[\p{scx:Hira}\p{scx:Kana}+]")),
            (name: "Hiragino Mincho ProN", covers: regex("[\p{scx:Han}+]")),
            "Source Han Serif",
        ),
        cjk-latin-spacing: none,
        weight: "regular",
        stylistic-set: (2, 10),
    )

    // show math.equation: set text(
    //   font: (
    //     (name: "Libertinus Math", covers: regex("[𝛼 𝛽 𝜶 𝜷 𝜽 𝑥 𝒙]")),
    //     (name: "New Computer Modern Math", covers: regex("[0-9 𝑔𝒈𝜋𝝅𝜃 Α-Ω 𝚨-𝛀 𝑎-𝑧 𝒂-𝒛 𝐴-𝑍 𝑨-𝒁 A-Z 𝐀-𝐙 a-z]")),
    //     // (name: "New Computer Modern Math", covers: regex("[0-9 𝑔𝒈𝜋𝝅𝜃]")),
    //     // (name: "Libertinus Math", covers: regex("[𝛼 𝛽 𝜶 𝜷 𝜽 Α-Ω 𝚨-𝛀 𝑎-𝑧 𝒂-𝒛 𝐴-𝑍 𝑨-𝒁 A-Z 𝐀-𝐙 a-z]")),
    //     (name: "TeX Gyre Schola Math", covers: regex("[𝛼-𝜔 𝜶-𝝎]")),
    //     (name: "STIX Two Math", covers: regex("[∑∏∐∫∬∭∮∯∰⋂⋃⋀⋁]")),
    //     (name: "New Computer Modern Math"),
    //     (name: "KoPubWorldBatang_Pro", covers: regex("[\p{scx:Hangul}+]")),
    //     (name: "Source Han Serif", covers: regex("[\p{scx:Hira}\p{scx:Kana}\p{scx:Han}+]")),
    //   ),
    //   cjk-latin-spacing: none,
    //   weight: "medium",
    //   stylistic-set: 2,
    //   // stylistic-set: 8,
    //   // ^ Libertine 사용 시
    // )

    // show math.equation: set text(
    //
    //   font: (
    //
    //     (name: "Libertinus Math", covers: regex("[𝛼 𝛽 𝑏 𝑝 𝑞 𝑧]")),
    //     (name: "XITS Math", covers: regex("[𝑓]")),
    //     (name: "STIX Two Math", covers: regex("[𝑎𝑑 𝑚𝑛 𝑔 𝑥𝑦 ℎℏ 𝜋  a-z]")),
    //     (name: "New Computer Modern Math", covers: regex("[0-9 𝜋𝜃]")),
    //     (name: "TeX Gyre Schola Math", covers: regex("[𝐴-𝑍 𝑨-𝒁 𝐀-𝐙 𝒂-𝒛 𝐚-𝐳 𝜶-𝝎 𝑎-𝑧 a-z A-Z ∞]")),
    //     (name: "TeX Gyre Schola Math", covers: regex("[\u{0370}-\u{03FF} \u{1D6E2}-\u{1D71B}]")),
    //     (name: "STIX Two Math", covers: regex("[∑∏∐∫∬∭∮∯∰⋂⋃⋀⋁]")),
    //     (name: "New Computer Modern Math"),
    //     (name: "KoPubWorldBatang_Pro", covers: regex("[\p{scx:Hangul}+]")),
    //     (name: "Source Han Serif", covers: regex("[\p{scx:Hira}\p{scx:Kana}\p{scx:Han}+]")),
    //   ),
    //   cjk-latin-spacing: none,
    //   weight: "medium",
    //   stylistic-set: 2,
    //   // stylistic-set: 8,
    //   // ^ Libertine 사용 시
    // )


    show math.equation.where(block: true): it => {
        let big_ops = regex("[∑∏∐⋂⋃⋀⋁]")
        show big_ops: match => {
            let scaled_text = text(size: 1.1em, baseline: 0.0em, match)
            math.op(limits: true, scaled_text)
        }
        it
    }

    // show math.equation: it => {
    //     let greek_regex = regex("[λμνξρχψ]")
    //     show greek_regex: it => context {
    //         if "schola" in lower(repr(text.font)) {
    //             set text(size: 0.9em, baseline: 0.0em)
    //             it
    //         } else { it }
    //     }
    //     it
    // }


    show math.equation: it => {
        show regex(
            "𝔸|𝔹|ℂ|𝔻|𝔼|𝔽|𝔾|ℍ|𝕀|𝕁|𝕂|𝕃|𝕄|ℕ|𝕆|ℙ|ℚ|ℝ|𝕊|𝕋|𝕌|𝕍|𝕎|𝕏|𝕐|ℤ|𝕒|𝕓|𝕔|𝕕|𝕖|𝕗|𝕘|𝕙|🇮|𝕛|𝕜|𝕝|𝕞|𝕠|𝕡|𝕢|𝕣|𝕤|𝕥|𝕦|𝕧|𝕨|𝕩|𝕪|𝕫",
        ): set text(font: "New Computer Modern Math")
        show regex("†|\*"): set text(font: "STIX Two Math")
        it
    }

    // [D] 각주, 따옴표, 기타
    set footnote(numbering: "*")
    set footnote(numbering: (..v) => super(typographic: false, size: 0.9em, baseline: -.25em, numbering("*", ..v)))
    set footnote.entry(indent: 0pt, gap: 0.75em, clearance: 1em, separator: line(length: 30%, stroke: 0.5pt + luma(20)))
    set smartquote(quotes: (double: ("「", "」"), single: ("『", "』")))
    show "“": "「"
    show "”": "」"
    show "((": "〈"
    show "))": "〉"
    show "[(": "《"
    show ")]": "》"
    show "[[": "【"
    show "]]": "】"
    show "‘": "『"
    show regex("\w’\w|’"): match => { if match.text.len() > 1 { match.text } else { "』" } }
    // show ".": "｡"
    // show ",": "､"

    show raw: set text(font: ("JetBrains Mono", "Pretendard JP", "Source Han Sans"))
    set math.equation(supplement: [식])
    set figure(supplement: [그림])

    body
}

// --- 4. 보조 함수들 (복구) ---
#let author-style(name) = {
    set text(size: 1.6em)
    block(spacing: 0em, emph(name))
}

#let dinkus(with: circle(fill: black, radius: 0.1em)) = {
    v(1.5em)
    align(center, block(spacing: 0em, with))
    v(1.5em)
}
