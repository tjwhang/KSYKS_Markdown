#import "../portfolio.typ": jsfont

#let intro = [
    탐구 활동과 더불어 여기서는 학교생활 일부를 함께 첨부합니다. 지속해 온 학업 노력 과정, 언어·작문에 대한 관심에 관련된 기록들입니다. 앞의 내용과는 조금 다른 양상입니다만, 제가 학교에서 배우고 지내온 모습을 조금이나마 보여드릴 수 있을 것이라고 생각했습니다.
]

#let record(body, caption: [], height: 66mm) = block(breakable: false)[
    #set par(first-line-indent: 0pt, justify: false)
    #block(width: 100%, height: height, above: 0pt, below: 0pt)[
        #align(center + horizon, body)
    ]
    #block(above: 2mm, below: 0pt)[
        #jsfont("gothic")[#caption]
    ]
]

#let scholarships = (
    (title: [계원장학회 4·19 장학증서 ▲], body: image("../assets/records/장학증서.pdf")),
    (title: [유영학술재단 장학증서 ▲], body: image("../assets/records/장학증서2.pdf")),
    (title: [석전육영재단 장학증서 ▲], body: image("../assets/records/장학증서3.pdf")),
)

#let pending = block(width: 100%, height: 100%, fill: white,
    stroke: 0.35pt + luma(80%), inset: 3mm)[
    #align(center + horizon)[
        #jsfont("gothic", size: 10pt, fill: luma(50%))[증서 플레이스홀더 \ (진짜 넣기 전까지)]
    ]
]

#let appendix = (
    title: "부록: 활동 및 기록",
    inset: 0em,
    body-width: 100%,
    body: [
        #set par(first-line-indent: 0pt, justify: false)
        #if intro == [] { v(22mm) } else {
            move(dx: 9%, block(above: 0pt, below: 7mm, width: 38em)[#intro])
        }
        #v(2em)
        #grid(columns: scholarships.map(_ => 1fr), column-gutter: 5mm,
            ..scholarships.map(item => record(
                if item.body == none { pending } else { item.body },
                caption: item.title, height: 70mm,
            )))
        #v(9mm)
        #grid(columns: (1fr, 1fr), column-gutter: 6mm,
            record(image("../assets/records/image-1.png", width: 100%, height: 100%, fit: "contain"),
                caption: [학교 기숙사 주최 백일장 우수작 선정 ▲]),
            record(image("../assets/records/image-2.png", width: 120%, fit: "contain"),
                caption: [
                    ▲ 아시아--태평양 자매학교 영어 에세이 경시대회 이등상 \
                    수학여행 기행문 우수작 선정 및 교지(83회) 기재 ▼
                ]),
        )
        #place(dx: 48%, dy: 2%, image("../assets/taipei1.png", width: 70%))
    ],
)
