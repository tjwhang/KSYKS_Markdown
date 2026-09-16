#import "../../preamble.typ": *
#import "../../components/theme.typ": *

// Edit this specimen independently of the project prose.
// area.width / area.height are the full-width space left on its final page.
// Use jsvert(flow: "region", region-height: ...) for bounded vertical examples.
// Do not use pagebreak() or page-flow jsvert here; keep the specimen in this area.
#let specimen(area) = [
    #set par(first-line-indent: 0pt)
    #line(length: 100%, stroke: 0.35pt + pf-muted)
    #v(3mm)
    #jsfont("gothic", size: 10pt, fill: luma(40%))[
        *조판 예시* 다음은 본문에는 기재되지 않은 제 학습 및 탐구 내용을 견본 문구로 가져와 조금 바꾼 것입니다. 가로쓰기와 세로쓰기, 다국어와 수식이 혼재하는 실제 상황 예시를 통해 판면을 구성해 보았습니다.
    ]
    #v(5mm)

    #grid(
        columns: (1fr, 1fr),
        gutter: 8mm,
        [
            *양자 홀 효과*(quantum Hall effect)는 저온의 2차원 전자 유체가 강한 자기장에 놓여 있을 때 나타나는 현상이다. 이때 전자 유체란 자유전자들이 전기장 상에서 움직이는 상태를 의미한다. 이러한 상황에서 전자의 양자 에너지 상태는 란다우(Лев Давидович Ландау, 1908 \~ 1968)에 의해 계산되었는데, 이를 *란다우 준위*#super(typographic: false)[Landau levels]라고 한다.
            $
              vec(I_1, I_2) = mat(rho_1, rho_2; rho_3, rho_4)^(-1) vec(V_1, V_2)
            $
            여기서 저항 행렬의 주대각성분인 $rho_1$과 $rho_4$는 종방향 저항(_longitudinal resistivity_)이라고 부르며, 그 값이 서로 같다. 반대각성분의 절댓값인 $abs(rho_2)$와 $abs(rho_3)$은 횡방향 저항(_transverse resistivity_)라고 하며 또한 그 값이 서로 같다. \
            *발표 영상*: `https://youtu.be/jR58gPSACh4`
        ],
        [
            양자 홀 효과는 전자 유체의 수송에서 나타나는 양자현상이며, 강의에서는 이를 #ruby[・|・|・|・][양|자|변|칙]\(#ruby[りょうしへんそく][量子變則], quantum anomaly)으로도 설명했다. 유체의 평면과 직교하는 주변 자기장은 전자의 궤적에 영향을 줄 수 있다는 것이다. 그에 따라 전류의 방향이 전압의 방향과 더 이상 같지 않기 때문에 일반적인 옴의 법칙 $I = V\/R$을 그대로 적용하기 어렵다. 이러한 상황에서는 옴의 법칙을 벡터 형식으로 사용해야 한다. 2차원 상에서 이 형태는 다음과 같다.

            위 그래프는 주변 자기장의 세기($B$)에 의한 종방향 저항(푸른 선, $rho_(x x)$)과 횡방향 저항(붉은 선, $rho_(x y)$)의 경향을 나타낸 것이다. 이 그래프에서는 $nu$가 정수 값을 가질 때 확실하게 양자역학적 효과가 나타나는 것을 관찰할 수 있다. 하지만, $nu$가 분수 값을 가질 때 발생하는 더 미미한 양자 현상도 있다. 후자는 분수 양자 홀 효과#sub[fractional quantum Hall effect]라고도 한다. 
        ],
        v(-1em)
    )
    #align(
        right,
        jsvert(
            flow: "region",
            region-height: 112mm,
            justify: true,
            min-fragment-chars: 2,
            tracking: -0.01em
        )[
            == 本質은 왜 뒤처지는가？
            界外視의 관점은 우리가 획득할 수도, 어떨지 상상할 수도 없는 것이며, 인간의 언어로도 표현할 수 없다는 것이다. 인간은 界外的 眞理를 추구하지만 절대 도달할 수 없다. 우리가 추구하는 것이 과연 계외적 진리가 맞는 것인지도 사실 알 수 없다. 반대로, 계외적 진리나 형이상학적 본질은 우리의 세계의 성립에 관여할 수 없다. 즉, 이 모든 것은 일종의 형이상학적 가정과 상상으로 경험을 배제하고 하는 논의이며, 따라서 진리를 논할 때는 배제되어야 한다.

            그렇다면, 애초에 진리는 무엇이고 존재란 무엇인지는 별로 중요하지 않은 것이 된다. 절대 알 수 없다면 의미가 없는 것이기 때문이다. 내가 계외적으로 존재하는가보다는 내가 나를 느끼고 내가 나의 세계를 살고 있다는 것이 중요한 것이다. 내가 언젠가 죽을 것이라는 것이 중요한 것이지, 내가 존재하는 것이 중요한 것이 아니다. 죽으면 실존도 소용이 없겠지만, 처음부터 실존은 살아 있는 동안을 위한 개념이다. \

            《Ich bin meine Welt.　》 \
            　　나는 나의 세계이다. \

            따라서, 본질이 계외적 진리를 말하는 것이라면, 알 수 없을 뿐 아니라 우리에게는 의미가 없다. 우리는 끊임없이 형이상학적 본질을 갈망하고자 하는 본능적 관념을 가지고 있으며, 일종의 #ruby[존|재|론|적][存|在|論|的] #ruby[향|수][鄕|愁]에 이끌린다. 하지만, 우리는 우리가 속한 좌표계, 또는 실존적 지평을 벗어날 수 없다.\

            　　　---『본질과 과학의 실존적 도구주의에 대한 고찰』
        ],
    )

]
