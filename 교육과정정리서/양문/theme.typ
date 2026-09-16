// theme.typ

#import "@preview/linguify:0.5.0": *

// --- 0. 차트 모드 상태 변수 (폰트 충돌 방지용) ---
#let is-chart-mode = state("is-chart-mode", false)

// --- 1. 색상 상수 ---
#let accent-color = rgb("6c1d2a")
#let c-maroon = rgb("#634343")
#let c-navy = rgb("#1A3A5F")
#let c-forest = rgb("#1E4620")

// --- 2. 전역 폰트 프리셋 ---
#let font-main = (
  (name: "STIX Two Math", covers: regex("[†‡§¶‖#*]")),
  (name: "KoPubBatang_Pro", covers: regex("[「」『』《》〈〉]")),
  (name: "STIX Two Text", covers: "latin-in-cjk"),
  (name: "Source Han Serif", covers: regex("[\p{scx:Han}\p{scx:Hira}\p{scx:Kana}+]")),
  (name: "KoPubBatang_Pro", covers: regex("[\p{scx:Hangul}+]")),
  "stix two math",
  "Source Han Sans",
)

#let font-heading = (
  (name: "Pretendard JP", covers: regex("[\p{Latin}\p{scx:Hangul}0-9]")),
  (name: "M PLUS 2", covers: regex("[\p{scx:Hira}\p{scx:Kana}\p{scx:Han}]")),
  "Source Han Sans",
)

// --- 3. 문서 전역 스타일 함수 ---
#let setup-rules(body) = {
  // [A] 기본 텍스트
  set text(size: 10pt, font: font-main, cjk-latin-spacing: none, lang: "ja", region: "KR")

  // [B] 문단 설정
  set par(first-line-indent: (amount: 1em, all: true), justify: true, leading: 1.2em, spacing: 1.7em)

  // [C] CJK 미세 조정 (핵심 수정: 차트 모드가 아닐 때만 작동하도록 context 사용)
  // show regex("[\p{scx:Han}\p{scx:Hira}\p{scx:Kana}\p{scx:Hangul}]+"): it => context {
  //   if is-chart-mode.get() { it } else {
  //     set text(size: 0.925em)
  //     it
  //   }
  // }
  show regex("[\p{scx:Han}\p{scx:Hira}\p{scx:Kana}\p{scx:Hangul}]+"): set text(size: 0.925em)
  show regex("[\p{scx:Hangul}]+"): it => context {
    if is-chart-mode.get() { it } else {
      set text(baseline: -0.03em)
      it
    }
  }
  // show regex("\d+"): it => {
  //   set text(
  //     size: 1.09em, // 크기를 9% 키움 (Libertinus의 짧은 숫자를 보정)
  //     baseline: 0em, // 크기가 커지면서 베이스라인이 미세하게 들뜨는 것을 방지
  //   )
  //   it
  // }

  // [D] 수식 조판 및 폰트 (기존 로직 유지)
  set math.mat(delim: "[")
  set math.vec(delim: "[")
  set math.cases(gap: 0.8em)

  show math.sum: math.limits
  show math.product: math.limits
  show math.union: math.limits
  show math.inter: math.limits
  show math.union.big: math.limits
  show math.inter.big: math.limits

  // show math.frac.where(block:false): math.display


  show math.equation.where(block: false): it => {
    show math.attach: a => {
      show math.frac: f => f
      a
    }
    show math.op: math.display
    show math.binom: math.display
    show math.mat: math.display
    show math.vec: math.display
    show math.cases: math.display
    show math.frac: math.display

    it
  }
  show math.equation.where(block: false): it => {
    show ([lim], [max], [min], [sup], [inf]).map(v => math.op.where(text: v)).reduce(selector.or): math.limits
    it
  }
  // show math.equation.where(block: false): it => math.display(it)
  show math.equation.where(block: false): set math.frac(style: "vertical")
  show math.equation.where(block: false): set text(
    top-edge: "bounds",
    bottom-edge: "bounds",
  )

  show math.equation: set text(
    font: (
      /***      ### 1. 라틴 알파벳 (Latin Alphabets)

            수식에서 변수나 상수를 쓸 때 가장 많이 사용되는 범위입니다.

            *   **이탤릭 (Italic - 기본 변수 `$x$`):**
                *   `[\u{1D434}-\u{1D467}]` (A-Z, a-z)
                *   *참고: 소문자 이탤릭 h($h$)는 가끔 `\u{210E}`(Planck constant)로 매핑되는 경우가 있으니 포함하는 것이 좋습니다. + ℏ*
            *   **볼드 (Bold - `$bold(A)$`):**
                *   `[\u{1D400}-\u{1D433}]`
            *   **볼드 이탤릭 (Bold Italic - `$bold(italic(A))$`):**
                *   `[\u{1D468}-\u{1D49B}]`

            ### 2. 그리스 문자 (Greek Letters)

            그리스 문자는 기본 유니코드 블록과 수학 전용 블록 두 군데를 모두 커버하는 것이 안전합니다.

            *   **기본/직립 (Standard/Upright - `$upright(alpha)$`):**
                *   `[\u{0370}-\u{03FF}]` (기본 그리스 문자 블록)
            *   **이탤릭 (Italic - 기본 `$alpha$`):**
                *   `[\u{1D6E2}-\u{1D71B}]`
            *   **볼드 (Bold - `$bold(alpha)$`):**
                *   `[\u{1D6A8}-\u{1D6E1}]`
            *   **볼드 이탤릭 (Bold Italic - `$bold(italic(alpha))$`):**
                *   `[\u{1D71C}-\u{1D755}]`

            ### 3. 숫자 (Digits)

            숫자도 수식 내에서 볼드체 등을 사용할 때 변환될 수 있습니다.

            *   **일반 숫자 (Default - `$123$`):**
                *   `[0-9]`
            *   **볼드 숫자 (Bold - `$bold(1)$`):**
                *   `[\u{1D7CE}-\u{1D7D7}]`

            ### 1. 주요 수학 연산자 유니코드 범위

      #### ① 기초 산술 및 비교 연산자 (Arithmetic & Relations)
      가장 빈번하게 쓰이는 기호들입니다.
      *   **범위:** `[\+-−=×÷±∓∗\/\%\<\>\≤\≥\≠\≈\≡\∝]`
      *   **포함 기호:** $+$, $-$, $=$, $\times$, $\div$, $\pm$, $\mp$, $\cdot$, $/$, $<$, $>$, $\le$, $\ge$, $\ne$, $\approx$, $\equiv$, $\propto$

      #### ② 고급 대수 연산자 (Advanced Binary Ops: 텐서곱, 직합 등)
      원형 기호 안에 연산자가 들어간 형태가 많습니다.
      *   **범위:** `[\u{2295}-\u{229A}\u{2218}\u{22C6}\u{22C5}]`
      *   **포함 기호:** $\oplus$ (직합), $\ominus$, $\otimes$ (텐서곱), $\oslash$, $\odot$ (점곱), $\circ$ (합성), $\star$, $\cdot$

      #### ③ 집합 및 논리 연산자 (Set Theory & Logic)
      *   **범위:** `[\u{2200}-\u{220B}\u{2223}-\u{222A}\u{2282}-\u{228B}\u{2227}\u{2228}\u{2201}-\u{2204}]`
      *   **포함 기호:** $\forall, \exists, \in, \notin, \ni, \subset, \supset, \subseteq, \supseteq, \cup, \cap, \setminus, \wedge, \vee, \neg$

      #### ④ 미적분 및 기하 기호 (Calculus & Geometry)
      *   **범위:** `[\u{2202}\u{2207}\u{2206}\u{221E}\u{222B}-\u{2233}]`
      *   **포함 기호:** $\partial$ (편미분), $\nabla$, $\Delta$, $\infty$, $\int$ (적분), $\iint$, $\iiint$, $\oint$
                ***/
      (name: "stix two math", covers: regex("[0-9]")),
      (name: "XITS Math", covers: regex("[𝑥𝑦𝑘 𝛼 𝛽 𝜃 𝜋 𝜏]")), // special greek
      (name: "tex gyre termes math", covers: regex("[a-zA-Z \u{1D434}-\u{1D467} \u{210E} ℎℏ]")), // normal latin
      (name: "TeX Gyre Schola Math", covers: regex("[\u{0370}-\u{03FF} \u{1D6E2}-\u{1D71B}]")), // normal greek
      (
        name: "TeX Gyre Schola Math",
        covers: regex(
          "[\u{1D400}-\u{1D433} \u{1D468}-\u{1D49B} \u{1D6A8}-\u{1D6E1} \u{1D71C}-\u{1D755} \u{1D7CE}-\u{1D7D7}]",
        ),
      ), //bold
      
      (name: "New Computer Modern Math", covers: regex("[ \\+ \\-−=×÷±∓∗/%<>≤≥≠≈≡∝  \u{2295}-\u{229A}\u{2218}\u{22C6}\u{22C5} \u{2200}-\u{220B}\u{2223}-\u{222A}\u{2282}-\u{228B}\u{2227}\u{2228}\u{2201}-\u{2204}]")), // operators
      (name: "STIX Two Math"),
      (name: "KoPubBatang_Pro", covers: regex("[\p{scx:Hangul}+]")),
      (name: "Source Han Serif", covers: regex("[\p{scx:Hira}\p{scx:Kana}\p{scx:Han}.+]")),
    ),
    cjk-latin-spacing: none,
    weight: "regular",
    // stylistic-set: 8,
  )


  show math.equation: it => {
    let greek_regex = regex("[𝜆𝜇𝜈𝜉𝜌𝜑𝜒𝜓 λμνξρφχψ 𝜕]")

    show greek_regex: it => context {
      if "schola" in lower(repr(text.font)) {
        set text(size: 0.9em, baseline: 0.0em)
        it
      } else {
        it
      }
    }
    it
  }

  // show math.equation: it => context {
  //   if "new computer modern" in lower(repr(text.font)) {
  //     // 수식 기호들은 더 세밀하게 조정 (너무 굵으면 기호가 뭉침)
  //     set text(stroke: 0.01em + text.fill)
  //     it
  //   } else {
  //     it
  //   }
  // }

  show math.equation: it => {
    show regex(
      "𝔸|𝔹|ℂ|𝔻|𝔼|𝔽|𝔾|ℍ|𝕀|𝕁|𝕂|𝕃|𝕄|ℕ|𝕆|ℙ|ℚ|ℝ|𝕊|𝕋|𝕌|𝕍|𝕎|𝕏|𝕐|ℤ|𝕒|𝕓|𝕔|𝕕|𝕖|𝕗|𝕘|𝕙|🇮|𝕛|𝕜|𝕝|𝕞|𝕠|𝕡|𝕢|𝕣|𝕤|𝕥|𝕦|𝕧|𝕨|𝕩|𝕪|𝕫",
    ): set text(font: "New Computer Modern Math")
    show regex("†|\*"): set text(font: "STIX Two Math")
    it
  }

  // [E] 각주, 따옴표, 기타
  set footnote(numbering: "*")
  set footnote(numbering: (..v) => super(typographic: false, size: 0.9em, baseline: -.25em, numbering("*", ..v)))
  set footnote.entry(indent: 0pt, separator: line(length: 30%, stroke: 0.5pt + luma(200)))
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
  show raw: set text(font: ("JetBrains Mono", "Source Han Sans K"))
  set math.equation(supplement: [식])

  body
}

// --- 4. 보조 함수들 ---
#let author-style(name) = {
  set text(size: 1.6em)
  block(spacing: 0em, emph(name))
}

#let dinkus(with: circle(fill: black, radius: 0.1em)) = {
  v(1.5em)
  align(center, block(spacing: 0em, with))
  v(1.5em)
}
