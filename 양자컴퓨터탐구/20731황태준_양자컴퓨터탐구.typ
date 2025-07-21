#import "@preview/physica:0.9.5": *
#import "@preview/ilm_custom:1.4.1": *
#import "@preview/alchemist:0.1.4": *
#import "@preview/theorion:0.3.3": *
#import "@preview/rich-counters:0.2.1": *
#import "@preview/cetz:0.3.4"
#import "@preview/cetz-plot:0.1.1"
#import cosmos.rainbow: *

// 표지
#let title = [양자컴퓨터 개론 탐구]

#show: ilm.with(
  title: title,
  author: "20731 황태준",
  date: datetime(year: 2025, month: 05, day: 30),
  abstract: [2025학년도 2학년 1학기 진로 포트폴리오],
  // preface: align(center + horizon)[
  //   = Preface
  //   #lorem(100)
  // ],
  //bibliography: bibliography(""),
  figure-index: (enabled: false),
  table-index: (enabled: false),
  listing-index: (enabled: false),
)

#set text(
  font: (
    // "Source Han Serif K", // 가장 우선순위 폰트
    (
      name: "STIX Two Text", // 라틴 폰트
      covers: "latin-in-cjk",
    ),
    (
      name: "LXGW WenKai",
      covers: regex("[\p{scx:Han}\p{scx:Hira}\p{scx:Kana}]"),
    ), // 한자, 히라가나, 가타가나
    "Source Han Serif", // CJK fallback 폰트
  ),
  cjk-latin-spacing: none,
)
#show math.equation: set text(
  font: (
    (
      name: "STIX Two Math",
      covers: "latin-in-cjk",
    ),
    "KoPubBatang",
  ),
  cjk-latin-spacing: none,
  weight: "regular",
)

#show heading.where(level: 1): it => {
  counter(math.equation).update(0)
  it
}

#set math.equation(
  numbering: n => {
    numbering("(1.1)", counter(heading).get().first(), n)
    // if you want change the number of number of displayed
    // section numbers, modify it this way:
    /*
    let count = counter(heading).get()
    let h1 = count.first()
    let h2 = count.at(1, default: 0)
    numbering("(1.1.1)", h1, h2, n)
    */
  },
)

#set figure(
  numbering: n => {
    numbering("1.1", counter(heading).get().first(), n)
    // if you want change the number of number of displayed
    // section numbers, modify it this way:
    /*
    let count = counter(heading).get()
    let h1 = count.first()
    let h2 = count.at(1, default: 0)
    numbering("(1.1.1)", h1, h2, n)
    */
  },
)

#set math.equation(supplement: [식])
#set outline()
#show raw: set text(font: ("JetBrains Mono", "Source Han Sans K"))
#set page(
  paper: "a4",
  margin: 3.5cm,
  header: align(right, title),
  numbering: "1",
)

#show: show-theorion
#set math.mat(delim: "[")

#let notag(content) = {
  math.equation(
    block: true,
    numbering: none,
    content,
  )
}

#let scr(it) = text(
  features: ("ss01",),
  box($cal(it)$),
)

// 컴포넌트

#let template = doc => {
  import "@preview/physica:0.9.5": *
  import "@preview/ilm_custom:1.4.1": *
  import "@preview/alchemist:0.1.4": *
  import "@preview/rich-counters:0.2.1": *
  import "@preview/cetz:0.3.4": *
  import "@preview/cetz-plot:0.1.1": *

  set math.mat(delim: "[")

  show heading.where(level: 1): it => {
    counter(math.equation).update(0)
    it
  }

  set math.equation(
    numbering: n => {
      numbering("(1.1)", counter(heading).get().first(), n)
      // if you want change the number of number of displayed
      // section numbers, modify it this way:
      /*
      let count = counter(heading).get()
      let h1 = count.first()
      let h2 = count.at(1, default: 0)
      numbering("(1.1.1)", h1, h2, n)
      */
    },
  )

  let scr(it) = text(
    features: ("ss01",),
    box($cal(it)$),
  )

  set math.equation(supplement: [식])

  doc
}

// 본문
= 고전 정보
양자역학 이전에는, ($F=m a$로 대표되는) 고전적인 물리 법칙이 "확정"적으로 기술되었고, 그것이 상식이었다. 인간적인 상식에 따라 정보 또한 당연히 확정적으로 표현되었다.

전형적인 고전 정보를 취하는 계(系, system)의 예시는, 고전적인 "상태"(state)인 0과 1로 이루어진 컴퓨터의 비트(bit, binary digit)이다. 다른 예시로는 여섯 면을 가진 주사위가 있다. 주사위가 가진 고전적인 상태는, 윗면의 숫자에 대응시킨다고 했을 때, 1, 2, 3, 4, 5, 6이다. DNA의 염기서열은 A, T, C, G를 가지고, 선풍기 풍량은 끔, 미풍, 약풍, 강풍 등의 상태를 가지게 된다.

이때, 이러한 계를 $X$라고 하고, 이 계가 가질 수 있는 상태의 집합을 $Sigma$라고 하자. 우리는 이렇게 놓음으로써 $Sigma$는 유한집합이고, 공집합이 아니라고 정하게 된다. 이것을 간단히 수식으로 표현하면
$
  X in Sigma wide "s.t. " Sigma != emptyset and abs(Sigma) != oo
$

몇 가지 예시는 다음과 같다.
- $X$가 비트라면, $Sigma = {0, 1}$
- $X$가 주사위라면, $Sigma = {1, 2, 3, 4, 5, 6}$
- $X$가 뉴클레오타이드라면, $Sigma = {"A", "T", "C", "G"}$
- $X$가 선풍기라면, $Sigma = {"끔", "미풍", "약풍", "강풍"}$

이처럼, 계 $X$의 상태 집합 $Sigma$의 원소들은 특정 의미를 갖는 문자에 대응되어 정보를 효율적으로 기술한다. 예를 들어 우리가 선풍기를 조작하고 있다고 생각해 보자. 이 상황에서는 상태가 무엇인지 바로 알 수 있다. 바람이 너무 세다고 느끼는 것은 선풍기를 코앞에서 강풍으로 틀어놨기 때문일 것이다. 우리는 선풍기가 강풍으로 되어 있음을 확인할 수 있고, 임의로 미풍으로 바꿀 수 있다. 하지만 모든 정보가 이렇게 확정적으로 처리될 수는 없다(물론 선풍기도, 풍량을 확인하기 전에는 무슨 풍량으로 되어 있는지 알 수 없기도 하다).

주사위를 던진다고 생각해 보자. 주사위가 구르다가 멈추기 전에는 주사위가 어떤 상태를 가질지 알 수가 없다. 사실, 대부분의(또는 모든) 정보가 이러한 성질을 갖는데, 우리는 이것을 확률로 표현한다. 일반적인 경우 주사위가 상태 2를 가질 확률은 아래와 같이 표현한다.
$
  P(X=2)=1/6
$

각 상태가 점유하는 확률을 모두 표현해 보면
$
  P(X=1)=1/6 \
  P(X=2)=1/6 \
  P(X=3)=1/6 \
  P(X=4)=1/6 \
  P(X=5)=1/6 \
  P(X=6)=1/6
$

또는 이것을 간단하게 행 벡터로 나타낸다.
$
  mat(1/6; 1/6; 1/6; 1/6; 1/6; 1/6)
$

