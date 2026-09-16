// jsarticle.typ

#let font-body = (
  (name: "Century Old Math", covers: regex("[0-9]")),
  (name: "STIX Two Math", covers: regex("[*†‡§¶‖]")),
  (name: "KoPubBatang", covers: regex("[() \[\] \{\}〔〕〈〉《》【】.,?! 「」『』]")),
  (name: "Hiragino Mincho ProN", covers: regex("[。｡︒、､︑ Ⅰ-Ⅹ]")),
  (name: "Century Old Math", covers: regex("[\p{scx:Latn}\p{scx:Grek}]")),
  (name: "Century Old Style", covers: regex("[\p{scx:Cyrl}]")),
  (name: "Hiragino Mincho ProN", covers: regex("[\p{scx:Hira}\p{scx:Kana}]")),
  (name: "source han serif k", covers: regex("[\p{scx:Han}]")),
  (name: "source han serif k", covers: regex("[\u{1113}-\u{115F}\u{1176}-\u{11A7}\u{11C3}-\u{11FF}\u{3164}-\u{318E}+]")),
  (name: "Hakgyoansim Bareonbatang", covers: regex("[\p{scx:Hangul}]")),
  "KoPubWorldBatang_Pro",
  "Hiragino Mincho ProN",
  "source han serif",
)
#let font-italic = (
  (name: "Century Old Math", covers: regex("[0-9]")),
  (name: "STIX Two Math", covers: regex("[*†‡§¶‖]")),
  // (name: "KoPubBatang_Pro", covers: regex("[() \[\] \{\}〔〕〈〉《》【】.,?! 「」『』]")),
  (name: "Hiragino Mincho ProN", covers: regex("[。｡︒、､︑ Ⅰ-Ⅹ]")),
  (name: "Century Old Style", covers: regex("[\p{scx:Latn}\p{scx:Grek}]")),
  (name: "Century Old Style", covers: regex("[\p{scx:Cyrl}]")),
  (name: "Hiragino Mincho ProN", covers: regex("[\p{scx:Hira}\p{scx:Kana}]")),
  (name: "source han serif k", covers: regex("[\p{scx:Han}]")),
  (name: "source han serif k", covers: regex("[\u{1100}-\u{11FF}\u{3130}-\u{318F}+]")),
  (name: "Hakgyoansim Bareonbatang", covers: regex("[\p{scx:Hangul}]")),
  "KoPubWorldBatang_Pro",
  "Hiragino Mincho ProN",
  "source han serif",
)
#let font-maru = (
  (name: "M PLUS 2", covers: regex("[\p{scx:Han}\p{scx:Hira}\p{scx:Kana}+]")),
  (name: "KoPubWorldDotum_Pro", covers: regex("[0-9\p{scx:Hangul}+]")),
  (name: "M PLUS 2", covers: "latin-in-cjk"),
  "M PLUS 2",
  "Source Han Sans",
)
#let font-gothic = (
  (name: "KoPubWorldDotum_Pro", covers: regex("[() \[\] \{\}〔〕〈〉《》【】「」『』.,?!]")),
  (name: "Hiragino kaku gothic ProN", covers: regex("[。｡︒、､︑ Ⅰ-Ⅹ]")),
  (name: "KoPubWorldDotum_Pro", covers: regex("[0-9]")),
  (name: "Hiragino Kaku Gothic ProN", covers: regex("[\p{scx:Han}\p{scx:Hira}\p{scx:Kana}+]")),
  (name: "Bookk Gothic", covers: regex("[\p{scx:Hangul}+]")),
  // (name: "New Computer Modern", covers: regex("[\p{scx:Latn}\p{scx:Grek}\p{scx:Cyrl}\d *†‡§¶‖]")),
  "KoPubWorldDotum_Pro",
  "Hiragino kaku gothic ProN",
  "Source Han Sans",
)
#let font-math = (
  (name: "STIX Two Math", covers: regex("[*†‡§¶‖]")), //‡§¶‖#*
  (name: "STIX Two Math", covers: regex("[∑∏∐∫∬∭∮∯∰⋂⋃⋀⋁]")), // ∫∬∭∮∯∰⋂⋃⋀⋁
  (name: "Century Old Math Alt", ),
  // mod part
  // (name: "HyhwpEQ", covers: regex("[\p{scx:Latn}\p{scx:Grek}\p{scx:Cyrl}]")),
  // (name: "New Computer Modern Math", covers: regex("[𝑄𝑈𝑇  0-9]")),
  // (name: "STIX Two Math", covers: regex("[𝐴-𝑍]")),
  // (name: "tex gyre schola math", covers: regex("[𝜆𝜑𝜙𝜓𝜀𝜖𝜌𝜎𝜇𝜈𝜅]")),
  // (name: "xits math", covers: regex("[𝜏𝜔𝜋]")),
  // (name: "TeX Gyre Termes Math", covers: regex("[𝑎𝑐𝑑𝑘𝑒𝑓𝑖𝑗𝑙𝑚𝑛𝑟𝑥 𝜀𝜖]")),
  // (name: "New Computer Modern Math", covers: regex("[𝑎-𝑧]")),
  // end of mod
  (name: "New Computer Modern Math"),
  (name: "Hiragino Mincho ProN", covers: regex("[\p{scx:Han}\p{scx:Hira}\p{scx:Kana}+]")),
  (name: "Hakgyoansim Bareonbatang", covers: regex("[\p{scx:Hangul}+]")),
  (name: "New Computer Modern Math"),
)

#let cjk-text(it) = {
  show regex("[() \[\] \{\}〔〕〈〉《》【】「」『』]"): it => context {
    set text(baseline: 0.00em)
    it
  }
  // show regex("\p{scx:Han}[\p{scx:Hira}\p{scx:Kana}]"): it => context {
  //   set text(tracking: -1em)
  //   it
  // }
  show regex("[\p{scx:Hangul}]+"): it => context {
    if text.weight == "semibold" or text.weight == "bold" {
      set text(baseline: -0.09em)
      it
      return
    }
    set text(
      baseline: -0.06em,
      tracking: -0.02em,
      // stroke: 0.005em
    )
    it
  }
  show regex("[\p{scx:Han}]+"): it => context {
    if text.weight == "semibold" or text.weight == "bold" {
      // set text()
      it
      return
    }
    set text(tracking: -0.01em, baseline: 0.02em)
    it
  }
  show regex("[\p{scx:Hira}\p{scx:Kana}]+"): it => context {
    if text.weight == "semibold" or text.weight == "bold" {
      // set text(baseline: -0.06em)
      it
      return
    }
    set text(tracking: -0.02em, baseline: 0.02em)
    it
  }
  // show regex("[\p{scx:Latn}\p{scx:Grek}]+"): it => context {
  //   if text.style == "italic" {
  //     it
  //     return
  //   }
  //   set text(size: 0.95em, tracking: -0.01em, baseline: -0.01em)
  //   it
  // }
  // show regex("[\p{scx:Cyrl}]+"): set text(size: 0.925em, tracking: -0.01em)
  set text(top-edge: 0.9em, bottom-edge: -0.1em)

  it
}

#let jsnumbering

#let jsarticle-book(
  title: [],
  subtitle: [],
  author: [],
  other: [],
  date: "",
  logo: [],
  bind: "top", // center,top
  paper-size: "a4", // a4,a5,jis-b5
  type: "article", // article,novel
  chapter-format: ("第", "章"),
  body,
) = {
  set document(title: title, author: author)

  // A4/A5에 따른 폰트 크기 및 여백 동적 계산
  let base-font-size = if paper-size == "a5" { 10.5pt } else { 12pt }

  let margin-inside = if bind == "top" { 2.3cm } else { 3.0cm }
  let margin-outside = if bind == "top" { 2.3cm } else { 2.0cm }
  let margin-top = if bind == "top" { 5.2cm } else { 3.0cm }
  let margin-bottom = 2.0cm

  // a5일 경우 여백을 A4 대비 약 70~75% 비율로 축소
  if paper-size == "a5" {
    margin-inside = if bind == "top" { 1.6cm } else { 2.2cm }
    margin-outside = if bind == "top" { 1.6cm } else { 1.5cm }
    margin-top = if bind == "top" { 4.5cm } else { 2.5cm }
    margin-bottom = 1.4cm
  }

  if type == "novel" {
    // 헤더가 비워지고 푸터에 번호가 생기므로, top을 줄이고 bottom을 늘림
    if bind != "top" {
      margin-top = if paper-size == "a5" { 1.8cm } else { 2.3cm }
      margin-bottom = if paper-size == "a5" { 2.1cm } else { 2.8cm }
    } else {
      margin-bottom = if paper-size == "a5" { 1.8cm } else { 2.5cm }
    }
  }

  set page(
    paper: paper-size,
    margin: (
      inside: margin-inside,
      outside: margin-outside,
      top: margin-top,
      bottom: margin-bottom,
    ),
    footer: none, // 하단 번호 완전 제거
    header-ascent: 23%,
    footer-descent: 30%,
  )

  // 1. 기본 본문 설정
  set text(
    font: font-body,
    size: base-font-size, // 12pt 또는 11pt 동적 적용
    number-type: "lining",
    cjk-latin-spacing: auto,

    weight: 400,
    fill: rgb("#1a1a1a"),
  )
  set par(
    first-line-indent: (amount: 1em),
    leading: 0.6em,
    spacing: 0.6em,
    justify: true,
    justification-limits: (
      spacing: (min: 70%, max: 130%),
      tracking: (min: -0.05em, max: 0.01em),
    ),
    linebreaks: "optimized",
  )
  let strong-font = if type == "novel" { font-body } else { font-maru }
  show strong: it => text(font: strong-font, weight: "semibold", it.body)

  let emph-font = if type == "novel" { font-italic } else { font-italic }
  show emph: it => text(font: emph-font, style: "italic", it.body)

  show math.equation: set text(font: font-math, stylistic-set: (), weight: "medium")
  show math.equation.where(block: false): it => {
    context {
      let size = measure(it)
      if size.height >= (par.leading / 2 + 0.925em).to-absolute() {
        set text(top-edge: "bounds", bottom-edge: "bounds")
        it
      } else {
        it
      }
    }
  }

  // show math.equation: it => {
  //   // Target the specific internal math symbol function
  //   let math-symbol = $a$.body.func()

  //   show math-symbol: sym => {
  //     let char = sym.text

  //     // Check if the character is a standard letter
  //     if char.match(regex("^[a-zA-Zα-ωΑ-Ω]$")) != none {
  //       // Force it to render using your standard Century text font.
  //       // Use style: "italic" to get the proper old-style text italic look!
  //       h(-0.05em) + text(font: "Century Old Style", style: "italic", char) + h(0em)
  //     } else {
  //       sym
  //     }
  //   }
  //   it
  // }

  show math.equation.where(block: true): set block(spacing: 1.5em)
  show math.equation.where(block: true): set par(leading: 1em)
  set math.cases(gap: 1em)

  show raw: set text(font: "Rec Mono Duotone")
  // show regex("[\u{1100}-\u{11FF}\u{3130}-\u{318F}]+"): set text(size: 0.9em)
  show regex("[\p{scx:Han}\p{scx:Hira}\p{scx:Kana}\p{scx:Hangul}]+"): set text(size: 0.925em)
  
  show regex("[｡。､、()\{\}\[\]]"): set text(tracking: -0.01em)

  show par: cjk-text

  set footnote(numbering: (..v) => box(height: 0.6em, super(size: 0.7em, baseline: -.3em, typographic: true, numbering(
    n => [\*#n],
    ..v,
  ))))
  show footnote: it => {
    if it.has("label") and it.label == <trans> {
      context {
        let n = counter("trans-note").at(it.location()).first()
        super(size: 0.7em, baseline: -0.3em)[\*#numbering("i", n)]
      }
    } else {
      it
    }
  }
  set footnote.entry(indent: 0pt, gap: 0.5em, clearance: 1em, separator: line(
    length: 30%,
    stroke: 0.5pt + luma(20),
  ))
  show footnote.entry: set par(leading: 0.55em, spacing: 0.8em)
  show footnote.entry: set text(size: 0.9em) // 기존 9pt -> 0.75em

  show footnote.entry: it => {
    let loc = it.note.location()
    let is_trans = it.note.has("label") and it.note.label == <trans>

    let n = if is_trans {
      counter("trans-note").at(loc).first()
    } else {
      counter(footnote).at(loc).first()
    }

    let prefix = if is_trans {
      "*" + numbering("i", n)
    } else { "*" + str(n) }

    pad(left: 1.5em, grid(
      columns: (1.3em, 1fr),
      super(prefix, typographic: true, size: 0.8em), { cjk-text(it.note.body) },
    ))
  }
  show footnote: it => {
    sym.wj
    box(it)
  }

  // 2. 헤딩 넘버링 형식 정의
  set heading(numbering: (..nums) => {
    let vals = nums.pos()
    if vals.len() == 1 { chapter-format.at(0) + str(vals.at(0)) + chapter-format.at(1) } else {
      if vals.at(0) == 0 {
        vals.slice(1).map(str).join(".")
      } else {
        vals.map(str).join(".")
      }
    }
  })

  // 수식 번호 (장.절.번호)
  set math.equation(numbering: n => context {
    let h = counter(heading).get()
    let ch = if h.len() > 0 { h.at(0) } else { 0 }
    let sec = if h.len() > 1 { h.at(1) } else { 0 }
    if ch == 0 {
      numbering("(1.1)", sec, n)
    } else {
      numbering("(1.1.1)", ch, sec, n)
    }
  })

  show ref: it => {
    if it.supplement == none { return it }
    ref(it.target, supplement: none, form: it.form)
  }

  // 3. 페이지 헤더 설정 적용
  set page(
    header: context {
      // [소설 모드] 본문 몰입을 위해 상단 헤더를 완전히 비웁니다.
      if type == "novel" { return none }

      let abs-page = here().page()
      let is-odd = calc.rem(abs-page, 2) != 0
      let display-num = counter(page).display()

      let is-chapter-start = query(heading.where(level: 1)).any(h => h.location().page() == abs-page)

      if is-chapter-start {
        return align(if is-odd { right } else { left })[#text(font: font-body, weight: "bold")[#display-num]]
      }

      let chapters = query(selector(heading.where(level: 1)).before(here()))
      let ch-text = if chapters.len() > 0 {
        let ch = chapters.last()
        if ch.numbering != none {
          chapter-format.at(0) + str(counter(heading).at(ch.location()).first()) + chapter-format.at(1) + "　" + ch.body
        } else {
          ch.body
        }
      } else { "" }

      let sections = query(selector(heading.where(level: 2)).before(here()))
      let sec-text = if sections.len() > 0 {
        let sec = sections.last()
        let nums = counter(heading).at(sec.location())
        if str(nums.at(0)) == "0" {
          str(nums.at(1)) + "　" + sec.body
        } else {
          str(nums.at(0)) + "." + str(nums.at(1)) + "　" + sec.body
        }
      } else { "" }

      let header-content = if is-odd {
        grid(
          columns: (1fr, auto),
          align(left)[#sec-text], [#text(weight: "bold", display-num)],
        )
      } else {
        grid(
          columns: (auto, 1fr),
          [#text(weight: "bold", display-num)], align(right)[#cjk-text(ch-text)],
        )
      }

      stack(spacing: 2pt, text(size: 0.96em, font: font-body)[#header-content], v(0.3em), line(
        length: 100%,
        stroke: 0.5pt,
      ))
    },
    footer: context {
      // [기본 모드] 학술 모드에서는 푸터를 비웁니다.
      if type == "article" { return none }

      // [소설 모드] 장 제목은 숨기고, 페이지 번호만 하단 바깥쪽에 작고 옅게 배치합니다.
      let abs-page = here().page()
      let is-odd = calc.rem(abs-page, 2) != 0
      let display-num = counter(page).display()

      // 페이지 번호를 작게(0.85em), 너무 튀지 않게 약간 부드러운 색상(luma)으로 설정
      align(if is-odd { right } else { left })[
        #text(font: font-body, size: 0.85em, fill: luma(60))[#display-num]
      ]
    },
  )

  // 4. 표지(Title Page) 출력부
  if title != "" {
    set page(header: none)
    align(center)[
      #v(25%)
      #text(size: 1.8em, font: font-body, title, weight: "semibold")
      #v(1em)
      #if subtitle != none {
        text(size: 1em, font: font-body)[--- #subtitle ---]
      }
      #v(3em)
      #text(size: 1em, font: font-body, date)
      #v(5%)
      #text(size: 1.2em, font: font-body, author)
      #v(0.1em)
      #text(size: 1em, font: font-body, other)
      #v(20%)
      #align(center + horizon, text(size: 1.2em, font: font-gothic, weight: "semibold")[#cjk-text(logo)])
    ]
    pagebreak()
  }

  // ==========================================
  // 5. 전역 통합 헤딩 렌더링
  // ==========================================
  show heading: it => {
    let heading-font = if type == "novel" { font-body } else { font-gothic }
    set text(font: heading-font, weight: "semibold")
    set par(first-line-indent: 0pt, leading: 0.8em)

    let head-num = if it.numbering != none { counter(heading).display(it.numbering) } else { none }

    if it.level == 1 {
      if it.numbering == none {
        counter(heading).update((first, ..rest) => (first, 0))
      }
      if it.has("label") and it.label == <__jspart__> {
        v(35%)
        align(center)[
          // 장식 없이 본문 표지에는 깔끔하게 제목만 렌더링
          #text(size: 2.2em, font: font-maru, weight: "bold")[#cjk-text(it.body)]
        ]
        v(1fr)
        pagebreak(weak: true)
      } else if type == "novel" {
        v(15%)
        align(center)[
          #if head-num != none {
            text(size: 1.1em, weight: "medium", font: font-maru, tracking: 0.3em)[#cjk-text(head-num)]
            v(1.5em, weak: true)
          }
          #text(size: 1.6em, weight: "bold")[#cjk-text(it.body)]
        ]
        v(4em)
      } else {
        pagebreak(weak: true)
        counter(footnote).update(0)

        v(10%)

        if head-num != none {
          text(size: 1.3em, weight: "medium", font: font-maru)[#cjk-text(head-num)]
          v(2em, weak: true)
        }

        if paper-size == "a4" {
          text(size: 1.9em)[#cjk-text(it.body)]
        } else {
          text(size: 1.7em)[#cjk-text(it.body)]
        }
        v(1.5em)
      }
    } else if it.level == 2 {
      v(2.5em, weak: true)
      grid(
        columns: (2.5em, 1fr),
        align: horizon,
        if head-num != none {
          text(size: 1.1em, font: font-maru, weight: "medium")[#head-num]
        } else { [] },
        text(size: 1.1em, weight: "bold")[#cjk-text(it.body)],
      )
    } else if it.level == 3 {
      v(2em, weak: true)
      grid(
        columns: (3.5em, 1fr),
        align: horizon,
        if head-num != none {
          text(size: 1.08em, font: font-maru, weight: "medium")[#head-num] // 기존 13pt -> 1.08em
        } else { [] },
        text(size: 1.08em, weight: "bold")[#cjk-text(it.body)],
        // 기존 13pt -> 1.08em
      )
    } else {
      v(1.5em, weak: true)
      cjk-text(it)
    }
    par[]
  }

  // ==========================================
  // 6. 목차(TOC) 스타일 수정
  // ==========================================

  let toc-fill = if type == "novel" { none } else { repeat(gap: 0.5em, justify: false)[.] }
  set outline.entry(fill: toc-fill)

  show outline.entry: it => {
    let level = it.level
    let is-ch = level == 1

    let is-part = "label" in it.element.fields() and it.element.label == <__jspart__>

    if is-part {
      v(2em, weak: true)
      block(width: 100%, align(center)[
        // [수정 후] 소설 모드면 font-body 적용
        #let part-font = if type == "novel" { font-body } else { font-gothic }
        #text(font: part-font, weight: "bold", size: 1.3em)[
          #link(it.element.location())[#cjk-text(it.body())]
        ]
      ])
      v(1em, weak: true)
      return
    }

    let text-font = if type == "novel" { font-body } else if is-ch { font-gothic } else { font-body }
    let text-weight = if is-ch { "semibold" } else { "regular" }

    v(if is-ch { 2em } else { 1em }, weak: true)

    let (indent, num-width) = if level == 1 {
      (0em, 4.5em)
    } else if level == 2 {
      (1em, 3.5em)
    } else {
      (4.5em, 3.0em)
    }

    let max-width = state("thesis-outline-max-width", 0pt)
    let page-element = it.page()
    let aligned-page = context {
      let this-width = measure(page-element).width
      max-width.update(calc.max.with(this-width))
      box(width: max-width.final(), align(right, page-element))
    }

    let aligned-fill = if not is-ch and it.fill != none {
      box(width: 1fr, align(right, it.fill))
    } else {
      h(1fr)
    }

    link(it.element.location())[
      #text(font: text-font, weight: text-weight)[
        #grid(
          columns: (indent, num-width, 1fr, auto),
          column-gutter: 0pt,
          [],
          cjk-text(it.prefix()),
          [
            #cjk-text(it.body())
            #if not is-ch [
              #h(0.5em)
              #aligned-fill
            ]
          ],
          [#h(0.5em) #sym.wj #aligned-page],
        )
      ]
    ]
  }

  body
}

// 부가 환경

#let transnote(body) = {
  counter("trans-note").step()
  // metadata를 사용해 역자 주임을 표시
  [#footnote(body)<trans>]
  counter(footnote).update(x => x - 1)
}

#let jspart(title, num: none) = [
  #[
    #set page(header: none, footer: none)
    #pagebreak(to: "odd", weak: true)

    #show heading: it => it.body

    #let outline-title = if num != none {
      [--- #num　#title ---]
    } else {
      [──--- #title ──---]
    }
    #place(hide([#heading(level: 1, numbering: none, outlined: true)[#outline-title]<__jspart__>]))
    #v(30%)
    #align(center)[
      #if num != none [
        #text(size: 1.2em, font: font-body, weight: "medium", tracking: 0.4em, fill: luma(80))[#cjk-text(num)]
        #v(0.2em)
      ]

      #text(size: 2.2em, font: font-body, weight: "semibold", tracking: 0.1em)[#cjk-text(title)]

      #v(3em)
      #line(length: 1.5em, stroke: 1.618em / 10 + luma(160))
    ]
    #v(1fr)
  ]
  #pagebreak(weak: true)
]

#let jsicover(title, subtitle: none, author: none, size: 2.7em) = [
  #context [
    #let rsize = size
    #if calc.min(page.width, page.height) == 148mm {
      rsize = 2.2em
    }
    #pagebreak(to: "odd", weak: true)
    #set page(header: none, footer: none)

    #v(20%)
    #align(center)[
      #text(size: rsize, font: font-body, weight: "semibold", tracking: 0.1em)[#cjk-text(title)]
      #if subtitle != none [
        #v(-rsize * 0.1)
        #text(size: rsize * 0.45, font: font-maru, weight: "semibold")[#cjk-text(subtitle)]
      ]
      #if author != none [
        #v(5em)
        #text(size: rsize * 0.45, font: font-gothic, weight: "medium")[#cjk-text(author)]
      ]
    ]
    #v(1fr)
  ]
  #set page(header: none)
  #pagebreak(to: "odd")
]

#let jsdinkus(sym: "*　*　*") = {
  v(3em, weak: true)
  align(center)[#text(size: 1.4em, font: font-body, weight: "bold", sym)]
  v(3em, weak: true)
}

#let jsquote(indent: false, body) = pad(left: 2em, right: 0em, top: 0.8em, bottom: 0.8em, {
  if indent == true {
    set par(first-line-indent: (amount: 1em, all: true))
    cjk-text(body)
  } else { cjk-text(body) }
})
#let jsbox(body) = align(center, block(width: 100%, stroke: 0.5pt, inset: (x: 2em, y: 1.5em), align(left, {
  set par(first-line-indent: 0em)
  cjk-text(body)
})))

#let jstopic(title: content, body) = {
  v(1.2em, weak: true)
  set par(first-line-indent: 0em)
  [*■#h(0.2em)#title*]
  h(0.5em)
  cjk-text(body)
}

// --- 일본 시험지 스타일 이중 테두리 빈칸 (복구) ---
#let jsans(it) = box(baseline: 25%, stroke: 0.5pt, inset: 1pt, {
  rect(
    stroke: 0.5pt,
    inset: (x: 3pt, y: 2pt),
    radius: 0pt,
    text(size: 0.85em)[*#cjk-text(it)*],
  )
})

#let jsnnh1(title) = heading(level: 1, numbering: none)[#title]
#let jsnnoh1(title) = heading(level: 1, numbering: none, outlined: false)[#title]

#let jsnumbering(format, ..args) = {
  let result = numbering(format, ..args)

  let n = args.pos().first()

  if format == "가" {
    // 유니코드 한글 조합 공식: 0xAC00 + (자음인덱스 * 21 * 28) + (모음인덱스 * 28)
    // 1. 순수 14자음 인덱스 (유니코드상 ㄱ, ㄴ, ㄷ, ㄹ, ㅁ, ㅂ, ㅅ, ㅇ, ㅈ, ㅊ, ㅋ, ㅌ, ㅍ, ㅎ의 위치)
    let c_map = (0, 2, 3, 5, 6, 7, 9, 11, 12, 14, 15, 16, 17, 18)
    // 2. 모음 순서 인덱스 (ㅏ, ㅓ, ㅗ, ㅜ, ㅡ, ㅣ)
    let v_map = (0, 4, 8, 13, 18, 20)

    let c_idx = calc.rem(n - 1, 14)
    let v_idx = calc.floor((n - 1) / 14)

    if v_idx < v_map.len() {
      let char_code = 0xAC00 + (c_map.at(c_idx) * 21 * 28) + (v_map.at(v_idx) * 28)
      result = str.from-unicode(char_code)
    } else {
      result = numbering(format, ..args)
    }
  } else {
    result = numbering(format, ..args)
  }

  result
    .replace("贰", "貳") // 2 (신자체는 弐, 번체는 貳)
    .replace("叁", "參") // 3 (신자체는 参, 번체는 參)
    .replace("陆", "陸") // 6
    //    .replace("万", "萬") // 10,000
    .replace("亿", "億") // 억
}
