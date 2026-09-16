// jsarticle.typ

#let font-body = (
    (name: "New Computer Modern Math", covers: regex("[0-9]")),
    (name: "STIX Two Math", covers: regex("[*†‡§¶‖]")),
    (name: "KoPubWorldBatang_Pro", covers: regex("[() \[\] \{\}〔〕〈〉《》【】.,?!Ⅰ-Ⅹ]")),
    (name: "Hiragino Mincho ProN", covers: regex("[。｡︒、､︑ 「」『』]")),
    (name: "New Computer Modern", covers: regex("[\p{scx:Latn}\p{scx:Grek}\p{scx:Cyrl}]")),
    (name: "Hiragino Mincho ProN", covers: regex("[\p{scx:Han}\p{scx:Hira}\p{scx:Kana}+]")),
    (name: "Hakgyoansim Bareonbatang", covers: regex("[\p{scx:Hangul}+]")),
    "KoPubWorldBatang_Pro",
    "Hiragino Mincho ProN",
    "source han serif",
)
#let font-maru = (
    (name: "M PLUS 2", covers: regex("[\p{scx:Han}\p{scx:Hira}\p{scx:Kana}+]")),
    (name: "KoPubWorldDotum_Pro", covers: regex("[\p{scx:Hangul}+]")),
    (name: "KoPubWorldDotum_Pro", covers: regex("[\d+]")),
    (name: "M PLUS 2", covers: "latin-in-cjk"),
    "M PLUS 2",
    "Source Han Sans",
)
#let font-gothic = (
    (name: "KoPubWorldDotum_Pro", covers: regex("[() \[\] \{\}〔〕〈〉《》【】.,?!]")),
    (name: "Hiragino kaku gothic ProN", covers: regex("[。｡︒、､︑ 「」『』Ⅰ-Ⅹ]")),
    (name: "Hiragino Kaku Gothic ProN", covers: regex("[\p{scx:Han}\p{scx:Hira}\p{scx:Kana}+]")),
    (name: "KoPubWorldDotum_Pro", covers: regex("[\p{scx:Hangul}+]")),
    // (name: "New Computer Modern", covers: regex("[\p{scx:Latn}\p{scx:Grek}\p{scx:Cyrl}\d *†‡§¶‖]")),
    "KoPubWorldDotum_Pro",
    "Hiragino kaku gothic ProN",
    "Source Han Sans",
)
#let font-math = (
    (name: "STIX Two Math", covers: regex("[*†‡§¶‖]")), //‡§¶‖#*
    (name: "STIX Two Math", covers: regex("[∑∏∐]")), // ∫∬∭∮∯∰⋂⋃⋀⋁
    (name: "New Computer Modern Math"),
    (name: "Hiragino Mincho ProN", covers: regex("[\p{scx:Han}\p{scx:Hira}\p{scx:Kana}+]")),
    (name: "KoPubWorldBatang_Pro", covers: regex("[\p{scx:Hangul}+]")),
    (name: "New Computer Modern Math"),
)

#let jsarticle-book(
    title: [],
    subtitle: [],
    author: [],
    other: [],
    date: "",
    logo: [],
    bind: "top", // center, top
    body,
) = {
    set document(title: title, author: author)
    set page(paper: "a4")

    // 1. 기본 본문 설정
    set text(
        font: font-body,
        size: 12pt,
        number-type: "lining",
        cjk-latin-spacing: auto,
    )
    set par(
        first-line-indent: (amount: 1em),
        leading: 1em,
        spacing: 1em,
        justify: true,
        justification-limits: (
            spacing: (min: 80%, max: 130%),
            tracking: (min: -0.05em, max: 0.01em),
        ),
        linebreaks: "optimized",
    )
    show strong: it => text(font: font-gothic, weight: "semibold", baseline: 0.01em, it.body)

    show math.equation: set text(font: font-math, weight: "regular")
    // show math.equation: set text(top-edge: "bounds", bottom-edge: "bounds")
    // show math.equation.where(block: false): math.display
    // show math.equation.where(block: false): set math.frac(style: "horizontal")
    show math.equation.where(block: false): it => {
        context {
            let size = measure(it)
            if size.height >= 1em.to-absolute() * 0.691 {
                set text(top-edge: "bounds", bottom-edge: "bounds", fill: red)
                it
            } else {
                it
            }
        }
    }
    show math.equation.where(block: true): set block(spacing: 1.5em)
    show math.equation.where(block: true): set par(leading: 1em)
    set math.cases(gap: 1em)


    show raw: set text(font: "Rec Mono Duotone")

    show regex("[\p{scx:Han}\p{scx:Hira}\p{scx:Kana}\p{scx:Hangul}]+"): set text(size: 0.925em)
    show regex("[｡。､、() \{\} \[\] \p{scx:Han}\p{scx:Hira}\p{scx:Kana}\p{scx:Hangul}]+"): set text(
        tracking: -0.03em,
    )
    // show regex("[\p{scx:Latn}\p{scx:Cyrl}\p{scx:Grek}]+"): set text(size: 1.05em)

    show regex("[\p{scx:Hangul}]+"): it => context {
        set text(baseline: -0.06em)
        it
    }


    // set footnote(numbering: (..v) => numbering(n => super(baseline: 0.3em, $attach(zws, tl: *#n)$), ..v))
    set footnote(numbering: (..v) => super(size: 0.7em, baseline: -.3em, typographic: true, numbering(
        n => [\*#n],
        ..v,
    )))
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
    show footnote.entry: set text(size: 9pt)
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
            // $attach(zws, tl: #prefix)$, it.note.body,
            super(prefix, typographic: true, size: 0.8em), it.note.body,
        ))
    }
    show footnote: it => {
        // 앞 단어와 각주 마커 사이에 zero-width joiner를 넣고 박스로 묶음
        sym.wj
        box(it)
    }

    // set smartquote(quotes: (double: ("「", "」"), single: ("『", "』")))

    // 2. 헤딩 넘버링 형식 정의
    set heading(numbering: (..nums) => {
        let vals = nums.pos()
        if vals.len() == 1 { "第" + str(vals.at(0)) + "章" } else { vals.map(str).join(".") }
    })

    // 수식 번호 (장.절.번호)
    set math.equation(numbering: n => context {
        let h = counter(heading).get()
        let ch = if h.len() > 0 { h.at(0) } else { 0 }
        let sec = if h.len() > 1 { h.at(1) } else { 0 }
        numbering("(1.1.1)", ch, sec, n)
    })


    show ref: it => {
        if it.supplement == none { return it }
        ref(it.target, supplement: none, form: it.form)
    }

    // 3. 페이지 헤더/푸터 설정
    set page(
        margin: if bind == "top" {
            (inside: 2.3cm, outside: 2.3cm, top: 5.2cm, bottom: 2cm)
        } else if bind == "center" {
            (inside: 3cm, outside: 2cm, top: 3cm, bottom: 2cm)
        },
        footer: none, // 하단 번호 완전 제거
        header: context {
            let abs-page = here().page()
            let is-odd = calc.rem(abs-page, 2) != 0
            let display-num = counter(page).display()

            let is-chapter-start = query(heading.where(level: 1)).any(h => h.location().page() == abs-page)

            // 장(h1) 시작 페이지는 바깥쪽 번호만
            if is-chapter-start {
                return align(if is-odd { right } else { left })[#text(font: font-body, weight: "bold")[#display-num]]
            }

            let chapters = query(selector(heading.where(level: 1)).before(here()))
            let ch-text = if chapters.len() > 0 {
                let ch = chapters.last()
                if ch.numbering != none {
                    "第" + str(counter(heading).at(ch.location()).first()) + "章　" + ch.body
                } else {
                    ch.body
                }
            } else { "" }

            let sections = query(selector(heading.where(level: 2)).before(here()))
            let sec-text = if sections.len() > 0 {
                let sec = sections.last()
                let nums = counter(heading).at(sec.location())
                str(nums.at(0)) + "." + str(nums.at(1)) + "　" + sec.body
            } else { "" }

            let header-content = if is-odd {
                grid(
                    columns: (1fr, auto),
                    align(left)[#sec-text], [#text(weight: "bold", display-num)],
                )
            } else {
                grid(
                    columns: (auto, 1fr),
                    [#text(weight: "bold", display-num)], align(right)[#ch-text],
                )
            }

            stack(spacing: 2pt, text(size: 11.5pt, font: font-body)[#header-content], v(0.3em), line(
                length: 100%,
                stroke: 0.5pt,
            ))
        },
        header-ascent: 23%,
    )

    // 4. 표지(Title Page) 출력부
    if title != "" {
        set page(header: none) // 표지는 헤더 없음
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
            #v(30%)
            #align(center, text(size: 1.2em, font: font-gothic, weight: "semibold")[#logo])
            // #image("logo.svg", width: 18%)
        ]
        pagebreak()
    }

    // ==========================================
    // 5. 전역 통합 헤딩 렌더링 (제시해주신 예시 구조 활용)
    // ==========================================
    show heading: it => {
        // 모든 헤딩에 기본적으로 고딕체, 굵게, 첫줄 들여쓰기 없음 적용
        set text(font: font-gothic, weight: "bold")
        set par(first-line-indent: 0pt, leading: 0.8em)

        // 넘버링이 있는 경우 카운터 텍스트 추출 (ex: "第1章", "1.1")
        let head-num = if it.numbering != none { counter(heading).display(it.numbering) } else { none }

        if it.level == 1 {
            pagebreak(weak: true)
            counter(footnote).update(0)

            v(10%)

            if head-num != none {
                text(size: 1.3em, weight: "medium", font: font-maru)[#head-num]
                v(2em, weak: true)
            }

            text(size: 1.9em, baseline: 0em)[#it.body]
            v(1.5em)
        } else if it.level == 2 {
            v(2.5em, weak: true)
            // 번호 영역을 3.5em으로 고정하여 제목 정렬
            grid(
                columns: (2.5em, 1fr),
                align: horizon,
                if head-num != none {
                    text(size: 1.1em, font: font-maru, weight: "medium")[#head-num]
                } else { [] },
                text(size: 1.1em, weight: "bold")[#it.body],
            )
            // v(1.5em, weak: true)
        } else if it.level == 3 {
            v(2em, weak: true)
            grid(
                columns: (3.5em, 1fr),
                align: horizon,
                if head-num != none {
                    text(size: 13pt, font: font-maru, weight: "medium")[#head-num]
                } else { [] },
                text(size: 13pt, weight: "bold")[#it.body],
            )
            // v(1.5em, weak: true)
        } else {
            v(1.5em, weak: true)
            it
            // v(1em, weak: true)
        }
        par[]
        // v(1.5em, weak: true)
    }

    // ==========================================
    // 6. 목차(TOC) 스타일 수정
    // ==========================================

    set outline.entry(fill: repeat(gap: 6pt, justify: false)[.])

    show outline.entry: it => {
        let level = it.level
        let is-ch = level == 1

        // 1. 레벨별 폰트 및 여백 설정
        let text-font = if is-ch { font-gothic } else { font-body }
        let text-weight = if is-ch { "semibold" } else { "regular" }

        v(if is-ch { 2em } else { 1em }, weak: true)

        // 2. 정렬 로직 (들여쓰기 및 번호 너비)
        let (indent, num-width) = if level == 1 {
            (0em, 4.5em)
        } else if level == 2 {
            (1em, 3.5em)
        } else {
            (4.5em, 3.0em)
        }

        // 3. 페이지 번호 최대 너비 계산 (align-fill 기능 통합)
        let max-width = state("thesis-outline-max-width", 0pt)
        let page-element = it.page()
        let aligned-page = context {
            let this-width = measure(page-element).width
            max-width.update(calc.max.with(this-width))
            box(width: max-width.final(), align(right, page-element))
        }

        // 4. 점선 채우기 처리
        let aligned-fill = if not is-ch {
            box(width: 1fr, align(right, it.fill))
        }

        link(it.element.location())[
            #text(font: text-font, weight: text-weight)[
                #grid(
                    columns: (indent, num-width, 1fr, auto),
                    column-gutter: 0pt,
                    [],
                    // 들여쓰기 공간
                    it.prefix(),
                    // 번호 (Typst가 알아서 가져옴)
                    [
                        #it.body()            // 제목 텍스트
                        #if not is-ch [
                            #h(0.5em)           // 제목과 점선 사이 미세 간격
                            #aligned-fill       // align-fill 이 적용된 점선 영역
                        ]
                    ],
                    [#h(0.5em) #sym.wj #aligned-page],
                    // 페이지 번호 (최대 너비로 정렬됨)
                )
            ]
        ]
    }

    // 본문 렌더링
    body
}

// 부가 환경


#let jsquote(indent: false, body) = pad(left: 2em, right: 0em, top: 0.5em, bottom: 0.5em, {
    if indent == true { set par(first-line-indent: 0em) }
    body
})
#let jsbox(body) = align(center, block(width: 100%, stroke: 0.5pt, inset: (x: 2em, y: 1.5em), align(left, {
    set par(first-line-indent: 0em)
    body
})))

#let jstopic(title: content, body) = {
    v(1.2em)
    set par(first-line-indent: 0em)
    [*■#title*]
    h(0.5em)
    body
}

// --- 일본 시험지 스타일 이중 테두리 빈칸 (복구) ---
#let jsans(it) = box(baseline: 25%, stroke: 0.5pt, inset: 1pt, {
    rect(
        stroke: 0.5pt,
        inset: (x: 3pt, y: 2pt),
        radius: 0pt,
        text(size: 0.85em, weight: "bold", font: "M PLUS 2", it),
    )
})
