#import "@preview/physica:0.9.4": *
#import "@preview/ilm_custom:1.4.1": *
#import "@preview/alchemist:0.1.4": *
#import "@preview/theorion:0.3.2": *
#import "@preview/rich-counters:0.2.1": *
#import "@preview/diverential:0.2.0": *
#import "@preview/cetz:0.3.4"
#import "@preview/cetz-plot:0.1.1"

#import cosmos.rainbow: *

// 표지
#let title = [운동량 보존 후속 연구 \ 작용\_action]

#set text(
  font: (
    (
      name: "STIX Two Text",
      covers: "latin-in-cjk",
    ),
    "Source Han Sans K",
  ),
  cjk-latin-spacing: none,
)
#show math.equation: set text(font: "STIX Two Math")

#show: ilm.with(
  title: title,
  author: "20731 황태준",
  date: datetime(year: 2025, month: 05, day: 8),
  abstract: [
    중앙고등학교 \
    2025 2학년 \
    운동량 보존 법칙 실험 후속 연구\
  ],
  preface: align(center + horizon)[
    한컴으로 쓰는데 여러 어려움이 있어서 그냥 LaTeX로 했습니다....


    4. 후속 탐구 내용
    작용(action)에 대해 조사하고, 다른 고전 역학의 물리량과의 관계에 대해 탐구한다.

    제 조사 능력이 부족한 것인지 모르겠지만 국내외를 막론하고 자료가 풍부하지 않아서 애를 먹었습니다....
  ],
  //bibliography: bibliography(""),
  figure-index: (enabled: false),
  table-index: (enabled: false),
  listing-index: (enabled: false),
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

#set math.equation(supplement: [식. ])

#set outline()
#show raw: set text(font: ("JetBrains Mono", "D2Coding"))
#set page(
  paper: "a4",
  margin: 3.5cm,
  header: align(right, title),
  numbering: "1",
)

#show: show-theorion
#set math.mat(delim: "[")

#let tag(content) = {
  math.equation(
    block: true,
    numbering: "(1.1)",
    supplement: [식. ],
    content,
  )
}

// 컴포넌트

#let template = doc => {
  import "@preview/physica:0.9.4": *
  import "@preview/ilm_custom:1.4.1": *
  import "@preview/alchemist:0.1.4": *
  import "@preview/theorion:0.3.2": *
  import "@preview/rich-counters:0.2.1": *
  import "@preview/cetz:0.3.4": *
  import "@preview/cetz-plot:0.1.1": *
  import "@preview/diverential:0.2.0": *
  import cosmos.rainbow: *

  show: show-theorion
  set math.mat(delim: "[")

  let tag(content) = {
    math.equation(
      block: true,
      numbering: "(1.1)",
      supplement: [식. ],
      content,
    )
  }

  doc
}

= 사전 조사
(탐구를 위한 배경 지식 쌓기)

== 작용의 정의

처음 탐구 발상을 하게 만든 것은 단순히 $m s$와 $m v s$의 꼴의 유사성이었지만, 달리 작용(action) $S$는 $m v s$가 아닌, 라그랑지언 $L$의 시간 적분으로 정의한다.
$
  S equiv integral_(t_1)^(t_2) L dif t
$

여기서 라그랑지언(Lagrangian)은 아래와 같이 정의되는 물리량이다.
$
  L = T - V
$
(구별을 위해 $cal(L)$ 처럼 필기체로 쓰기도 하지만, 구별이 불필요할 때는 $L$과 같이 정자로 쓰는 것이 흔하다. 무엇보다 필기체는 안 예쁘다.)

$T$는 운동 에너지, $V$는 퍼텐셜 에너지(위치 에너지)이다. 이때 라그랑지언은 $L(q,dot(q),t) = T(q, dot(q), t) - V(q, t)$처럼, 라그랑주 역학과 같이 일반화 좌표 $q_i$와 일반화 속도 $dot(q)_i$를 매개변수로 갖는다. 운동 에너지에서 퍼텐셜 에너지를 뺌으로써 계의 운동 상태를 알 수 있다는 의미를 가지는데, $T$가 클 때 계는 활동적이며, $V$가 클 때 계는 정적이라는 것을 뜻한다. 하지만 라그랑지언과 라그랑주 역학의 참 의미는 바로 이 작용과 관련돼 있다.

== 일반화 좌표
(라그랑주 역학 겉핥기)

일반화 좌표(generalized coordinates)란 계를 편리하게 분석하기 위해 사용되는 매개변수의 집합이다. '일반화'라는 이름이 붙은 이유는 데카르트 좌표(Cartesian coordinates)와의 구분을 위해서이다.

가장 간단한 예를 들어 질량이 $m$인 물체가 반지름 $r$의 원운동을 하는 것을 기술할 때, 데카르트 좌표인 직교 좌표 $(x,y)$로 표현하는 것보다 극좌표 $(r, theta)$로 표현하는 것이 편리하다. 따라서 아래와 같이 변환한다. $r$은 고정이므로 여기서 일반화 좌표는 $theta$가 된다.
$
  x = r cos theta \
  y = r sin theta
$
이는 $theta$에 대한 매개변수 방정식이다. 일반화 속도는 일반화 좌표를 미분하여 구한다.#footnote[위에 점을 찍어 미분했음을 나타내는 것은 뉴턴의 표기 방법이다.]
$
  dot(x) = -r sin theta dot dot(theta) \
  dot(y) = r cos theta dot dot(theta)
$
운동에너지는 $1 / 2 m v^2$인데, $v^2 = dot(x)^2 + dot(y)^2 = r^2 dot(theta)^2$ 이므로 아래와 같다.
$
  T = 1 / 2 m r^2 dot(theta)^2
$

외력이 없다고 가정하면 퍼텐셜 에너지는 운동에 영향을 주지 않으므로 $V=0$으로 두면, 라그랑지언은 아래와 같다.
$
  L = 1 / 2 m r^2 dot(theta)^2
$


꿈속에서 배운 오일러-라그랑주 방정식을 이용해 이를 전개해 보자. 오일러-라그랑주 방정식은 아래와 같다(이 방정식의 원리가 작용과 관련이 있다).
$
  dv(, t) pdv(L, dot(q)) - pdv(L, q) = 0
$
$q = theta$, $dot(q) = dot(theta)$를 대입하면 아래와 같다.
$
  dv(, t) pdv(L, dot(theta)) - pdv(L, theta) = 0
$

먼저 첫째항부터 계산하면,
$
  pdv(L, dot(theta)) = m r^2 dot(theta) \
  dv(, t) pdv(L, dot(theta)) = m r^2 dot.double(theta)
$
둘째 항은 간단하게,
$
  pdv(L, theta) = 0
$

따라서 방정식은 아래와 같다.
$
  m r^2 dot.double(theta) = 0
$

$m$이나 $r$이 0이 될 수는 없으므로 $dot.double(theta) = 0$이고, 이는 각속도가 상수임을 의미하여 각속도 보존이라는 특징을 알아내었다.

이처럼 일반화 좌표를 이용한 라그랑주 역학은 복잡한 운동을 좀 더 간단히, 일관된 방법으로 기술하고 운동 방정식을 세울 수 있다는 장점이 있다.

= 역사와 이론의 변화
특히 근대적인 물리 이론을 알아보기 위해서는 그 역사를 같이 알 필요가 있다. 왜 이러한 개념이 필요한지에 대한 이해가 수반되어야 하기 때문이라고 생각한다.

== 태동

'작용'이라는 물리량은 프랑스의 수학자 모페르투이(Pierre Louis Maupertuis)가 최소화 원리(minimization principle)#footnote[광선 최소화 원리, 페르마 원리, 사이클로이드 곡선, 스넬의 법칙 등으로 대표된다.]의 더욱 근본적인 원리를 찾는 과정에서, “최적 경로에서 궁극적으로 최소가 되어야 하는 물리량은 무엇인가?”에 대한 질문에 따른 발상으로 처음 주장했다.

이때 그는 작용을 그 물리량으로 정하고 아래와 같이 정의했다#footnote[이것은 abbreviated action으로 $S$보다 $S_0$ 또는 $W$로 나타낸다.].
$
  S_0 equiv m v s
$


즉, 물체가 더 멀리 움직이고, 더 빠르고, 더 무거울수록 작용이 크다는 것이다. 모페르투이는 이렇게 말했다.


_"This action is the true expense of Nature, which she manages to make as small as possible.#footnote[작용은 자연의 진정한 비용이며, 자연은 그것을 가능한 한 최소화하려고 한다.]"_

== 일반화되기까지

하지만 그의 개념의 정의는 다소 애매하고 신학적인 부분도 있기 때문에 그가 이를 발표했을 때 학계의 반응은 차가웠고 오히려 그는 조롱당하기도 했지만, 오일러(Leonhard Euler)는 이를 긍정적으로 받아들여 작용 이론을 방어하며 계속 변하는 작용의 값에 대한 모페르투이의 표현 $Sigma m v s$를 적분식 $integral m v dif s$로 바꾸어 수학적 정확성을 개선하여 표현했다. 오일러는 또한 이 원리가 실제로 적용되는 경우(입자가 행성의 공전과 같이 특정 질점(質點)으로부터 중력을 받으며 운동하는 때)를 찾아 식으로 표현하고, 이 원리가 성립하기 위한 추가 조건을 발견했다.
1. 에너지는 보존되어야 한다.
2. 가능한 모든 경로에 대해 에너지는 같다.

하지만 그 역시 증명 및 일반화는 하지 못했고, 이는 또 다른 전설적인 수학자인 라그랑주(Joseph Louis Lagrange)의 등장으로 조금 더 진전이 있었다. 라그랑주는 오일러와 자신의 연구 결과를 공유했고, 모페르투이 사후 1년 만에 두 명에 의해 일반화가 이루어졌다.

오일러와 라그랑주의 접근법은 아래와 같다.

가능한 무한대의 경로 중, 가장 작은 작용을 취하는 경로(the path of least action)은 일종의 극값을 구함으로써 알아낼 수 있다. 함수의 극값을 $dv(, x) f(x) = 0$와 같이 찾는 것처럼, 다음 형태의 방정식을 풀어 극값을 갖는 함수의 함수(범함수)를 구하고, 이를 통해 최소 작용의 경로도 구할 수 있다.
$
  dv(, t) pdv(L, dot(q)) - pdv(L, q) = 0
$

이를 오일러-라그랑주 방정식이라고 한다.

사실 위 식은 시간, 일반화 좌표와 라그랑지언 등이 보이다시피 라그랑주에 의해 라그랑주 역학적으로 개조된 식이고, 오일러-라그랑주 방정식의 수학적 원형은 오일러가 고안한 오일러 방정식으로 아래와 같다.

$
  dv(, x) pdv(F, y') - pdv(F, y) = 0
$

== 식의 전개를 통한 원리 탐구
$
  dv(, t) pdv(L, dot(q)) - pdv(L, q) = 0
$
이 식은 꽤 신기한 변분의 원리를 통해 유도할 수 있다.

=== 수학적 이해
함수는 극값, 즉 최솟값을 가지는 점에서 아주 미소한 변화를 주어도 극값의 위치가 바뀌지 않는다. 이해를 위해 간단한 이차함수에서 먼저 예시를 보겠다.
$
  f(x) = x^2
$
에 대해 그 도함수는
$
  f'(x) = 2x
$
이고 극값을 갖는 점은 $2x = 0$인 곳인 $(0,0)$이다. 이때, $x=0$에 미소 변화 $epsilon$을 주면,
$
  f(x + epsilon) - f(0) = epsilon^2 - 0 = epsilon^2 >= 0
$
즉, 극값을 가지는 점에서는 함수에 미소 변화를 주어도 그 값은 변함이 없다. 이는 수학적으로 아래와 같이 이해(완벽하지는 않지만 증명) 가능하다.

미분 가능한 함수 $f(x)$에 대해 그 도함수는 아래와 같이 구한다.
$
  f'(x) = lim_(delta x -> 0) (f(x + delta x) - f(x)) / (delta x)
$
양변에 $delta x$를 곱하고 적절히 이항하면 아래와 같다.
$
  f(x + delta x) - f(x) approx f'(x) delta x wide "where " delta x -> 0
$
이는 테일러 급수로도 근사가 가능하다. $f(x + delta x)$의 테일러 급수는
$
  f(x + delta x) = sum_(n=0)^oo (f^((n))(x)) / n!(delta x)^n = f(x) + f'(x) delta x + (f''(x)) / 2! (delta x)^2 + ...
$
$delta x$가 미소하므로 고차항은 무시하면,
$
  f(x + delta x) - f(x) approx f'(x) delta x wide "where " delta x -> 0
$
로 결과가 동일하다.

이를 이해가 용이하도록 꼴에 맞추어 다시 쓰면 다음과 같다.
$
  delta f = f(x + delta x) - f(x) approx f'(x) delta x
$

이는 직관적으로, 범함수에 대해서도 동일하게 성립하여,
$
  delta y(x) = y(x) + eta(x) - y(x) = eta(x) \
$
여기서 $eta(x)$는 미소한 변화를 주는 함수이다.

결론을 재진술하자면, 극값을 가지는 점에서는 함수에 미소 변화를 주어도 그 값은 변함이 없다. 이 특성을 이용하면 함수의 함수에 대해서도 극값을 구할 수 있다. 즉, 함수와 동일하게 범함수에 대해서도 극값을 찾는 방법은 $delta y(x) = 0$이 되는 지점을 찾는 것이다.

궁극적으로, 최소 작용을 찾기 위해서는 아래 식을 전개하면 된다.
$
  delta S = 0
$

=== 오일러 방정식 유도
잠시 물리적인 것은 배제해 두고, 순전히 수학적으로만 오일러 방정식을 유도해보자.

$
  I = integral_a^b F(y, y', x) dif x
$

$F$는 함수 $y$와 그 도함수 $y'$, 그리고 변수 $x$를 매개변수로 받는 범함수이다.

이 상황에서 $I$의 값을 최소화/최대화하는 함수 $y(x)$를 찾아보자.

함수 $y(x)$에 미소 변화를 주어도 $I$는 일정해야 극값이다.
$
  y(x) -> y(x) + epsilon eta(x) wide "where " epsilon -> 0,space eta(a)=eta(b)=0
$
여기서 $eta(x)$는 임의의 함수이고, 경계($a, b$)에서는 변화를 주지 않는다.

변화를 적용한 후의 적분 식은 아래와 같다.
$
  I(epsilon) = integral_a^b F(y + epsilon eta, y' + epsilon eta', x) dif x
$

그러므로 다음이 성립해야 한다.
$
  delta I = dv(I, epsilon, eval: epsilon = 0) = 0
$

테일러 전개를 통해 $F$를 근사하면
$
  F(y + epsilon eta, y' + epsilon eta', x) approx F(y, y', x) + epsilon pdv(F, y) eta + epsilon pdv(F, y') eta'
$

따라서
$
  I(epsilon) = integral_a^b [F + epsilon(pdv(F, y)eta + pdv(F, y')eta') ] dif x
$
$
  therefore delta I = dv(I, epsilon, eval: epsilon = 0) = integral_a^b [ pdv(F, y)eta + pdv(F, y')eta' ] dif x
$

두번째 항에 부분적분을 사용하여 정리하면
$
  integral_a^b pdv(F, y')eta' dif x = [pdv(F, y') eta ]_a^b - integral_a^b dv(, x) (pdv(F, y') )eta dif x
$
이때, $eta(a) = eta(b) = 0$이므로
$
  delta I = integral_a^b [pdv(F, y) - dv(, x) pdv(F, y')] eta dif x
$

이때 $eta(x)$는 임의의 함수이므로 식이 항상 0이 되기 위해서는 아래 조건이 성립해야 한다.
$
  pdv(F, y) - dv(, x) pdv(F, y') = 0
$

이항하여 아래와 같이 나타낼 수도 있다.

$
  dv(, x) pdv(F, y') - pdv(F, y) = 0
$

이 오일러 방정식에 라그랑지언과 일반화 좌표를 적용해 오일러-라그랑주 방정식을 만들 수 있다.

=== 변분 식 전개
$
  delta S = 0
$
이제 이 식을 실제로 전개해 보자.
이전에, 오일러는 모페르투이의 작용 표현식을 아래와 같이 바꾸었다고 했었다.
$
  sum m v s --> integral m v dif s
$
또, 오일러는 작용 이론이 성립하기 위한 두 가지 조건을 제시했다고 했다. 식을 전개해야하므로 자연어 문장을 수식으로까지 정리하여 표현해 보자.

1. 에너지는 보존되어야 한다. $-> E = "const."$
2. 가능한 모든 경로에 대해 에너지는 같다. $-> delta E = 0$

먼저, 아래와 같다.
$
  S_0 equiv integral m v dif s
$
그런데 $v$는 아래와 같이 표현할 수 있다.
$
  v = dv(s, t) -> dif s = v dif t
$

그러므로 $delta S$는 아래와 같이 된다.
$
  delta S\
  & = delta integral m v dif s \
  & = delta integral m v^2 dif t
$

그런데 $m v^2$은 운동 에너지의 두 배이므로 아래와 같이 된다.
$
  ... \
  & = integral 2T dif s = integral (T + T) dif s
$

역학적 에너지는 $E = T + V$이므로, $T = E - V$이다. 그러므로 아래와 같이 된다.
$
  ... \
  & = delta integral (T + E - V) dif t \
  & = delta integral (T - V) dif t + delta integral E dif t \
  & = delta integral (T - V) dif t + delta (E t) wide because E = "const." \
$

변분은 곱의 미분처럼 전개할 수 있다.
$
  ... \
  & = delta integral (T - V) dif t + E delta t + t delta E \
  & = delta integral (T - V) dif t + E delta t + cancel(t delta E) wide because delta E = 0 \
  & therefore delta integral (T - V) dif t = - E delta t
$

여기서 $E delta t$가 0이기만 하다면 이것은 다른 최소화 원리의 식과 동일한 꼴이다. 우리는 걸린 시간이 같은 경로들만을 생각함으로써 이를 0으로 만들 수 있다. 그러면 아래와 같이 된다.
$
  & delta integral (T - V) dif t = cancel(- E delta t) \
  & delta integral (T - V) dif t = 0 \
$

이제, 모페르투이의 원리가 다른 꼴로 변한 것을 알 수 있다.

운동 에너지와 퍼텐셜 에너지의 차의 시간 적분의 변분은 0과 같다는 식이 나왔다.

중간 결론을 정리하면 다음과 같다.
$
  delta integral m v dif s = delta integral (T - V) dif t = 0
$
여기서 $T-V$는 라그랑지언 $L$이다.

그러므로 $integral (T - V) dif t$ 또한 작용을 표현하는 또 다른 식이라는 것을 알 수 있다. 작용 식을 처음으로 이렇게 나타낸 사람은 또 다른 전설적인 수학자인 해밀턴(William Rowan Hamilton)이다. 이로써 이 원리는 그의 이름을 따 '해밀턴 원리(Hamilton's principle)'라고 명명됐다.

해밀턴 원리는 최소 작용의 원리를 나타내는 현대적인 방법이라고 한다. 모페르투이, 오일러, 라그랑주가 제시한 원리와 해밀턴의 원리는 몇가지 차이점이 있다. 먼저, 식의 특징에서 공간에 대한 적분과 시간에 대한 적분이라는 차이가 있고, 또 에너지와 시간 중 무엇이 가변적인가에 대한 차이도 있다.

어쨌든, 우리는 아래 식
$
  delta S = delta integral L dif t = 0
$
으로부터, 앞서 수학적으로 증명한 오일러 방정식의 유도 과정과 동일한 방법으로 오일러-라그랑주 방정식을 이끌어낼 수 있다.
$
  & q(t) -> q(t) + epsilon eta(t) \
  & S(q + epsilon eta) = integral_(t_1)^(t_2) L(q + epsilon eta, dot(q) + epsilon dot(eta), t) dif t \
  & delta S = dv(, epsilon) [integral_(t_1)^(t_2) L(q + epsilon eta, dot(q) + epsilon dot(eta), t) dif t]_(epsilon=0) = 0 \
  & L(q + epsilon eta, dot(q) + epsilon dot(eta), t) approx L(q, dot(q), t) + epsilon pdv(L, q)eta + epsilon pdv(L, dot(q))dot(eta) \
  & delta S = integral_(t_1)^(t_2) [pdv(L, q)eta + pdv(L, dot(q)dot(eta))] dif t
$
이제 부분적분을 이용해 정리하면,
$
  integral_(t_1)^(t_2) pdv(L, dot(q))dot(eta) dif t = [pdv(L, dot(q))dot(eta)]_(t_1)^(t_2) - integral_(t_1)^(t_2) dv(, t)(pdv(L, dot(q)))eta dif t
$
시간 경계에서 $eta = 0$이므로
$
  & delta S = integral_(t_1)^(t_2) [pdv(L, q) - dv(, t) pdv(L, dot(q))] = 0 \
  & therefore pdv(L, q) - dv(, t) pdv(L, dot(q)) = 0
$

= 엄청난 것
사전 지식 부분에서 엄청나게 스포를 하긴 했지만, 처음 이 부분에 대해서 발견했을 때는 매우 놀랍고 예상치 못한 결과가 나왔다고 생각했다. 다시 작용의 현대적 정의로 돌아가보자.
$
  S equiv integral_(t_1)^(t_2) L dif t
$

또, 오일러-라그랑주 방정식은 다음과 같다.
$
  dv(, t) pdv(L, dot(q)) - pdv(L, q) = 0
$

한 입자를 가정해 보자. 이 입자에 대해서 그 속성은 다음과 같다.
$
  & T = 1 / 2 m dot(x)^2 \
  & V = V(x) \
  & L = 1 / 2 m dot(x)^2 - V(x)
$

오일러-라그랑주 방정식에 $q = x$를 대입하면,
$
  dv(, t) pdv(L, dot(x)) - pdv(L, x) = 0
$

각 항을 계산하면
$
  & pdv(L, dot(x)) = m dot(x) \
  & dv(, t) pdv(L, dot(x)) = m dot.double(x)
$
$
  pdv(L, x) = - dv(V, x)
$

그러므로 방정식은 아래와 같이 된다.
$
  m dot.double(x) + dv(V, x) = 0
$

여기서, $W = F s$이므로 $-dv(V, x)$는 그냥 힘 $F$이다. 또, $dot.double(x) = dv(x, t, deg: 2)$이므로 그냥 가속도 $a$이다. 그러므로 위 방정식은 아래와 동치이다.
$
  F = m a
$

즉, 최소 작용 원리는 뉴턴 운동 제 2법칙과 정확히 같은 것이다. 이는 최소 작용 원리가 옳다는 것을 증명한다. 라그랑주는 증명#footnote[가상 일을 통한 오일러-라그랑주 방정식과 뉴턴 운동 제 2법칙의 동치 증명]을 통해 뉴턴 역학과 동일한 또 다른 방법인 라그랑주 역학을 창시하게 되었다. 오일러는 이에 대해 이런 말을 남겼다.

_"How satisfied would not be Mr. Maupertuis be, were he still alive, if he could see this principle of least action applied to the highest degree of dignity to which it is susceptible.#footnote[만약 모페르투이 씨가 살아 계셨다면, 최소 작용 원리가 그것이 오를 수 있는 최고 존엄에 적용된 것을 보고 얼마나 만족스러워하겠는가.]"_

이것은 또한 뉴턴이 얼마나 대단한지도 새삼스럽게 다시 느끼게 한다. 하지만, 최소 작용 원리는 여기서만 적용되는 것이 아니다. 빛이 최소 시간 경로를 따른다는 페르마의 원리와 그에 따른 스넬 법칙도 결국 최소 작용 원리의 특별한 경우이다. 스넬 법칙은 아래와 같은데,
$
  (sin theta_i) / (sin theta_r) = n_r / n_i
$
($theta_i, theta_r$는 입사각과 굴절각, $n_r, n_i$는 두 매질의 굴절률)
이는 페르마의 원리인 아래 식으로부터 유도할 수 있다.
$
  delta integral (dif s) / v = delta integral n dif s = 0 wide because n = c / v
$

이처럼, 물체의 운동부터 빛의 진행까지 모든 것을 하나의 원리로 설명할 수 있게 된다.

== 확장 예시

이것은 모든 것의 이론(Theory of Everything)#footnote[자연의 네 가지 힘을 하나로 통합하여 설명하려는 이론]에서 중요한 비중을 차지하기도 하는데, 상대성 이론, 전자기학 등에도 적용하려는 시도가 있고, 꽤 유효(legit)하다.

라그랑주 역학을 기반으로 해밀턴은 해밀턴 역학을 창시했다. 그 근본은 라그랑지언과 비슷한 해밀토니언을 정의하는 것으로 시작한다. 일반화 좌표계에서 일반화 운동량은 아래와 같은데,
$
  p_i equiv pdv(L, dot(q)_i)
$
해밀토니언은 $p_i$를 변수로 인정하여 라그랑지언의 르장드르 변환으로 정의된다.
$
  cal(H) (q_i, p_i, t) equiv sum_i p_i dot(q)_i - L(q_i, dot(q)_i, t)
$
특정 조건에서#footnote[퍼텐셜 에너지가 시간과 속도에 의존하지 않고, 입자의 좌표와 일반화 좌표 간 변환식이 시간에 의존하지 않을 때] 해밀토니언은 역학적 에너지와 같게 된다. 해밀턴 역학은 현대 물리의 근간이 되는데, 해밀턴 역학의 오일러-라그랑주 방정식 정도의 위치를 가지는 해밀턴-야코비 방정식을 유도하는 과정에서도 최소 작용 원리가 사용된다.

해밀턴-야코비 방정식은 아래와 같은데,
$
  pdv(S, t) + cal(H) = 0
$
이 또한 $delta S = 0$에서 비롯한다. 해밀토니언의 정의 $cal(H) = p_i dot(q)_i - L$을 이용하면 작용은 아래 꼴로도 나타낼 수 있다.
$
  S = integral p dif q
$

양자역학에서 최소 작용 원리는 사실 깊게 들어갈 것도 없는데, 플랑크 상수(Planck constant) $h$는 다름 아닌 작용의 양자(quantum of action)이고, 디랙 상수(reduced Planck constant, Dirac constant) $hbar$는 $h / (2pi)$로 각운동량의 양자가 된다. 즉, $S ~ h$일 때, 양자역학적 효과가 유의미해진다는 것이다.

드브로이(De Broglie) 물질파의 파동성은 아래와 같다.
$
  lambda = h / p
$
이때 작용은 아래와 같고
$
  S = integral p dif q = integral h / lambda dif q
$
한 주기 동안의 경로의 길이가 $lambda$이므로
$
  & S = integral_0^lambda h / lambda dif q = h / lambda dot lambda \
  & therefore S = h
$

또, 파동 함수 위상에 대해서도 비슷한 관계가 있다.
$
  psi = A e^(i(vb(upright(k)) dot vb(upright(r)) - omega t))
$
이때 아래가 성립한다.
$
  & vb(upright(k)) = p / hbar \
  & vb(upright(k)) dot vb(upright(r)) = (p dot r) / hbar \
  & S = p dot r = integral p dif q
$


== 직접 해보기

수업시간에 배운 단진동(단순 조화 진동, simple harmonic oscillator)에 대해서도 사전지식에서 해봤던 것과 똑같이 해보면,

먼저 탄성력은 훅의 법칙(Hooke's Law)으로 표현된다.
$
  F = -k x
$

일반화 좌표는 평형점으로부터의 거리 $x$, 일반화 속도는 $dot(x) = dv(x, t)$로 두자.

이때 라그랑지언은 아래와 같다.
$
  L = T - V = 1 / 2 m dot(x)^2 - 1 / 2 k x^2
$

오일러-라그랑주 방정식에 대입하면 아래와 같다.
$
  dv(, t) pdv(L, dot(x)) - pdv(L, x) = 0
$

각 항을 순차적으로 계산해 보면, 첫째 항은
$
  pdv(L, dot(x)) = m dot(x) \
  dv(, t) pdv(L, dot(x)) = m dot.double(x)
$

둘째 항은
$
  pdv(L, x) = - k x
$

즉 아래와 같이 정리된다.
$
  m dot.double(x) + k x = 0 \
  dot(x) + k / m x = 0
$
이는 알려진 단진동 미분 방정식과 일치한다. 당연히 뉴턴 운동 방정식인 $F = m a$에 대입하여 아래와 같이 찾을 수도 있다.
$
  m a = m dot.double(x) = - k x
$

이때 조화 진동자의 표준형 $dot.double(x) + omega^2 x = 0$에 따라 각진동수 $omega$는 아래와 같다.
$
  omega = sqrt(k / m) = 2 pi f
$
또, 일반해는 아래와 같은데,
$
  x(t) = A cos(omega t + phi)
$
검증하기 위해 꼴을 맞춰 이계 미분하면,
$
  dv(, t, deg: 2) [A cos(omega t + phi)] = - omega^2 A cos(omega t + phi)
$
가 되므로 $omega^2 = k / m$이 되어야 함을 알 수 있다.

= 느낀 점

본래 탐구 계획에서 다른 물리량과의 연관성을 탐구하겠다고 했는데, 작용의 정체를 알게 된 지금, 작용은 수많은 물리량과 물리학 이론의 근간에 있는 가장 근본적인 양이기 때문에 거의 모든 물리량과 연관이 있게 된다.

증명과 발전 과정에서 쓰인 라그랑지언과 해밀토니언은 물론이고, 운동 에너지와 퍼텐셜 에너지 등등에도 관련이 있게 된다. 사실 이러한 것을 논할 필요가 없는 것이, 최소 작용의 원리가 자연이 작동하는 가장 중요한 메커니즘 중 하나이기 때문이다.

하지만 조금의 여지를 남겨 두고 특별히 처음 의문을 들게 한 $m s$와 함께 생각을 해보도록 노력하면, $m s$는 본래 운동량 보존 실험에서는 속도의 측정이 어려워 운동량을 바로 구할 수 없으니, 속도에 비례하는 값인 변위로 대체한다는 의미에서 사용하게 되었다.

하지만 이 값에 속도만 곱하게 되면, 또는 운동량에 변위만 곱하게 되면 갑자기 자연의 합리성을 가장 원론적으로 묘사하는 엄청난 물리량이 되어버린다. $m v s$에 특별한 것이 있는 것인가, 너무도 당연하게 배워 중요하지 않게 생각했던 기초적 물리량들이 사실은 가장 특별하고 중요했던 것인가? $m v s$와 $T-V$를 보면 연상되는 물리량들을 하나씩 곱씹어보고 있자니 답은 후자에 가까운 것 같다.

질량, 물체가 함유하는 양이다. 사실 물체 그 자체를 하나의 물리량으로 나타내야 한다면 바로 질량이 될 것이라고 생각했다.

속도, 시간에 따른 위치 변화이다. 물체가 "운동"하고 있다는 증거가 되고, 물체와 함께 운동의 중요한 요소이다.

운동량, 질량과 속도의 곱이다. 사실 이보다 더 정확한 정의는 물체의 운동 상태 자체를 나타내는 물리량일 것이다. 질량이 없는 빛과 같은 물체도 운동량은 갖는다. 운동량은 힘의 시간 미분이고, 힘은 변화를 유발하는 요인이며, 그 힘의 효과는 가속도로 나타난다.

그리고 항상 간과하지만 항상 등장하는 것, 시간과 위치, 즉 시공간이다. 당연하게도 모든 사건은 시공간 상에서 일어나고 있다.

무엇 하나 중요하지 않은 것이 없다. 그래도 의문은 풀리지 않는다. 왜 하필 질량과 속도와 변위의 곱인가? 왜 하필 운동 에너지와 퍼텐셜 에너지의 차의 시간 적분인가? 이렇게 직관적 이해를 요구하는 질문은 짧은 물리적 식견을 가지고는 단순히 적분 식들을 이리저리 가지고 노는 것만으로는 해결되지 않는 것 같다. 이런 면에서 모페르투이는 수학적으로 엄밀하지는 못했어도 처음 이러한 발상을 떠올렸다는 것은 매우 대단하다고 생각된다.

다소 장황해 보이는 이 보고서는 사실상 작용의 역사를 그 진술과 함께 찾아보고, 적분 식을 만져서 이미 누군가가 증명하고 유도해놓은 식과 원리를 재확인한 것밖에는 없다. 하지만 이 과정을 거치며 계속해서 신기하고 아름답다고까지 느껴질만한 사실들을 알게 되며, 새 발의 피겠지만 고전 역학의 정수에 발을 담갔다가 온 느낌이었다. 이런 기분은 $e^(i pi) + 1 = 0$ 이후로 거의 처음인 듯하다.

작용에 대해 알아보며 등장했지만 대충만 이해하고 넘어가 자세히 알아보지 못한 개념(르장드르 변환, 크로네커 델타, 사루스 법칙, 델 연산자 4개 등등...)들은 다음 기회에...
