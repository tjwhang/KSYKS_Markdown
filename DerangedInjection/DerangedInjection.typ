#import "@preview/physica:0.9.4": *
#import "@preview/ilm_custom:1.4.1": *
#import "@preview/alchemist:0.1.4": *
#import "@preview/theorion:0.2.0": *
#import "@preview/rich-counters:0.2.1": *
#import cosmos.rainbow: *

#let title = [Deranged Injection]

#show: ilm.with(
  title: title,
  author: "Taejoon Whang, Dongwoo Nam",
  date: datetime(year: 2025, month: 03, day: 06),
  abstract: [#lorem(30)],
  preface: align(center + horizon)[
    = Preface
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
#show raw: set text(font: ("JetBrains Mono", "Source Han Sans K"))
#set page(
  paper: "a4",
  margin: 3.5cm,
  header: align(right, title),
  numbering: "1",
)
#set math.equation(numbering: "(1.1)", supplement: [식. ])

#show: show-theorion
// 본문
= 발상

#figure(
  image("KOI_2023_HS_1_10.png", width:80%),
  caption: [한국 정보 올림피아드 2023년 고등부 1교시 10번 문제]
)

작년 (2024년)에 정보올림피아드에 출전하기 위해 저번 기출문제를 살펴보다가 경우의 수로 풀 법 한데 뭔가 안되서 몹시 많이 짜증나는 문제를 발견하고야 말았다. 시험지를 재배치하는것은 분명히 교란순열의 일종 같은데 청강생 때문에 뭔가 많이 꼬여서 케이스를 분류하여 푸는데도 순탄하게 되지 않고 뭔가 많이 거지같은 상황들이 많이 연출되어서 푸는데에 골머리를 썩게 되었다. 궁금하면 직접 해보아라. *과연 당신도 이딴 생각을 안 하고 배길 수 있겠는가??*

정올은 이와 같이 가끔씩 당연히 컴퓨터가 해야 할 일들을 사람 새끼에게 시키고는 한다. 이것은 분명 KOI가 수험생들을 사람이 아니라 일개 계산 노예로 취급한다는 방증이다. 하지만, 그러한 문제들은 수학적 사고력이나 지식으로 풀 수 있는 경우가 많다. 이 경우도 그러하다. 이 문제를 풀기 위하여 필자 일동은 완전순열(또는 교란순열)이라고 불리는 derangement의 개념을 확장할 생각을 하였다.

= 시작
이 문제 뿐 아니라, 2015 개정 교육과정 수학(하)에서 좆 같은 교란순열 문제들로 피똥을 질질 싼 필자 일동은 오기가 생겨 새로운 개념을 정립하기 시작했다. 어차피 1학년 끝나면 나오지도 않을 문제를 왜 중요시하며 쳐 내는지 모르겠지만 마지막을 즐기라는 의도인 것 같기도 하다. 어쨌든 간에 필자 일동은 일반적인 개념을 정립하기 위해 정의부터 시작했다.

처음에는 문제풀이 과정 중 하나로 시작했기 때문에, 일반화를 하기 어려웠다.

= 새로운 수열 $δ_n$

$X = {A, B}, Y = overbrace((A, B, ... , X), n)$ 이고 $f:X -> Y$ 인 함수 $f(x)$에 대해서
A와 B를 A,B가 포함된 총 $n$개의 것들에 대응시킬 때 A와 B가 각각 A,B로 대응되지 않는 경우의 수가 총 몇개일까?
이를 $delta_n$으로 정의하고 직접 한번 $delta_n$의 값을 구해보자.

${A, B} -> {A, B, C, D}$로 대응되면서 A와 B 모두 자기자신으로 대응되지 않는 경우의 수가 $delta_4$이다.
몇 개 안 되니 직접 한번 세어보자. (A의 도착지점, B의 도착지점)의 꼴로 나타내보면 다음과 같이 7개가 나온다.

$ 
(B,A), (B,C), (B,D), (C,A), (C,D), (D,A), (D,C) 
$

이 순열 $delta_n$의 값을 구하는 것이 쉬워보였다면 한번 직접 $delta_7$의 값을 구해보아라. (만일 직관이 좋다면 이를 하나하나 구하는 과정에서 스스로 $delta_n$의 점화식과 일반항을 찾아낼 수도 있을 것이다.)

== $delta_(n+1)$의 점화식

기본적으로 $delta_n$은 교란순열을 기반으로 만들어졌다. 그러므로 점화식을 만들어내는 방법이 교란순열과 몹시 유사하다.

이제 $delta_(n+1)$의 점화식을 구해보자. 치역에 새롭게 추가된 원소를 $x$ 라고 하고 경우의 수를 나눠보면 1, $x$에 A,B 둘다 대응시키지 않기와 2, $x$에 대응시키기 의 두가지 방법이 있다.

먼저 첫 번째 경우를 생각해보면 그냥 단순하게 이떄는 총 $delta_n$개만큼의 가짓수가 생긴다.

그리고 두 번째 경우를 생각해보면 이때는 약간 생각해야할게 늘었을 뿐 그리 복잡하지 않게 개수를 구할 수 있다. 우선 A와 B중 누구를 $x$에 대응시킬지를 정해야 한다. 이 경우는 총 2가지이다(사건 1). 이때 임의로 A가 $x$에 대응된다고 했을때 나머지 B는 B와 $x$를 제외한 $(n+1)-2$, 즉 $(n-1)$개에 대응될 수 있다(사건 2). 사건 1과 사건 2는 서로 동시에 일어나기 때문에 곱의 법칙에 의해 두번째 경우에서는 $2(n-1)$개의 가짓수가 생긴다.

이제 점화식 $delta_(n+1)$을 작성할 수 있게 되었는데 첫 번째 경우와 두 번쨰 경우는 서로 동시에 일어나는 사건이 아니므로 합의 법칙에 의해 $delta_(n+1)$의 점화식을 다음과 같이 쓴다. ($delta_n$에서 $n=1$ 이라는 상황 자체가 논리적으로 말이 안 되지만 #strike[정의역에 원소가 남더라도 배열은 할 수 있으니 1개라고 쳐주자])

$ 
delta_(n+1) = delta_n+2(n-1) wide (n>=1, delta_1=1)
$

== $delta_n$의 일반항

$delta_n$의 일반항은 교란순열과 많이 다르다. 원래 교란순열의 일반항은 포함배제의 원리에 의해 만들어진거라 시그마도 들어가고 $(-1)$의 거듭제곱 같은것들이 들어가곤 하는데 *다행히도* 이번 $delta_n$의 일반항은 그런것 없이 간단하게 나온다. 이것도 가짓수를 분류해서 알아볼 수 있는데 1.(B,A) 의 경우, 2. A가 B로 가는 경우, 3. A가 B로 가지 않는 경우이다.

첫 번째 같은 경우에는 그냥 그 경우 자체가 하나의 가짓수이므로 1개이다.

두 번쨰의 경우에는 A가 B로 가는것은 고정되어 있으니 이제 B가 A와 B를 제외한(A로 가는 경우는 첫 번쨰 경우에서 이미 다루었다) $(n-2)$개로 갈 수 있다.

세 번째의 경우에는 A가 B로 가지 않고 다른 것으로 가야 하므로 A와 B를 제외한 $(n-2)$개로 갈 수 있고(사건 1) B는 B와 A가 도착한 곳을 제외하고 갈 수 있으므로(이번에는 A로 가도 된다) $(n-2)$개로 갈 수 있다(사건 2). (사건 1)과 (사건 2)는 서로 동시에 일어나므로 곱의 법칙에 의해 세 번쨰 경우에는 총 $(n-2)^2$ 개만큼의 가짓수가 생긴다.

마찬가지로 이 세 경우 모두 동시에 일어나지 않는 경우이므로 합의 법칙으로 이들을 합쳐서 일반항을 적어본다면 $delta_n=(n-2)^2+(n-2)+1$ 이고 이를 정리하면 #strike[누구와는 다르게] 다음과 같이 깔끔하게 나온다.

$ 
delta_n = (n-1)(n-2)+1 wide (n>=1, delta_1=1)   
$

== 점화식의 활용

사실 본인이 수학적 귀납법의 고수라면 이러한 의미에 의한 일반항의 도출을 굳이 할 필요가 없다. $delta_n$의 점화식을 자세히 살펴보면 $delta_n+1 = delta_n+2(n-1)$, 즉 $delta_n+1 - delta_n = 2(n-1)$의 형태로 고쳐 쓸 수 있고 새로운 수열 ${b_n}$의 일반항 $b_n$을 $b_n=2(n-1)$ 으로 정의한다면 다음과 같은 식이 나온다.

$ 
delta_(n+1) - delta_n = b_n  
$

이는 $delta_(n+1)$의 일반항을 계차수열의 형태로 재작성한 것이며 $delta_n$이 계차수열임을 이용하여 $delta_(n+1)$의 일반항을 구해낼 수 있다.

계차수열의 일반항은 다음과 같다.
$
  delta_n=delta_1+sum_(k=1)^(n-1)b_k wide (n>=2)
$

$b_n=2(n-1)$을 대입하여 정리하면 아래와 같다.

$
  delta_n &= delta_1 + sum_(k=1)^(n-1) 2(k-1)\
  delta_n &=delta_1 + (n-1)(n-2)\
  therefore delta_n &= (n-1)(n-2)+1
$

== 점화식과 그 특성 방정식
(경문사 이산수학 제 2장 점화관계와 알고리즘 혹은 그와 같은 내용을 다루는 교재물 참고)

혹시 본인이 대학 수학을 공부하였다, 그 중 이산수학을 공부하였다면 점화식의 특성방정식을 이용하여 이 문제를 풀 수 있다! 물론 이 $delta_n$의 점화식이 선형동차점화식이 아니기 때문에 특수해가 존재하여 몹시나도 귀찮고 까다롭기 때문에(#strike[심지어 원래 차수에서는 특수해를 구하는 과정에 모순이 생기기 때문에 한 차수 더 높여서 구해야 한다...]) 굳이 이걸로 할 필요는 없다. 그래도 혹시 모르니 알아보도록 하자.

다시 원래의 점화식을 자세히 살펴보면 다음과 같다.

$
  delta_(n+1) = delta_n + 2(n-1)
$

이를 이용해 특성방정식을 세운다면 다음과 같이 나온다.
$
  t-1=0
$

따라서 특성방정식의 해는 1이므로 일반항을 다음과 같이 쓸 수 있다. (동차점화식의 뒤에 첨가된 $2(n-1)$을 $f(x)$, $delta_n$의 특수해를 $g(n)$이라고 하자)

$
  delta_n = A dot 1^n + 2(n-1)
$

이때 동차점화식의 뒤에 첨가된 $f(x)$가 일차이므로 $delta_n$의 특수해 $g(x)$는 $B_1 n+B_0$ 이다. 그러면 $delta_(n+1) = g(n+1),med delta_n = g(n)$이 성립하므로 점화식에 이를 대입하면 아래와 같다.

$ 
  &g(n+1) = g(n) + 2(n-1)\
  &=cancel(B_1 n) + B_1 + cancel(B_0) = cancel(B_1 n) + cancel(B_0) + 2(n-1)\
  &=B_1 = 2(n-1)
$ 

이때, $B_1$은 상수이므로 모순이다. 따라서 $delta_n$의 특수해 $g(x)$를 한 차수 올려서 다시 쓰면 $B_2 n^2 + B_1 n + B_0$ 이다. 이때도 마찬가지로 $delta_(n+1)=g(n+1),med delta_n=g(n)$이 성립하므로 점화식에 이를 대입하면 다음과 같다.

$
  & g(n+1) = g(n) + 2(n-1) \
  &= B_2 (n+1)^2 + B_1 (n+1) + B_0 \
  &= B_2 n^2 + 2B_2 n + B_0 + 2(n-1) \
  &= cancel(B_2 n^2) + 2B_2 n + B_2 + cancel(B_1 n) + B_1 + cancel(B_0) = cancel(B_2 n^2) + cancel(B_1 n) + cancel(B_0) + 2(n-1) \
  & 2B_2 n + B_2 + B_1 = 2(n-1) = 2n-2 \
  therefore& B_2=1, B_1=-3
$

이제 특수해 $g(x)=B_2 n^2 + B_1 n + B_0 = n^2 - 3$이므로 일반항을 다시 쓸 수 있다.

$
  delta_n = A + n^2 - 3n
$

이때 $delta_1=1$이므로 $A=3$이다. 이를 대입하고 정리하면 $delta_n$의 일반항은 아래와 같다.

$
  delta_n = (n-1)(n-2) + 1
$

= 일반화

하지만 $delta_n$은 A, B 두 개의 원소에 대한 제한적인 경우였다. 필자 일동은 이것을 모든 자연수 원소 개수에 대해 수행하고자 했다. 곧 목적에 맞게 두 매개변수 입력을 받는 식 표현을 완성했고, 아래와 같이 정의했다.

#definition[
  일대일 함수 $f:X->Y$에서 $|X| = d, |Y| = a$이고 $X subset Y$일 때, \
  모든 $x in X$에 대해 $f(x) != x$인 경우의 수를 다음과 같이 표현한다.

  $
    attach("U", bl: d, br: a) wide ("if "d>a, attach("U", bl: d, br: a) = 0)
  $

  또, $d=a$일 때 $attach("U", bl: d, br: a) = D_n$이다.
] <defU>

== 표기에 대하여
이는 모두 임의로 지정한 기호로 정식 표기는 문서 하단에서 정할 예정이다. 일단, 임시 표기는 엉터리인 부분이 있기는 하지만, $delta_n$의 델타는 derangement의 d에서 따왔고, $attach("U", bl: d, br: a)$의 U는 Unique(#strike[엉터리다]), d는 departure, a는 arrival에서 따왔다. 여기서 d를 domain, r를 range로 하지 않는 이유는 추후 더 확장을 할 때, 해당 관계가 함수가 아닐 때의 경우를 염두에 두고 정한 것이라고 할 수 있다.

또, 굳이 표기를 $U(n, r)$ 과 같이 하지 않고, $attach("X", bl: n, br: r)$ 꼴로 한 이유는 이 새로운 수열이자 순열이 기존의 순열, 조합 등 $attach("X", bl: n, br: r)$ 꼴로 표기되는 수들과 관계가 있다고 판단했기 때문이다. 가만히 생각해보면, $attach("C", bl: 4, br: n)$에서 $n in NN,n<=4$이라고 정하면 이 또한 수열이기 때문이다. 우리의 새로운 순열과 유사한 점이 있는 부분이다.

== $delta_n$의 새로운 표현

위 정의에 따라 여태까지 구했던 $delta_n$은 $attach("U", bl: 2, br: n)$으로 표현할 수 있다. 이의 점화식과 일반항을 쓰면 다음과 같다.
$
  & attach("U", bl: 2, br: n+1) = attach("U", bl: 2, br: n) + 2(n-1) wide (n>=2, attach("U", bl: 2, br: 2) = 1) \
  \
  & attach("U", bl: 2, br: n) = (n-1)(n-2) + 1
$

이렇게 놓고 보면 $delta_n$, 즉 $attach("U", bl: 2, br: n)$을 통해 일반적인 $attach("U", bl: d, br: a)$에 대한 점화식과 일반항을 유추해 볼 수 있다.

처음에 필자 일동은 식의 형태만 보고 일반항이 아래와 같을 거라고 유추했다.
$
  attach("U", bl: d, br: a) = product_(k=1)^(d)(a-k) + D_d
$
필자가 유추한 식이 맞는지 확인하기 위해 사용하던 예시인 $attach("U", bl: 3, br: 4)=11$이라는 값도 맞아 떨어졌기 때문에 잠시 이 식이 맞다고 판단했다. 하지만 논리적으로 뭔가 맞지 않았다. 그래서 유추를 그만두고 정식적인 유도 과정으로 넘어가기로 했다.

== $attach("U", bl: d, br: a)$의 일반항 유도
여러 시행착오 과정에서 필자 일동은 $attach("U", bl: 3, br: n)$에 1, 2, 3, 4, 5, 6 정도의 값을 넣어 보았고, 나온 값은 0, 0, 2, 11, 32 와 같이 진행했다. 앞서 유추한 식과 맞지 않았다.

일반항 유도 과정에서 힌트를 얻기 위해, 처음 발상의 시작인 교란순열 일반항의 원리를 살펴보았다. 기본적으로 교란순열 일반항 유도 과정은 (점화식에서 유도해 내지 않을 때) 포함 배제의 원리를 따른다. 포함 배제의 원리는 단순하게는 집합의 크기를 계산할 때 중복하여 센 것을 빼는 것으로, 익숙한 아래 원리가 그 예시이다.
$
  & |A union B| = |A| + |B| - |A inter B| \
  \
  & |A union B union C| \
  &= |A| + |B| + |C| - |A inter B| - |B inter C| - |C inter A| + |A inter B inter C|
$

이의 일반형은 아래와 같다.

#corollary(title: "포함 배제의 원리")[
  유한집합인 전체집합 $U$의 부분집합 $A_1, A_2, A_3, ... A_n$에 대해, 이들의 합집합의 원소의 개수는 다음과 같다.
  $
    & abs(union.big_(i=1)^n A_i) = sum_(emptyset != I subset [n]) (-1)^(|I| -1) abs(inter.big_(i in I) A_i) \
    & "where" [n]={1, 2, 3, ... , n}
  $

]

이 원리의 결과를 가장 쉽게 설명하면, 한 개 짜리 크기끼리 더하고, 두 개 짜리 크기끼리 빼고, 세 개 짜리 크기끼리 더하고, 네 개 짜리 크기끼리 빼고, ... 하는 것이다. 즉, 홀수 개짜리 크기들의 합에서 짝수 개짜리 크기들의 합을 빼면 된다. 이를 이용하여 교란순열의 일반항을 유도하면 다음과 같다.

$
  D_n & = sum_(k=0)^n (-1)^k binom(n, k) (n-k)! \
  & = sum_(k=0)^n (-1)^k attach("C", bl: n, br: k) (n-k)! \
  & = sum_(k=0)^n (-1)^k (n!)/(k!(n-k)!) (n-k)! \
  & = sum_(k=0)^n (-1)^k/k! \
$

이 발상을 이용하여 $attach("U", bl: d, br: a)$의 일반항을 유도해보자.

먼저, @defU 을 복기해 보자. 주어진 상황에서 일대일 함수의 개수는 아래와 같다.
$
  attach("P", bl: abs(Y), br: abs(X)) = attach("P", bl: a, br: d) = a!/(a-d)!
$

이제 새로운 집합 $A_x$를 아래와 같이 정의하자.
$
  A_x={f: X -> Y | f"는 일대일 함수" and f(x) = x}
$

임의의 $x in X$에 대해 $f in A_x$인 함수 $f$는 이미 정해졌으므로, 나머지 $d-1$ 개의 원소에 대해 $Y - {x}$에서 일대일 함수를 정의해야 한다. 따라서 아래와 같다.
$
  abs(A_x) = attach("P", bl: a-1, br: d-1) =(a-1)!/(a-d)!
$

일반적으로, $J in X med (abs(J)=j)$에 대해 아래와 같다고 하자.
$
  A_J = inter.big_(x in J) A_x
$

그러면 $J$에 속한 모든 $x$가 "고정"된 상태에서, 남은 $d-j$ 개의 원소에 대해서 $Y-J$에서의 일대일 함수를 정의해야 하므로 다음과 같다.
$
  abs(A_J) = attach("P", bl: a-j, br: d-j) = (a-j)!/(a-d)!
$

또, $J$를 선택하는 경우의 수는 $attach("C", bl: d, br: j)$ 가지이다.

이에 따라 포함 배제의 원리를 이용해 일반항을 구하면 다음과 같다.
$
  & attach("U", bl: d, br: a) \
  & = attach("P", bl: a, br: d) - sum_(x in X)abs(A_x) + sum_(J subset X\ abs(J)=2)abs(A_J) - sum_(J subset X\ abs(J)=3)abs(A_J) + ... + (-1)^d abs(A_X) \
  & =sum_(j=0)^d (-1)^j sum_(J subset X\ abs(J) =j) |A_J| 
$

각 $J$에 대해 $abs(A_J)=attach("P", bl: a-j, br: d-j)$이고 $J$를 선택하는 경우의 수는 $attach("C", bl: d, br: j)$이므로 위 식을 정리하면 다음과 같다.

$
  attach("U", bl: d, br: a) & = sum_(j=0)^d (-1)^j attach("C", bl: d, br: j) thin attach("P", bl: a-j, br: d-j) \
  & = sum_(j=0)^d (-1)^j binom(d, j) (a-j)!/(a-d)! \
  & = sum_(j=0)^d (-1)^j attach("C", bl: d, br: j) (a-j)!/(a-d)! wide qed
$
더 이상의 정리는 불가능하다. 이로써 $attach("U", bl: d, br: a)$의 일반항을 유도하였다. 

== $attach("U", bl: d, br: a)$의 점화식
사실 $attach("U", bl: d, br: a)$에서 $d$는 차원이라고 볼 수도 있다. 이는 $a$를 고정해 두고 $d$의 변화에 따라 모든 경우의 수형도를 표 형식를 그려보면 이해할 수 있다. 각 항목에 대해 경우의 수가 $d$개 만큼 나오게 되므로 행과 열에 합당한 라벨을 붙인 표를 그리게 된다면 $d=3$일 때는 3차원 표가, $d=4$일 때는 4차원 표가 필요해 진다.

분명히 각 차원에서의 경우의 수 간 관계도 수열일 것이다. 하지만 그 전에 먼저 같은 차원 내에서 $a$만 늘릴 때부터 생각해 보자.

=== $a$에 대한 점화식
@defU 에서 $Y$ 원소의 개수를 한 개 늘린 집합 $Y'$에 대해 고정점 없는 일대일 함수 $g: X -> Y'$의 경우를 크게 다음과 같이 분류할 수 있다.

i) $g$가 $Y'$에 새로 추가된 원소를 사용하지 않는 경우\
개수는 그대로 $attach("U", bl: d, br: a)$이다.

ii) $g$가 $Y'$에 새로 추가된 원소 $z$를 사용하는 경우\
일대일 함수이므로 $z$는 오직 한 개의 $x in X$의 상으로만 할당된다. $z$를 할당할 $x$를 $d$ 개의 원소 중에서 고르고, 나머지 $d-1$ 개의 원소에 대해 $g$는 $Y$로의 고정점 없는 일대일 함수가 되어야 하므로 그 개수는 $d thin attach("U", bl: d-1, br: a)$이다.

두 경우는 서로 배타적이므로 점화식은 아래와 같다.
$
  therefore attach("U", bl: d, br: a+1) = attach("U", bl: d, br: a) + d thin attach("U", bl: d-1, br: a)
$

=== $d$에 대한 점화식
$d$에 대한 점화식을 구하는 것은 조금 더 복잡하다. 먼저 계산의 편의를 위해 일반항을 분해하겠다.
$
  S(d,a) := sum_(k=0)^d (-1)^k attach("C", bl: d, br: k) (a-k)! \
  ==> attach("U", bl: d, br: a) = S(d,a)/(a-d)!
$

이제 $d+1$에 대해 $S(d+1, a)$를 전개해 보면,
$
  S(d+1, a) & = sum_(k=0)^(d+1) (-1)^k attach("C", bl: d+1, br: k) (a-k)! \
  & = sum_(k=0)^(d+1) (-1)^k binom(d+1, k) (a-k)! \
  & = sum_(k=0)^(d+1) (-1)^k {binom(d, k) + binom(d, k-1)} (a-k)! \
  & = sum_(k=0)^d (-1)^k binom(d, k) (a-k)! - sum_(k=0)^(d+1) (-1)^(k-1) binom(d, k-1) (a-k)! \
  & = sum_(k=0)^d (-1)^k binom(d, k) (a-k)! - sum_(k=0)^d (-1)^k binom(d, k) (a-k-1)! \
  & = S(d, a) - S(d, a-1) \
  therefore & S(d+1, a) = S(d, a) - S(d, a-1)
$

$attach("U", bl: d, br: a) = S(d,a) \/ (a-d)!$이므로,
$
  attach("U", bl: d+1, br: a) & = S(d+1, a)/(a-d-1)! \
  & = (S(d, a) - S(d, a-1))/(a-d-1)! \
  & = S(d, a)/(a-d)! - S(d, a-1)/(a-d-1)! \
$

여기서 $S(d,a)=attach("U", bl: d, br: a) (a-d)!$임을 대입하면, 
$
  attach("U", bl: d+1, br: a) = (a-d)!/(a-d-1)! attach("U", bl: d, br: a) - S(d, a-1)/(a-d-1)! \
$

같은 방법으로 $S(d, a-1) = attach("U", bl: d, br: a-1){(a-1)-d}! = attach("U", bl: d, br: a-1)(a-d-1)!$임을 사용하면,
$
  S(d, a-1) / (a-d-1)! = attach("U", bl: d, br: a-1)
$

$
  therefore attach("U", bl: d+1, br: a) = (a-d) attach("U", bl: d, br: a) - attach("U", bl: d, br: a-1)
$


== $attach("U", bl: d, br: a)$의 최종 정리

#theorem(title: "고정점 없는 일대일 함수")[
  일대일 함수 $f:X->Y$에서 $|X| = d, |Y| = a$이고 $X subset Y$일 때, \
  모든 $x in X$에 대해 $f(x) != x$인 경우의 수는 다음과 같다.

  $
    & attach("U", bl: d, br: a) = sum_(k=0)^d (-1)^k attach("C", bl: d, br: k) thin attach("P", bl: a-k, br: d-k)=sum_(k=0)^d (-1)^k attach("C", bl: d, br: k) (a-k)!/(a-d)! \
    & "if "d>a, attach("U", bl: d, br: a) = 0
  $

  이 때, $attach("U", bl: d, br: a)$는 아래의 두 점화식을 만족한다.
  $
    & attach("U", bl: d, br: a+1) = attach("U", bl: d, br: a) + d thin attach("U", bl: d-1, br: a) \
    & attach("U", bl: d+1, br: a) = (a-d) attach("U", bl: d, br: a) - attach("U", bl: d, br: a-1)
  $

  또, $d=a$일 때 $attach("U", bl: d, br: a) = D_n$이다.
]