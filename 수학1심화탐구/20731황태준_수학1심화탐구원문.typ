#import "@preview/physica:0.9.5": *
#import "@preview/ilm_custom:1.4.1": *
#import "@preview/alchemist:0.1.4": *
#import "@preview/theorion:0.3.3": *
#import "@preview/rich-counters:0.2.1": *
#import "@preview/cetz:0.3.4"
#import "@preview/cetz-plot:0.1.1"
#import cosmos.rainbow: *

// 표지
#let title = [두 삼각함수의 교점의 개수]

#show: ilm.with(
  title: title,
  author: "20731 황태준",
  date: datetime(year: 2025, month: 05, day: 30),
  abstract: [2025학년도 2학년 1학기 수학 I 심화탐구],
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
    "KoPubBatang", // CJK fallback 폰트
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
= 발상
중간고사를 준비하며 공부를 하다가 이런 문제를 마주쳤습니다.

#figure(caption: [2019년 3월 교육청 학력평가 수학 가형 26번])[
  #image("image.png")
]

분명 어려운 문제는 아니지만, 사실상 효율적으로 푸는 방법은 그냥 세 개의 그래프 $y=sin x, y = sin 3x, y=sin 5x$ 를 모두 그려서 교점 개수를 세는 것입니다.

#figure(
  caption: [그래핑 계산기로 그린 세 함수의 그래프#footnote[붉은색: $y = sin x$, 푸른색: $y = 3 sin x$, 녹색: $y = 5 sin x$]],
)[
  #image("image-1.png", width: 80%)
] <desmos-graph1>

그런데 이것은 오직 이 문제를 푸는 방법일 뿐이지, 만약 문제에서 $a_3 + a_5 + a_7 + a_9$ 처럼 값을 더 여러 개를 구하라고 했거나, $a_2019$처럼#footnote[그 해 년도를 구해야 하는 값에 넣는 문제가 꽤 많은 것 같습니다.] 무식하게 큰 값을 구하라고 했다면 단순히 그래프를 푸는 방법으로는 해결하지 못했을 겁니다.

그렇게 되면 슬슬 규칙성을 파악해야겠다는 생각이 듭니다. 여전히, 가장 빠른 방법은 한 5개에서 10개까지 해보고 일반항을 때려 맞추는 것일 겁니다. 어쨌든 수학에서 유추는 중요한 부분을 차지하니, 저는 시도를 해보았으나 부합하는 식을 직관적으로 맞추기는 어려워서, 생성형 AI한테도 한 번 시켜봤었습니다.

하지만 일단, 앞으로의 수식 표현을 일반화하기 위해 아래와 같이 정의하겠습니다.

#pagebreak()

#definition[
  아래 방정식
  $
    sin x = sin n x wide "where " n >= 2, n in NN
  $
  의 실근에 대해 앞으로 아래와 같이 약속하자.
  $
    "S" := Set(x, sin x = sin n x\, n>=2\, n in NN)
  $
  $
    abs("S") =: s_n
  $
]

ChatGPT, Gemini, Sonnet 등 여러 군데에 시켜봤는데, AI들이 내놓은 식들을 모아보면 공통적으로 이 정도입니다#footnote[놀라울 정도로 일관됩니다.].
$
  s_n = cases(
    n & quad (n"은 짝수", n>2),
    n + 1 & quad (n"은 홀수")
  )
$

$
  s_n = 2n - 2 quad (n >= 2)
$

문제에서 요구하는 3과 5만 넣어봐도 성립하지 않는다는 것을 알 수 있습니다. 아직까지는 얘들도 멍청한가봅니다.

이렇게 되면 더욱 가만히 있을 수 없어서 근거 없는 유추가 아니라, 정말로 유도를 해보기로 마음먹었습니다.

= 해의 일반항 유도

== 해의 조건
먼저 주어진 방정식은
$
  sin x = sin n x wide "where " n >= 2, n in NN
$

이 식이 성립하려면 경우는 아래 둘 중 하나이고, 생각할 수 있는 다른 경우는 사인 곡선의 주기성과 대칭성에 의해 모두 동치입니다.
$
  x = n x + 2 k pi " or " x = -n x + (2k + 1) pi wide "where " k in ZZ
$

여기서 쓸모는 없겠지만, 편안함을 위해 이 두 경우를 하나의 식으로 표현해 보면 아래와 같습니다.
$
  x = (-1)^k n x + k pi quad "where " k in ZZ
$

혹시 나중에 문제 풀 때 써먹을 수 있을지도 모르니 일단 이것으로 부터 얻은 일반적인 결론부터 정리하고 넘어가겠습니다.

#theorem[
  아래 방정식
  $
    sin theta = sin phi
  $
  에 대해 그 해의 조건은 아래와 같다.
  $
    theta = (-1)^k phi + k pi quad "where " k in ZZ
  $
]<general-sol>

== 해의 개수 구하기
돌아와서, 개수를 구하기 위해서는 어차피 경우를 나누어 생각해야 할 것 같습니다.

=== 첫번째 경우
$x = n x + 2 k pi$를 변형해서 $x$를 구해 봅시다. 앞으로 계속 $k in ZZ$라고 하고 이 조건은 생략하겠습니다.
$
  x - n x = 2 k pi
$
그런데 $n$이 뒤에 오는게 불편하니까 조건을 $x = n x - 2 k pi$로 변형한 뒤 계속합시다.
$
  & n x - x = 2 k pi\
  & (n - 1) x = 2 k pi \
  & x = (2 k pi) / (n - 1)
$

$0 <= x <= pi$이므로
$
  & 0 <= (2 k pi) / (n - 1) <= pi
$

이때 $n >= 2$이므로 $n - 1 > 0$입니다. $k$에 대해서 정리하면
$
  0 <= k <= (n - 1) / 2
$

이때 $k$는 정수이므로 $k$의 값은 다음과 같습니다.
$
  k = 0, 1, 2, ..., floor((n - 1) / 2)
$

그러므로 이 경우 해의 개수는
$
  floor((n - 1) / 2) + 1
$

=== 두번째 경우
$x = - n x + (2k + 1)pi$를 $x$에 대해서 정리하면
$
  & x + n x = (2k + 1) pi \
  & (1 + n)x = (2k + 1)pi \
  & x = ((2k + 1)pi) / (n+1)
$
따라서
$
  0 <= ((2k + 1)pi) / (n + 1) <= pi ==> 0<= 2k + 1 <= n + 1
$

이 때 $2k + 1$의 값들은
$
  2k + 1 = 1, 3, 5, ..., n, n + 1
$

이것의 개수는
$
  ceil((n+1) / 2) = floor((n+2) / 2)
$

그러므로 가능한 $k$의 값들은
$
  k = 0, 1, 2, ..., floor(n / 2)
$

따라서 가능한 $k$의 개수는
$
  floor(n / 2) + 1
$

=== 두 경우에서 해의 개수
먼저 교점 개수가 될 수 있는 후보를 $s^*_n$로 놓겠습니다. 또, 첫번째 조건에 해당하는 집합을 $"A"$, 두번째 조건에 해당하는 집합을 $"B"$라고 하겠습니다.

앞서 구해놓은 두 경우에 대한 해의 개수를 다시 봅시다.

$
  & abs("A") = floor((n - 1) / 2) + 1 \
  & abs("B") = floor(n / 2) + 1
$

$
  s^*_n =& abs("A") + abs("B") \
  =& (floor((n-1) / 2) + 1) + (floor(n / 2) + 1) \
  =& floor((n-1) / 2) + floor(n / 2) + 2
$

이 때, 앞서 구한 두 경우에 대해 각각 $n$이 홀수일 때와 짝수일 때로 구분해 바닥(floor) 기호를 벗길 수 있습니다.

먼저 $n$이 짝수일 때, 바닥 값들이 아래와 같으므로
$
  & abs("A") = floor((n-1) / 2) = (n-2) / 2 = n / 2 - 1 \
  & abs("B") = floor(n / 2) = n / 2
$
해의 개수는
$
  s^*_n = n / 2 - 1 + n / 2 + 2 = n + 1
$ <sstar-odd>

또, $n$이 홀수일 때, 바닥 값들이 아래와 같으므로
$
  & floor((n - 1) / 2) = (n - 1) / 2 \
  & floor(n / 2) = (n - 1) / 2
$
해의 개수는
$
  s^*_n = (n - 1) / 2 + (n - 1) / 2 + 2 = n + 1
$ <sstar-even>

@sstar-odd 와 @sstar-even 에 의해 아래를 얻습니다.
$
  s^*_n = n + 1
$

=== 중복된 해의 처리
그런데 위 두 경우를 모두 만족하는 해들이 존재할 수 있습니다. 즉, 주기성과 대칭성을 모두 만족하는 해를 의미하는데, 이는 두 곡선이 접하는 부분에서 생기게 됩니다.

아까 전 @desmos-graph1 에서도 $y = 5 sin x$(녹색 곡선)과 $y = sin x$(붉은색 곡선)이 접하면서 곡선이 주기 내에서 한 번 진동할 때 교점이 둘이 아니라 하나가 생기는 것을 확인할 수 있습니다.

즉 포함배제 원리에 따라
$
  abs("S") = s^*_n - abs("A" inter "B")
$

아아까 전에 구해놨던 두 경우의 조건을 다시 봅시다.
$
  & "A" = Set(x, x = (2 k pi) / (n-1)) \
  & "B" = Set(x, x = ((2k + 1)pi) / (n+1))
$

따라서 $"A" inter "B"$를 구하려면 아래 방정식을 풉니다.
$
  x = (2 k_1 pi) / (n - 1) = ((2k_2 + 1)pi) / (n + 1) wide "where " k_1, k_2 in ZZ
$

$x != 0$이라고 가정하고 양변에 $(n-1)(n+1)\/pi$를 곱하면
$
  2 k_1 (n + 1) = (2 k_2 + 1)(n - 1)
$

즉 짝수와 $n+1$의 곱이 홀수와 $n-1$의 곱과 같아야 한다는 것입니다.

#note-box(title: "시행착오")[
  처음에 아래처럼 전개했다가 정수론의 늪에 빠졌습니다.

  $
    & 2k_1 n + 2k_1 = 2k_2 n - 2k_2 + n - 1 \
    & (2k_1 - 2k_2 - 1)n = -(2k_1 + 2k_2 + 1) \
    & n = -(2k_1 + 2k_2 + 1) / (2k_1 - 2k_2 - 1) \
  $

  결국 저 상태에서 어떤 조작을 가해도 풀리지 않길래 컴퓨터의 힘을 빌려서 무차별 대입을 하는 파이썬(Python) 코드를 짠 후 100까지 돌려봤습니다#footnote[현재 콜라츠 추측은 이런 식으로 컴퓨터를 이용해 $2^68$까지 참임을 보였다고 합니다.].

  ```
  # find_intersection.py

  def find_solutions(n_max=100):
    results = []
    for n in range(2, n_max + 1):
        # 2k1(n+1) = (2k2 + 1)(n-1)
        # 위를 k1에 대해 정리한 식에 무차별 대입
        # k1 = ((2k2 + 1)(n - 1)) / (2(n + 1))

        for k2 in range(-n, n + 1):
            lhs = 2 * (n + 1)
            rhs = (2 * k2 + 1) * (n - 1)
            if rhs % lhs == 0: # 정수이면
                k1 = rhs // lhs
                results.append((n, k1, k2))
                break # 결과에 등록
    return results # 전체 결과 배열 반환

  # 출력
  for n, k1, k2 in find_solutions(100): # 100까지만 해보자
    print(f"n = {n}, k1 = {k1}, k2 = {k2}")
  ```

  출력 결과는 아래와 같았습니다.
  ```
  n = 5, k1 = -3, k2 = -5
  n = 9, k1 = -6, k2 = -8
  n = 13, k1 = -9, k2 = -11
  n = 17, k1 = -12, k2 = -14
  n = 21, k1 = -15, k2 = -17
  n = 25, k1 = -18, k2 = -20
  n = 29, k1 = -21, k2 = -23
  n = 33, k1 = -24, k2 = -26
  n = 37, k1 = -27, k2 = -29
  n = 41, k1 = -30, k2 = -32
  n = 45, k1 = -33, k2 = -35
  n = 49, k1 = -36, k2 = -38
  n = 53, k1 = -39, k2 = -41
  n = 57, k1 = -42, k2 = -44
  n = 61, k1 = -45, k2 = -47
  n = 65, k1 = -48, k2 = -50
  n = 69, k1 = -51, k2 = -53
  n = 73, k1 = -54, k2 = -56
  n = 69, k1 = -51, k2 = -53
  n = 73, k1 = -54, k2 = -56
  n = 77, k1 = -57, k2 = -59
  n = 81, k1 = -60, k2 = -62
  n = 85, k1 = -63, k2 = -65
  n = 69, k1 = -51, k2 = -53
  n = 73, k1 = -54, k2 = -56
  n = 77, k1 = -57, k2 = -59
  n = 81, k1 = -60, k2 = -62
  n = 69, k1 = -51, k2 = -53
  n = 73, k1 = -54, k2 = -56
  n = 77, k1 = -57, k2 = -59
  n = 69, k1 = -51, k2 = -53
  n = 73, k1 = -54, k2 = -56
  n = 73, k1 = -54, k2 = -56
  n = 77, k1 = -57, k2 = -59
  n = 81, k1 = -60, k2 = -62
  n = 85, k1 = -63, k2 = -65
  n = 89, k1 = -66, k2 = -68
  n = 93, k1 = -69, k2 = -71
  n = 97, k1 = -72, k2 = -74
  ```

  $n = 4k + 1$의 꼴임을 알게 되었습니다. 이를 토대로 증명 방식을 바꿔보기로 했습니다.
]

식을 적당히 정리해서 아래와 같이 만들었습니다.
$
  (n+1) / (n-1) = (2k_2 + 1) / (2k_1)
$

수많은 $(k_1, k_2)$의 조합이 있을 수 있지만, 우리는 $n$을 원하므로 유일한 $(k_1, k_2)$를 알아냄으로써 중복을 방지하기 위해 유리수의 정의에 입각해 우변을 기약분수라고 하겠습니다.

좌변 분수의 약분을 고려하기 위해 최소공배수를 따지겠습니다. 유클리드 호제법(互除法)에 따라 아래가 성립합니다.
$
  gcd(n+1, n-1) =& gcd(n+1-(n-1), n-1)\
  =& gcd(2, n-1)
$

이를 통해 홀짝에 따라 자명하게 다음을 알 수 있습니다.
$
  gcd(n+1, n-1) = cases(1 quad & (n"이 짝수"), 2 quad & (n"이 홀수"))
$ <gcdnp1nm1>

이제 $n$이 짝수일 때와 홀수일 때로 나누어 생각하겠습니다.

먼저, $n$이 짝수라면, $n-1$은 홀수인데, $2k_1$은 짝수입니다. 이때 @gcdnp1nm1 에 의해 좌변의 분수도 기약분수이므로 양변이 절대로 일치하지 않아 이 경우는 불가능합니다.

$n$이 홀수라면 $n+1$, $n-1$은 짝수입니다. 좌변 분수를 기약분수로 만들기 위해 분모와 분자를 최대공배수인 2로 나누겠습니다.
$
  ((n+1)\/2) / ((n-1)\/2) = (2k_2 + 1) / (2k_1)
$
이것이 성립하려면 좌변 분수의 분모는 짝수, 분자는 홀수가 되어야 합니다. 분모를 전개하면 아래와 같고,
$
  & (n - 1) / 2 equiv 0 space (mod 2) \
  & n - 1 equiv 0 space (mod 4) \
  & therefore quad n equiv 1 space (mod 4)
$
분자는 아래와 같습니다.
$
  & (n + 1) / 2 equiv 1 space (mod 2) \
  & n + 1 equiv 2 space (mod 4) \
  & therefore quad n equiv 4 space (mod 1)
$

분모, 분자 모두 성립하는 조건은 아래와 같습니다.
$
  n equiv 1 space (mod 4)
$

이제 다시 큰 그림으로 돌아가겠습니다. $0 <= x <= pi$의 범위에서 $y = sin x$에서 $sin x = 1$이 되는 경우는 $x=pi\/2$ 한 군데밖에 없고, 겹치는 근은 주기성과 대칭성을 동시에 만족해야 하기 때문에, 한 개밖에 없습니다.

그러므로 아래가 성립합니다.
$
  abs("A" inter "B") = 1
$

== 일반항
이상의 내용에 따라 다음 결론을 얻습니다.
$
  s_n = n + 1 - delta^(n mod 4)_(1)
$
이때 $delta$는 크로네커 델타(Kronecker delta)입니다.

#theorem[
  아래 방정식
  $
    sin x = sin n x wide "where " n >= 2, n in NN
  $
  의 실근의 개수 $s_n$은 아래와 같다.
  $
    s_n = n + 1 - delta^(n mod 4)_(1)
  $
]

#footnote[한 번 해보고 싶었습니다.]
QED

= 추후 탐구 계획
일반적인 범위 $r_1 pi <= x <= r_2 pi$ 방정식
$
  sin n_1 x = sin n_2 x wide "where " n_1, n_2 in NN
$
의 실근의 개수를 구하는 것을 다음 목표로 설정하면 재미있을 것 같습니다. 예상되는 추가 고려 사항은...
1. 범위에 따라서 주기와 함께 잘리는 부분도 고려해야하므로 훨씬 복잡해질 것입니다.
2. 중복되는 해의 조건과 개수도 달라질 것입니다.
3. 아까 구해놨던 @general-sol 가 유용하게 작용할 것 같습니다.

여기서부터는 더 하는 것이 의미가 있나 싶기도 하고 생각보다 많이 어려워질지도 모르겠지만 시도해볼 계획입니다.

감사합니다.
