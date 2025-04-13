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
  & a^x+a^(-x) \
  & a^x-a^(-x) \
  & (a^x-a^(-x))/(a^x+a^(-x)) \
  & a^x / (a^x + 1)
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
    & sinh x equiv e^x - e^(-x) \
    & cosh x equiv e^x + e^(-x) \
    & tanh x equiv (sinh x)/(cosh x) = (e^x - e^(-x))/(e^x + e^(-x)) \
    & sech x = 1/cosh x \
    & csch x = 1/sinh x \
    & coth x = 1/tanh x
  $
]

생김새와 특성이 삼각함수와 비슷하다는 것을 눈치챘을 것이다. 삼각함수와의 관련성은 간단하다. 삼각함수가 $x^2 + y^2 = 1$의 원 상에서 정의된다면, 쌍곡함수는 $x^2 - y^2 = 1$ 상의 쌍곡선에서 정의된다. 길이 관계는 비슷하며, 또 아래와 같은 관계도 성립한다.

$
  & sinh x = sin i x \
  & cosh x = cos i x \
  & tanh x = tan i x 
$

이 증명은 $e^(i x) = cos x + i sin x$의 대입을 통해 간단히 된다.

어쨌든, 우리가 이걸 알아서 어디다 써먹을 수 있는지 알아보자.

=== 쌍곡함수의 그래프

우리가 알고 써먹을 수 있는 그래프는 세 가지밖에 없다. $sinh x, cosh x, tanh x$의 그래프이다.

#canvas({
  import cetz.draw: *
  
  draw.set-style(
    axes: (
      y: (label: (anchor: "north-west", offset: -0.2), mark: (end: "stealth", fill: black)),
      x: (label: (anchor: "north", offset: 0.1), mark: (end: "stealth", fill: black)),
    ),
  )
  plot.plot(
    size: (13, 14),
    x-label: $x$,
    y-label: $y$,
    y-tick-step: none,
    x-tick-step: none,
    // x-grid: true,
    // y-grid: true,
    legend: "inner-south-east",
    legend-style: (stroke: .5pt),
    axis-style: "school-book",
    {
      // sinh x
      plot.add(
        style: (stroke: red + 1.5pt),
        domain: (-2, 2), // avoid x=0 since ln(0) is undefined
        samples: 100,
        label: $y = sinh x$,
        x => calc.sinh(x),
        
      )

      plot.annotate({
        content((0.05,1.1), [1], anchor: "north-east", padding: 0)
      })
      
      // cosh x
      plot.add(
        style: (stroke: purple + 1.5pt),
        domain: (-2, 2), // avoid x=0 since ln(0) is undefined
        samples: 100,
        label: $y = cosh x$,
        x => calc.cosh(x),
      )

      // tanh x
      plot.add(
        style: (stroke: blue + 1.5pt),
        domain: (-2, 2),
        label: $y = tanh x$,
        x => calc.tanh(x),
      )

      // special exp func
      plot.add(
        style: (stroke: green + 1.5pt),
        domain: (-2, 2),
        label: $y = e^x \/ (e^x + 1)$,
        x => calc.exp(x) / (calc.exp(x) + 1),
      ) 

      plot.annotate({
        content((0.05,0.4), [$1/2$], anchor: "north-east", padding: 0)
      })
    },
  )
})

조금만 생각해 보면 알 수 있지만, $cosh x$의 그래프는 $e^x$와 $e^(-x)$ 그래프의 평균으로서 (0,1)을 지난다. $sinh x$와 $tanh x$는 원점 대칭이다.

그런데 특별한 함수가 하나 있다. 바로 $e^x \/ (e^x + 1)$이다. 이 함수는 $tanh x$를 적절히 조작하고 평행이동하여 만들 수 있는 점대칭 함수로, (0, 1/2)에 대칭이다. 다른 함수들의 증가율에 가려 직선처럼 보이지만, $tanh x$와 개형이 비슷한 곡선이다. 종종 함수 값들의 합을 점대칭 함수의 성질을 이용하여 빠르게 구할 수 있는 형태로 출제된다.

재미로 $sech x, csch x, coth x$의 그래프도 보자.
#grid(
  columns: 2,
  rows: 1,

  canvas({
  import cetz.draw: *
  
  draw.set-style(
    axes: (
      y: (label: (anchor: "north-west", offset: -0.2), mark: (end: "stealth", fill: black)),
      x: (label: (anchor: "north", offset: 0.1), mark: (end: "stealth", fill: black)),
    ),
  )
  plot.plot(
    size: (5, 5),
    x-label: $x$,
    y-label: $y$,
    y-tick-step: none,
    x-tick-step: none,
    // x-grid: true,
    // y-grid: true,
    legend: "inner-south-east",
    legend-style: (stroke: .5pt),
    axis-style: "school-book",
    {
      // sec x
      plot.add(
        style: (stroke: red + 1.5pt),
        domain: (-2, 2), // avoid x=0 since ln(0) is undefined
        samples: 100,
        label: $y = sech x$,
        x => 1/calc.cosh(x),
        
      )

      plot.annotate({
        content((0,1), [1], anchor: "north-east", padding: 0)
      })
    },
  )
}),

canvas({
  import cetz.draw: *
  
  draw.set-style(
    axes: (
      y: (label: (anchor: "north-west", offset: -0.2), mark: (end: "stealth", fill: black)),
      x: (label: (anchor: "north", offset: 0.1), mark: (end: "stealth", fill: black)),
    ),
  )
  plot.plot(
    size: (5, 5),
    x-label: $x$,
    y-label: $y$,
    y-tick-step: none,
    x-tick-step: none,
    // x-grid: true,
    // y-grid: true,
    legend: "inner-south-east",
    legend-style: (stroke: .5pt),
    axis-style: "school-book",
    {
      // csch x
      plot.add(
        style: (stroke: blue + 1.5pt),
        domain: (-2, 2), // avoid x=0 since ln(0) is undefined
        samples: 100,
        label: $y = csch x$,
        x => 1/calc.sinh(x),
        
      )
      
      plot.add(
        style: (stroke: purple + 1.5pt),
        domain: (-2, 2), // avoid x=0 since ln(0) is undefined
        samples: 100,
        label: $y = coth x$,
        x => 1/calc.tanh(x),
        
      )
    },
  )
})
)

역수 쌍곡함수들은 별로 의미도 없다. $sech x$는 종 모양이고, $csch x$와 $coth x$는 비슷한 개형으로 발산한다.

=== 쌍곡함수 문제 풀이 방법
앞서, 쌍곡함수 문제 풀이의 기본은 여전히 이차방정식이다. 쌍곡함수는 복잡한 연산으로 정의되기 때문에 문제 풀이 상황에서 특정 함숫값을 직관적으로 알아낼 수 없다. 아래 문제를 보자.

#problem[
  $2^x + 2^(-x) = 3$일 때, $x$의 값을 구하라.
]

이 문제를 $2 cosh (x ln 2) = 3$과 같이 푸는 것은 헛수고다. 가장 좋은 방법은 양변에 $2^x$를 곱한 후 $2^x$에 대한 이차방정식을 푸는 것이다.

$
  & 2^(2x) -3 dot 2^x + 1 = 0 <==> 2^x = (3 plus.minus sqrt(5))/(2) \
  & therefore x = log_2(3 plus.minus sqrt(5))/(2)
$

주의할 점은 $cosh x$는 우함수이므로, 두 근의 합은 무조건 0이고, 최솟값은 1이므로 1 이하의 값을 갖도록 하는 실근은 존재하지 않는다. 문제 상황에서 이것이 유리하게 작용할 수도, 불리하게 작용할 수도 있다.

=== 쌍곡함수 항등식

하지만 특정 상황에서는 잘 알려진 쌍곡함수 항등식을 이용해 문제를 빨리 풀어낼 수 있다. 아래 공식은 어차피 삼각함수에도 비슷하게 적용되니 암기해 두자. 

==== 정의에 따른 항등식
$
  cosh^2 x - sinh^2 x = 1
$

=== 쌍곡함수 합의 공식

$
  & sinh (x plus.minus y) = sinh x cosh y plus.minus cosh x sinh y \
  & cosh (x plus.minus y) = cosh x cosh y plus.minus sinh x sinh y \
  & tanh (x plus.minus y) = (tanh x plus.minus tanh y)/(1 plus.minus tanh x tanh y) \
$

==== 배각 공식

$
  & sinh (2x) = 2 sinh x cosh x \
  & cosh (2x) = cosh^2 x + sinh^2 x = 2 cosh^2 x - 1 = 1 + 2 sinh^2 x \
  & wide wide = (1 + tanh^2 x)/(1 - tanh^2 x) \
  & tanh (2x) = (2 tanh x)/(1 + tanh^2 x) \
  \
  & sinh (3x) = 3 sinh x + 4 sinh^3 x \
  & cosh (3x) = 4 cosh^3 x - 3 cosh x \
  \
  & sinh (4x) = 8 sinh^3 x cosh x + 4 sinh x cosh x \
  & cosh (4x) = 8 cosh^4 x - 8 cosh^2 x + 1 \
$

=== 기타 항등식
$
  & sinh ln a = (a^2 - 1)/(2a) \
  & cosh ln a = (a^2 + 1)/(2a) \
  & tanh ln a = (a^2 -1)/(a^2 + 1) \
$

유용한 것만 모았으나, 과한 부분도 있으니 모두 암기하지는 않아도 된다. 어차피 쌍곡함수의 출제 빈도는 그렇게 높은 편은 아니다. 공식을 모른다면, 항상 이차방정식을 주저 없이 사용하도록 한다.

#exercise[
  정의에 따른 항등식을 통해 합의 공식과 2배각 공식을 유도해 보자.
]

#problem[
  $f(x) = (a^x + a^(-x))/(a^x - a^(-x))$이고, $f(alpha)=2, f(beta)=3$일 때, $f(alpha + beta)$의 값은?\
  (단, $a > 0$)
]

#solution[
  이는 실제로 모 수I 문제집에 있는 문제이다. 본래라면 $f(x)$의 분모와 분자에 $a^x$를 곱한 후 대입해야 하지만, 이는 사실 $tanh$의 합의 공식을 대놓고 묻고 있는 문제이다.

  $f(x)=coth(x ln a) = 1\/(tanh(x ln a))$ 이므로 $tanh$ 합의 공식을 역수 취해서 사용하면 $(2 times 3 + 1) / (2 + 3) = 7/5$ 로 너무 쉽게 풀린다. 당연하게도 $tanh$ 합의 공식을 알면 $coth$ 합의 공식은 알 필요가 없는 것이다.
]

#problem[
  $(3^x - 3^(-x))/(3^x + 3^(-x)) = 1/11$일 때, $9^x + 9^(-x)$의 값을 구하여라.
]

#solution[
  이는 아래와 같이 재해석할 수 있다.

  $tanh (x ln a) = 1/11$일 때, $cosh (2x ln a)$의 값을 구하여라.

  그렇다면 이 문제는 특수한 2배각 공식을 활용하여 쉽게 해결된다. \
  $2cosh x = 2 dot (1 + (1\/11)^2 )\/(1-(1\/11)^2)=61\/30$
]

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