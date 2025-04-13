#import "@preview/physica:0.9.4": *
#import "@preview/ilm_custom:1.4.1": *
#import "@preview/alchemist:0.1.4": *
#import "@preview/theorion:0.3.2": *
#import "@preview/rich-counters:0.2.1": *
#import "@preview/cetz:0.3.4": *
#import "@preview/cetz-plot:0.1.1": *

#import cosmos.rainbow: *

// 표지
#let title = [15 수학 I/22 대수]

#show: ilm.with(
  title: title,
  author: "Taejoon Whang, Dongwoo Nam",
  date: datetime(year: 2025, month: 03, day: 06),
  abstract: [#lorem(30)],
  preface: align(center + horizon)[
    = 이 과목의 요지
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
#set math.equation(numbering: "(1.1)", supplement: [식. ])
#set outline()
#show raw: set text(font: ("JetBrains Mono", "D2Coding"))
#set page(
  paper: "a4",
  margin: 3.5cm,
  header: align(right, title),
  numbering: "1",
)
#set math.equation(numbering: none)

#let tag(content) = {
  math.equation(
    block: true, 
    numbering: "(1.1)", supplement: [식. ],
    content
  )
}

// 컴포넌트

#show: show-theorion

// #show: great-theorems-init

// #let mathcounter = rich-counter(
//   identifier: "mathblocks",
//   inherited_levels: 1
// )

// #let theorem = mathblock(
//   blocktitle: "Theorem",
//   counter: mathcounter,
// )

// #let lemma = mathblock(
//   blocktitle: "Lemma",
//   counter: mathcounter,
// )

// #let corollary = mathblock(
//   blocktitle: "Corollary",
//   counter: mathcounter,
// )

// #let definition = mathblock(
//   blocktitle: "Definition",
//   counter: mathcounter,
// )

// #let remark = mathblock(
//   blocktitle: "Remark",
//   prefix: [_Remark._],
//   inset: 5pt,
//   radius: 5pt,
// )

// #let proof = proofblock()

#set math.mat(delim: "[")

// 본문
= 지수

== 쌍곡함수

여러 문제에서 아래 꼴의 식의 값을 구하라고 하였을 것이다.

$
  a^x+a^(-x) \
  a^x-a^(-x) \
  (a^x-a^(-x))/(a^x+a^(-x)) \
  a^x / (a^x + 1)
$

이 외에도 어떤 밑의 $x$ 제곱으로 된 수많은 꼴을 보았을텐데, 이것의 정체는 바로 쌍곡함수(hyperbolic function)이다. 모든 지수함수는 아래와 같이 나타낼 수 있기 때문이다.
$
  a^x = e^(x ln a) <==> a^x = exp (x ln a)
$

쌍곡함수는 정식 고등학교 교육과정에는 포함되어 있지 않는 내용이다. 하지만 수학 I/대수에서 자주 출제하는 이유는 그정도의 의미를 가지고 있기 때문일 것이다. 종종 써먹기 위해 그 일부를 좀 알아보자.

이들의 기본 정의는 다음과 같다.

#definition(title: "쌍곡함수의 정의")[
  쌍곡함수는 아래와 같이 정의된다.
  $
    sinh x equiv e^x - e^(-x) \
    cosh x equiv e^x + e^(-x) \
    tanh x equiv (sinh x)/(cosh x) = (e^x - e^(-x))/(e^x + e^(-x)) \
    sech x = 1/cosh x \
    csch x = 1/sinh x \
    coth x = 1/tanh x
  $
]

생김새와 특성이 삼각함수와 비슷하다는 것을 눈치챘을 것이다. 삼각함수와의 관련성은 간단하다. 삼각함수가 $x^2 + y^2 = 1$의 원 상에서 정의된다면, 쌍곡함수는 $x^2 - y^2 = 1$ 상의 쌍곡선에서 정의된다. 길이 관계는 비슷하며, 또 아래와 같은 관계도 성립한다.

$
  sinh x = sin i x \
  cosh x = cos i x \
  (dots)
$

이 증명은 $e^(i x) = cos x + i sin x$의 대입을 통해 간단히 된다.

어쨌든, 우리가 이걸 알아서 어디다 써먹을 수 있는지 알아보자.

=== 쌍곡함수의 그래프

우리가 알고 써먹을 수 있는 그래프는 세 가지밖에 없다. $sinh x, cosh x, tanh x$의 그래프이다.

#cetz.canvas({
  import cetz.draw: *

  plot.plot(axis-style: "school-book", x-tick-step: none, y-tick-step:none, size: (5, 5),

  legend: "north-west",
  {
    let domain = (-5, 5)
    plot.add(calc.sinh, domain: domain, label: $ sinh x  $,
      style: (stroke: green))
    plot.add(calc.cosh, domain: domain, label: $ sinh x  $,
      style: (stroke: red))
    plot.add(calc.tanh, domain: domain, label: $ sinh x  $,
      style: (stroke: blue))
  })
})
= 로그

= 지수함수

= 로그함수

= 삼각함수

= 삼각함수의 활용

= 등차수열

= 등비수열

= 수열의 합

= 수학적 귀납법

목차 글꼴이 깨지는 이유는 알 수 없네요