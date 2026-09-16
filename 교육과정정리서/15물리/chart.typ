// chart-manual.typ
#import "theme.typ": *


// --- 1. Color Palette ---
#let accent-color = accent-color
#let chart-red = rgb("#B22222") // 기본사항용 빨강
#let chart-gray = luma(240)      // 해설 배경용 회색
#let chart-border = luma(100)

// --- 2. Font Setup (Covers Logic) ---
#let chart-font-setup(body) = {
    is-chart-mode.update(true)
    set text(
        font: (
            (name: "Pretendard JP", covers: regex("[\p{Latin}\p{scx:Hangul}0-9]")),
            (name: "M PLUS 2", covers: regex("[\p{scx:Hira}\p{scx:Kana}\p{scx:Han}]")),
            "Source Han Sans",
        ),
        size: 9.5pt,
        lang: "ja",
    )
    body
}

// --- 3. Chapter Cover (사진 3 재현) ---
#let chapter-cover(
    number: [01],
    title: [],
    sections: (),
    description: [],
    accent-color: accent-color,
) = {
    // 1. 페이지 설정: 여백 0, 헤더/푸터 제거
    page(
        header: none,
        footer: none,
        margin: 0pt,
    )[
        // 2. 제목 숨기기 (목차와 북마크에는 나타나지만 페이지에는 공간을 차지하지 않음)
        #place(top + left)[
            #block(width: 0pt, height: 0pt, clip: true)[
                #heading(level: 1, outlined: true, bookmarked: true, title)
            ]
        ]

        #chart-font-setup[
            // 3. 전체 페이지를 하나의 그리드로 분할 (행의 합이 정확히 100%)
            #grid(
                columns: 100%,
                rows: (2%, 98%), // 상단 띠 2%, 메인 영역 98%
                gutter: 0pt,

                // [행 1] 상단 장식 띠
                rect(width: 100%, height: 100%, fill: accent-color),

                // [행 2] 메인 레이아웃 영역
                grid(
                    columns: (1fr, 35%),
                    // 좌측 65%, 우측 35%
                    rows: 100%,
                    // 부모 행(98%)의 전체 높이 사용
                    gutter: 0pt,

                    // --- 좌측 영역 ---
                    block(width: 100%, height: 100%, inset: (left: 10%, top: 20%, right: 10%), {
                        // 배경 거대 숫자 (place를 사용하여 레이아웃 흐름에서 제외)
                        place(left + top, dx: -5%, dy: -5%)[
                            #text(size: 20em, weight: "black", fill: accent-color.transparentize(92%), number)
                        ]

                        stack(
                            dir: ttb,
                            spacing: 2.6em,
                            text(size: 2em, weight: "bold", fill: accent-color, "CHAPTER " + number),

                            stack(dir: ttb, spacing: 5em, {
                                set par(leading: 0.4em, first-line-indent: 0em)
                                text(size: 4.5em, weight: "black", fill: accent-color, title)
                                // 선의 길이를 고정값(pt)으로 주어 밀림 방지
                                line(length: 100pt, stroke: 5pt + accent-color)
                            }),
                        )
                        if description != "" {
                            pad(top: 1em, {
                                set text(size: 1.2em, fill: chart-border)
                                set par(leading: 0.8em, justify: true) // 줄 간격 조절
                                description
                            })
                        } else { none }
                    }),

                    // --- 우측 영역 (CONTENTS) ---
                    block(
                        width: 100%,
                        height: 100%,
                        fill: accent-color,
                        inset: (top: 20%, x: 10%),
                        {
                            set text(fill: white)
                            text(size: 2.2em, weight: "bold", "CONTENTS")
                            v(2em)

                            // 섹션 리스트
                            stack(
                                spacing: 1.8em,
                                ..sections
                                    .enumerate()
                                    .map(((i, sec)) => grid(
                                        columns: (2.5em, 1fr),
                                        column-gutter: 0.5em,
                                        align(center + top, move(dy: -0.5em, circle(
                                            radius: 0.9em,
                                            fill: white,
                                            inset: 0.3em,
                                            text(fill: accent-color, weight: "black", size: 0.9em, str(i + 1)),
                                        ))),
                                        align(left + top, text(size: 1.1em, weight: "medium", sec)),
                                    )),
                            )

                            // 우측 하단 배경 숫자 (place 사용)
                            place(bottom + right, dx: 15%, dy: 5%)[
                                #text(size: 14em, weight: "black", fill: white.transparentize(88%), number)
                            ]
                        },
                    ),
                )
            )
        ]
    ]
    // 커버 이후 자동으로 페이지를 넘김
    pagebreak(weak: true)
}

// --- 4. Basic Points (사진 1 상단 재현) ---

#let basic-points(title: "基本事項", body, accent-color: accent-color) = {
    context {
        // 1. 페이지 마진 계산 (B5 비대칭 대응)
        let is_odd = calc.odd(here().page())
        let m_left = if is_odd { 25mm } else { 20mm }
        let m_right = if is_odd { 20mm } else { 25mm }

        // 2. 전체 페이지 너비 확장을 위한 패딩 설정
        pad(left: -m_left, right: -m_right, block(
            width: 100% + m_left + m_right,
            spacing: 2em,
            {
                // [상단 바 영역]
                // grid를 사용하여 타이틀 박스와 선을 병렬 배치
                grid(
                    columns: (auto, 1fr),
                    rows: auto,
                    gutter: 0pt,

                    // (1) 타이틀 사각형: 종이 왼쪽 끝에서 시작
                    rect(
                        fill: accent-color,
                        inset: (left: m_left, right: 1.5em, y: 0.7em),
                        stroke: none,
                        text(fill: white, weight: "bold", size: 1.1em, title),
                    ),

                    // (2) 옆으로 뻗는 선:
                    // height: 100% 대신 align(bottom)을 사용하여 타이틀 박스의 바닥에 고정
                    align(bottom, move(dy: -0.75pt, line(
                        length: 100%,
                        stroke: 1.5pt + accent-color,
                    ))),
                )
            },
        ))
    }
    // [본문 영역]
    set par(justify: true, first-line-indent: 0pt)
    body
}

// --- 5. Content Grid (텍스트와 그래프 병렬 배치) ---
#let chart-grid(left-body, right-fig) = {
    pad(y: 1em, grid(
        columns: (1fr, 180pt),
        column-gutter: 2em,
        left-body, align(center + top, right-fig),
    ))
}

// --- 6. Decoration Elements ---
#let attention(body) = {
    text(fill: chart-red, weight: "bold", "注意 ") + body
}

#let question-badge(body) = {
    (
        box(
            stroke: 0.5pt + chart-border,
            radius: 2pt,
            inset: (x: 0.5em, y: 0.2em),
            text(size: 0.8em, weight: "bold", "問"),
        )
            + h(0.5em)
            + body
    )
}

#let explanation-box(title: "解 説", body) = {
    block(
        width: 100%,
        fill: chart-gray,
        inset: 1.2em,
        stroke: (top: 1pt + chart-border, bottom: 1pt + chart-border),
        {
            rect(fill: luma(150), inset: (x: 1em, y: 0.3em), text(fill: white, weight: "bold", size: 0.9em, title))
            v(0.5em)
            body
        },
    )
}
