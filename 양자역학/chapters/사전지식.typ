#import "../../TypstTemplate/TypstTemplate.typ": *

= 시작하기 전에
앞으로 등장할 개념과 수학적 기반을 이해하기 위한 사전 지식들입니다.

== 양자란?
양자(量子), 영어로는 quantum. 복수로는 quanta입니다. quantity에서 유래했고, 한자로도 양과 관련있는 무언가인 것 같습니다.

#definition(title: [양자])[
  물리량의 최소 단위
]

양자는 \~자로 끝나서 무슨 입자인가 싶으실 수도 있겠지만, 정의는 어떤 물리량의 최소 단위입니다. 즉, 양자라는 개념은 실질적이기보다는 추상적, 관념적인 것입니다. 어떤 것이 '양자화(quantized)' 되었다는 것은 특정 물리량이 더 이상 분해될 수 없는 기본 단위가 있다는 것으로, 양자역학의 범위에 들어왔다는 것, 양자역학의 언어로 표현된다는 것 정도가 됩니다.

이 정의를 보면 어느 정도 과학적 사고가 전개되시는 독자들은 의문이 들겁니다.

#emph-box()[
  1. 아날로그 세상은 연속적이라 물리량에는 최소 단위가 없는 것 아닌가?
  2. 최소라고 하는데, 얼마나 작은 것인가? 분자? 원자? 핵자? 쿼크??
  3. 각주로 달리는 것은 부연 설명 또는 참고 용도이므로 일단 이해할 수 없다면 넘겨도 좋습니다.
]

먼저, 양자역학에서 확실한 것은 없습니다. 심지어 그 이론 자체도 확실하게 증명되어 있지 않아요. 사실, 대부분의 논리는 추측에 가까운 과정으로 전개되었습니다. 양자역학에서 가장 기본적인 가정은 '양자화 이론'이 아니라 '양자화 가설(hypothesis of quantization)'입니다.

나머지 양자역학 이론들은 이 양자 가설을 기반으로 쌓아 올려졌습니다. 언제든지 모순이 발생할 수 있다는 것입니다.

그럼에도 양자 가설을 채택하는 이유는, 실제 관측 결과, 실제 현상을 너무 잘 설명하기 때문입니다. 일부 이론들에서 리만 가설을 참이라고 가정하는 것과 비슷한 것입니다. 대부분의 식들도 합리적인 추측과 비슷한 과정을 통해 도출된 것이 많습니다. 이런 걸 postulate(가정)라고 합니다.

아직까지는 의문이 많이 생길 것인데, 정확한 것은 더 자세한 내용이 등장할 때 설명하도록 하겠습니다.

== 수학적 기반

=== 미적분 표기법에 대하여
$f(x)$를 $x$에 대해 미분했을 때, 우리는 보통 이렇게 표현하고는 합니다.
$
  f'(x) = dv(, x) f(x)
$

여기서 $f'(x)$는 라그랑주(Joseph Louis Lagrange)의 표기법입니다. $dif$를 사용하는 표기#footnote[여러 곳에서 표기를 $display((d y) / (d x))$와 같이 하지만, 사실 $dif$를 연산자로 본다면 정확한 표기는 기울이지 않고 $display(dv(y, x))$로 하는 것이 맞습니다.]는 라이프니츠(Gottfried Wilhelm von Lebniz)의 표기입니다. 참고로, 뉴턴(Isaac Newton)은 시간 $t$에 대한 미분을 $dot(f)$와 같이 표기했습니다#footnote[뉴턴은 뉴턴 역학을 정립하는 과정에서 미적분을 발명했습니다.].

이계도함수는 각 표기법에 따라 표현하면 아래와 같습니다.
$
  "라그랑주": f ''(x) wide "라이프니츠:" dv(, x, 2) f(x) wide "뉴턴:" dot.double(f)
$

라이프니츠는 처음에, 미분계수를 아래와 같이 무한소의 분수로 나타낼 수 있다고 했습니다#footnote[$dif x$는 $x$의 무한소인 반면, $difference(x)$는 $x$의 증분으로 유한소입니다.].
$
  lim_(difference(x) -> 0) (f(x + difference(x)) - f(x)) / difference(x) = lim_(difference(x) -> 0) difference(y) / difference(x) = dv(y, x)
$
그의 주장에 모호한 부분이 있었지만, 여전히 여러 상황에서 이들은 분수와 같이 행동한다는 점, 그리고 특히 다변수 상황에서 미적분 연산을 명확하게 표시할 수 있다는 점에서 현재까지 분수가 아닌, 미적분 연산 자체에 대한 표기로서 널리 사용되고 있습니다.

$dif y \/ dif x$를 읽을 때는, 이것이 분수가 아니기 때문에 '$dif x$ 분(分)의 $dif y$'가 아니라 '$dif y$ $dif x$'라고 읽습니다.

그런데, 수학적으로 엄밀히 들어가면 사실 이것은 분수가 맞습니다! 다만, $dif x$ 등은 일반적인 수가 아니라 미분 형식(differential form)입니다. 하지만 이 정의와 논증은 미분기하학과 선형대수학 등의 이해를 수반해야하므로, 여기서 다루기에는 너무 복잡하니 넘어가겠습니다.

적분 표기도 라이프니츠의 것을 따릅니다. $f(x)$를 $x$에 대해 적분할 때, 아래와 같이 표기하죠.
$
  integral f(x) dif x
$

이것은 사실 구분구적법에 따라 아래와 같습니다.
$
  lim_(difference(x) -> 0) sum_i x_i difference(x)
$

=== 편미분
편미분(偏微分, partial derivative)은 대상으로 하는 문자 외에 나머지 항들을 모두 상수로 취급하고 미분하는 방법입니다.

백문(百聞)이 불여일견(不如一見), 직접 봅시다.

$
  f(x,y) := x^2 + y^2 -r^2
$

이 함수를 $x$에 대해 일반적으로 미분하면 다음과 같습니다.
$
  dv(f, x) = 2x + 2y dot y'
$

하지만 이를 $x$에 대해 편미분하면 다음과 같습니다.
$
  pdv(f, x) = 2x
$

이때 $partial$은 편미분 기호로, partial, round, partial d, round d, del#footnote[델 연산자($nabla$)와 혼동 가능성이 있습니다. ] 등 여러 가지로 부릅니다. 이 책에서는 명칭 언급이 필요한 경우 partial로 통일하겠습니다.

이 원리를 적용해, $f(x,y)$를 $x$에 대해서 미분하는 과정을 다시 써보면 다음과 같습니다.

$
  dv(f, x) = pdv(f, x) + pdv(f, y) dv(y, x)
$

이 원리에 따라, 아래와 같은 식이 성립합니다.
$
  dif f(x,y,z) = f_x dif x + f_y dif y + f_z dif z wide "where " f_u = pdv(f, u)
$

이때, $dif f$를 $f$의 전미분(全微分, total derivative)이라고 합니다. 이것을 확장시켜 엄밀히 정의한 것이 미분 형식입니다.

=== 연산자
연산자(operator)란 특정한 항에 연산을 작용하는 것입니다. 사실 이것은 수학적으로 올바른 정의는 아닙니다#footnote[광의(廣義)로, 연산자란 정의역과 공역이 동일한 함수입니다.]. 우리가 가장 잘 아는 연산자는 사칙연산의 기호들입니다.
$
  3 + 2 = 5
$
위 식에서 +가 바로 연산자 입니다. +는 앞의 항과 뒤의 항, 두 개의 항을 피연산항으로 가집니다. 이런 것을 이항 연산자(binary operator)라고 합니다. 이것을 우리에게 익숙한 함수 꼴로 굳이 나타내면 아래와 같습니다.
$
  +: CC times CC --> CC \
  +(3, 2) = 5 quad <- "(이 표기는 수학적으로 부정확합니다.)"
$

다른 대표적인 연산자로는 미분 연산자가 있습니다. 별게 아니고, 갖다 붙이면 미분하라는 뜻이 됩니다.
$
  D := dv(, x)
$
위와 같이 정의한다면, $D f$는 $f$를 $x$에 대해 미분하라는 뜻이 되겠습니다. 미분 연산자는 덧셈과 달리 피연산항이 하나밖에 없습니다. 양자역학에서 등장하는 연산자는 대부분 피연산항이 하나밖에 없을 것입니다. 연산자라는 것을 표시하기 위해 $hat(x)$와 같이 문자 위에 $\^$를 찍어 나타냅니다. $hat(x)$는 $x$ hat 이라고 읽습니다. 예를 들어, 운동량 연산자는 아래와 같습니다.
$
  hat(vbu(p)) = hbar / i grad = -i hbar grad
$

아직 각 기호의 의미는 몰라도 됩니다. 지금은 이것이 파동함수라는 어떤 상태 함수에 작용하여 운동량을 알아내는데 쓰인다는 것 정도만 대충 알면 될 것 같습니다.

=== 디랙 표기법
디랙(Paul Dirac)이 고안한 브라-켓 표기법(bra-ket notation)은 벡터를 표기하는 새로운 방법입니다. 이름의 유래는 $angle.l angle.r$(bracket)를 반으로 잘라서 $angle.l$를 bra, $angle.r$를 ket이라고 하는데서 왔습니다.

먼저, 우리가 아는 벡터 표기법은 아래와 같습니다. 굵은 글씨로 쓰는 것은 위에 화살표를 쓰는 것보다 가독성이 좋다는 장점이 있으며, 기울일지 바로 세울지는 정해져 있지 않습니다.
$
  va(v) = vb(v) = vbu(v)
$
켓을 사용한 표기는 아래와 같습니다.
$
  va(v) = ket(v)
$

브라는 일종의 연산자로서, 옆에 오는 항과의 내적(inner product, dot product)을 의미합니다.
$
  va(v) dot {} = innerproduct(vbu(v), {}) = bra(v)
$

어떤 벡터가 브라에 결합하면 아래와 같이 됩니다.
$
  bra(a) ket(b) = braket(a, b) = vbu(a) dot vbu(b)
$

이러한 브라-켓 표기법으로, 힐베르트 공간의 원소인 벡터를 통해 양자 상태를 $ket(psi)$처럼 표현하게 됩니다. 이것에 대한 이야기도 나중에 자세히 하겠습니다.

=== 좌표계

==== 직교 좌표계
#figure(image("../Descartes_system_3D.svg", width: 30%))

데카르트 좌표계(Cartesian coordinate system)이라고도 합니다 .가장 간단하고 직관적인 좌표계이죠. 3차원에서는 원점과 $x, y, z$ 축이 주어지면 다음과 같이 한 점 $"P"$의 좌표를 유일하게 특정할 수 있습니다.
$
  "P"(x, y, z)
$

변수의 범위는 당연히 다음과 같죠.
$
  -oo < x, y, z < +oo
$

==== 원통 좌표계
영어로는 cylindrical coordinate system 입니다.
#figure(image("../Cylindrical_Coordinates.svg", width: 30%))

특정한 점 P를 경계에 포함하는 원통을 생각해보면, 인수 세 개로 점을 나타낼 수 있습니다. 원통의 반지름 $rho$, $x$ 축과의 편각 $phi$, 높이 $z$만 있으면 됩니다.
$
  "P"(rho, phi, z)
$

이 좌표계는 사실 2차원 극좌표계(polar coordinate system)를 $z$축에 대해서만 쌓아 올린 것입니다. 즉 $(x,y,z$는 $(rho, phi, z)$로 아래와 같이 나타낼 수 있습니다.
$
  x = rho cos phi \
  y = rho sin phi \
  z = z
$
반대로도 해보면 아래와 같습니다.
$
  rho = sqrt(x^2 + y^2) \
  phi = arctan y / x \
  z = z
$

변수의 범위는 다음과 같습니다.
$
  0 <= rho < oo \
  0 <= phi < 2pi \
  -oo < z < +oo
$

==== 구면 좌표계
#figure(image("../Spherical_Coordinates.svg", width: 30%))
영어로는 spherical coordinate system입니다. 특정한 점 P는 반지름 $rho$, $z$ 축과의 편각 $theta$, $x$축 과의 편각 $phi$로 표현될 수 있습니다.
$
  "P"(rho, theta, phi)
$
각 변수를 $(x, y, z)$를 $(rho, theta, phi)$에 대해 나타내 봅시다.
$
  x = rho sin theta cos phi \
  y = rho sin theta sin phi \
  z = rho cos theta
$
반대로도 해봅시다.
$
  rho = sqrt(x^2 + y^2 + z^2) \
  theta = arctan sqrt(x^2 + y^2) / z \
  phi = arctan y / x
$

변수의 범위는 아래와 같을 겁니다.
$
  0 <= rho < +oo \
  0 <= theta <= pi \
  0 <= phi < 2pi
$

$theta$와 $phi$가 함께 회전하므로 $theta$는 180#sym.degree 범위로 충분하겠죠.

=== 델 연산자
델(del) 연산자는 이렇게 $nabla$ 역삼각형 모향으로 생겼습니다. 이 기호 자체는 나블라(nabla)라고 하고, 하프 모양에서 따왔다고 합니다.

네 가지가 있는데, 종류는 아래와 같습니다.
$
  "Gradient": & grad \
  "Divergence": & diver \
  "Curl": & curl \
  "Laplacian": & lapl
$
델 연산자는 벡터이기 때문에, 단순히 $nabla$ 외에도 $va(upright(nabla))$ 또는 $grad$로 표기합니다.

divergence와 curl의 $dot$ (dot product)와 $times$ (cross product)는 벡터의 내적과 외적을 의미합니다. 연산을 더 자세히 알아보기 위해 $f$를 스칼라 함수, $vbu(A)=(A_x, A_y, A_z)$라고 합시다. 이때 네 가지 연산은 다음과 같습니다.
$
  grad f = (dv(f, x), dv(f, y), dv(f, z))
$
$
  diver vbu(A) = dv(A_x, x) + dv(A_y, y) + dv(A_z, z)
$
$
  curl vbu(A) = matrixdet(
    hat(i), hat(j), hat(k);
    dv(, x), dv(, y), dv(, z);
    A_x, A_y, A_z
  )
  = (dv(A_z, y) - dv(A_y, z), dv(A_x, z) - dv(A_z, x), dv(A_y, x) - dv(A_x, y))
$
$
  lapl f = dv(f, x, 2) + dv(f, y, 2) + dv(f, z, 2)
$

$x, y, z$는 각각 독립된 변수이기 때문에 편미분을 쓰지 않아도 상관없지만 앞으로 혼동을 피하기 위해 편미분으로 재정의합시다.
$
  grad = (pdv(, x), pdv(, y), pdv(, z))
$

// 이것을 예를 들어 원자와 같은 곳에 적용하려면 구면 좌표계로의 변환이 필요합니다. 그래서 델 연산자를 원통 좌표계와 구면 좌표계에 대해 변환해 봅시다.

=== 오일러 항등식
수학에 관심이 있는 독자들이라면 한 번쯤은 보았을 식입니다.
$
  e^(i x) = cos x + i sin x
$ <cisx>
$
  e^(i pi) + 1 = 0
$ <eipi1->

@eipi1- 은 "오일러 공식"이라고 불리며 아름다운 수학적 결론으로는 훌륭하지만, 물리에서는 그 원형인 오일러 항등식[@cisx]에 더 관심이 있습니다.

$cos$과 $sin$으로 파동을 표현할 수 있으면서도 $e^x$의 성질에 따라 미분이 편리하고 특정 상황에서는 전기장과 자기장의 진행을 실수부와 허수부로 동시에 나타낼 수 있다는 점에서 장점이 많아 널리 이용됩니다.

간단히 증명해보도록 하겠습니다.

먼저, $cos theta + i sin theta$는 복소평면(complex plane)에서의 극형식(polar form)이라고 합니다. 편각(argument) $theta$를 매개변수로 받아 복소평면 위의 점 $x + y i$를 나타내기 때문입니다. 이때, $x = cos theta, y = sin theta$입니다. 이상을 정리하면 다음과 같습니다.

#theorem(title: "오일러 항등식")[
  $
    & z := x + y i wide "where" x, y in RR, space i = sqrt(-1) \
    & arg z =: theta
  $
  $
    & x = cos theta \
    & y = sin theta \
    therefore & z = cos theta + i sin theta
  $
]

#proof[
  $
    z = cos theta + i sin theta
  $
  $z$가 $theta$에 따라 변하므로 이 값을 함수 $f(theta)$라고 합시다. 이제 이 함수에 대해 알아보기 위해 먼저 $theta$에 $x+y$를 대입해 봅시다.

  $
    f(x+y) =& cos(x+y) + i sin(x+y) \
    =& cos x cos y - sin x sin y + i(sin x cos y + cos x sin y) \
    =& cos x (cos y + i sin y) + sin x (i cos y - sin y) \
    =& cos x (cos y + i sin y) + sin x (i cos y + i^2 sin y) \
    =& cos x (cos y + i sin y) + i sin x (cos y + i sin y) \
    =& (cos x + i sin x)(cos y + i sin y)\
    =& f(x)f(y)
  $
  $
    therefore f(x+y) = f(x)f(y)
  $ <ciscauchy>

  또, $f(0)=1 + 0 i = 1$입니다.

  그런데, $f(x)$는 @ciscauchy 이고 $f(0)=1$이며, $cos$과 $sin$은 여각 관계이므로 모든 실수 $x$에 대해서 $f(x) !=0$이므로, 코시 함수 방정식에 의해 $f(x)$는 지수함수입니다.
  $
    cos x + i sin x = c^x wide "where " c != 0
  $

  양변을 미분하면 아래와 같습니다.
  $
    c^x ln c = -sin x + i cos x
  $

  이 식은 $x$에 대한 항등식이 되므로, $x=0$을 대입하면
  $
    ln c = i quad therefore c = e^i
  $
  $
    therefore e^(i x) = cos x + i sin x
  $
]

또, 테일러 급수로도 이것이 성립함을 쉽게 확인할 수 있습니다.
$e^x$의 테일러 급수가 아래와 같으므로
$
  e^x =^"Tayl." sum_(n = 0)^oo (x^n) / n!
$
그러므로 $e^(i x)$의 테일러 전개식은
$
  e^(i x) =^"Tayl." sum_(n=0)^oo (i x)^n / n = 1 + i x - x^2 / 2! - i x^3 / 3! + x^4 / 4+...
$ <cistayl>

그런데, $cos x$와 $sin x$의 테일러 전개식은 아래와 같습니다.
$
  cos x =^"Tayl." 1 - x^2 / 2! + x^4 / 4! - x^6 / 6! + ...
$ <costayl>
$
  sin x =^"Tayl." x - x^3 / 3! + x^5 / 5! - x^7 / 7! + ...
$ <sintayl>

@sintayl 에 $i$만 곱해 @costayl 과 더하면 @cistayl 과 같습니다.

== 확률 기본
양자역학의 확률 해석 때문에, 확률을 다룰 줄 아는 것은 중요합니다. 조금 쉬운 부분으로 가 봅시다.

이 부분의 내용은 David J. Griffiths와 Darrel F. Schröter의 \<Introduction to Quantum Mechanics> 3판에서 가져왔습니다.
=== 이산 변수
먼저, 불연속적인, 즉 이산(離散, discrete)적인 변량을 다루어 봅시다.

한 방에 나이별로 사람이 아래와 같이 있다고 합시다.
#figure(
  table(
    align: center + horizon,
    columns: 2,
    [나이 (세)], [사람 수 (명)],
    [14], [1],
    [15], [1],
    [16], [3],
    [22], [2],
    [24], [2],
    [25], [5],
  ),
)
$N(j)$를 나이 $j$ 세의 사람 수라고 정의한다면, 다음과 같이 표현할 수 있습니다.
$
  N(14) = 1\
  N(15) = 1 \
  N(16) = 3 \
  N(22) = 2 \
  N(24) = 2 \
  N(25) = 5
$
또, $N(18), N(19)$ 등은 0입니다.

방 안에 있는 전체 사람 수는 이렇게 구할 수 있습니다.
$
  N_"Total" = sum_(j=0)^oo N(j)
$

나이 $j$ 세일 사람이 방에 있을 확률을 $P(j)$라고 한다면 아래와 같습니다.
$
  P(j) = N(j) / N_"Total"
$

또, 대푯값들을 살펴보면, 최빈값(最頻값, mode)은 25, 중간값(median)은 23, 평균(average, mean)은 21입니다. 여기서, 평균은 아래와 같습니다.
$
  expval(j) = (sum j N(j)) / N = sum_(j=0)^oo j P(j)
$
양자역학에서는 최빈값, 중간값보다는 모든 변량을 반영하는 평균에 관심이 있고, 이러한 맥락에서는 평균을 기댓값(expectation value)라고 합니다. 기댓값이라는 말은 나올 확률이 가장 높은 값이라는 말인데, 실제로 21살인 사람은 이 방에 없으므로 오해의 소지가 있는 용어이긴 합니다.

하지만 기댓값만으로 전체 변량을 대표하기에는 아직 한계가 있습니다. 평균은 같지만 고르게 분포한 것과 한 쪽에 좁게 분포한 것에는 분명히 차이가 있기 때문입니다. 그래서 각 변량이 평균으로부터 얼마나 떨어져 있는지를 구해 보겠습니다.
$
  difference(j) = j - expval(j)
$
이 값을 편차(deviation)이라고 합니다. 그럼 이제 편차의 평균을 구하면 되겠네요? 좋습니다.
$
  expval(difference(j)) &= sum (j - expval(j))P(j) = sum j P(j) - expval(j) sum P(j) \
  &= expval(j) - expval(j) = 0
$
그 값이 \... 0이 나온다는 것 빼고요. 그러면 어떡해야 할까요? 절댓값을 취하면 되려나요? 절댓값은 양수, 음수 두 가지 경우로 나뉘기 때문에 계산이 복잡해질수록 더 다루기 번거로워집니다. 그래서 제곱을 한 후 평균을 구해 봅시다.

$
  expval((difference(j))^2) =: sigma^2
$
이 값을 분산(variance)라고 하고, 이는 표준편차(standard deviation)의 제곱입니다. 보통 앞글자 s의 그리스 문자인 $sigma$로 표현합니다. (표준편차는 변량 빼기 평균의 제곱의 평균의 제곱근이 됩니다. 헉!#footnote[원본 책을 존중하여 재미있는 문장을 그대로 넣었습니다.])

표준편차를 좀 더 쉽게 구하는 방법이 없을까요?

$
  sigma^2 &= expval((difference(j))^2) = sum (difference(j))^2 P(j) = sum (j - expval(j))^2 P(j) \
  &= sum (j^2 - 2j expval(j) + expval(j)^2) P(j) \
  &= sum j^2 P(j) - 2 expval(j) sum j P(j)+ expval(j)^2 sum P(j) \
  &= expval(j^2) - 2 expval(j) expval(j) + expval(j)^2 \
  &= expval(j^2) - expval(j)^2
$

즉, 분산은 $"(제곱의 평균)" - "(평균의 제곱)"$이 됩니다.
$
  sigma equiv sqrt(expval(j^2) - expval(j)^2)
$ <sdeq>

$sigma in RR$이므로 @sdeq 은 다음을 암시하기도 합니다.
$
  expval(j^2) >= expval(j)^2 wide "(등호 성립 조건: " sigma = 0")"
$
$sigma = 0$이라는 것은 모든 변량이 같다는 것이겠죠.

=== 연속 변수
이제 연속적인 변수를 다루어 봅시다. 이산 분포에서는 $j in ZZ$였기 때문에 불연속적인 특정 값을 잡았어야 했습니다. 하지만, 연속 분포는 그렇지 않습니다. 예를 들어, 길에서 아무나 잡았을 때, 그 사람의 나이가 정확히 16세 35일 4시간 27분 3.333...초일 확률은 0 입니다. 그러므로 우리는 범위를 잡아서 확률을 따져야 합니다. 이 사람의 나이가 16세에서 17세 사이일 확률 같은 것 말이죠.

길에서 잡은 사람의 나이가 0살일 확률은 0입니다. 모든 사람이 150살에는 죽는다고 가정할 때, 예를 들어 0살에서 10살을 만날 확률보다는 0살에서 50살을 만날 확률이 더 높습니다. 0살에서 150살을 만날 확률은 1이 되겠죠.

이 '누적 확률'을 나타낸 함수를 누적 분포 함수(CDF, cumulative density function)이라고 하고, 이것을 미분한 것이 확률 밀도 함수(PDF, probability density function)가 됩니다. 이 PDF를 $"PDF"(x)$라고 할 때, 변량이 $x$와 $x + dif x$ 사이에 분포할 확률은 다음과 같습니다.
$
  "PDF"(x) dif x
$
이를 더 세련된 용어로 확률 밀도라고 하는 것입니다. $a$와 $b$ 사이의 확률 밀도는 아래와 같습니다.
$
  P_(a b) = integral_a^b "PDF"(x) dif x
$

당연히 아래도 성립해야 합니다.
$
  integral_(-oo)^(+oo) "PDF"(x) dif x = 1
$
$
  expval(x) = integral_(-oo)^(+oo) x "PDF"(x) dif x
$
$
  expval(f(x)) = integral_(-oo)^(+oo) f(x) "PDF"(x) dif x
$
$
  sigma^2 equiv expval((difference(x))^2)= expval(x^2) - expval(x)^2
$

== 상태 함수 $psi$
$psi$는 상태 함수(state function) 또는 파동함수(wave function)로, 어떤 입자의 분포 등의 정보를 포함하고 있는 함수입니다. 상태 벡터(state vector)이기도 하므로, $ket(psi)$처럼 쓰기도 합니다. 파동함수는 그 자체로는 아무 물리적 의미도 없습니다. 대신, $psi$에 그 켤레 복소수(conjugate)를 곱하면 PDF가 나옵니다#footnote[$abs(a+b i) = sqrt(a^2 + b^2)$].
$
  "PDF" = psi^*psi = abs(psi)^2
$

예를 들어 $psi(x, t)$는 위치 $x$와 시간 $t$에서 입자가 발견될 확률을 나타낼 수 있습니다.

따라서 아래가 성립합니다.
$
  integral_(-oo)^(+oo) abs(psi(x, t))^2 dif x = 1
$

== 슈뢰딩거 방정식

독일의 물리학자 슈뢰딩거(Erwin Schrödinger)가 제안한 파동 방정식으로, 아직 식의 의미는 몰라도 됩니다. 하지만 그 모양 정도는 눈에 담아두면 좋습니다.

$
  hat(E) psi = hat(cal(H), size: #0pt) psi
$

이를 완전히 전개하면 다음과 같이 생기게 됩니다.
$
  i hbar pdv(, t) psi = - hbar^2 / (2m) laplacian psi + V(x) psi
$

이 식의 해는 $psi$가 됩니다.

이 식은 양자역학에서, 뉴턴 역학의 뉴턴 운동 방정식($F=m a$)이라거나, 라그랑주 역학의 오일러-라그랑주 방정식#footnote[$q$는 일반화 좌표, $L$은 라그랑지언일 때 $display(dv(, t) pdv(L, dot(q)) - pdv(L, q) = 0)$]과 비슷한 역할을 가집니다.

Now, Let's dive into the fascinating world of Quantum Mechanics!
