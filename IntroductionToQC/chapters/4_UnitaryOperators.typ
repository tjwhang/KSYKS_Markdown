#import "../template.typ": *

= 유니터리 연산자

이번에는 양자계의 시간 변화(evolution)에 대해 알아보도록 하겠다.

== 양자계의 시간 변화와 유니터리 연산자
#definition(title: [유니터리 연산자])[
  닫힌 양자계의 시간 변화는 유니터리 연산자로 주어진다. $V$를 양자계의 상태의 에르미트 공간이라고 하자. 수학적으로 $V$는 에르미트 내적이 성립하는 복소벡터공간이다.

  어떤 연산자 $U: V -> V$는 다음을 만족하면 유니터리(unitary) 연산자라고 한다.
  $
    forall vb(u), vb(v) in V quad braket(U vb(u), U vb(v)) = braket(vb(u), vb(v))
  $

  유니터리 연산자의 조건은 아래와 같이 서술할 수도 있다.
  $
    U^dagger U = I
  $
  이때 $I$는 단위행렬이다.

  이는 다음과 동치이다.
  $
    U^dagger = U^(-1)
  $
]

유니터리 연산자는 표준기저의 정규직교성(orthonormality)을 보존한다.

#definition(title: [표준기저])[
  어떤 벡터공간에서 가장 기본적인 방향을 나타내는 벡터의 집합을 표준기저(standard basis)라고 한다.

  예를 들어 3차원 실수 공간 $RR^3$에서 표준기저는
  $
    vb(e)_1 = vec(1, 0, 0), vb(e)_2 = vec(0, 1, 0), vb(e)_3 = vec(0, 0, 1)
  $
  과 같으며#footnote[물론 표기는 $vb(e)_x$로 하던 $hat(i)$로 하던 $hat(x)$로 하던 혼동만 되지 않으면 상관 없다.], 각각 $x, y, z$ 좌표축 방향과 일치한다. 이때 이 공간 상의 점 $"P"(2, 3, 1)$의 위치벡터 $vb(P)$는
  $
    vb(P) = 2 vb(e)_1 + 3 vb(e)_2 + vb(e)_3
  $
  이 된다.
]

#definition(title: [정규직교기저])[
  정규직교기저(orthonormal basis)란 서로 직교(orthogonal)하면서 크기가 1로 정규화된(normalized) 벡터의 집합이다. 즉, 벡터 $vb(u)_i, vb(u)_j$에 대해 다음이 성립하면 두 벡터는 정규직교기저이다.
  - 직교: $iprod(vb(u)_i, vb(u)_j) = 0$
  - 정규화: $abs(vb(u)_i) = abs(vb(u)_j) = 1$

  예를 들어 $n$차원 표준기저도 정규직교기저이다.

  정규직교기저의 내적은 다음과 같이 쉽게 계산할 수 있다#footnote[$delta_(i j)$는 크로네커 델타(Kronecker delta)라고 하며, $delta_(i j) = cases(1 quad & (i = j), 0 quad & (i != j))$이다. 즉 두 매개변수가 같으면 1, 아니면 0을 반환하는 함수이다.].
  $
    iprod(vb(u)_i, vb(u)_j) = delta_(i j)
  $

  양자역학에서 상태벡터를 정규직교기저로 나타내면 계산이 매우 간단해진다는 장점이 있다.
]

간단히 설명해서, 표준기저에 대해서는
$
  braket(vb(e)_i, vb(e)_j) = delta_(i j)
$
이 성립하는데, 여기에 $U$가 작용해도 여전히
$
  braket(U vb(e)_i, U vb(e)_j) = braket(vb(e)_i, vb(e)_j) = delta_(i j)
$
이 성립하여 내적이 보존된다.

원래 표준기저는 정규직교기저이다. 즉 표준기저 $ket(vb(e)_i)$의 집합 ${ket(vb(e)_i)}$는 정규직교기저의 집합이다. 이때 $U$가 작용한 벡터의 집합 ${ket(U vb(e)_i)}$도 정규직교벡터의 집합이 된다는 뜻이다.

#exercise[
  $forall vb(u), vb(v) in V = CC^N$에 대해
  $
    braket(vb(u), vb(v)) = vb(u)^dagger vb(v)
  $
  이고
  $
    braket(U vb(u), U vb(v)) = (U vb(u))^dagger U vb(v) = vb(u)^dagger U^dagger U vb(v)
  $
  이다. 이를 이용하여 유니터리 연산자의 정의 $U^dagger U = I$를 유도하여라.
]

#solution[
  $
    braket(U vb(u), U vb(v)) = vb(u)^dagger U^dagger U vb(v) = u^dagger v
  $
  이므로 $forall vb(u), vb(v) in V = CC^N$에 대해
  $
    vb(u)^dagger (U^dagger U) vb(v) = vb(u)^dagger vb(v) = vb(u)^dagger I vb(v)
  $
  여야 한다.

  즉,
  $
    markrect(U^dagger U = I)
  $

  #align(right, $qed$)
]

$U^dagger U = I$라는 것은 다음과도 동치이다.
$
  U^dagger = U^(-1)
$

== 유니터리 연산자의 고윳값과 고유벡터
#theorem(title: [유니터리 연산자의 고윳값과 고유벡터])[
  에르미트 벡터공간 $V$ 상의 연산자 $U$가 유니터리 연산자라고 하자. 이때 다음이 성립한다.
  1. $U$의 고윳값은 크기가 1인 복소수이다.
  2. 서로 다른 고윳값에 대응하는 $U$의 고유벡터는 서로에 대해 각각 직교한다.
]

#proof[
  1. $U vb(v) = lambda vb(v)$라고 하자. 이때
  $
    braket(U vb(v), U vb(v)) = braket(lambda vb(v), lambda vb(v)) = lambda overline(lambda) braket(vb(v), vb(v)) = abs(lambda)^2 braket(vb(v), vb(v)) = braket(vb(v), vb(v))
  $
  그런데, $vb(v) != 0$이라면 $braket(vb(v), vb(v)) != 0$이므로 $abs(lambda) = 1$이다.

  2. $U vb(u) = lambda vb(u), U vb(w) = mu vb(w)$라고 하자. 그러면
  $
    braket(U vb(u), U vb(w)) = braket(lambda vb(u), lambda vb(w)) = overline(lambda) mu braket(vb(u), vb(w)) = mu/lambda braket(vb(u), vb(w))
  $
  그런데, $braket(U vb(u), U vb(w)) = braket(vb(u), vb(w))$이므로
  $
    (1 - mu/lambda) braket(vb(u), vb(w)) = 0
  $
  이때 $mu != lambda$이면 $1 - mu/lambda != 0$이므로 $braket(vb(u), vb(w)) = 0$이다.
]

#theorem(title: [유니터리 연산자의 스펙트럼 정리])[
  유한차원 에르미트 공간 $V$ 상의 유니터리 연산자 $U$는 대각화 가능(diagnolizable)하다. $U$는 크기가 1인 고윳값을 가진 고유벡터들로 이루어진 정규직교기저를 갖는다.
]

어떤 행렬 $A$가 대각화 가능하다는 것은, 적절한 기저를 택하면 $A$를 대각행렬로 표현할 수 있다는 뜻이다.
$
  A = P D P^(-1)
$
이때 $D$는 대각행렬, $P$의 열벡터들은 $A$의 고유벡터들, $D$의 대각성분은 $A$의 고윳값들이다. 즉, 대각화는 복잡한 행렬을 각 고윳값에 대응하는 축으로 분해하는 것과 같다.

유니터리 연산자가 대각화 가능한 고유벡터를 가지므로 유니터리 연산자는 대각화하면 이런 식으로 생겼다는 뜻이다.
$
  U = diagonalmatrix(e^(i alpha_1), e^(i alpha_2), dots.down, e^(i alpha_N))
$

$e^(i alpha_i)$가 고윳값이므로, 만약 $abs(lambda_i) = 1$이라면 $lambda_i$는 아래와 같이 쓸 수 있다.
$
  lambda_i = e^(i alpha_i) = cos alpha_i + i sin alpha_i quad "where " alpha_i in RR
$
$lambda_i$는 복소평면에서 편각 $alpha_i$를 가지고 크기가 1인 벡터가 된다.

== 양자계의 시간변화
다시 양자계의 시간 변화로 돌아와 보자. 초기 상태 $psi_0$는 시간 $t=0$일 때의 초기 상태라고 하자. 이때 이렇게 표현할 수 있다.
$
  psi(t) = U(t) psi_0
$
$U$는 유니터리 변환의 모임이다. 계의 시간변화를 제어하기 위해서는 $U(t)$의 값들을 제어할 수 있다. 물리적으로는 계에 영향을 주는 자기장을 조작한다거나, 계에 레이저를 쏠 때 그 레이저의 세기나 파장을 조정할 수 있다. 즉 양자계의 시간변화는 다양하게 일어날 수 있다.

양자 계산의 일반적인 절차는 세 단계로 나뉜다. 
1. 초기화(initialization)
2. 양자 알고리즘 적용
3. 측정

초기화는 초기 상태를 준비하는 단게이다. 이 벡터는 양자 알고리즘의 입력이다. 양자 알고리즘은 유니터리 연산자이다#footnote[여러 연산자의 합성도 결국 하나의 연산자와 같다.]. 유니터리 연산자는 연산 적용 후에도 벡터의 내적을 보존하므로 크기를 보존한다#footnote[벡터의 크기는 자신과의 내적으로 표현되기 때문이다.]. 측정 단계에서는 관측을 하여 확률적인 결과를 얻는다. 

== 군론 기초
여기서 우리는 군론(group theory) 기초를 다지고 넘어갈 필요가 있다. 첫째로, 양자 알고리즘을 더 잘 이해하기 위함이고, 둘째로 암호학을 이해하기 위해 군론이 필요하기 때문이다. 군의 정의로 시작해보자.

#definition(title: [군])[
  군 $G$는 이항연산이 주어진 집합으로, 연산과 그 연산의 대상이 되는 집합을 묶어 표현한다.

  집합 $G$의 이항연산을 $* : G times G -> G$라고 할 때, $forall a, b, c in G$에 대해 $*$이 다음을 만족하면 $(G, *)$를 군이라고 한다.
  1. 결합법칙
  $
    (a * b) * c = a * (b * c)
  $
  2. 항등원의 존재
  $exists e in G$에 대해
  $
    a * e = a = e * a
  $
  가 성립하면 $e$는 $*$의 항등원이고, 항등원의 존재는 유일하다. 따라서 이 원소를 $1$, $e$, $i$ 따위로 표기한다.
  3. $a in G$에 대해 $x in G$가 존재하여
  $
    a * x = e = x * a
  $
  가 성립하면 $x$는 $*$의 역원이고, 역원의 존재는 유일하다. 따라서 이 원소를 $a^(-1)$로 표기한다.
]

#problem[
  군 $(G, *)$의 항등원 $e$와 역원 $x$가 유일함을 보여라.
]

#solution[
  1. 또 다른 항등원을 $f$라고 하면
  $
    e = e * f = f
  $
  이므로 $e = f$이다. 즉, 항등원은 유일하다.
  2. 또 다른 역원을 $y$라고 하면
  $
    x = x * e = x * (a * y) = (x * a) * y = e * y = y
  $
  이므로 $x = y$이다. 즉, 역원은 유일하다.
]

아래는 흔하고 자주 등장하는 군의 예시이다.

#definition(title: [일반선형군])[
  $n times n$ 실수 가역행렬들의 집합을 $"GL"(n, RR)$ 또는 $"GL"_n (RR)$이라 쓰고 $n$차 일반선형군(general linear group)이라고 한다.
  $
    "GL"_n (RR) := M_(n times n) (RR) \\ Set(A in M_(n times n) (RR), det A = 0)
  $
]

$"GL"_n (CC)$는 복소 가역행렬들의 집합이다. 행렬곱에 대해 그 항등원은 단위행렬 $I$가 된다.

#definition(title: [특수선형군])[
  행렬식이 1인 $n times n$ 실수 행렬들의 집합을 $"SL"(n, RR)$ 또는 $"SL"_n (RR)$이라고 쓰고 $n$차 특수선형군(special linear degree)이라고 한다.
  $
    "SL"_n (RR) := Set(A in M_(n times n) (RR), det A = 1)
  $
]

특수선형군에 속한 두 행렬 $A, B$에 대해 $det A = det B = 1$이므로 $det A dot det B = det A B = 1$이 된다. 마찬가지로 $"SL"_n (CC)$는 행렬식이 1인 복소행렬들의 집합이다.

#definition(title: [유니터리 군])[
  $n times n$ 유니터리 행렬들의 집합을 $U(n)$ 또는 $"U"_n$이라고 쓰고 $n$차 유니터리 군(unitary group)이라고 한다.
  $
    "U"_n := Set(A in M_(n times n) (CC) ~ "GL"_n (CC), A^dagger A = I) \
  $
]

#lemma(title: [유니터리 군과 일반선형군])[
  유니터리 군 $"U"_n$은 일반선형군 $"GL"_n (CC)$의 부분집합이자 부분군이다.
  1. $I in "U"_n quad I^dagger I = I$
  2. $A, B in "U"_n => A dot B in "U"_n$

  또, $"U"_n$ 상의 모든 행렬은 가역이다. 다음을 확인하자.
  $
    (A B)^dagger dot (A B) = A^dagger B^dagger A B = I
  $

  3. $X in "U"_n => X^(-1) in "U"_n$
]

#definition(title: [특수 유니터리 군])[
  행렬식이 1인 $n times n$ 유니터리 행렬들의 집합을 $"SU"(n)$ 또는 $"SU"_n$이라고 쓰고 $n$차 특수 유니터리 군(special unitary group)이라고 한다.
  $
    "SU"_n &:= Set(A in M_(n times n) (CC), A^dagger A = I and det A = 1) \
    &= "U"_n inter "SL"_n (CC)
  $
]

이상에서
$
  "SU"_n subset "U"_n subset "GL"_n (CC)
$

유니터리 군은 양자 이론에서 다양한 부분을 차지하며, 한 가지 작은 예시로, 기본 입자의 표준 모형은 유니터리 군에서 기인한다. 기본입자를 표현하기 위해 아래와 같은 식을 쓴다.
$
  "U"_1 times "SU"_2 times "SU"_3
$

$"U"_1$은 전자기력, $"SU"_2$는 약한 핵력, $"SU"_3$은 쿼크와 강한 핵력에 관련돼 있다.