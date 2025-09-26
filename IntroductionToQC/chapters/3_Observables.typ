#import "../template.typ": *

= 관측가능량
이번 장에서는 양자역학의 관측가능량에 대해 알아보겠다.

== 자기 수반 연산자

상태 공간 $V$는 에르미트 내적이 성립하는 복소 벡터공간이었다.

관측가능량(觀測可能量, observable)이란 $V$ 상의 자기 수반(self-adjoint) 연산자 또는, 다른 말로 에르미트(Hermitian) 연산자이다. 직관적인 의미는 말 그대로 측정할 수 있는 양이라는 뜻이며, 가측량(可測量)이라고도 한다.

#definition(title: [자기 수반 연산자])[
  $A: V -> V$인 어떤 연산자 $A$에 대해 다음이 성립하면 $A$는 자기 수반 연산자(에르미트 연산자)이다.
  $
    forall vb(v), vb(w) in V quad braket(vb(v), A vb(w)) = braket(A vb(v), vb(w))
  $

  이때 아래가 성립한다.
  $
    A = A^dagger
  $
] <defSelfJointOperator>

$CC^N$ 상에서 다음과 같은 에르미트 내적을 보자.
$
  braket(vb(v), vb(w)) = overline(vb(v))^TT dot vb(w)
$

또, 다음 연산을 보자.
$
  & braket(vb(v), A vb(w)) = overline(vb(v))^TT dot A dot vb(w) \
  & braket(A vb(v), vb(w)) = overline((A vb(v)))^TT dot vb(w) = overline(vb(v))^TT dot overline(A)^TT dot vb(w)
$

그러므로 @defSelfJointOperator 에서 $A$가 에르미트 연산자이려면 아래가 성립해야 한다.
$
  A = overline(A)^TT = A^dagger
$

이때 $overline(A)^TT$를 $A$의 켤레 전치(conjugate transpose) 또는 에르미트 전치(Hermitian transpose)라고 하며, $A^dagger$라고도 쓴다#footnote[$dagger$는 단검을 본따 만든 기호로, 한국어로는 칼표라고 하며, $A^dagger$는 'A dagger'라고 읽는다.].

#exercise[
  연산자 $A$에 대해 $A$가 에르미트 연산자이려면 $A = overline(A)^TT$가 성립해야함을 엄밀히 증명하여라. $vb(v)$의 기저를 $hat(i)$, $vb(w)$의 기저를 $hat(j)$로 놓으면 위 등식은 $a_(i j) = overline(a_(j i))$와 동치이다.
]

이 연산자 $A$를 실수부와 허수부로 나누자. $B$와 $C$는 실수 행렬이다.
$
  A = B + i C
$

$A$가 에르미트 연산자라면
$
  overline(A)^TT &= overline((B + i C))^TT \
  &= B^TT - i C^TT \
  &=^? B + i C
$
여기서 $=^?$ 등호가 성립해야 한다. 그 조건은
$
  B^TT = B and C^TT = -C
$

그러므로 어떤 행렬의 실수부가 대칭(symmetric, 對稱)행렬이고 허수부가 비대칭(skew-symmetric, 非對稱)행렬이면 그 행렬은 자기 수반 행렬 또는 에르미트 행렬#footnote[반대칭(antisymmetric, 反對稱)행렬이라고도 한다.]이다.

한 가지 예시로 아래를 보자.
$
  A = mat(2, 1+i; 1-i, 3)
$

이 행렬의 실수부를 취하면
$
  mat(2, 1; 1, 3)
$
으로 대칭이고, 허수부를 취하면
$
  mat(0, 1; -1, 0)
$
으로 비대칭이다.

== 자기 수반 연산자의 고윳값과 고유벡터
#definition(title: [에르미트 공간])[
  $CC$ 상의 벡터공간 $V$에 대해 그 공간 상에서 임의의 벡터의 내적이 에르미트 내적이라면 이 공간을 에르미트 공간(Hermitian space)이라고 한다.
]

복소 벡터공간에 길이와 직교를 정의할 수 있도록 한 것이 에르미트 공간이며, 앞서 배운 에르미트 내적의 개념에서 기원한다.

#theorem(title: [자기 수반 연산자의 성질])[
  $A$를 에르미트 공간 $V$ 상의 자기 수반 연산자라고 하자. 이때 다음이 성립한다.
  1. $A$의 모든 고윳값은 실수이다.
  2. 각 고윳값에 대응하는 고유벡터는 서로에 대해 직교한다.
]

#proof[
  1. $vb(v)$가 $A$의 고유벡터라고 하자. 즉, $A vb(v) = lambda vb(v)$이다.
  $
    braket(vb(v), A vb(v)) = braket(vb(v), lambda vb(v)) = lambda braket(vb(v), vb(v))
  $
  이때 $A$는 자기 수반 연산자이므로 다음도 성립한다.
  $
    braket(vb(v), A vb(v)) = braket(A vb(v), vb(v)) = braket(lambda vb(v), vb(v)) = overline(lambda) braket(vb(v), vb(v))
  $
  고윳값의 정의에 따라 $vb(v) != 0$이다. 즉, $braket(vb(v), vb(v))!=0$이다. 이제 아래 등식
  $
    lambda braket(vb(v), vb(v)) = overline(lambda) braket(vb(v), vb(v))
  $
  에 의해 $lambda = overline(lambda)$이므로 $lambda in RR$이다.

  2. $A$의 두 고유벡터 $vb(v), vb(w)$에 대해
  $
    & A vb(v) = lambda vb(v) \
    & A vb(w) = mu vb(v) \
    & "s.t. " lambda != mu and lambda, mu in RR
  $
  일 때,
  $
    braket(vb(v), A vb(w)) & = braket(vb(v), A mu vb(w)) = mu braket(vb(v), vb(w))\ 
    &= braket(A vb(v), vb(w)) = braket(lambda vb(v), vb(w)) = lambda braket(vb(v), vb(w)) \
    => & (lambda - mu) braket(vb(v),vb(w)) = 0 \
    therefore & braket(vb(v), vb(w)) = 0 quad because lambda != mu
  $

  이처럼 임의의 두 고유벡터 간 내적이 0이므로, 각 고유벡터는 대해 직교한다.
]

이해를 위해 빠르게 예시를 보자. 아래 연산자가 있다고 하자.
$
  A = mat(1, i; -i, 1)
$

이 행렬의 고유벡터는
$
  vb(v)_1 = vec(1, i) \
  vb(v)_2 = vec(1, -i)
$
따라서
$
  & A vb(v)_1 = vec(0, 0), quad lambda_1 = 0 \
  & A vb(v)_2 = vec(2, -2 i), quad lambda_2 = 2
$

$A$의 실수부는 대칭이고 허수부는 비대칭이므로 $A$는 자기 수반 행렬이다. 이때 고유벡터는 실수가 아니지만 고윳값 $lambda_1, lambda_2$는 모두 실수이다. 또, 두 고유벡터를 내적하면
$
  braket(vb(v)_1, vb(v)_2) &= overline(vb(v)_1)^TT vb(v)_2 \
  &= vecrow(1, -i) vec(1, -i) = 1 - 1 = 0
$
이므로 고유벡터끼리 직교한다는 것도 알 수 있다. 이로써 정리가 성립함을 확인해 볼 수 있었다.

== 자기 수반 연산자의 스펙트럼 정리
#theorem(title: [자기 수반 연산자의 스펙트럼 정리])[
  유한차원 에르미트 공간 $V$ 상의 자기 수반 연산자 $A$는 대각화할 수 있다.

  $V = {vb(v)_1, ..., vb(v)_N}$에 직교하고 실수 고윳값을 갖는 $A$의 고유벡터가 존재한다.
  $
    & A vb(v)_j = lambda_j vb(v)_j wide "where " lambda_j in RR\
    & braket(vb(v)_j, vb(v)_k) = 0 wide "if " j != k
  $
]

실수 자기 수반 행렬은 대칭행렬이다. 즉, 우리는 $A$ 연산자의 행렬이 실수 대각행렬이 되도록 하는 $V$의 직교 기저를 찾을 수 있다는 뜻이다.

자기 수반 연산자의 성질은 차원의 크기에 관련이 없었지만, 우리가 본 스펙트럼 정리는 유한차원에서만 성립한다는 것이다. 본 과정에서는 유한 차원에 대한 것만 필요하기 때문이다. 하지만 무한차원으로 일반화하여 확장한 스펙트럼 정리도 존재한다. 증명에 대한 것 등 자세한 것은 선형대수학에서 공부하자.

== 브라-켓 표기법
브라-켓(bra-ket) 표기법 또는 디랙(Dirac)#footnote[물리학자 폴 디랙(Paul Dirac, 1902 \~ 1984)의 이름을 땄다. ] 표기법은 양자역학의 공리와 함께 양자역학을 공부할 때 상정하고 들어가는 것 중 하나로, 브라(bra, $bra(bullet)$)와 켓(ket, $ket(bullet)$)을 이용해 벡터와 벡터 연산을 표기하는 방법이다. 이름은 뾰족괄호 $expval(bullet)$을 브라켓(bracket)이라고 하는 것에서 유래했다.

우리는 앞서 벡터의 내적을 이렇게 표기함을 배웠다.
$
  iprod(vb(v), vb(w)) equiv braket(vb(v), vb(w)) = overline(vb(v))^TT dot vb(w)
$

그런데 물리학자들은 이 표기를 반갈죽내서 사용하기로 했다.

$ket(vb(w))$는 우리가 관습적으로 사용하는 일반적인 열 벡터이다.
$bra(vb(v))$는 $overline(vb(v))^TT$로 행벡터이다.

자기 수반 연산자에서 다음이 성립했었다.
$
  braket(vb(v), A vb(w)) = braket(A vb(v), vb(w))
$

이건 곧 
$
  overline(vb(v))^TT dot A dot vb(w) = overline((A vb(v)))^TT dot vb(w) = overline(vb(v))^TT overline(A)^TT vb(w)
$
이라는 뜻이므로, 같은 연산에 대해 표기를 다음과 같이 하기도 한다.
$
  braket(vb(v), A vb(w)) = braket(A vb(v), vb(w)) = braket(vb(v), A, vb(w))
$
연산자 $A$가 양 옆 아무데나 작용할 수 있다는 뜻이다.

== 양자역학에서의 측정
양자계의 속성을 어떻게 측정하여, 물리적인 실험을 진행할 수 있는지 알아보자.

광자의 편광을 복기해 보자. 이 광자의 편광 상태를 어떻게 측정할 수 있을까? 레이저를 쏴서 광자 하나를 진행시킨다고 생각해 보자. 그 진로에는 수직 편광 필터가 놓여있다고 하자. 광자가 이 필터를 통과한다면, 수직 편광된 광자는 필터를 통과하고 수평 편광된 광자는 통과하지 못하고 튕겨나올 것이다. 그런데, 지난번에 광자는 수직이나 수평 편광 상태 이외의 상태들도 가진다고 했었다. 기본 상태가 아닌 상태도 가질 수 있다는 뜻이다.

#let kat = $ket(arrow.t)$
#let kar = $ket(arrow.r)$
광자가 $alpha$의 각도로 편광되어 있다고 하자. 그렇다면 그 편광 상태는
$
  psi = sin alpha kat + cos alpha kar
$

이제 이 광자가 수직 편광 필터로 들어가면 어떻게 될까? 결론적으로, 이 측정의 결과는 확률적이고, 가능한 결과는 두 가지가 있다.
- $sin^2 alpha$의 확률로 필터를 통과한다. 이때 광자는 수직 편광 상태가 된다.
- $cos^2 alpha$의 확률로 필터에서 튕겨나온다. 이때 광자는 수평 편광 상태가 된다.

중요한 것은, 정설로 받아들여지는 코펜하겐 해석에 의하면 광자는 필터에 들어가기 전에는 수직 편광 상태도 수평 편광 상태도 아니었다. 

이 측정의 과정에는 두 가지 중요한 특징이 있다. 첫번째는 측정의 결과는 확률적이라는 것이다. 우리는 한 개의 광자로 측정의 결과를 예측할 수 없으며 그 결과는 상태의 확률에 의해 결정된다. 두번째는 측정은 양자계의 상태를 바꾼다는 것이다. 상태에 변화를 주지 않고 측정하는 것은 근본적으로 불가능하다.

이러한 특징들은 양자컴퓨팅을 매우 어렵게 만든다. 어떤 정보가 나올지 알 수 없으며, 그것을 알기 위해 측정을 하면 그 정보는 이미 변형되어서 전에는 어떤 정보가 저장되어 있었는지 알 수 없게 된다. 즉, 측정은 아껴서, 그리고 신중하게 사용해야하는 것이다. 양자 알고리즘의 경우, 알고리즘의 맨 마지막 부분에서 한 번만 측정하는 것이 일반적이다.

실제로는 광자 하나를 쏘기가 쉽지 않다. 그것보다는 레이저 빔을 쏴서 광자의 흐름을 만드는 것이 낫다. 그러면 우리는 수많은 측정 결과를 얻을 것이며, 큰수의 법칙에 따라 통계적 확률이 수학적 확률에 근접할 것이다. 여기서 갈라져 나오는 레이저 빔의 세기나 광자의 개수 등을 측정하여 편광 상태의 확률을 알아볼 수 있다.

이제 전자의 스핀을 측정하는 것에 대해 얘기해 보자. 전자의 스핀을 측정하는 방법으로는 전자를 강한 자기장 속에 놓고(이 자기장은 연직 위 방향이라고 하자) 그곳에 전자 빔(음극선)을 쏘는 것이다. 그러면 빔이 자기장에 들어갈 때 두 갈래로 나뉘게 된다. 위로 갈라진 빛은 위쪽 스핀을, 아래로 갈라진 빛은 아래 스핀을 가진 전자로 이루어진다. 이때 상태는 다음과 같다.

#let katx = $ket(scripts(arrow.t)_x)$
#let kabx = $ket(scripts(arrow.b)_x)$
#let katy = $ket(scripts(arrow.t)_x)$
#let kaby = $ket(scripts(arrow.b)_x)$
#let katz = $ket(scripts(arrow.t)_z)$
#let kabz = $ket(scripts(arrow.b)_z)$

$
  psi = a katz + b kabz
$

아까와 비슷하게, 측정 결과는 다음과 같다.
- $a^2$의 확률로 위쪽 스핀, 새로운 상태는 $katz$
- $b^2$의 확률로 아래쪽 스핀, 새로운 상태는 $kabz$

== 양자역학적 측정의 공리
#axiom(title: [양자역학적 측정의 공리])[
  각 측정 실험에 대해 우리는 양자상태의 공간 $V$ 상의 자기 수반 연산자인 관측가능량 $A$를 할당할 수 있다. 스펙트럼 정리에 의해, $A$는 고유공간을 갖는다. 이것을 분해했을 때 다음과 같다고 하자.
  $
    V = V_lambda_1 plus.circle V_lambda_2 plus.circle ... plus.circle V_lambda_k 
  $
  이때 $lambda_j$는 $A$의 실수 고윳값이고, $V_lambda_j$는 해당 고윳값에 대응하는 고유공간들이다.

  양자계 $s$가 상태 $v in V$에 있다고 하자. 이 상태 $v$를 각 고유공간으로 분해하면 다음과 같다.
  $
    v = v_1 + ... + v_k wide "s.t. " v_j in V_lambda_j,space A v_j = lambda_j v_j
  $
  이 측정을 시행한다면 그 결과는 확률적인데, $abs(v_j)^2$의 확률로 값 $lambda_j$가 관측되며 양자상태는 상태 $v_j/abs(v_j)$로 붕괴한다. 
]

위 서술에서, 당연히 $abs(v)=1$이고, 각 기저들은 서로에 대해 직교하므로, 피타고라스 정리의 확장을 생각하면 다음이 성립한다.
$
  abs(v)^2 = abs(v_1)^2 + ... + abs(v_k)^2
$

전자의 스핀을 예로 들어보자. 스핀의 상태벡터는
$
  psi = a katz + b kabz wide "where " a, b in CC,space abs(psi)^2 = abs(a)^2 + abs(b)^2 = 1
$
라고 하자.

이때 관측가능량은
$
  1/2 mat(1, 0; 0, -1)
$
이고, 고유벡터들은 기저벡터들로, 다음과 같다.
$
  e_1 = katz,space lambda_1 = 1/2 \
  e_2 = kabz,space lambda_2 = -1/2
$

이 계에 대해 측정을 수행하면, 우리는 $abs(a)^2$의 확률로 스핀 $+ 1/2$를 관측하고, 계는 새로운 상태로 $katz$를 갖게 되며, $abs(b)^2$의 확률로 스핀 $- 1/2$를 관측하고, 계는 새로운 상태로 $kabz$를 갖게 된다.

== 큐비트의 측정
$n$-큐비트의 양자상태는
$
  psi = sum_(k=0)^(2^n - 1) a_k ket(k) wide "s.t. " k in ZZ
$
였다. 여기서 $k$는 10진수로 표현된 정수이다. 큐비트 상태로 작용할 때는 2진수로서의 의미를 갖는다.

양자컴퓨팅에서 우리는 한 가지 관측가능량만 필요한데, 그 관측가능량 $A$는 다음을 만족해야 한다.
$
  A ket(k) = k ket(k)
$

이해를 위해 몇 가지 계산 결과 예시를 주자면 아래와 같다.
$
  & A ket(000) = 0 \
  & A ket(001) = ket(001) \
  & A ket(010) = 2 ket(010) \
  & A ket(011) = 3 ket(011)
$

측정의 결과로 우리는 값 $k$를 $abs(a_k)^2$의 확률로 얻으며, 계의 새로운 상태는 $ket(k)$가 된다. 이렇게 $n$-큐비트의 모든 비트를 읽어올 수 있다.

하지만 어떨 때는 특정 비트만 측정할 필요가 있을 때도 있다. 이런 것을 부분 측정이라고 한다. 예를 들어 3-큐비트의 첫 비트만 측정하겠다고 하자. 3-큐비트의 모든 기저 벡터는 $2^3$가지로,
$
  ket(000), ket(001), ket(010), ket(011), \
  ket(100), ket(101), ket(110), ket(111)
$
이다. 여기서 맨 앞 비트만 측정한다고 하면, 우리가 관측할 수 있는 값은 상태별로 각각
$
  0, 0, 0, 0, \
  1, 1, 1, 1
$
이 된다.

이때 관측가능량 $A$는 0이 4개, 1이 4개 있는 대각행렬이 된다.
$
  A = diagonalmatrix(0, 0, 0, 0, 1, 1, 1, 1)
$

또, 상태벡터는 다음과 같다.
$
  psi = a_0 ket(000) + a_1 ket(001) + ... + a_7 ket(111)
$

여기서 우리는 벡터 공간을 측정값이 0인 것과 1인 것으로 나누어 볼 수 있다. 다음과 같이 생각하면,
$
  ket(000), ket(001), ket(010), ket(011) space : lambda = 0 \
  ket(100), ket(101), ket(110), ket(111) space : lambda = 1
$
전체 벡터공간을 두 개의 부분적 고유공간으로 나누어 볼 수 있다.
$
  V = V_0 plus.circle V_1
$

그러므로 상태벡터는
$
  psi = vb(v)_0 + vb(v)_1 \
  "where " & vb(v)_0 = a_0 ket(000) + ... + a_3 ket(011) \
  & vb(v)_1 = a_4 ket(100) + ... + a_7 ket(111)
$

이때 우리는 확률
$
  abs(vb(v)_0)^2 = sum_(k=0)^3 abs(a_k)^2
$
로 0을 관측하고 계는 새로운 상태로 $vb(v)_0/abs(vb(v)_0)$를 가진다.

또, 확률
$
  abs(vb(v)_1)^2 = sum_(k=4)^7 abs(a_k)^2
$
로 1을 관측하고 새로운 상태는 $vb(v)_1/abs(vb(v)_1)$이 된다.

이렇게 $n$-큐비트의 상황에서 부분측정이 일어나는 예시를 알아보았다.

== 퍼텐셜 우물에서 입자 물리량의 측정
이번 예시에서는 무한 차원 상태공간의 경우를 보고자 한다. 퍼텐셜 우물 속의 입자에 대해 이야기하자.

상태공간 $V$의 파동함수 $psi$들은 $[0, L]$의 구간에서 정의되는 복소함수이다.
$
  psi: [0, L] -> CC
$

또,
$
  psi(0) = psi(L) = 0
$

이 함수들의 에르미트 내적은
$
  iprod(psi, phi) = integral_0^L overline(psi(x)) phi(x) dif x
$

관측가능량으로는 운동량 연산자를 생각해 보자. 이 연산자 $hat(p)$의 식은 다음과 같다#footnote[$hat(p)$의 꼭지 $hat$은 hat이라고 하며, 말 그대로 모자 씌운 것과 비슷하다. 일반적으로 양자역학에서는 hat을 씌워 연산자라는 것을 표시한다. 본 문서에서는 편의를 위해 씌웠다가 안 씌웠다가 혼용하지만 씌우지 않을 경우 연산자라는 것을 명시한다.].
$
  hat(p) = - i hslash pdv(, x)
$

이 연산자가 함수 $psi$에 작용한다면
$
  hat(p) psi = - i hslash pdv(psi, x)
$
처럼 된다는 뜻이다.

여기서 고유벡터는
$
  hat(p) psi = lambda psi
$

이 식은 미분방정식이다.
$
  - i hslash pdv(psi, x) = lambda psi \
  pdv(psi, x) = (lambda i)/hslash psi
$

해는 쉽게 구할 수 있다.
$
  psi(x) = C exp(- (lambda i)/hslash x)
$
여기서 $C$는 정규화 상수이다.

이 고유함수들은 평면파로, 크기가 항상 1이기 때문에 앞서 정해둔 조건 $psi(0) = psi(L) = 0$#footnote[이런 조건을 디리클레(Johann Dirichlet, 1805 \~ 1859) 경계 조건이라고 한다.]을 만족하지 않음을 확인할 수 있다. 이 때문에 일반적인 운동량 고유상태는 퍼텐셜 우물의 경계 조건을 만족하지 않는다.

지난번에 우리는 슈뢰딩거 방정식을 이용해 경계 조건을 만족하는 기본적인 해를 구해보았다.
$
  psi = sin lambda_k x
$

이 사인 함수들은 지수 꼴로 나타낼 수 있다#footnote[왜인지 모르겠다면 오일러 공식 $e^(i x) = cos x + i sin x$으로 유도해 보아라. 다른 방법은 $cosh x = cos i x$, $sinh x = sin i x$라는 것을 이용하는 것이다.].
$
  sin lambda_k x = (exp(lambda_k i x) - exp(- lambda_k i x))/ (2i)
$

각 지수항은 $hat(p)$의 고유함수이다. 
$
  hat(p) e^(i lambda_k x) = (+ hslash lambda_k) e^(i lambda_k x) \
  hat(p) e^(- i lambda_k x) = (- hslash lambda_k) e^(i lambda_k x)
$

즉 $1/2$의 확률로 운동량 $hslash lambda_k$, $1/2$의 확률로 운동량 $-hslash lambda_k$를 갖는다. 

#exercise[
  운동량 연산자 $hat(p)$가 자기 수반 연산자임을 보여라.
]

#solution[
  $braket(psi, hat(p) phi) = braket(hat(p) psi, phi)$임을 보이면 된다.
  $
    "LHS" =& integral_0^L overline(psi(x)) dot i hslash phi(x) dif x \
    =& cancel(evaluated(i hslash overline(psi) phi)_(x=0)^(x=L)) - integral_0^L i hslash overline(dv(psi, x)) phi(x) dif x \
    because psi(0) = psi(L) = 0
  $
  이고
  $
    "RHS" =& integral_0^L overline(i hslash psi(x)) dot phi(x) dif x \
    =& - integral_0^L hslash overline(dv(psi, x)) phi(x) dif x
  $

  따라서
  $
    markrect(hat(p) = hat(p)^dagger)
  $
  즉, $hat(p)$는 자기 수반 연산자이다.
  #align(right, $qed$)
]


주의할 것은, 엄밀하게 말하면 디리클레 경계 조건 하에서 정의한 운동량 연산자는 대칭이지만 일반적으로 자기 수반은 아니다.

또 하나 자연스럽게 측정할 수 있는 관측가능량은 위치이다. 위치연산자를 다음과 같다고 하자.
$
  hat(x) = x
$

$x in RR$이므로,
$
  braket(psi, hat(x) phi) = integral_0^L overline(psi(x)) x phi(x) dif x = integral_0^L overline(x psi(x)) phi(x) dif x = braket(hat(x) psi, phi)
$
와 같이 자명하게 자기 수반 연산자이다.


$x$의 고유함수는 일반화 함수라고 하는 것들로, 델타함수(Dirac delta)라고 한다. 델타함수는 쉽게 말해 어떤 위치 $x=a$ 외에서는 그 값이 0인 함수를 말한다. $a$에서의 값은 무한대라고 두는 것이 보통이다. 델타함수는 다음과 같은 성질이 있다.
$
  integral_0^L delta_a (x) phi(x) dif x = phi(a)
$

즉 델타함수는 구간 $[0, L]$에서의 함수가 아니라, $V$ 상의 선형 사상으로 보아야 한다#footnote[델타함수는 일반적인 함수가 아니며, 일반화 함수(generalized function)이다.].

델타함수는 아래와 같은 성질도 가진다. 즉 $hat(x)$의 고유함수가 된다.
$
  x delta_a (x) = a delta_a (x)
$

== 두 물리량의 동시 측정

두 관측가능량에 대해, 그에 각각 대응하는 연산자 $A, B$에 대해 아래가 성립하면 두 양을 동시에 측정할 수 있다.
$
  A dot B = B dot A
$

이런 것을 가환(可換, commutable)이라고 하며, 두 연산자가 공통된 고유벡터 기저를 가지고 있다는 뜻과 같다.

특히, $n$-큐비트에 대해 그 기저 고유벡터가 모두 같으므로 모든 큐비트의 값을 동시에 측정할 수 있다.

전자의 스핀을 예시로 들어보자. 모든 방향으로 측정이 가능하므로, 각 방향의 관측가능량을 살펴보자. 먼저, $x$ 방향으로의 측정 연산자는 아래와 같다.
$
  1/2 sigma_1 = 1/2 mat(0, 1; 1, 0)
$

$y$ 방향으로의 연산자는
$
  1/2 sigma_2 = 1/2 mat(0, -i; i, 0)
$

$z$ 방향에 대응하는 관측가능량은
$
  1/2 sigma_3 = 1/2 mat(1, 0; 0, -1)
$

이때 $sigma_1, sigma_2, sigma_3$은 파울리 행렬이다. 각 행렬은 자기 수반이다. 실수부는 대칭이고 허수부는 반대칭이기 때문이다. 하지만, 이 행렬들은 비가환이다($sigma_j sigma_k != sigma_k sigma_j$). 즉, 서로 다른 방향에 대한 전자의 스핀은 동시에 측정할 수 없다. 실험적으로 생각해 보자. 전자의 스핀을 측정하려면 전자를 강한 자기장 안에 넣어야 했었다. 그런데 상식적으로, 한 번에 두 방향의 자기장을 한꺼번에 걸 수 있는가? 물론 가능이야 하겠지만 자기장은 합성이 될 것이지 각각의 순수한 방향에 대한 측정 결과를 내놓지 못할 것이다.

비슷하게 퍼텐셜 우물 속 입자도 살펴보자. 우리는 두 관측가능량을 보았다.
$
  hat(p) = - i hslash pdv(, x) \
  hat(x) = x
$

이제 두 연산자의 곱을 보자.
$
  hat(p) hat(x) (psi) &= - i hslash pdv(, x) [x psi(x)] \
  &= - i hslash [psi(x) + psi'(x)]
$
또,
$
  hat(x) hat(p) (psi) &= - x i hslash psi'(x)
$
그러므로 $hat(p) hat(x) != hat(x) hat(p)$이다. 즉, 퍼텐셜 우물 속 입자의 위치와 운동량을 동시에 측정할 수 없다. 우리가 살펴본 운동량 연산자와 위치 연산자는 우리가 앞서 상정한 퍼텐셜 우물의 디리클레 조건 외에서도 성립하므로, 일반적으로 입자의 위치와 운동랴은 동시에 측정할 수 없다는 결론이 나온다. 이것은 하이젠베르크(Werner Heisenberg, 1901 \~ 1976)의 불확정성 원리(uncertainty principle)로 귀결된다.

#theorem(title: [불확정성 원리])[
  두 관측가능량 $hat(A), hat(B)$에 대해 다음이 성립한다.
  $
    Delta A Delta B
    >= (1/2) abs(expval([hat(A), hat(B)]))
  $
]

#proof[
  먼저 다음을 상정한다. 아래 둘은 쉽게 증명 가능하므로 증명은 따로 하지 않는다.
  - 에르미트 연산자의 기댓값은 실수이다.
  - 반 에르미트 연산자#footnote[$hat(A)^dagger = - hat(A)$를 만족하는 연산자]의 기댓값은 순허수이다.
  
    이제 다음의 연산자를 약속하자.
  $
    Delta hat(A) = hat(A) - expval(A)
  $
  즉, 본래의 연산자에서 기댓값을 뺀 형태이다.

  참고로
  $
    expval((Delta hat(A))^2)
    =& expval((hat(A) - expval(A))^2) \
    =& expval(hat(A)^2 - 2 hat(A) expval(A) + expval(A)^2) \
    =& expval(A^2) - expval(A)^2 \
    =& (Delta A)^2
  $
  으로 분산이 된다. $Delta A$는 표준편차이다#footnote[경우에 따라 $sigma_A$와 같이 쓰기도 한다.].

  코시--슈바르츠 부등식에 의해 다음이 성립한다.
  $
    braket(ket(alpha), ket(alpha)) ,
    braket(ket(beta), ket(beta))
    >= abs(braket(ket(alpha), ket(beta)))^2
  $

  이제 임의의 $ket(xi)$에 대해
  $
    ket(alpha) = Delta hat(A) ket(xi) \
    ket(beta)  = Delta hat(B) ket(xi)
  $
  라 놓자. 한편, $Delta hat(A)$는 쉽게 에르미트 연산자임을 보일 수 있어
  $
    braket(ket(alpha), ket(alpha)) 
    =& expval((Delta hat(A))^2) braket(ket(beta), ket(beta)) \
    =& expval((Delta hat(B))^2) braket(ket(alpha), ket(beta)) \
    =& expval(Delta hat(A)  Delta hat(B))
  $
  가 되고, 다음을 얻는다.
  $
    expval((Delta hat(A))^2)  expval((Delta hat(B))^2)
    >= abs(expval(Delta hat(A)  Delta hat(B)))^2
  $
  위에서 논한 결과로 대치하면,
  $
    (Delta A)^2 (Delta B)^2
    >= abs(expval(Delta hat(A)  Delta hat(B)))^2
  $
  이제, 우변의 항을 구하는 것으로 귀결된다.

  $
    Delta hat(A)  Delta hat(B)
    = (1/2) [Delta hat(A), Delta hat(B)]
      + (1/2) {Delta hat(A), Delta hat(B)}
  $
  으로 교환자와 반교환자의 합으로 구성할 수 있다.

  한편, 여기서 $[Delta hat(A), Delta hat(B)]$라는 연산자는 반 에르미트 연산자, ${Delta hat(A), Delta hat(B)}$라는 연산자는 에르미트 연산자인데,
  $
    expval(Delta hat(A)  Delta hat(B))
    = (1/2)  expval([Delta hat(A), Delta hat(B)])
      + (1/2)  expval({Delta hat(A), Delta hat(B)})
  $
  으로 쓸 수 있다.

  위의 논의대로, 좌변의 1항은 실수가, 2항은 순허수가 나올 것이다. 이상에서
  $
    & abs(expval(Delta hat(A)  Delta hat(B)))^2 \
    =& (1/4) abs(expval([Delta hat(A), Delta hat(B)]))^2
      + (1/4) abs(expval({Delta hat(A), Delta hat(B)}))^2
    >= (1/4) abs(expval([Delta hat(A), Delta hat(B)]))^2
  $

  이상에서 다음의 결론을 얻는다.
  $
    Delta A  Delta B
    >= (1/2)  abs(expval([Delta hat(A), Delta hat(B)]))
  $
  쉽게 $[Delta hat(A), Delta hat(B)] = [hat(A), hat(B)]$임을 증명 가능하므로 최종적으로
  $
    markrect(Delta A Delta B>= (1/2) abs(expval([hat(A), hat(B)])))
  $
]

특히, 위치와 운동량에 대해 둘은 정준교환자(canonical commutator)
$
  [hat(x), hat(p)] = i hslash
$
이므로,
$
  Delta x Delta p >= hslash/2
$
이 성립한다#footnote[이 부분은 양자컴퓨팅이 아니라 양자역학의 영역이므로 이해가 안 된다면 넘어가도 된다.].