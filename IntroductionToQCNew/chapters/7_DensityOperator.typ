#import "../template.typ": *

= 밀도 연산자

앞으로부터 몇 장의 목표는 얽힘을 더 잘 이해하는 것이다. 밀도 연산자는 그를 위한 도구 중 하나이다.

서로 다른 양자 상태들에 있을 기본 입자의 빔을 생각하자. 여기서 측정을 수행한다고 하면 빔이 관측자가 설정한 고유상태로 분리될 수 있는데, 이때 각 상태의 빔의 세기(intensity)를 알려주는 것이 밀도 연산자(density operator)이다. 하지만 이 빔의 상태가 어떤지 특정해서 알려주지는 않는다. 즉 밀도 연산자는 전체 빔의 통계학적 정보를 각 입자의 개별 상태를 특정하지 않고 측정한다. 

#definition(title: [순수 입자 빔])[
  입자 빔은 빔에 속하는 모든 입자가 같은 양자상태를 가질 때 '순수'(pure)하다고 한다.
]

이제 이 빔 속의 모든 입자의 양자 상태가 같아 빔이 순수하다고 하자.

== 양자 상태의 측정
측정 과정의 수학적 모델을 복습하도록 하자. 모든 측정에 대해, 우리는 수학적으로 상태공간 $V$ 상의 자기 수반 연산자인 관측가능량 $A$를 부여한다. 모든 자기 수반 연산자는 대각화 가능하므로 $A$는 실수 고유값 $lambda_1, ..., lambda_n$을 가진 고유벡터 ${vb(v)_1, ..., vb(v)_n}$의 정규직교기저가 있다. 이제 상태 $vb(w) in V$에 있는 입자를 측정하면 어떻게 되는가? 먼저 $vb(w)$를 고유벡터에 대해 전개하자.
$
  vb(w) = c_1 vb(v)_1 + ... + c_n vb(v)_n quad "s. t. " abs(vb(w))^2 = abs(c_1)^2 + ... + abs(c_n)^2 = 1
$
이때 고윳값 $lambda_j$를 측정할 확률은 $abs(c_j)^2$이다. 그런데 이 계수들을 어떻게 찾을까? 여기에는 간단한 방법이 있었다. $vb(w)$와 고유벡터 중 하나인 $vb(v)_j$를 이런 식으로 내적하면 된다. 이때 식을 전개해보자.
$
  braket(vb(v)_j, vb(w)) = braket(v_j, c_1 vb(v)_1 + ... + c_n vb(v)_n) = sum_(k=1)^n c_k braket(vb(v)_j, vb(v)_k)
$
그런데, 기저들이 정규직교하므로 $j != k$이면 $braket(vb(v)_j, vb(v)_k) = 0$이고, $j=k$라면 1이다. 그러므로 우리가 얻는 결과값은 단순히 $c_j$가 된다. 즉 계수 $c_j$를 찾으려면 주어진 상태벡터와 정규직교기저 $vb(v_j)$를 내적하면 된다. 

만약 상태 $vb(w)$에 단일 입자가 아니라 순수 빔이 있다면, $abs(c_j)^2$는 앞서 논한 각 상태 별 빔의 세기가 된다. 우리가 정규직교기저 ${vb(v)_1, ..., vb(v)_n}$에 대한 상태벡터 $vb(w)$의 전개식을 구할 때는 기본적으로 각 기저 벡터에 대한 사영(projection)을 계산하는 것이다.

== 정사영

단위벡터 $vb(v)$에 대한 정사영(orthogonal projection)에 대해 복습하자. 어떤 벡터 $vb(w)$를 $vb(v)$에 정사영한 벡터 $"proj"_vb(v) vb(w)$를 구하려면 어떻게 할까? 먼저 $vb(w) = c vb(v)$로 놓을 수 있다. 또 $vb(v)$에 대해 수직인 어떤 벡터 $vb(u)$에 대해 $vb(w) = "proj"_vb(v) vb(w) + vb(u)$로 놓을 수 있다. 이것을 이용해 미지의 상수 $c$를 알아낼 수 있다. 

먼저 내적 $braket(vb(v), vb(w))$를 계산하자.
$
  braket(vb(v), vb(w)) = braket(vb(v), c vb(v) + vb(u)) = c braket(vb(v), vb(v)) + cancel(braket(vb(v), vb(u))) = c
$

이제 이것을 공식화할 수 있다. 벡터 $vb(w)$의 단위벡터 $vb(v)$로의 정사영은
$
  "proj"_vb(v) vb(w) = braket(vb(v), vb(w)) thin vb(v)
$ <projmath>

우리는 또 $V->V$의 선형 연산자인 사영 연산자 $P$에 대해 생각해볼 수 있다. 이 연산자는 $vb(w) mapsto "proj"_vb(v) vb(w)$를 한다. 디랙 표기법으로는 $P = ketbra(vb(v))$로 쓴다. 이게 무슨 뜻인지 보자. 어떤 벡터 $vb(w)$에 $P$를 적용하면
$
  P ket(vb(w)) = ket(vb(v)) braket(vb(v), vb(w))
$
가 되어 @projmath 와 동일한 꼴이 된다.

== 디랙 표기법과 연산자의 대각합
이 표기법에 좀 더 익숙해지기 위해 행렬로 하면 어떻게 될지도 보자. 예를 들어 행렬 $A = (a_(i j))$로 주어진 연산자에 대해 생각하자. 이 연산자는 기저 벡터 $vb(e)_j$를 아래와 같이 대응시킨다고 하자.
$
  vb(e)_j mapsto sum_(i = 1)^n a_(i j) vb(e)_i
$ <diracmatmap>
이제 $A$를 디랙 표기법으로 써보자.
$
  A = sum_(i, j = 1)^n a_(i j) ket(vb(e)_i) bra(vb(e)_j)
$<demomatmap>

이제 $A$에 어떤 기저 $vb(e)_k$를 넣어보자.
$
  A ket(vb(e)_k) = sum_(i, j) a_(i j) ket(vb(e)_i) braket(vb(e_j), vb(e)_k)
$
이때 기저들은 표준기저이므로 정규직교이다. 즉 $braket(vb(e)_j, vb(e)_k)$는 $j = k$이면 1, 아니면 0이다. 즉 남는 항은 $j=k$인 항들이므로 이렇게 된다.
$
  A ket(vb(e)_k) = sum_(i = 1)^n a_(i k) ket(vb(e)_i)
$ 
이 식은 아까 @diracmatmap 과 동일한 것을 볼 수 있다. 즉 @diracmatmap 과 @demomatmap 은 같은 연산자를 표기하는 서로 다른 방법임을 실감하자.

하나 더 볼 것은 연산자의 대각합(trace, 對角合)이다. 대각합 $tr A$는 주대각 원소들의 합으로 아래와 같다.
$
  tr A = sum_(i = 1)^n a_(i i)
$
그런데 이것은 이렇게 쓸 수도 있다.
$
  tr A = sum_(i, j) a_(i j) braket(vb(e)_j, vb(e)_i)
$
즉 $ketbra(bullet)$으로 쓰인 연산자의 대각합은 브라와 켓의 순서를 바꿔 $braket(bullet)$으로 쓰면 된다.

== 밀도 연산자
#definition(title: [입자 빔의 밀도 연산자])[
  양자상태 $vb(w)$에 있는 순수 빔에 대해 그 밀도 연산자는 $vb(w)$로의 사영 연산자이다.
  $
    P = ketbra(vb(w)) quad "s. t. " abs(vb(w))^2 = 1
  $
  순수하지 않은 빔에 대해 밀도 연산자는 연산자들의 평균이다.
  $
    rho = 1/N sum_(i = 1)^N ketbra(vb(w)_i) quad "where" {vb(w)_i}"는 빔을 이루는 입자의 상태"
  $
]

밀도 연산자의 성질로는 정사영이 자기 수반이라는 것이 있다. 즉
$
  forall vb(v), vb(u) in V quad braket(vb(v), P_vb(w) vb(u)) = braket(P_vb(w) vb(v), vb(u))
$
증명은 $P$를 전개하면 자명하다.
$
  & "LHS" = braket(vb(v), braket(vb(w), vb(u)) vb(w)) = braket(vb(w), vb(u)) braket(vb(v), vb(w)) \
  & "RHS" = braket(braket(vb(w), vb(v)) vb(w), vb(u)) = overline(braket(vb(w), vb(v))) braket(vb(w), vb(u)) = braket(vb(v), vb(w)) braket(vb(w), vb(u)) \
  & therefore "LHS" = "RHS"
$

#corollary()[
  밀도 연산자는 자기 수반이다. 
]

다시 고유값 $lambda_1, ..., lambda_n$의 정규직교기저 ${vb(v)_1,..., vb(v)_n}$을 갖는 관측가능량 $A$를 생각하자. 이때
$
  A = sum_(i = 1)^n lambda_i ketbra(vb(v)_i) = sum_(i = 1)^n lambda_i P_vb(v)_i
$
어떤 벡터 $vb(v)_k$에 대해
$
  A ket(vb(v)_k) = sum_(i=1)^n lambda_i ket(vb(v)_i) braket(vb(v)_i, vb(v)_k) = lambda_k ket(vb(v)_k)
$
이것이 고유값-고유벡터 관계를 만족함을 확인하자.

#proposition()[
  1. 밀도 행렬 $rho$를 가진 입자 빔을 관측가능량 $A$로 측정을 수행할 때, 관측값 $lambda_k$에 대응하는 빔#footnote[특정 상태로 분광시킨 빔을 말하는 것이다.]의 세기는 $abs(c_k)^2 = tr (rho P_vb(v)_k)$이다.
  2. 관측값의 평균은 다음과 같다.
  $
    tr(rho A) = sum_(k = 1)^n lambda_k abs(c_k)^2
  $
]

이 가정은 밀도 연산자가 모든 통계적 정보를 포함하고 있음을 시사한다. 이 가정을 증명해보자.

#proof[
  순수 빔에 대해 가정이 성립한다면, 순수하지 않은 빔은 각 상태를 모두 평균내는 결과로 똑같이 가정이 성립할 것이므로, 가정은 상태 $vb(w)$에 있는 순수 빔에 대해 증명하는 것만으로 일반성을 잃지 않아 충분하다.

  1. $c_k$는 $vb(w)$를 기저 ${vb(v)_1, ..., vb(v)_n}$에 대해 전개하였을 시의 계수였고, 그 값은 $braket(vb(v)_k, vb(w))$였다. 이때
  $
    "RHS" &= tr(rho P_vb(v)_k) = tr(P_vb(w) P_vb(v)_k) = tr(ket(vb(w)) braket(vb(w), vb(v)_k) bra(vb(v)_k)) \
    &= braket(vb(w), vb(v)_k) braket(vb(v)_k, vb(w)) = overline(c_k) c_k = abs(c_k)^2
  $
  이므로 가정이 옳다.

  2. $rho$를 전개하는 것으로 시작하자.
  $
    tr(rho A) &= tr(P_vb(w) A) = tr(ketbra(vbu(w)) sum_(i=1)^n lambda_i ketbra(vbu(v)_i)) \
    &= tr(sum_(i=1)^n lambda_i ket(vb(w)) ketbra(vb(w), vb(v)_i) bra(vb(v)_i)) = sum_(i=1)^n lambda_i braket(vb(w), vb(v)_i) braket(vb(v)_i, vb(w)) \
    &= sum_(i=1)^n lambda_i abs(c_i)^2
  $
  로, 이 합의 물리적 의미는 이 관측에 대한 평균 관측 값들이다.
]

== 얽힘 상태에서의 밀도 연산자
우리는 이제 순수하지 않은 빔에 대한 밀도 연산자(또는 밀도 행렬) $rho$를 공부하였다. 이제는 얽힘 상태 또는 이분(二分, bipartite) 상태의 양자계에서의 밀도 연산자를 보겠다.

한 점에서 발사하여 서로 반대 방향으로 진행하는 두 얽힌 입자를 생각하자. 두 입자가 각각 지나는 위치 A, B를 상상해 보자. 이때 측정을 A에서만 할 수 있다고 하자. 이때 A에서의 국소적 측정의 통계적 확률을 제공할 밀도 연산자를 어떻게 표현할 수 있을까? 

수학적으로 얽힌 두 입자의 상태는 그것들의 상태 공간의 텐서 곱으로 표현할 수 있다. A에서의 상태 공간을 $V$, B에서의 상태 공간을 $W$라고 하면 어떤 일반적인 얽힘 상태 $psi$는 텐서 곱의 공간에서 단위벡터가 될 것이다.
$
  psi in V times.o W quad "s.t. " abs(psi)^2 = 1
$
이때 $psi$는 아래와 같이 쓰일 수 있다. 이때 $n = dim V, m = dim W, vb(v)_i in V, vb(w)_j in W$이다.
$
  psi = sum_(i = 1)^n sum_(j = 1)^m c_(i j) ket(vb(v)_i) times.o ket(vb(w)_j)
$

#definition(title: [얽힘 상태에서의 밀도 연산자])[
  얽힌 상태 $psi in V times.o W$의 밀도 연산자 $rho_V$는 다음과 같다.
  $
    rho_V = tr_V (ketbra(psi))
  $
]
이 정의의 의미를 더 잘 이해하기 위해 식을 전개해 보자.
$
  rho_V &= tr_V (sum_(i, j) c_(i j) ket(vb(v)_i) times.o ket(vb(w)_j) sum_(k, s) overline(c_(k s)) bra(vb(v)_k) times.o bra(vb(w)_s)) \
  &= sum_(i, j) sum_(k, s) c_(i j) overline(c_(k s)) ket(vb(v)_i) bra(vb(v)_k) braket(vb(w)_s, vb(w)_j) \
  &= sum_(i, j, k) c_(i j) overline(c_(k j)) ket(vb(v)_i) bra(vb(v)_k) 
$
이때 $C := (c_(i j))$라고 하면 연산자 $rho_A$는 $C^dagger C$의 $V$ 상에서의 연산자이다.

#exercise[
  상태 $psi$의 밀도 연산자를 구하여라.
  1. $psi = 1/sqrt(2) ket(00) + 1/sqrt(2) ket(11)$

  2. $psi = 1/2 ket(00) + i/sqrt(2) ket(01) - i/2 ket(11)$
]

#solution[
  1.
  $
  rho &= tr_V (ketbra(psi)) = tr_V [(1/sqrt(2) ket(00) + 1/sqrt(2) ket(11))(1/sqrt(2) bra(00) + 1/sqrt(2) bra(11))] \
  &= 1/2 ketbra(0) + 1/2 ketbra(1) = mat(1\/2, 0; 0, 1\/2)
  $

  2.
  $
    rho &= tr_V [ (1/2 ket(00) + i/sqrt(2) ket(01) - i/2 ket(11)) (1/2 bra(00) + i/sqrt(2) bra(01) - i/2 bra(11)) ] \
    &= 1/4 ketbra(0) + 1/2 ketbra(0) = 1/(2 sqrt(2)) ket(0) bra(1) - 1/(2 sqrt(2)) ket(1) bra(0) + 1/4 ketbra(1) \
    &= mat(3\/4, - 1\/2 sqrt(2); -1\/2 sqrt(2), 1\/4)
  $
]

== 이분 양자계에서 밀도 연산자의 성질
#theorem(title: [이분 양자계에서 밀도 연산자의 성질])[
  $rho_V$를 $abs(psi)^2 = 1$인 상태 $psi in V times.o W$의 밀도 연산자라고 하자. 이때 다음이 성립한다.
  1. $rho_(vb(v))$는 자기 수반 연산자이다.
  2. $rho_(vb(v))$는 음이 아니다. 즉 
  $
  forall phi in V quad braket(phi, rho_(vb(v)), phi) >= 0
  $
  3. $tr rho_V = 1$
  4. $rho_V$의 고유값들은 실수이며 음수가 아니고 그 합이 1이다.
  5. $psi$가 얽히지 않았다면 $rho_V$는 사영 연산자이며, 그 계수(階數, rank)는 1이다.
  6. $A$가 $V$ 상의 국소적 관측가능량이라면 전체 관측가능량은 $A times.o id_vb(w)$이고 $psi$의 평균 관측값은 $tr(rho_V A)$이다.
]

#proof[
  1. $rho_V = rho_V^dagger$임을 보이면 된다.
  $
    & rho_V = sum_(i, j, k) c_(i j) overline(c_(k j)) ket(vb(v)_i) bra(vb(v)_k) \
    & rho_V^dagger = sum_(i, j, k) overline(c_(i j)) c_(k j) ket(vb(v)_k) bra(vb(v)_i) = rho_V
  $

  2. $rho_V = C^dagger C$로 표현될 수 있음을 이용한다.
  $
      braket(phi, rho_V, phi) = braket(phi, C^dagger C, phi) = braket(C^dagger phi) >= 0
  $
  3. $tr rho_V$의 정의를 이용한다.
  $
    tr rho_V = sum_(i, j, k) c_(i j) overline(c_(k j)) braket(vb(v)_k, vb(v)_i) = sum_(i, j) c_(i j) overline(c_(i j)) = sum_(i, j) abs(c_(i j))^2 = abs(psi)^2 = 1
  $
  4. $rho_V vb(u) = lambda vb(u)$라고 하자. 이제 $braket(vb(u), rho_V, vb(u)) >= 0$인데
  $
    braket(vb(u), rho_V, vb(u)) = vb(u)^dagger rho_V vb(u) = lambda braket(vb(u))
  $
  그러므로 $lambda >= 0$이다. 대각화 가능 행렬의 대각합은 고유값들의 합과 같은데 $tr rho_V = 1$이므로 정리가 성립함을 보일 수 있다.
  5. $psi = vb(v) times.o vb(w)$로 쓰인다고 할 때 밀도 연산자는
  $
    rho_V &= tr_V (ketbra(psi)) = tr_V (ket(vb(v)) times.o ket(vb(w)) bra(vb(v)) times.o bra(vb(w))) \
    &= ket(vb(v))braket(vb(w))bra(vb(v)) = ketbra(vb(v)) = P_vb(v) => rank rho_V = 1
  $
  #corollary[
    $rank rho != 1 => psi "는 얽힘 상태이다."$
  ]

  6. 관측값의 평균은
  $
    sum_i lambda_i abs(P_vb(v)_i psi)^2 = braket(psi, A, psi) \
  $
  이것으로 다음을 알아낼 수 있다.
  $
    A = sum_i lambda_i P_vb(v)_i
  $
  $tr (rho_V A) = expval(A, psi)$임을 보이면 된다.
  $
    psi = sum_(i, j) c_(i j) ket(vb(v)_i) times.o ket(vb(w)_j) \
    rho_V = sum_(i, j, k) = c_(i j) overline(c_(k j)) ket(vb(v)_i) bra(vb(v)_k) \
    A = sum_(s, m) a_(s m) ket(vb(v)_s) bra(vb(v)_m)
  $
  $A = A^dagger$이므로
  $
    a_(s m) = overline(a_(m s))
  $
  이제
  $
    expval(A, psi) &= sum_(p, q) overline(c_(p q)) bra(vb(v)_p) times.o bra(vb(w)_q) sum_(s, m) a_(s m) ket(vb(v)_s) bra(vb(v)_m) sum_(i, j) c_(i j) ket(vb(v)_i) times.o vb(w)_j \
    &= sum_(p, q) overline(c_(p q)) bra(vb(v)_p) times.o bra(vb(w)_q) dot sum_s a_(s i) ket(vb(v)_s) sum_(i, j) c_(i j) ket(vb(w)_j)
  $
  일반항에서 0이 아닌 항이 나올 조건은 $q = j, p = s$이므로 위 식은 아래와 같이 쓸 수 있다.
  $
    sum_(i, j, s) overline(c_(s j)) a_(s i) c_(i j)
  $
  다음으로 $tr(rho_V A)$를 계산하자.
  $
    tr (rho_V A) &= tr(sum_(i, j, k) c_(i j) overline(c_(k j)) ket(vb(v)_i) bra(vb(v)_k) sum_(s m) a_(s m) ket(vb(v)_s) bra(vb(v)_m)) \
    &= sum_(i, j, k) c_(i j) overline(c_(k j)) a_(k i)
  $
  $s$만 $k$로 이름을 바꿔주면 아래가 성립함을 알 수 있다.
  $
    expval(A, psi) = tr(rho_V A)
  $
]

특히 6번 성질은 복잡한 기댓값 계산을 하지 않고 대각합만으로 평균 관측값을 알아낼 수 있다는 점에서 아주 강력한 성질이다.