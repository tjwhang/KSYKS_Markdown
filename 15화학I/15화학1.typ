#import "@preview/physica:0.9.4": *
#import "@preview/ilm_custom:1.4.1": *
#import "@preview/alchemist:0.1.4": *
#import "@preview/theorion:0.3.2": *
#import "@preview/rich-counters:0.2.1": *
#import "@preview/whalogen:0.3.0": *
#import cosmos.rainbow: *


#let title = [2015 개정 \ 화학 I]

#show: ilm.with(
  title: title,
  author: "Taejoon Whang",
  //date: [중앙고등학교],
  date: datetime(year: 2025, month: 03, day: 06),
  abstract: [2015 교육 개정 고등학교 화학 I의 내용을 다룬다.],
  preface: align(center + horizon)[
    = 서 문
    #lorem(100)
  ],
  //bibliography: bibliography(""),
  figure-index: (enabled: false),
  table-index: (enabled: false),
  listing-index: (enabled: false)
)

#set text(font: (
  (
    name: "STIX Two Text",
    covers: "latin-in-cjk",
  ),
  "Source Han Serif K"
))
#show math.equation: set text(font: "STIX Two Math")

#set outline()
#set page(
  paper: "a4",
  margin: 3.5cm,
  header: align(right, title),
  numbering: "1",
)
#set math.equation(numbering: none, supplement: [식. ])

#let tag(content) = {
  math.equation(
    block: true, 
    numbering: "(1.1)",
    content
  )
}

#show: show-theorion

#set math.mat(delim: "[")

// 본문
= 시작하기 전 배경 지식

== 원자 표기법

$
  attach("X", tl: M, bl: N, tr: I, br: n)
$
- X: 원소 기호
- $M$: 원자 질량수
- $N$: 원자 번호 (양성자 수)
- $I$: 이온
- $n$: 원자 개수

== 화학식의 종류
- *분자식*: 한 분자를 구성하는 원자와 원자의 수를 나열한 식
- *실험식*: 각 성분 원소의 원자수의 비율을 가장 간단한 정수비로 나타내 각 원소 기호 뒤에 붙인 식
- *시성식*: 물질이 가진 특성을 알 수 있도록 작용기를 분리하여 나타낸 식
- *구조식*: 구성하는 원자와 원자 간 결합 모양과 배열 상태를 결합선을 사용하여 나타낸 식

== 구조식 읽는 방법

#skeletize({
  molecule("H")
  branch({
    single(angle:-3)
    molecule("O")
  })
  branch({
    single(angle:-1)
    molecule("O")
  })
})
원자 간 전자 선으로 결합을 나타낸다.

#skeletize({
  molecule("O")
  double()
  molecule("C")
  double()
  molecule("O")
})
이중 결합은 선 두 개로 나타낸다.
#skeletize({
  molecule("N")
  triple()
  molecule("N")
})
삼중 결합은 선 세 개로 나타낸다.

 #skeletize({
 molecule("H")
 single()
 molecule("C")
 branch({
 single(angle:2)
 molecule("H")
 })
 branch({
 single(angle:-2)
 molecule("H")
 })
 single()
 molecule("C")
 branch({
 single(angle:-1)
 molecule("H")
 })
 branch({
 double(angle:1)
 molecule("O")
 })
})
위는 에탄올이다.

3D 모델을 사용하여 나타내는 경우 원자의 색은 보통 다음 규칙을 따른다.
- 수소: 흰색
- 탄소: 검은색
- 산소: 빨간색
- 질소: 파란색
- 황: 노란색
- 염소: 녹색
- 브로민: 갈색
- 아이오딘: 보라색
이외의 색은 작성자가 임의로 지정한다.

복잡한 분자들은 간단한 표기를 위해 원자를 생략하여 그리기도 한다.
#skeletize({
  cycle(6, align: true, {
    branch({
      single(angle:2)
      molecule("H")
    })
    branch({
      single(angle:6)
      molecule("HO")
    })
    single()
    branch({
      single(angle:2)
      molecule("OH")
    })
    branch({
      single(angle:6)
      molecule("H")
    })
    single(stroke: black + 3pt)
    branch({
      single(angle:2)
      molecule("H")
    })
    branch({
      single(angle:6)
      molecule("OH")
    })
    single()
    branch({
      single(angle:2)
      molecule("H")
    })
    branch({
      single(angle:6)
      molecule("OH")
    })
    single()
    molecule("O")
    single()
    branch({
      single(angle:2)
      molecule("CH_2OH")
    })
    branch({
      single(angle:6)
      molecule("H")
    })
    single()
  })
})
위는 #sym.alpha - 포도당이다.

여전히 선은 공유결합을 의미하나, 꺾인 부분은 탄소 원자들이 생략된 부분이며, 탄소 원자와 결합한 수소들까지 모두 생략하여 표기한다. 
자세한 것은 아래 링크를 참조한다.

#link("https://www.wikiwand.com/en/articles/Skeletal_formula")
//[ Skeletal Formula - Wikipedia ]

= 화학의 역사
맥락을 이용하는데 필요한 상식이다. 중요하지는 않다. 일부 교과서에 소개된 내용을 가져와 적절히 배치했다.

== 불의 발견
불은 인류에게 가장 중요한 발견 중 하나이자, 화학의 태동이라고 할 수 있다. 150만년 전 불을 발견한 인류는 불을 사용하여 고기를 굽고, 농경지를 개간하고, 높은 온도에서 흙을 구워 곡물 저장에 필요한 토기를 만들었다. 또, 불을 이용해 광석에서 금속을 추출해 무기와 도구를 만들기도 했다. 

처음 농사를 지을 때는 돌로 만든 도구를 사용하다가, 이후 불을 이용해 광석에서 구리를 추출해 청동을 만들었다. 이후 더 높은 온도에서 녹지만 청동보다 훨씬 단단한 철을 제련하는 기술이 발달하면서 식량 생산량이 증대되었다.

== 연금술
5원소설(물, 불, 흙, 공기의 4원소 + 에테르)의 등장 이후 많은 사람들이 연금술을 통해 값 싼 돌이나 금속을 이용해 금 등의 비싼 귀금속을 만드려고 시도했다. 현대에 와서는 이런 시도가 무의미하다는 것이 밝혀졌지만, 금을 만들기 위한 수많은 실험 과정에서 여러 가지 물질을 합성하고 그 성질을 알아내며 화학은 큰 발전을 이룰 수 있었다.

== 근대 화학의 발전
연금술은 오랫동안 유지되었다. 그러다가 1774년 라부아지에(Lavoisier)는 질량 보존 법칙을 발견했다.이는 물질이 갑자기 생기거나 없어지지 않고, 그 형태만 변하여 존재한다는 뜻을 담고 있다. 라부아지에는 또한 산화가 연소 반응임을 증명해 내기도 했다.

이후 1803년, 돌턴(Dalton)이 근대적 원자설을 발표하고 아보가드로(Avogadro)가 아보가드로 원리와 분자설을 발표했다. 그 뒤로는 발전된 현대적 원자 모형이 계속 제시되고, 원자와 분자들의 성질이 하나씩 밝혀지고, 양자역학이 탄생하며 화학은 계속 발전하게 된다.

= 화학의 유용성
이제 본격적으로 첫 단원으로 들어가는데, 이 부분은 상식에 가까운 내용으로 이루어져 있다. 인간 생활의 각 분야에서 화학이 어떤 긍정적 영향을 주었는지 배우며, 화학을 배워야 하는 이유를 제시하는 단원이라고 할 수 있다. 상식이라고 생각하고 이해하려고 노력하며 암기해 보자.

== 식량
=== 하버-보슈(Haber-Bosch)법
질소(N)은 단백질과 핵산을 이루는 기본 원소 중 하나이다. 즉, 생물체는 생존에 질소가 반드시 필요하다. 하지만 대기의 78%가 질소임에도 불구하고 대부분의 생물은 공기 중의 질소 기체(#ce("N2"))를 이용하지 못한다. 이는 질소 분자가 삼중 결합을 이루어 매우 안정해, 화학 반응을 하기 어렵기 때문이다. 그래서 질소는 생물이 이용할 수 있는 형태로 전환되어야 한다.

공기 중 질소의 일부는 번개에 의해 산소와 반응하여 물에 녹을 수 있는 이산화질소(#ce("NO2")) 등의 물질이 되어 빗물에 섞이거나, 콩과식물의 뿌리혹박테리아에 의해 생물이 사용할 수 있는 형태로 변환(질소 고정)된다.

식물은 토양 속의 물에 녹아 암모늄 이온(#ce("N H_4^+"))이나 질산 이온(#ce("NO3^-"))으로 변환된 질소를 흡수하여 생장에 이용한다. 

산업 혁명 이후 인구가 급격히 증가하며 식량 부족 문제가 대두됐다. 질소는 농작물의 성장에 영향을 주는 주요 성분으로, 당시에는 식물 퇴비나 동물 분뇨 등의 천연 비료와 칠레 초석이라고 부르는 질산 칼륨(#ce("KNO_3")) 등을 질소 공급원으로 사용했으나, 양이 부족했다.

20세기, 독일의 화학자 하버(Harber)와 보슈(Bosch)는 공기 중의 질소 기체와 수소 기체를 고온(400\~600#sym.degree\C), 고압(200\~400기압)에서 산화 철 촉매를 사용해 반응시켜 암모니아를 대량으로 합성하는 방법을 알아내었다.
$
  #ce("N_2 (g) + 3H_2 (g) -> 2NH_3 (g)")
$
이렇게 만든 암모니아를 질산암모늄 등으로 바꾸어 비료를 만든다. 이 업적으로 하버는 1918년에 노벨 화학상을 수상했다.
이 반응은 인류의 식량 문제를 획기적으로 해결한 만큼, 특히 수능에서 중요하게 다루어진다.

=== 이외
화학은 어업 분야에서는 새로운 섬유로 낚시줄, 그물 등을 만들거나 살충제, 제초제, 복합 비료 등 새로운 화학 물질을 만드는 등을 통해 식량 생산 증대에 기여했다.

== 의류
=== 섬유
천연 섬유(면, 마, 모, 건, 비단 등)는 촉감과 흡습성#footnote[천연 섬유에는 친수성인 하이드록시기 #ce("OH-")가 많다]이 좋다는 장점이 있지만, 강도가 약하고 생산 과정에 많은 시간과 노력이 들어 대량 생산에 불리하다.

합성 섬유(나일론, 폴리에스터, 폴리아크릴로나이트릴 등)이 개발되며 값싸고 다양한 기능이 있는 의복을 제작 밑 이용할 수 있게 되었다. 합성 섬유는 보통 ㅡㅂ습성이 좋지 않지만, 질기고 쉽게 닳지 않으며 대량 생산이 가능하다. 또, 세탁이 간편하고 해충과 곰팡이의 피해가 없으며, 다양한 기능의 섬유를 제작할 수 있다.

나일론은 캐러더스(Carothers)가 고분자 물질을 연구하던 중에 발견한 인류 최초의 합성 섬유로, "공기, 석탄, 그리고 물로 만들며, 강철보다 강하다."라는 주목을 받았다. 나일론은 질기고 물을 흡수해도 팽창하지 않으며 오랫동안 변하지 않는 장점이 있어 의류, 밧줄, 전선, 그물 등에 사용된다. 그러나 고온에 민감해 쉽게 변형되고 섬유가 누렇게 되는 황변 현상이 일기도 한다.

폴리에스터는 1941년 영국에서 처음 개발되었는데, 질기고 잘 구겨지지 않으며 빨리 마르는 특징이 있어 면의 대용으로 많이 사용된다. 질감과 탄성이 좋아 다양한 의류용 섬유로 사용된다.

폴리아크릴로나이트릴 또는 폴리아크릴은 모와 비슷한 보온성을 가지면서도 모보다 훨씬 질기다. 스웨터, 양말, 내의 등의 소재로 사용된다.

최근에는 첨단 기능을 지닌 합성 섬유가 개발된다. 물은 스며들지 않으나 수증기는 통과시키는 #footnote[이 두 성질을 각각 방수성과 투습성이라고 하며, 본래는 서로 상반되는 성질이다.] 고어텍스, 총알에도 뚫리지 않는 케블라 섬유 등이 그 예시이다.

=== 염료

천연 염료는 광물, 곤충, 식물 등에서 추출해 만드는 것으로, 얻기 어렵고 귀해 일부 사람들만 다양한 색의 옷을 입을 수 있었다.

퍼킨(Perkin)은 말라리아 치료제인 키니네를 연구하던 중 우연히 선명하게 착색되는 색소를 발견했는데, 이후 이를 개량하여 인류 최초의 염료인 모브를 합성했다. 합성 염료는 섬유 뿐 아니라 가죽, 종이 염색 등에도 쓰이고 있다.

== 주거
=== 화석 연료
인류가 처음으로 사용한 연료는 나무였다. 이후 석탄이 채굴되며 산업혁명이 일어났고, 현재는 석유오 천연가스를 사용하며 생활에 큰 변화가 생겼다. 화석 연료를 연소시켜 발생하는 에너지로 가정에서 난방과 조리를 하고, 발전소에서 전기를 생산한다.

석유 원유는 바다에 살던 생물의 사체가 땅속에 묻혀 오랜 기간 분해되어 만들어진 물질로, 대부분 가스 성분과 함께 매장되어 있어 분별 증류로 분리한다.

원유를 증류탑에 넣고 가열하게 되면 각 석유 물질의 끓는점 차이에 의해 끓는점이 낮고 가벼운(탄소 수가 적은) 물질부터 순서대로 위쪽에서부터 분리된다. 석유 가스, 나프타, 등유, 경유, 중유, 아스팔트 등이 분리되며, 이는 대부분 연료로 사용되지만 그 뿐 아니라 도로 포장, 플라스틱, 합성 섬유, 의약품 등 많은 물질의 원료로 사용된다. 주의할 점은, 증류탑에서 나오는 석유 가스는 뷰테인(#ce("C4H10"))과 프로페인(#ce("C3H8")) 등이며, 메테인(#ce("CH4"))은 증류탑으로 거르지 않는다.

=== 철의 제련
철기시대부터 쓰인 철은 18세기 대량생산 기술이 발달하면서 더욱 다양한 분야에 이용되었다. 특히, 강도가 개선된 고탄소강인 강철을 만들 수 있게 되며 건축물에 활용되었다.

롤러를 이용하여 철 광석, 석회석, 코크스 등의 원료를 용광로에 함께 넣고 아래에서 뜨거운 공기를 불어 넣어주면 용융 상태의 철을 얻을 수 있다. 용광로에서 바로 얻어지는 철은 탄소를 비롯한 불순물이 포함되어 있는데, 이를 선철이라고 한다. 선철은 강도가 낮아 그대로 사용하기 어려워 탄소의 함량을 줄여 강철 또는 연철을 만든다. 강철은 가공이 쉽고 강도가 높아 강판, 공구, 자동차 등에 사용된다. 연철은 탄소 함량이 강철보다도 낮아 연하며 가공이 쉽다. 철판, 철사, 못 등에 사용된다.

철의 제련 과정에서 일어나는 화학 반응은 아래와 같다.

1. 코크스의 불완전 연소로 일산화 탄소가 생성된다.
#ce("2C + O2 -> 2CO")

2. 제3산화철과 일산화 탄소의 산화 환원 반응에 의해 철광석의 산화 철이 철로 환원된다.
#ce("Fe2O3 + 3CO -> 2Fe + 3CO2")

3. 철광석 중의 불순물인 이산화 규소는 석회석과 반응하여 슬래그로 된다.
#ce("CaCO3 -> CaO + CO2") \
#ce("CaO + SiO2 -> CaSiO3")

철의 제련 과정에서 남는 찌꺼기인 슬래그는 시멘트나 벽돌 제조에 이용된다.

=== 시멘트와 콘크리트
석회석을 가열하면 생석회가 된다(#ce("CaCO3 -> CaO + CO2")). 이 생석회를 점토와 섞으면 시멘트가 만들어진다. 시멘트에 모래, 자갈 등을 넣고 물로 반죽한 후 건조시키면 콘크리트가 된다. 콘크리트는 내구성이 높지만 인장 강도가 작은 단점이 있다. 이 단점을 보완하기 위해 콘크리트에 철근을 넣는다.

철근 콘크리트는 콘크리트가 철근을 감싸는 형태로 되어 있어 철근의 부식을 막아 수명이 길고 매우 단단하다. 철근 콘크리트가 개발되면서 크고 높은 건물과 다리, 댐 등 대규모 건축물을 지을 수 있게 되었다.

=== 알루미늄의 제련
현재는 철근 콘크리트 이외에도 다양한 건축 재료가 이용되는데, 그 중 대표적인 것이 알루미늄이다. 알루미늄은 가볍고 단단하여 건축 외벽 등에 이용한다.

알루미늄은 지각에 가장 많이 존재하는 금속으로, 반응성이 커서 자연 상태에서 산화물의 형태로 존재한다.

알루미늄을 제련하려면 보크사이트#footnote[Bauxite, 철반석(鐵礬石). 주성분은 수산화알루미늄(#ce("Al(OH)3")), 산화알루미늄(#ce("Al2O3")), 산화철(#ce("Fe2O3")), 소량의 생석회(#ce("Cao")), 산화마그네슘(#ce("MgO")), 미량의 갈륨(Ga) 등이다.]를 정제하여 얻은 순수한 산화 알루미늄(#ce("Al2O3"))을 가열하여 녹인 후 전기 분해한다. 산화 알루미늄의 녹는점은 2054#sym.degree\C로 매우 높지만, 크라이올라이트#footnote[Cryolite, 빙정석(氷晶石). 헥사플루오로알루민산나트륨(#ce("Na3AlF6"))]를 첨가하면 녹는점이 960#sym.degree\C 정도로 낮아진다.

=== 이외
스타이로폼은 건물 내부의 열이 밖으로 빠져나가지 않도록 하는 단열재로 사용되며, 가볍고 거의 부식되지 않지만 열에 약하다.

유리는 모래에 포함된 이산화 규소(#ce("SiO2"))를 원료로 만들며, 건물의 외벽과 창 등에 이용한다.

== 의약품
=== 아스피린
버드나무 껍질은 예로부터 진통 효과를 가지고 있는 것으로 유명한데, 히포크라테스의 저서에서도 언급되었고, 고대 이집트의 파피루스에서도 언급된다. 이순신 장군도 무과 시험 중 낙마하자 버드나무 껍질을 벗겨서 상처가 난 다리에 동여매고 시험을 완주한 기록이 있다. 아스피린은 해열, 소염의 기능도 한다.

독일 바이엘AG사의 연구원 호프만(Hoffmann)은 버드나무 껍질 추출물인 살리실산(#ce("C7H6O3"))의 부작용을 줄이기 위해 아세트산(#ce("CH3COOH"))을 섞는 방법으로 아세틸살리실산(#ce("C9H8O4")), 즉 아스피린#footnote[사실 아스피린은 약의 상품명이다.]을 합성했다. 

= 탄소 화합물
탄소(C)를 기본 골격으로 수소(H), 산소(O), 질소(N), 황(S), 인(P), 할로젠 등이 공유 결합하여 이루어진 물질이다. 아미노산, DNA, 합성 섬유, 포도당 등 우리 생활 속 물질의 상당수가 탄소 화합물이다.

== 탄소의 특성
탄소는 14족 원소로 원자가 전자가 4개이다. 즉, 탄소 원자 한 개는 최대로 다른 원자 4개와 공유 결합할 수 있고, 탄소 원자들은 다양한 결합 방법(단일 결합, 이중 결합, 삼중 결합)으로 여러 가지 구조의 탄소 화합물을 만든다. 또, 탄소는 이러한 다양한 결합 방법을 바탕으로 사슬 모양, 가지 모양, 가지 친 사슬 모양, 고리 모양 등 수많은 모양으로 결합할 수 있어 구성 원소의 종류가 적더라도 수많은 종류의 화합물을 만들어낼 수 있다.

== 탄화 수소
탄소 화합물 중 탄소와 수소로만 이루어진 화합물이다. 일반적인 특징 중 몇 개는 아래와 같다.
- 물에 잘 녹지 않는다.
- 연소할 때 많은 열이 발생하여 연료로 많이 사용한다.
- 완전 연소되면 이산화탄소(#ce("CO2"))와 물(#ce("H2O"))이 생성된다.

탄화 수소의 일반적인 분자식은 아래와 같다.
$
  "C"_m"H"_n
$
이때 대부분의 경우에서 $n=2m+2$가 된다. 이는 여러 가지 모양의 탄소 결합 분자 모양의 모든 가지에 수소 원자를 붙여 보면 알 수 있다. 다만, 고리 모양 결합이거나 이중, 삼중 결합이 존재하는 경우 $n=2m+2$가 성립하지 않는 경우가 있음에 유의하자.

대표적인 탄화 수소로는 메테인(#ce("CH4"))가 있다. 메테인은 천연가스의 주 성분으로 공기보다 가볍다. 정사면체 분자 구조를 가지고 있으며 물에 대한 용해도가 작다. 본래 무색 무취의 기체이다. 가스에서 냄새가 나는 것은 가스 누출을 알리기 위한 추가적인 첨가제의 냄새이다. 

다른 탄화 수소 몇 개를 나열해 보면 아래와 같다.
- 에테인(#ce("C2H6"))
- 프로페인(#ce("C3H8"))
- 뷰테인(#ce("C4H10"))

=== 명명법
탄화 수소는 탄소 원자의 개수에 따라 이름이 달라진다. 아래는 탄화 수소에서 탄소의 개수에 따른 이름 접두어이다.

#grid(
  columns: 2,
  gutter: 1em,
  table(
  columns: 2,
  align: horizon,
  table.header(
    [탄소 수], [접두어]
  ),
  [1], [metha],
  [2], [etha],
  [3], [propa],
  [4], [buta],
), 
  table(
  columns: 2,
  align: horizon,
  table.header(
    [탄소 수], [접두어]
  ),
  [5], [penta],
  [6], [hexa],
  [7], [hepta],
  [8], [octa]
  )
)

또, 단일 결합으로 이루어져 있는 경우에는 \~에인(\~ane)#footnote[독일식 발음인 "\~안"으로 읽기도 한다. 다만 2000년대 이후 영어 발음이 공식화 되었다.], 이중 결합이 포함된 경우에는 \~엔(\~ene), 삼중 결합이 포함된 경우에는 \~아인(\~yne)으로 끝난다. 또, 고리 모양 구조로 결합한 경우에는 사이클로\~(cyclo\~)가 앞에 붙는다.

#problem[
  아래 분자의 이름은 무엇일까?
#skeletize({
  molecule("C")
  branch({
    single(angle:4)
    molecule("H")
  })
  branch({
    single(angle:6)
    molecule("H")
  })
  branch({
    single(angle:2)
    molecule("H")
  })
  single()
  molecule("C")
  branch({
    single(angle:6)
    molecule("H")
  })
  branch({
    single(angle:2)
    molecule("H")
  })
  single()
  molecule("C")
  branch({
    single(angle:6)
    molecule("H")
  })
  branch({
    single(angle:2)
    molecule("H")
  })
  single()
  molecule("C")
  branch({
    single(angle:6)
    molecule("H")
  })
  branch({
    single(angle:2)
    molecule("H")
  })
  branch({
    single(angle:0)
    molecule("H")
  })
})
]

#solution[
  탄소 원자 4개가 있고 모두 단일 결합으로 이루어져 있으니 뷰테인(butane)이 된다. 화학식은 #ce("C4H10")이다.
사실 이 구조식은 앞에서 설명한 것 처럼 간단히 나타낼 수 있다. 그 그림은 아래와 같다.
#skeletize({
  single(angle:0.8)
  single(angle:7.2)
  single(angle:0.8)
})
]

#problem[
  아래 분자의 이름은 무엇일까?
#skeletize({
  cycle(5, align: false, {
    single()
    single()
    single()
    single()
    double()
  })
})
]
#solution[
  고리 모양 구조이고, 탄소는 5개이며 이중 결합이 있으므로 사이클로펜텐(cyclopentene)이 된다. 화학식은 #ce("C5H8")이다.
]

=== 연소 반응과 이용
탄화 수소는 완전 연소 시 물과 이산화탄소, 그리고 큰 에너지를 낸다. 이를 굳이 일반적인 화학식으로 나타내면 다음과 같다.
$
  "C"_m "H"_n + (m+n/4) "O"_2 --> m "CO"_2 + n/2 "H"_2 "O" + "E"
$
식의 원리는 간단하고 당연한데, 이산화탄소의 개수는 탄소의 개수와 같게 정해지고, 그에 따라 물의 개수도 정해진다. 위 공식은 참고용일 뿐이며, 외우지 말고 해당 상황에서 반응식의 계수를 맞추도록 하자. 이 때 계수를 쉽게 맞추기 위해서는 C - H - O의 순서대로 계수를 맞추는 것이 좋다. 

큰 에너지를 내기 때문에 연료로 이용된다고 했었는데, 교과에서 다루는 용도는 크게 세 가지가 있다.
- 압축 천연 가스(CNG, Compressed Natural Gas)
- 액화 천연 가스(LNG, Liquefied Natural Gas)
- 액화 석유 가스(LPG, Liquefied Petroleum Gas)
이때 천연 가스의 주 성분은 메테인(#ce("CH4"))이고, 석유 가스의 주 성분은 프로페인(#ce("C3H8"))과 뷰테인(#ce("C4H10"))이다. 실생활 예시로, 메테인은 공기보다 가벼우므로 LNG 경보기는 천장 쪽에 설치하고, 프로페인이나 뷰테인은 공기보다 무거우므로 LPG 경보기는 바닥 쪽에 설치한다. 이 분자들의 질량에 대해서는 이후 단원에서 더 자세히 설명한다.

=== 끓는점
녹는점과 끓는점은 분산력(런던 힘)#footnote[반데르발스 힘 중 하나. 순간적으로 전자가 분자 안에서 한 쪽으로 치우치면서 극성이 없는 분자가 극성 분자처럼 쌍극자가 된다. 이 현상을 편극(polarization)이라고 하고, 이때 순간적인 쌍극자를 유발 쌍극자라고 한다. 유발 쌍극자는 다시 주위의 분자들을 편극시켜 유발 쌍극자로 만들고, 이때 작용하는 인력이 분산력이다.]에 의해 결정되는데, 질량이 클수록 분자 간 인력이 커 끓는 점이 높다. 또, 분자의 모양이 옆으로 퍼져 있을수록 끓는점이 높다.

=== 구조 이성질체
구조 이성질체란 분자식은 같지만 구조가 달라 성질이 다른 물질이다. 예를 들어 뷰테인(#ce("C4H10"))을 생각해보자. 아래 두 분자는 모두 뷰테인 분자이다.

#grid(
  columns: 2,
  gutter: 5em,
  skeletize({
  single(angle:0.8)
  single(angle:7.2)
  single(angle:0.8)
}),

skeletize({
  single(angle: 3.3)
  branch({
    single(angle: 4.7)
  })
  single(angle: 2)
  
})
)

왼쪽은 노말 뷰테인(normal butane), 오른쪽은 아이소뷰테인(isobutane)이라고 한다.

== 탄화 수소 유도체
탄화 수소에서 일부 수소 원자 대신 다른 작용기를 결합시킨 화합물을 탄화 수소 유도체라고 한다.
화학식은 아래와 같다.
$
  "C"_m"H"_(n-k)+"R"
$
이때 R이 작용기이다. 

=== 알코올
작용기로 하이드록시기("-OH")를 가진다. 가연성이 있고, 완전 연소시 물과 이산화탄소를 생성한다. 액성은 중성이다#footnote[-OH는 수산화 이온(#ce("OH-"))가 아니라 하이드록시기이다. 술이 쓴 것은 술이 염기성이라서가 아니라 그냥 인생이 쓴 것이라고 한다.]. 소수성의 탄화수소 부분과 친수성의 하이드록시기 부분으로 나뉘어져 있으며, 하이드록시기 때문에 극성을 띤다. 메탄올, 에탄올, 프로판올 등 작은 분자는 하이드록시기가 우세하여 물에 잘 녹지만, 더 큰 알코올 분자들은 탄화수소 부분이 더 우세하여 물에 잘 녹지 않거나 녹는 양이 적다.

알코올 분자들 사이에 수소 결합이 형성될 수 있기 때문에 비슷한 분자량의 탄화 수소에 비해 끓는 점이 높다. 알코올이 산화되면 알데하이드, 카복실산, 케톤 등이 된다. 

대표적인 알코올로는 에탄올(#ce("C2H5OH"))이 있다. 에탄올은 일상에서 가장 쉽게 접하는 알코올로, 에텐(#ce("C2H4"))과 물을 반응시켜 얻는다. 단백질을 응고시키는 성질이 있어 살균, 소독에 사용한다. 또, 술의 성분, 실험실 시약, 용매, 연료로 사용하기도 한다. 알코올의 일반적인 특징을 그대로 가지고 있어 물과 기름 모두에 잘 녹고, 특유의 냄새가 있다. 끓는점은 78#sym.degree\C이다. 

아래는 몇가지 알코올의 종류와 그 용도이다.
- 메탄올(#ce("CH3OH")): 가장 간단한 알코올. 플라스틱의 원료, 연료 전지 등
- 프로판올(#ce("C3H7OH")): 소독제, 산업용 용매 등
- 에틸렌 글리콜(#ce("C2H4 (OH)2")): 자동차 부동액, 폴리에스터 원료 등
- 글리세롤(#ce("C3H5 (OH)3")): 화장품의 원료, 식품 첨가물, 잉크 등

=== 카복실산
작용기로 카복실기#footnote["카르복시기"라고도 한다.] (-COOH)를 가진다. 알코올이나 알데하이드를 산화시켜 얻는다. 탄소 수가 적은 카복실산은 물에 잘 녹고, 물에 녹으면 수소 이온(#ce("H+"))을 내놓아 약한 산성을 띤다. 수소결합을 하기 때문에 비슷한 분자량의 탄화수소에 비해 끓는점이 높다. 

 대표적인 카복실산으로는 아세트산(#ce("CH3COOH"))가 있다. 아세트산은 물에 잘 녹으며, 녹는점은 17#sym.degree\C로, 상온(20#sym.degree\C)에서는 액체 상태이지만 조금만 온도가 낮아지면 얼기 시작하므로 빙초산(氷醋酸)이라고도 한다. 아세트산은 식초의 주 성분이며, 이 외에도 음료, 장기 보관용 재료 염료, 합성수지의 원료 등에 사용한다.

 다른 유명한 카복실산으로는 포름산(HCOOH)가 있다#footnote[개미에서 처음 분리하였기 때문에 "개미산"이라고도 한다.]. 가장 간단한 카복실산이며, 카복실산이자 포밀인 물질이다. 아세트산보다 강한 산성을 띤다. 맹독은 아니지만 독성이 있고, 벌, 개미 등 곤충의 독에 섞여 있다. 또, 가축 사료의 방부제, 가죽의 무두질, 천 염색 마감처리, 응고제 등으로 사용된다. 

=== 알데하이드
알데히드라고도 한다. 알코올에서 수소를 떼었다(DEHYDrated)는 뜻이다. 작용기로 포밀기#footnote["포르밀기"라고도 한다.]\(-CHO)를 가진다. 상온에서 기체이다. 액성은 중성이며, 주로 알코올의 산화 과정에서 부산물로 나온다. 알데하이드를 다시 환원시키면 알코올이 되고, 산화시키면 카복실산이 된다. 산화성이 매우 강력하여 환원제로 많이 쓰인다. 치환기가 없고 단순한 알데하이드는 모두 독성을 가지고 있다.

대표적인 알데하이드로는 포름알데히드(#ce("HCHO"))가 있다#footnote[포름알데히드는 "메탄알(methanal)" 또는 "폼알데히드"라고도 부른다. 실험식으로는 #ce("CH2O")인데, 문제에서는 이렇게도 자주 표기한다.]. 메탄올을 산화시켜 얻으며, 냄새가 자극적이고 물에 잘 녹는다. 물에 녹이면 박제할 때 사용하는 포르말린이 되고, 산화시키면 포름산(HCOOH)이 된다. 플라스틱의 일종인 베이클라이트의 합성, 소독제, 방부제 등에 사용된다. 건축 자재의 방부제에 사용되기 때문에 새집 냄새의 원인이 되며 새집 증후군을 일으키기도 한다.

다른 유명한 알데하이드로는 아세트알데하이드#footnote["에탄알(enthanal)"이라고도 한다.]가 있다. 에탄올을 산화하여 나오고, 이를 다시 산화시키면 아세트산이 된다. 간에서 에탄올이 분해될 때도 나오는데, 이것이 숙취의 원인이 된다. 아세트알데하이드 또한 독성을 가진 발암물질이며, 술이 발암물질인 이유도 이 때문이다.

=== 케톤
사실상 화학I에서는 일반적인 개념을 다루지 않는다. 그 정의부터 복잡하기 때문인데, 단순히 작용기만으로 정의하지 않는다. 케톤이 되려면 카르보닐기와 카르보닐기의 탄소 바로 옆 자리#footnote[이를 #sym.alpha 위치라고 한다.] 양쪽에 탄소 사슬이 있어야 한다. 휘발성과 인화성이 있고, 훌륭한 용매이기도 하다. 독특한 냄새가 나며, 극성과 무극성 용매에 모두 잘 섞인다. 

대표적인 케톤으로는 아세톤(#ce("CH3COCH3"))이 있다. 독특한 냄새가 나고, 물과 잘 섞인다. 휘발성과 인화성이 강하다. 가장 많이 쓰이는 용도는 용매이고, 일상생활에서는 무극성인 매니큐어를 지우는데 사용한다. 

= 화학식량과 몰
== 원자량
원자는 원자핵과 전자로 이루어져 있고, 원자핵은 다시 핵자들인 양성자와 중성자로 이루어져 있다. 양성자와 중성자는 중성자가 아주 조금 더 무겁지만 질량 차이가 거의 없으며, 전자는 이들 질량의 1/1837 정도의 질량을 가진다. 그러므로 원자의 질량을 대략적으로 비교할 때는 전자의 질량을 무시하고 양성자와 중성자의 질량만 고려한다. 핵자의 질량을 각각 1이라고 두었을 때, 핵자 질량의 합을 그 원자의 질량수라고 한다.

탄소 원자 1개의 실제 질량은 대략 $1.99 times 10^(-23)$ g, 수소 원자 1개의 질량은 대략 $1.67 times 10^(24)$ g 라고 한다. 탄소 원자가 질량이 더 큰 것은 알겠지만, 질량이 너무 작아 표기 밑 사용이 불편하고, 배수 관계가 잘 보이지 않는 단점이 있다. 

이러한 단점을 보완하기 위해 원자량을 정의했다. 
#definition(title: "원자량")[
  $attach("C", tl: 12)$의 질량을 12라고 놓았을 때의 질량의 상대량을 원자량이라고 한다. 이때 탄소의 원자량의 1/12를 $m_"u" = 1 "Da"$라고 정의하고, 이것이 원자량 1이다.

  또, 원소 X에 대해 그 원자량은 기호 $A_r ("X")$로 나타낸다.
]

원자량은 상대적인 값이므로 차원도 단위도 없다. 위의 정의에 따라 도출된 원자량 중 몇 가지는 기억해 두자.

#table(
  columns: 11, align: center,
  [원소], [H],[C],[N],[O],[F],ce("Na"),[S],ce("Cl"),ce("Ca"),ce("Cu"),
  [원자량], [1],[12],[14],[16],[19],[23],[32],[35.5],[40],[63.5],
 )

일반적으로 원자 X의 원자번호를 $n$이라고 했을 때 질량수는 아래 식을 만족한다.
$
  A_r ("X") = cases(
    2n &quad "(n이 짝수)",
    2n + 1 &quad "(n이 홀수)"
  )
$
물론 수소, 질소, 염소, 구리 등의 예외가 꽤 존재한다. 

염소, 구리 등의 원자량이 정수로 떨어지지 않는 이유는 바로 평균 원자량 때문이다. 평균 원자량은 자연계에 존재하는 동위 원소의 비율을 고려하여 정한 원자량으로, 동위원소 원자량을 비례배분(즉 내분)하여 구한다. 

== 분자량
#definition(title: "분자량")[
  분자를 이루는 원자들의 원자량의 합을 분자량이라고 하고, 분자의 상대적인 질량을 나타낸다. 
]

== 화학식량
#definition(title: "화학식량")[
  화학식량은 비분자 물질들의 질량도 정하기 위하여, 화학식 한 단위를 이루는 원소들의 원자량의 합을 그 질량으로 정한 것이다. 분자량을 포함하는 개념이다.
]
예를 들어 NaCl의 화학식량은 23 + 35.5 = 58.5이다.

아래는 문제에서 자주 나오는 화학식량들의 표이다. 기억해두면 유용하게 쓸 수 있다.

#table(
  columns: 7, align: center,
  [화학식], ce("NO"), ce("N2O"), ce("NO2"), ce("N2O3"), ce("N2O4"), ce("N2O5"),
  [화학식량], [30], [44], [46], [76], [92], [108] 
 )

 #table(
  columns: 5, align: center,
  [화학식], ce("O2"), ce("SO"), ce("SO2"), ce("SO3"),
  [화학식량], [32], [48], [64], [80] 
 )

#table(
  columns: 6, align: center,
  [화학식], ce("CH4"), ce("CH3, C2H6"), ce("CH2, C2H4, ..."), ce("C3H4, C6H8, ..."), ce("CH, C2H2, ..."),
  [화학식량], [16], [15, 30], [14, 28, ...], [40, 80, ...], [13, 26, ...],
  [질량비], [3:1], [4:1], [6:1], [9:1], [12:1]
 )

 #table(
  columns: 3, align: center,
  [화학식], ce("CO"), ce("CO2"),
  [화학식량], [28], [44], 
  [질량비], [3:4], [3:8], 
 )

 #table(
  columns: 7, align: center,
  [화학식], ce("NH3"), ce("H2O"), ce("NaOH"), ce("C2H5OH"), ce("CH3COOH"), ce("SiO2"),
  [화학식량], [17], [18], [40], [46], [60], [60],
 )

 #table(
  columns: 4, align: center,
  [화학식], ce("CaCl2"), ce("CaCO3"), ce("C6H12O6"),
  [화학식량], [111], [100], [180]
 )

== 몰
몰(mole)은 입자의 개수를 세는 묶음 단위이고, 단위 표기는 mol로 한다. 연필 한 다스가 연필 12개, 마늘 한 접은 마늘 100개를 의미하는 것처럼, 입자 1 mol은 입자가 아보가드로 수 만큼 존재하는 것을 의미한다. 

아보가드로 수는 분자설을 주장한 화학자 아보가드로를 기리는 의미로 이름 붙여졌으며, 입자 1 mol에 들어 있는 입자의 개수이다. 그 값은 $6.02 times 10^(23)$이다#footnote[이는 당연히 대략적인 값이며, 6.02 대신 6.022, 6 에 $10^23$이 곱해진 것으로 나오기도 하니, 문제를 푸는 경우에는 문제에서 제시한 아보가드로 수를 잘 보자.]. 기호로는 $N_"A"$로 표시한다.

이상을 정리하면 아래와 같다.
#definition(title: "몰")[
  몰은 묶음 단위로, 입자 1 mol에 들어 있는 입자의 개수를 아보가드로 수라고 하고, 그 값은 $N_"A" = 6.02 times 10^(23)$이다. 
] <defmol>

과학자들은 원자량을 우리가 실제로 사용하는 질량의 단위인 그램(g)과 연결 짓고 싶었다. 그래서, 원자량 12의 탄소 원자가 12 g 만큼 있다면, 이 만큼의 탄소 원자는 몇 개일까를 알아내고자 하였고, 그 답이 바로 아보가드로 수 였다. 즉, 어떤 입자가 $6.02 times 10^23$개가 있다면, 그 입자의 화학식량에 g을 붙인 것이 그것들의 총 질량이 된다. 이것이 아보가드로 수의 의미이자 mol의 의의이다.

#problem[
  만약 $attach("C", tl:12)$의 원자량을 15라고 했다면 아보가드로 수는 얼마가 될까?\
  (단, $attach("C", tl: 12)$ 12 g에 들어 있는 탄소 원자의 개수는 $6.02 times 10^23$ 개이다.)
]

#solution[
  1 mol의 실질적 정의에 따라 $N_"A" = 15/12 times 6.02 times 10^23$이 된다. 이러한 문제는 실제로 출제되는 경우가 있다. 
]

하지만 몰의 정의는 사실 @defmol 과 같이 바뀌었다. 본래의 정의는 $attach("C", tl: 12)$ 12g 속에 들어 있는 원자의 개수였지만, 현재는 $6.02214076 times 10^23$ 개의 구성 요소를 포함하는 단위로 정의가 바뀐 것이다. 그러므로 새로운 정의에 따르면 위와 같은 문제는 큰 의미가 없다. 답은 그대로 $6.02 times 10^23$이다. 그럼에도 본래 정의가 어떻게 되었는지를 고려하는 관점으로 생각할 수도 있기 때문에, 연습은 해두도록 하자.

분자로 이루어진 물질의 양을 알면, 그 물질을 구성하는 원자의 양 또한 알 수 있다. 예를 들어, 이산화탄소(#ce("CO2")) 분자에는 탄소 원자 1 mol, 산소 원자 2 mol이 들어 있다. 또, 이산탄소 분자 1 mol에 들어 있는 전체 원자 수는 3 mol이 된다. 

이온 결합 물질에서도 마찬가지이다. 이온 결합 물질의 양을 알면 그 물질을 구성하는 이온의 양을 알 수 있다. 예를 들어, 염화 나트륨(#ce("NaCl")) 1 mol에는 나트륨 이온(#ce("Na+")) 1 mol, 염화 이온(#ce("Cl-")) 1 mol, 총 2 mol의 이온이 들어 있다.

#exercise()[
  다음의 입자 수를 구하시오. ($N_"A" = 6.02 times 10^23$)
  1. 수소(#ce("H2")) 기체 1 mol의 H 원자 수
  2. 메테인(#ce("CH4")) 2 mol의 전체 원자 수
  3. 염화 칼슘(#ce("CaCl2")) 3 mol의 염화 이온 수
]

#definition(title: "몰 질량")[
  입자 1 mol의 질량을 몰 질량이라고 한다. 단위는 g/mol 이다. 표기는 $M$으로 한다.
]

#example[
  분자량이 18인 물(#ce("H2O")) 분자 1 mol의 질량은 18 g이고, 몰 질량은 18 g/mol이다. 
]

#problem[
  물(#ce("H2O")) 분자 54g의 분자 수를 구하시오.
]

#solution[
  물 분자 1 mol의 질량은 18 g이므로, 54 g의 물 분자는 3 mol이다.
]

이를 정리하면 다음과 같다.

#theorem(title: "질량과 분자의 양")[
  $
  n("물질의 양") = m("질량") / M("몰 질량")
  $
]

이제 아래 화학 반응식을 보자.
$
  #ce("N2 + 3H2 -> 2NH3")
$

이 반응식의 계수비는 질소 분자: 수소 분자: 암모니아 분자의 비율이 1:3:2이다. 여기서 각 항의 계수비는 분자의 개수비와 같고, 기체인 경우 부피비와도 같다. 하지만 질량비는 바로 계수비로 바로 알 수 없다.

그렇다면 질소 기체 1 mol이 완전히 반응하려면 수소 기체가 몇 mol이 필요할까? 반응식에 따라 3 mol이다. 분자의 개수로 표현해도 되는데 왜 굳이 mol로 표현할까? 그 이유는 질량의 표현 때문이다. 질소 분자 1 mol의 질량은 28g, 수소 기체 3 mol의 질량은 6g이다. 그러므로 반응물의 질량비는 질소:수소가 14:3이다. 

#problem[
  질소 분자 14g이 완전히 반응하면 암모니아는 몇 g이 만들어지는가?
]
#solution[
  질소 분자의 몰 질량이 28g 이므로 질소 분자는 0.5 mol이 있다. 질소 분자 : 암모니아 분자의 계수비가 1:2 이므로 암모니아는 1 mol이 만들어지고, 이 질량은 17 g이다.
]
 
이처럼 계수비를 통해 간단한 계산을 통해 질량비를 구할 수 있다는 것이 몰의 또 다른 의의이다. 이러한 이유 때문에 몰을 통햏 양적 관계를 해석하는 것이다.

== 아보가드로 법칙
#theorem(title: "아보가드로 법칙")[
  모든 기체는 온도와 압력이 일정할 때, 기체의 종류와 관계 없이 같은 부피에 같은 수의 분자가 들어 있다.
]
#theorem(title: "몰 부피")[
  0#sym.degree\C, 1 atm(기압)에서 1 mol의 기체는 22.4 L의 부피를 차지한다. 이처럼 특정 조건에서 기체 1 mol의 부피를 몰 부피라고 하고, $V_"m"$ 또는 $tilde(V)$로 표기한다.  
]

즉, 부피가 입자의 양과 비례하므로, 질량과 마찬가지로 부피로 기체 분자의 양을 구할 수 있다. 

#problem[
  20#sym.degree\C, 1 atm에서 기체 1 mol의 부피가 24L일 때, 20#sym.degree\C에서 메테인(#ce("CH4")) 기체 12L에 포함된 분자의 양을 구하시오.
]

#solution[
  1 mol의 메테인 기체는 24 L이므로, 12L의 메테인 기체는 12/24 = 0.5 mol이다.
]

이를 정리하면 다음과 같다.

#theorem(title: "기체의 부피와 분자량")[
  $
    n("기체의 양") = V("부피") / V_"m"("몰 부피")
  $
]

#problem[
  0#sym.degree\C, 1 atm에서 몰 부피가 22.4L일 때, 0#sym.degree\C, 2 atm에서 몰 부피를 구하시오.
]

#solution[
  부피는 압력에 반비례하므로, 2 atm에서의 몰 부피는 22.4/2 = 11.2 L이다.
]

#theorem(title: "물질의 양과 입자 수, 질량, 기체의 부피 간 관계")[
  1. 물질의 양은 입자 수와 비례한다.
  2. 물질의 양은 질량과 비례한다.
  3. 물질의 양은 기체의 부피와 비례한다.
  $
    n ["mol"] = a/N_"A" = m["g"]/M["g/mol"] = V["L"]/(V_"m"["L/mol"]) med "(기체일 때만 성립)"
  $
]

#problem[다음을 식으로 표현하시오.
  1. 메테인(#ce("CH4")) 분자 a g의 개수
  2. 암모니아(#ce("NH3")) 분자 b L의 질량
  3. 이산화탄소(#ce("CO2")) 분자 c 개의 부피
]

#solution[
  1. a g의 양은 $a/16$ mol이다. 그러므로 개수는 $a/16 times N_"A"$가 된다.

  2. b L의 양은 $b/(V_"m")$이다. 그러므로 질량은 $(17b)/(V_"m")$이다.

  3. c 개의 양은 $c/N_"A"$이다. 그러므로 부피는 $(V_"m" c)/N_"A"$이다.
]

#problem[
  0#sym.degree\C, 1 atm에서 메테인(#ce("CH4"))에 들어 있는 수소 원자가 8 g 있을 때, 메테인 분자의 총 부피를 구하시오.
]

#solution[
  수소 원자 1 mol의 질량은 1 g이므로, 수소 원자는 8 mol 았다. 메테인 분자에는 수소 원자 4개가 들어 있으므로, 메테인 분자는 2 mol이 있다. 따라서 메테인 분자의 총 부피는 $2 times 22.4 = 44.8$ L이다.
]

== 추가적인 지식, 기술
여기 있는 항목들은 화학I 정식 교육과정에서는 소개하지 않는 내용이다. 하지만 추가적인 지식을 얻거나 문제를 푸는데 유용하므로 알아두면 좋다.

=== 이상 기체 상태 방정식
#theorem(title: "이상 기체 상태 방정식")[
  이상 기체(ideal gas)란 실제로는 존재하지 않는 이론상의 기체로, 기체 상태 방정식과 법칙들을 완벽하게 따르는 기체이다#footnote[이상 기체의 자세한 정의는 여기서 다루지 않는다.]. 이러한 이상 기체는 아래의 방정식을 만족한다. 
  $
    p V = n R T
  $
  이 때, $p$는 압력, $V$는 부피, $n$은 물질의 양, $R$은 기체 상수, $T$는 온도이다.
]

이상 기체 상태 방정식에서 먼저 다음을 알 수 있다.
$
  n prop V
$

방정식을 좀 더 전개해 보자.
$
  p V = m/M R T, quad p M = m/V R T = rho R T
$

화학I이 다루는 범위에서는 온도와 압력이 일정하므로, 이들까지 상수로 취급하고 상수를 무시하면 다음과 같다.

$
  M prop m/V = rho
$

=== 기체의 밀도

#problem[
  20#sym.degree\C, 1 atm에서 산소(#ce("O2")) 기체의 밀도가 $4/3$ g/L일 때, 메테인(#ce("CH4")) 기체의 밀도를 구하시오.
]

#solution[
  밀도는 단위 부피당 질량이고, 같은 온도와 압력 조건에서 같은 부피의 기체에 포함된 분자 수가 같으므로 기체의 밀도는 분자량에 비례한다. 따라서 메테인 기체의 밀도는 $4/3 times 16/32 = 2/3$ g/L이다.
]

#problem[

]

#theorem(title: "기체의 밀도")[
  1. 밀도란 단위 부피 당 질량이다.
  $
    rho = m/V, quad m = rho V
  $
  2. 기체의 밀도는 분자량에 비례한다.
  $
    rho = m/V prop M
  $

  3. 두 분자 A, B에 대하여 다음이 성립한다.
  $
    M_"A"/M_"B" = rho_"A"/rho_"B"
  $
  또, 두 기체가 같은 부피가 있다면 
]



=== 단위 질량 당 분자 수
#problem[
  1 g의 메테인(#ce("CH4"))과 1 g의 이산화탄소(#ce("CO2"))에 포함된 분자 수 비를 구하시오.
]

#solution[
  1 g에 포함된 분자의 양의 단위는 mol/g 이 된다. 이는 몰 질량, 또는 분자량의 역수가 되는 값이다. 그러므로, 1 g의 메테인에 포함된 분자는 1/16 mol, 1 g의 이산화탄소에 포함된 분자는 1/44 mol이다. 따라서 답은 아래와 같다.
  $
    #ce("CH4 : CO2") = 1/16 : 1/44 = 11 : 4
  $
]

#remark(title: "단위 질량 당 분자 수")[
  단위 질량 당 분자 수의 단위는 mol/g으로, 몰 질량 g/mol, 즉 분자량의 역수가 된다. 
]















