#import "@preview/bubble_custom:0.2.2": *
#import "@preview/physica:0.9.5": *
#import "@preview/alchemist:0.1.4": *
#import "@preview/theorion:0.3.3": *
#import "@preview/rich-counters:0.2.1": *
#import "@preview/cetz:0.3.4"
#import "@preview/cetz-plot:0.1.1"
#import cosmos.rainbow: *


#show: bubble.with(
  title: [양자컴퓨터의\ 수학적 기초 탐구],
  subtitle: "",
  author: "황태준",
  affiliation: "중앙고등학교",
  date: datetime.today().display(),
  year: "2025",
  class: "20731",
  other: none,
  // logo: image("logo.png"),
  color-words: ("important",),
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
    "Source Han Serif K", // CJK fallback 폰트
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
  stylistic-set: (2, 3, 4),
)

#show heading.where(level: 1): it => {
  counter(math.equation).update(0)
  it
}

#set math.equation(numbering: n => {
  numbering("(1.1)", counter(heading).get().first(), n)
  // if you want change the number of number of displayed
  // section numbers, modify it this way:
  /*
  let count = counter(heading).get()
  let h1 = count.first()
  let h2 = count.at(1, default: 0)
  numbering("(1.1.1)", h1, h2, n)
  */
})

#set figure(numbering: n => {
  numbering("1.1", counter(heading).get().first(), n)
  // if you want change the number of number of displayed
  // section numbers, modify it this way:
  /*
  let count = counter(heading).get()
  let h1 = count.first()
  let h2 = count.at(1, default: 0)
  numbering("(1.1.1)", h1, h2, n)
  */
})

#set math.equation(supplement: [식])
#set outline()
#show raw: set text(font: ("JetBrains Mono", "Source Han Sans K"))
#set page(
  paper: "a4",
  margin: 3.5cm,
  header: align(right, "양자컴퓨터 개론"),
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

#let cal(it) = math.class("normal", context {
  show math.equation: set text(font: "Garamond-Math", stylistic-set: 3)

  let scaling = 100% * (1em.to-absolute() / text.size)
  let wrapper = if scaling < 60% { math.sscript } else if scaling < 100% { math.script } else { it => it }

  box(text(top-edge: "bounds", $wrapper(math.cal(it))$))
})

#let scr(it) = math.class("normal", context {
  show math.equation: set text(font: "Garamond-Math", stylistic-set: 1)

  let scaling = 100% * (1em.to-absolute() / text.size)
  let wrapper = if scaling < 60% { math.sscript } else if scaling < 100% { math.script } else { it => it }

  box(text(top-edge: "bounds", $wrapper(math.cal(it))$))
})

#show math.equation: it => {
  let bb-font = "New Computer Modern Math"
  show regex(
    "𝔸|𝔹|ℂ|𝔻|𝔼|𝔽|𝔾|ℍ|𝕀|𝕁|𝕂|𝕃|𝕄|ℕ|𝕆|ℙ|ℚ|ℝ|𝕊|𝕋|𝕌|𝕍|𝕎|𝕏|𝕐|ℤ|𝕒|𝕓|𝕔|𝕕|𝕖|𝕗|𝕘|𝕙|𝕚|𝕛|𝕜|𝕝|𝕞|𝕠|𝕡|𝕢|𝕣|𝕤|𝕥|𝕦|𝕧|𝕨|𝕩|𝕪|𝕫",
  ): set text(font: bb-font)
  it
}

#outline()
#pagebreak()

#let sX = $sans(upright(X))$
#let sY = $sans(upright(Y))$

친구 몇 명이 보여달라고 해서 설명문 형식이 될 수도 있음을 양해 부탁드립니다.

// 본문
= 고전 정보
양자역학 이전에는, ($F=m a$로 대표되는) 고전적인 물리 법칙이 "확정"적으로 기술되었고, 그것이 상식이었다. 인간적인 상식에 따라 정보 또한 당연히 확정적으로 표현되었다.

== 고전 정보와 확률벡터

전형적인 고전 정보를 취하는 계(系, system)의 예시는, 고전적인 "상태"(state)인 0과 1로 이루어진 컴퓨터의 비트(bit, binary digit)이다. 다른 예시로는 여섯 면을 가진 주사위가 있다. 주사위가 가진 고전적인 상태는, 윗면의 숫자에 대응시킨다고 했을 때, 1, 2, 3, 4, 5, 6이다. DNA의 염기서열은 A, T, C, G를 가지고, 선풍기 풍량은 끔, 미풍, 약풍, 강풍 등의 상태를 가지게 된다.

이때, 이러한 계를 $sX$라고 하고, 이 계가 가질 수 있는 상태의 집합을 $Sigma$라고 하자. 우리는 이렇게 놓음으로써 $Sigma$는 유한집합이고, 공집합이 아니라고 정하게 된다. 이것을 간단히 수식으로 표현하면
$
  X in Sigma wide "s.t. " Sigma != emptyset and abs(Sigma) != oo
$

몇 가지 예시는 다음과 같다.
- $sX$가 비트라면, $Sigma = {0, 1}$
- $sX$가 주사위라면, $Sigma = {1, 2, 3, 4, 5, 6}$
- $sX$가 뉴클레오타이드라면, $Sigma = {"A", "T", "C", "G"}$
- $sX$가 선풍기라면, $Sigma = {"끔", "미풍", "약풍", "강풍"}$

이처럼, 계 $sX$의 상태 집합 $Sigma$의 원소들은 특정 의미를 갖는 문자에 대응되어 정보를 효율적으로 기술한다. 예를 들어 우리가 선풍기를 조작하고 있다고 생각해 보자. 이 상황에서는 상태가 무엇인지 바로 알 수 있다. 바람이 너무 세다고 느끼는 것은 선풍기를 코앞에서 강풍으로 틀어놨기 때문일 것이다. 우리는 선풍기가 강풍으로 되어 있음을 확인할 수 있고, 임의로 미풍으로 바꿀 수 있다. 하지만 모든 정보가 이렇게 확정적으로 처리될 수는 없다(물론 선풍기도, 풍량을 확인하기 전에는 무슨 풍량으로 되어 있는지 알 수 없기도 하다).

주사위를 던진다고 생각해 보자. 주사위가 구르다가 멈추기 전에는 주사위가 어떤 상태를 가질지 알 수가 없다. 사실, 대부분의(또는 모든) 정보가 이러한 성질을 갖는데, 우리는 이것을 확률로 표현한다. 일반적인 경우 주사위가 상태 2를 가질 확률은 아래와 같이 표현한다.
$
  P(sX=2)=1/6
$

각 상태가 점유하는 확률을 모두 표현해 보면
$
  P(sX=1)=1/6 \
  P(sX=2)=1/6 \
  P(sX=3)=1/6 \
  P(sX=4)=1/6 \
  P(sX=5)=1/6 \
  P(sX=6)=1/6
$

또는 이것을 간단하게 열벡터로 나타낸다.
$
  vec(1/6, 1/6, 1/6, 1/6, 1/6, 1/6)
$


우리는 아래 두 가지를 가정하면 모든 확률 분포를 열벡터로 나타낼 수 있다.
1. 모든 원소는 음이 아닌 실수이다.
2. 모든 원소의 합은 1이다.

반대로, 위 두 속성을 만족하는 열벡터는 확률 분포로 해석할 수 있다. 앞으로 우리는 이런 벡터를 '확률벡터'라고 하자.

== 확률 상태의 측정
어떤 계를 측정한다는 것은 그 계가 어떤 상태에 있는지를 명확히 확인하는 것이다. 또, 측정을 하게 되면 확률벡터가 새로 정의되는데, 계가 현재 상태에 있는 것이 확실하게 되므로 현재 상태의 확률은 1, 나머지 상태들은 0이 된다.

어떤 계에서 상태가 $a in Sigma$에 있다면, 우리는 확률벡터를 아래와 같이 나타낼 수 있다.
$
  vec(1, 0, 0, 0, dots.v, 0)
$
이 벡터는 이 계가 확실히 상태 $a$에 있다는 것을 의미하고, 이 벡터를 $ket(a)$라고 한다#footnote[물론 $va(a)$나 $vbu(a)$처럼 표현할 수도 있겠지만, 양자역학에서는 디랙 표기법에 따라 $ket(a)$를 사용한다.].

하나의 동전을 계라고 보면 상태에 대한 기저 벡터는 다음과 같이 정할 수 있다.
$
  ket("앞면") = vec(1, 0) quad ket("뒷면") = vec(0, 1)
$

이제, 계의 확률벡터는 각 기저 벡터의 선형 결합식으로 나타내어질 수 있다. 우리의 예에서는
$
  vec(1/2, 1/2) = 1/2 vec(1, 0) + 1/2 vec(0, 1) = 1/2 ket("앞면") + 1/2 ket("뒷면")
$

꽤나 뻔한 소리처럼 보일 수 있으나, 양자 정보도 고전 정보와 비슷하게 기술하게 되며, 우리는 고전 정보를 이렇게 표현함으로써 양자 정보를 이해하는 데 조금 더 가깝게 다가갈 수 있다.

= 양자 정보

== 양자 상태벡터
계의 양자 상태는 고전 정보의 확률벡터와 비슷하게 열벡터로 나타낸다. 하지만, 확률벡터와 달리 양자 상태벡터의 원소는 복소수이다. 그에 따라 모든 원소의 절댓값 제곱의 합이 1이 되어야한다. 이것은 곧 해당 벡터의 유클리드 노름이 1이라는 것과 동치이다.

#pagebreak()

#definition(title: "열벡터의 유클리드 노름")[
  열벡터
  $
    v = vec(alpha_1, alpha_2, alpha_3, dots.v, alpha_n)
  $
  의 유클리드 노름(Euclidian norm)은
  $
    norm(v) = sqrt(sum_(k=1)^n abs(alpha_k)^2)
  $
]

즉, 양자 상태벡터는 유클리드 노름이 1임을 만족하는 힐베르트 공간 상의 단위 벡터이다.

== 큐비트
큐비트(qubit)란 상태를 $Sigma = {0, 1}$로 가지는 양자계이다. 즉, 양자 상태를 가질 수 있는 비트이다.
$
  ket(0) =^Delta vec(1, 0), space ket(1) =^Delta vec(0, 1)
$

이때, 큐비트의 상태로 가능한 몇 가지 예는 아래 같은 것들이 있다.
$
  vec(1/sqrt(2), 1/sqrt(2)) = 1/sqrt(2) ket(0) + 1/sqrt(2) ket(1) \
  vec((1+2i)/3, -2/3) = (1+2i)/3 ket(0) + -2/3 ket(1)
$

그 중에서도 아래 두 상태는 자주 등장하여 별도의 기호가 있다.
$
  ket(+) = 1/sqrt(2) ket(0) + 1/sqrt(2) ket(1) \
  ket(-) = 1/sqrt(2) ket(0) - 1/sqrt(2) ket(1)
$

== 디랙 표기법
우리가 가능한 상태 $a in Sigma$를 가진 상태벡터 $ket(psi)$에 대해 행렬곱은 해당 인덱스의 원소 값을 출력한다.
$
  ket(psi) = (1+2i)/3 ket(0) + -2/3 ket(1) = vec((1+2i)/3, -2/3)
$
이라고 하면
$
  braket(0, psi) = (1+2i)/3, space braket(1, psi) = -2/3
$

또, 임의의 벡터에 대해 행벡터 $bra(psi)$는 열벡터 $ket(psi)$를 켤레 전치(conjugate transpose)한 것이다.
$
  bra(psi) = (1-2i)/3 bra(0) - 2/3 bra(1) = vecrow((1-2i)/3, -2/3)
$

#definition(title: "에르미트 전치행렬")[
  복소수체 상의 행렬 $A$에 대해 모든 원소에 켤레를 취한 행렬을 $A$의 켤레 행렬이라고 하고, $overline(A)$로 쓴다.

  이때, 아래를 켤레 전치행렬(conjugate transpose) 또는 에르미트 전치행렬(Hermitian transpose)이라고 한다#footnote[$dagger$는 단검을 본뜬 모양으로, 칼표라고 한다. 켤레 전치행렬을 표기할 때, 순수 수학에서는 별표를, 물리학에서는 칼표를 쓰는 편이다. 비슷하게, 켤레 복소수를 표기할 때 순수 수학에서는 윗선을, 물리학에서는 별표를 쓴다.].
  $
    A^dagger equiv A^* =^Delta overline(A^TT)
  $
]

이 표기법에 따라, 상태벡터는 다음을 만족한다고 할 수 있다.
$
  norm(ket(psi))^2 = braket(psi, psi) = 1
$


한 가지 예시로, 가능한 상태 $Sigma = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9}$를 갖는 양자 10진법 자릿수 상태는 아래와 같다#footnote[$1/sqrt(385)$는 벡터를 크기 1로 만들기 위한 계수이다. $ket(psi)=sum_(k=0)^9 (k+1) ket(k)$로 두면, 벡터의 노름 제곱은 $braket(psi, psi)=sum_(k=0)^9 abs(k+1)^2 = sum_(k=1)^10 k^2 = 385$. 상태벡터를 확률로 해석하려면 그 크기가 1이어야 하며, 그렇게 만드는 과정을 정규화라고 한다.].
$
  1/sqrt(385) vec(0, 1, 2, 3, 4, 5, 6, 7, 8, 9) = 1/sqrt(385) sum_(k=0)^9 (k+1) ket(k)
$

이렇게 상태가 많아질수록 열벡터 표기는 불편해지고, 디랙 표기법이 얼마나 효율적인지를 확인해볼 수 있다. 디랙 표기법은 아직 상태가 확정되지 않았을 때도 그 상태를 표현할 수 있는데, 임의의 고전 상태 집합 $Sigma$에 대해 양자 상태벡터는 아래와 같다.
$
  1/sqrt(abs(Sigma)) sum_(a in Sigma) ket(a)
$

== 양자 상태의 측정
양자 상태가 측정될 때는 어떤 일이 일어나는가? 여러 가지 측정 방법이 있지만 그 중에서도 표준 기저#footnote[큐비트에서 표준 기저는 ${ket(0), ket(1)}$이다.] 측정(standard basis measurement)라는 방법을 알아보겠다.
확률론적 상황에서처럼, 어떤 양자 상태를 측정하면 관찰자는 양자 상태벡터 그 자체가 아닌, 그 벡터에 속한 어떤 고전 상태 하나만을 보게 된다. 즉, 측정은 양자 정보와 고전 정보 간 연결 고리의 역할을 한다.

양자 상태가 측정될 때, 각 고전 상태는 상태벡터에 대응되는 값의 절댓값 제곱의 확률로 나타난다. 예를 들어, $ket(+)$ 상태를 측정할 때는
$
  P(sX=0)=abs(braket(0, +))^2 = abs(1/sqrt(2))^2 = 1/2 \
  P(sX=1)=abs(braket(1, +))^2 = abs(1/sqrt(2))^2 = 1/2
$
해보면 알겠지만, $ket(-)$도 같은 결과가 나온다.

상태벡터가
$
  ket(psi) = (1+2i)/3 ket(0) + -2/3 ket(1)
$
라면, 측정 시 확률은
$
  P(sX = 0)=abs(braket(0, psi))^2 = abs((1+2i)/3)^2 = 5/9 \
  P(sX = 1) = abs(braket(1, psi))^2 = abs(-2/3)^2 = 4/9
$

== 유니터리 연산
그런데, 양자 정보는 고전 정보와 근본적으로 뭐가 다른가? 지금까지 본 바로는 복소수를 원소로 가진다는 것 외에는 없어 보인다. 그러면 상태벡터의 확률을 그냥 확률벡터로 나타내면 안 되는 것인가?

가장 쉬운 답은, 양자 정보는 고전 정보와 허용된 연산의 집합이 다르다. 확률벡터와 비슷하게 상태벡터에서의 연산도 선형 사상이다. 하지만 고전적인 경우에는 연산이 확률 행렬(벡터)로 표현되는 반면, 양자 상태벡터에 대한 연산은 유니터리 행렬로 표현된다는 점이 다르다.

#definition(title: "선형 사상")[
  벡터 공간 $V, W$ 상에서 정의된 함수 $T: V -> W$가 아래 두 조건을 만족시키면 $T$는 선형 사상(線型寫像, linear map) 또는 선형 변환(線型變換, linear transformation)이라고 한다.
  1. 가법성(加法性, additivity)
  $
    T(vbu(u) + vbu(v)) = T(vbu(u)) + V(vbu(v)) wide forall vbu(u), vbu(v) in V
  $
  2. 동차성(同次性, homogeneity#footnote[정확하게는 homogeneity of scalar multiplication(스칼라배의 동차성)])
  $
    T(c vbu(v)) = c T(vbu(v)) wide forall c in FF, vbu(v) in V
  $
  여기서 $FF$는 $RR, CC$ 등 벡터 공간 $V, W$의 스칼라 체이다.

  이 두 조건을 합쳐서 표현하면
  $
    T(a vbu(u) + b vbu(v)) = a T(vbu(u)) + b T(vbu(v)) wide forall a, b in FF and vbu(u), vbu(v) in V
  $
]

#definition(title: "유니터리 행렬")[
  복소 정사각행렬#footnote[정방행렬이라고도 한다.] $U$는 아래 식을 만족시키면 유니터리 행렬이다#footnote[정사각행렬에 대해서 위 두 식 중 하나가 참이면 나머지 하나도 참이다. 정사각행렬이 아닌 경우, 하나가 성립한다고 나머지 하나가 무조건 성립하지 않을 수 있으며, 이러한 경우는 유니터리 행렬이라고 하지 않는다.].
  $
    U U^dagger = II \
    U^dagger U = II
  $
  여기서 $II$는 단위행렬이다.

  위 두 등식이 성립함은 아래가 성립함과 동치이다.
  $
    U^(-1) = U^dagger
  $

  또, 위 정의는 다음과 동치이다.

  임의의 벡터에 복소 정사각행렬 $U$를 곱하여도 유클리드 노름이 변하지 않을 때 $U$는 유니터리 행렬이다. 즉, $n times n$ 복소 정사각행렬 $U$가 유니터리 행렬이라는 것은, 임의의 $n$ 차원 복소수 열벡터 $ket(psi)$에 대해
  $
    norm(U ket(psi)) = norm(ket(psi))
  $
  가 항상 성립함을 의미한다.
  양자 상태벡터의 집합은 유클리드 노름이 1인 벡터들의 집합과 동일하기 때문에, 유니터리 행렬을 양자 상태벡터에 곱하면 또 다른 양자 상태벡터가 된다.
]

유니터리 행렬(unitary matrices)은 항상 양자 상태벡터를 다른 양자 상태벡터로 변환하는 선형 사상의 집합과 정확히 일치한다. 여기서 고전 확률론과의 유사성을 주목할 수 있다. 고전적인 경우, 확률벡터를 항상 다른 확률벡터로 변환하는 연산은 확률 행렬과 대응된다. 즉, 양자역학에서는 유니터리 행렬이 상태 보존을 보장하며, 고전 확률론에서는 확률 행렬이 확률 보존을 보장한다.

== 유니터리 연산
유니터리 행렬은 양자 상태벡터의 노름을 보존하므로, 양자 컴퓨터에서 큐비트에 가하는 모든 연산은 유니터리 연산이어야 한다. 다음은 1 큐비트에 대한 대표적인 유니터리 연산의 예시이다. 이 행렬들은 연산자처럼 행동하며, 선형 변환이나 로렌츠 변환을 적용하듯이 상태벡터에 작용하게 된다.

=== 파울리 연산
아래 네 개를 파울리 행렬이라고 한다.
$
  & II = mat(1, 0; 0, 1) \
  & sigma_x equiv X =^Delta mat(0, 1; 1, 0) \
  & sigma_y equiv Y =^Delta mat(0, -i; i, 0) \
  & sigma_z equiv Z =^Delta mat(1, 0; 0, -1)
$

단, $X, Y, Z$는 다른 용도로도 많이 쓰인다는 것에 주의하자.

$X$ 연산은 비트에 대해 아래 결과를 내놓기 때문에 NOT 연산자 또는 비트 플립(bit flip)이라고 하기도 한다.
$
  X ket(0) = ket(1) \
  X ket(1) = ket(0)
$

$Z$ 연산은 phase flip(위상 플립?)이라고 하며, 아래와 같은 결과를 내놓는다.
$
  & Z ket(0) = ket(0) \
  & Z ket(1) = - ket(1)
$

$Y$ 연산은 복소수 위상까지 포함된 회전 연산이다.

=== 아다마르 연산
$
  H = 1/sqrt(2) mat(1, 1; 1, -1)
$
비트 $ket(0), ket(1)$을 균등한 중첩상태로 바꾸는 연산으로, 결과는 아래와 같다.
$
  H ket(0) = ket(+) = 1/sqrt(2) (ket(0) + ket(1)) \
  H ket(1) = ket(-) = 1/sqrt(2) (ket(0) - ket(1))
$

큐비트 상태 벡터에 대해 아래 네 개의 아다마르 연산 결과는 기억해 두자.
$
  H ket(0) = ket(+) quad H ket(1) = ket(-) \
  H ket(+) = ket(0) quad H ket(-) = ket(1)
$

=== 위상 연산
노름, 즉 확률 분포#footnote[양자 상태벡터는 고전 확률벡터와 다르다고 했지만, 상태벡터를 단위벡터로 정함으로써 확률 해석을 할 수 있게 된다.]는 유지하면서 상태 벡터의 복소수 위상만 변화시키는 선형 연산을 위상 연산이라고 한다. 위상이란 복소평면 상의 편각(argument)와 같은 말이다#footnote[임의의 복소수 $z = r e^(i theta) = r(cos theta + i sin theta)$에서 $theta = arg z$가 바로 위상이다.].

예를 들어,
$
  ket(psi') = e^(i phi) ket(psi)
$
는 원래 상태 $ket(psi)$와 측정 확률은 완전히 같지만, 위상이 $phi$만큼 변한 상태이다.

같은 말을 수식으로 되풀이해보자면, 위상 연산은 상태 벡터에 다음과 같이 작용한다.
$
  ket(psi) mapsto e^(i theta) ket(psi)
$

일반적인 위상 회전 변환 연산 행렬은 다음과 같이 주어진다.
$
  P_theta = mat(1, 0; 0, e^(i theta))
$

그 중 특수한 경우는 간단한 과정이지만 매번 계산하지 말고 따로 기억해 두자.
$
  & S = P_(pi/2) = mat(1, 0; 0, i) \
  & T = P_(pi/4) = mat(1, 0; 0, (1+i)/sqrt(2))
$

앞서 본 파울리 행렬도 위상 변환의 대표적인 예 중 하나이다.

위상 변환의 필요성과 위상의 물리적 의미를 이해하려면 간단한 예를 들어보자. $ket(+)$와 $ket(-)$는 측정 시 동일한 확률인 $1/2$를 가져 구분이 불가능하다. 하지만 아다마르 연산을 적용 후 측정하면 각각 $ket(0)$과 $ket(1)$을 출력해 구별이 가능해진다.

따라서, 위상 변화는 물리적으로 의미가 있는 변화이며, 양자 상태 간 구별에 중요한 역할을 한다고 할 수 있다.

== 유니터리 연산의 합성
행렬곱은 벡터기하학적으로 선형변환의 합성의 의미를 가진다. 즉, 유니터리 연산을 합성하려면 행렬곱을 취한다.

예를 들어, 아다마르 연산 후 $S$ 연산을 적용하고 다시 아다마르 연산을 적용한다고 하자. $R$이라고 명명할 이 연산은 아래와 같다.
$
  R & =^Delta H S H \
    & = mat(1/sqrt(2), 1/sqrt(2); 1/sqrt(2), -1/sqrt(2)) mat(1, 0; 0, i) mat(1/sqrt(2), 1/sqrt(2); 1/sqrt(2)) \
    & = mat((1+i)/2, (1-i)/2; (1-i)/2, (1+i)/2)
$

$R$은 흥미로운 경우로, 파울리 $X$ 연산의 제곱근이다.
$
  R^2 = mat((1+i)/2, (1-i)/2; (1-i)/2, (1+i)/2)^2 = mat(0, 1; 1, 0)
$

이렇게, NOT 연산을 두 번의 다른 연산으로 하는 것은 고전적인 단일 비트에서는 불가능하다.

= 다중 계에서의 정보 처리

== 데카르트 곱과 상태 집합
$sX$, $sY$는 각각 고전 상태 집합 $Sigma, Gamma$를 갖는 계라고 하자. 이 두 계가 합쳐져 또 다른 하나의 계를 이룬다고 할 때, $(sX, sY)$ 또는 $sX sY$로 나타낼 수 있다. 이때, 궁금한 것은 $(sX, sY)$의 고전 상태 집합은 무엇인가에 대한 것이다.

답은 꽤 당연하게 느껴지는데, $Sigma$와 $Gamma$의 데카르트 곱이다.

#definition(title: "데카르트 곱")[
  두 집합 $A$, $B$의 데카르트 곱은 아래와 같다.
  $
    A times B = Set((a, b), a in A\, b in B)
  $
]

두 개 이상의 계 $sX_1, ..., sX_n$과 그 상태 집합 $Sigma_1, ..., Sigma_n$에 대해서도 이 계들을 단일 계 $(sX_1, ..., sX_n)$으로 보았을 때 그 계의 상태 집합은 아래와 같이 된다.
$
  Sigma_1 times ... times Sigma_n = Set((a_1, ..., a_n), a_1 in Sigma_1 \, ... \, a_n in Sigma_n)
$

이렇게 계가 많아질 때, 그 계의 상태를 순서쌍 $(a_1, ..., a_n)$ 대신 간단히 문자열 $a_1...a_n$으로 나타낼 수 있다.

예를 들어, $sX_0, ..., sX_9$가 모두 비트이며, 이들의 고전 상태 집합은 모두 같다고 하자.
$
  Sigma_0 = ... = Sigma_9 = {0, 1}
$

그렇다면 이 비트들을 묶은 단일 계 $(sX_0, ..., sX_n)$은 총 $2^10 = 1024$ 개의 가능한 상태를 가지며, 이 상태들은 아래 집합의 부분집합이다.
$
  Sigma_0 times ... times Sigma_9 = {0, 1}^10
$

문자열로 나타냈을 때 상태들의 사전식 배열은 다음과 같다.
$
  0000000000\
  0000000001\
  0000000010\
  0000000011\
  0000000100\
  dots.v\
  1111111111
$

== 두 계의 독립
확률과 통계에서 배운 우리가 알고 있는 독립의 정의는 다음과 같다.
#definition(title: "사건의 독립")[
  두 사건 $A, B$에 대하여 다음이 성립하면 두 사건은 서로 독립이다.
  $
    P(A inter B) = P(A) P(B)
  $
]

이와 같은 맥락으로,

#definition(title: "계의 독립")[
  상태 집합 $Sigma, Gamma$를 갖는 두 계 $sX, sY$가 서로 독립이려면 아래가 성립해야 한다.
  $
    P((sX, sY) = (a, b)) = P(sX = a) P(sY = b) wide forall a in Sigma, b in Gamma
  $
]


이걸 디랙 표기법을 통해 확률벡터로 나타내어 보자. 확률 상태 $(sX, sY)$에 대해
$
  & sum_((a, b) in Sigma times Gamma) p_(a b) ket(a b) \
  & ket(phi) = sum_(a in Sigma) q_a ket(a) \
  & ket(psi) = sum_(b in Gamma) r_b ket(b)
$
라고 할 때, 계가 독립이려면 모든 $a in Sigma, b in Gamma$에 대해
$
  p_(a b) = q_a r_b
$
가 성립해야 한다.

== 벡터의 텐서곱
독립의 조건은 간단히 텐서곱으로 나타낼 수 있다. 텐서곱은 일반적인 표기로,여러 가지 자료구조에 추상적인 방법으로 적용될 수 있지만, 우리는 벡터에 대한  텐서곱의 명확한 정의를 살펴보자.

#definition(title: "벡터의 텐서곱")[
  두 벡터
  $
    ket(phi) = sum_(a in Sigma) alpha_a ket(a) \
    ket(psi) = sum_(b in Gamma) beta_b ket(b)
  $
  에 대하여 두 벡터의 텐서곱은 아래와 같다.
  $
    ket(phi) times.circle ket(psi) = sum_((a,b) in Sigma times Gamma) alpha_a Beta_b ket(a b)
  $

  이 새로운 벡터의 원소들은 $Sigma times Gamma$의 원소들에 대응된다. 또, 이 정의는 $ket(pi) := ket(phi) times.circle ket(psi)$에 대해 아래와 동치이다.
  $
    braket(a b, pi) = braket(a, phi) braket(b, psi) wide forall a in Sigma, b in Gamma
  $
]

좀 더 직관적인 이해를 위해 열벡터를 전개하여 텐서곱을 살펴보면
$
  ket(phi) = vec(alpha_1, alpha_2, alpha_3, dots.v, alpha_abs(Sigma)) \
  ket(psi) = vec(beta_1, beta_2, beta_3, dots.v, beta_abs(Gamma)) \
$

$
  ket(phi) times.circle ket(psi) = vec(
    alpha_1 beta_1, dots.v, alpha_1 beta_abs(Gamma),
    alpha_2 beta_1, dots.v, alpha_2 beta_abs(Gamma),
    dots.v,
    alpha_abs(Sigma) beta_1, dots.v, alpha_abs(Sigma) beta_abs(Gamma)
  )
$

이제 텐서곱으로 계의 독립 조건을 다시 나타낼 수 있다.

#theorem(title: "텐서곱을 이용한 계의 독립 조건")[
  상태 집합 $Sigma, Gamma$를 갖는 두 계 $sX, sY$가 각각 확률벡터 $ket(phi) in RR^abs(Sigma), ket(psi) in RR^abs(Gamma)$로 주어질 때, 두 계가 서로 독립이려면 아래가 성립해야 한다.
  $
    ket(pi) = ket(phi) times.circle ket(psi) wide "where " ket(pi) in RR^(abs(Sigma) times abs(Gamma))
  $
]

텐서곱은 이러한 정보 처리에서 자주 쓰이고 중요하기 때문에, 아래와 같은 표기로 기호가 생략 및 간략화되기도 한다.
$
  ket(phi) times ket(psi) equiv ket(phi) ket(psi) equiv ket(phi times.circle psi) equiv ket(phi psi) equiv ket((phi, psi)) equiv ket(phi\, psi)
$

또, 텐서곱 연산에서는 분배 법칙과 스칼라에 한해 결합법칙이 성립한다.
$
  (ket(phi_1) + ket(phi_2)) times.circle ket(psi) = ket(phi_1) times.circle ket(psi) + ket(phi_2) times.circle ket(psi)
$
$
  & (alpha ket(phi)) times.circle ket(phi) = ket(phi) times.circle (alpha ket(psi)) = alpha(ket(phi) times.circle ket(psi)) \
  & equiv alpha ket(phi) ket(psi)
$

== 확률 상태의 측정
여러 계로 구성된 확률 상태의 측정에 대해 알아보자. 다중 계를 하나의 전체적인 계로 간주한다면, 모든 계를 측정하는 경우 측정이 어떻게 일어나야 하는지에 대한 정의를 자연스럽게 얻을 수 있다.

예를 들어, 두 비트 $(sX, sY)$의 상태가 아래와 같이 주어진다고 하자.
$
  1/2 ket(00) + 1/2 ket(11)
$

이 경우, 측정 결과가 00, 즉 $sX$를 측정했을 때 0이고 $sY$를 측정했을 때도 0일 확률은 1/2 이고, 11일 확률도 1/2이다. 측정 결과가 00이면 상태는 $ket(00)$으로, 11이면 $ket(11)$로 바뀐다.

그러나 모든 계를 측정하는 것이 아니라, 일부 계만 측정할 수도 있다. 이 경우에는, 측정된 계에 대해서는 측정 결과를 얻고, 측정하지 않은 계에 대해 우리가 갖고 있는 정보도 변하게 된다. 이것을 설명하기 위해 두 계 중 하나만 측정하는 간단한 경우에 집중하자. 세 개 이상의 계 중 일부만 측정하는 보다 일반적인 상황은, 측정된 계들을 하나의 시스템으로 묶고 측정되지 않은 계들도 하나의 시스템으로 묶으면 결국 두 계로 이루어진 경우로 환원할 수 있기 때문이다.

계 $sX, sY$의 상태 집합을 다시 각각 $Sigma, Gamma$라고 두고, 두 계는 어떤 상태를 공유하고 있다고 하자. 이제 이 중 $sX$만 측정하고 $sY$는 측정하지 않았을 때 무슨 일이 생기는지 알아보자.

$sX$만 측정할 경우 특정 상태 $a in Sigma$가 나올 확률은
$
  P(sX=a) = sum_(b in Gamma) P((sX, sY) = (a, b))
$

이는 주변 확률분포(marginal distribution)이라고 하며, 전체 상태로부터 일부 변수만 남긴 분포이다. 만약 이 식이 성립하지 않는다면, 즉 $sY$의 측정 여부가 $sX$의 확률에 영향을 준다면, 이는 초광속 정보 전달을 허용하게 되는 것이므로 물리학적으로 허용되지 않는다. 즉, 다른 사람이 어디에 있든 측정을 했다는 사실만으로는 측정되지 않은 $sX$의 상태에 아무런 영향을 주지 않아야 한다.

$sX$만 측정된다는 가정 하에서, 여전히 $sY$의 상태에 대한 불확실성이 존재한다. 그러므로 $(sX, sY)$의 상태를 임의로 특정 상태 $ket(a b)$로 선언하는 것이 아니라, $sY$에 대한 불확실성을 반영하는 방법이 필요하다. 이것은 조건부 확률로 표현한다.
$
  P(sY = b | sX = a) = (P((sX, sY) = (a, b)))/(P(sX=a)) wide "s.t. " P(sX = a) != 0
$

$P(sX=a)=0$인 상황은, $sX = a$ 상태가 관측되지 않는 것이 아니라면 발생하지 않기 때문에, 걱정하지 않아도 된다.

이것을 확률벡터로 표현하기 위해, $(sX, sY)$의 확률 상태를 기술하는 벡터 $ket(psi)$를 생각하자.
$
  ket(psi) = sum_((a, b) in Sigma times Gamma) p_(a b) ket(a b)
$

오직 $sX$를 관측해 $sX = a$가 될 확률은
$
  P(sX = a) = sum_(c in Gamma) p_(a c)
$

이에 따라 $sX$의 상태벡터는
$
  sum_(a in Sigma) (sum_(c in Gamma) p_(a c)) ket(a)
$

측정 결과로 $a in Sigma$가 나왔다고 한다면, $sY$의 상태는 조건부 확률을 통해 반영된다. 이때 $sY$의 상태벡터는
$
  ket(pi_a) = (sum_(b in Gamma) p_(a b) ket(b))/(sum_(c in Gamma) p_(a c)) 
$

이제 $sX = a$인 사건에 대해 계 $(sX, sY)$에서 해당 확률은 $ket(a) times.circle ket(pi_a)$가 된다.

$ket(pi_a)$가 저렇게 나오는 이유 중 하나로 이해해두면 좋은 것은 벡터의 정규화이다.
$
  ket(pi_a) = 1/(sum_(c in Gamma) p_(a c)) sum_(b in Gamma) p_(a b) ket(b)
$
식을 이렇게 보면, 이 식은 $ket(b)$에 대한 상태벡터 $sum_(b in Gamma) p_(a b) ket(b)$를 벡터 원소의 전체 합 $sum_(c in Gamma) p_(a c)$로 나누어 정규화시킨 것이다.

잘 이해가 되지 않으니 구체적인 예를 들어보자. $Sigma = {0, 1}$, $Gamma = {1, 2, 3}$이라고 하고, 상태벡터는 다음과 같이 주어졌다고 하자.
$
  ket(psi) = 1/2 ket(0\,1) + 1/12 ket(0\,3) + 1/12 ket(1\,1) + 1/6 ket(1\,2) + 1/6 ket(1\,3)
$

텐서곱의 성질을 이용해 벡터를 $sX$를 기준으로 인수분해하듯 분리해서 정리하자.
$
  ket(psi) = ket(0) times.circle (1/2 ket(1) + 1/12 ket(3)) + ket(1) times.circle (1/12 ket(1) + 1/6 ket(2) + 1/6 ket(3))
$

그러므로 확률은
$
  & P(sX = 0) = 1/2 + 1/12 = 7/12 \
  & P(sX = 1) = 1/12 + 1/6 + 1/6 = 5/12
$
확률 총합이 1이므로 정상적인 분포임을 검산할 수 있다.

이제 $sY$의 조건부 확률벡터를 구하자. 먼저 $sX = 0$일 때부터 하면
$
  ket(pi_0) = 1/(7/12) (1/2 ket(1) + 1/12 ket(3)) = 6/7 ket(1) + 1/7 ket(3)
$
$sX=1$일 때도 똑같이
$
  ket(pi_1) = 1/5/12 (1/12 ket(1) + 1/6 ket(2) + 1/6 ket(3)) = 1/5 ket(1) + 2/5 ket(2) + 2/5 ket(3)
$

= 마무리
이렇게 양자 컴퓨팅의 방대한 세계 중에서도 가장 기본적인 내용인 고전 정보와 양자 정보의 기초적 처리 방법에 대한 이론을 알아 보았다. 입문을 위한 흥미를 돋구는 차원에서는 괜찮았지만, 실질적인 실현 방법이나, 게이트 연산과 정보 저장 방식 등 유틸리티 규모의 양자 컴퓨팅까지 가기에는 길이 멀다. 확실히 재미있는 주제는 맞는 것 같다.

== 추후 탐구 계획

아래의 커리큘럼을 통해 양자컴퓨팅 개론 공부를 완성시킬 계획이다. 대부분 수학과 물리 내용이지만, 이산수학과 암호화 알고리즘, 기본적인 자료구조에 대한 이해, 기존 컴퓨터의 대략적인 작동 개론 등 컴퓨터과학 지식도 필요한 편이다.

- 양자상태
- 관측가능성
- 유니터리 연산자
- 양자얽힘
- 양자암호학
- 밀도 연산자
- 슈미트 디컴퍼지션
- 순간이동
- No Cloning 정리
- 고전 정보 처리
- 고전 정보의 양자역학적 구현
- 그로버 양자 탐색 알고리즘
- 나머지와 군집론
- 공동키 암호학
- DFT, FFT, 양자 FFT
- 가역 양자컴퓨팅
- 애니온, 위상양자컴퓨팅

감사합니다.