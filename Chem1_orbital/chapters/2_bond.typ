#import "../template.typ": *

= 결합의 표현

두 원자 A, B가 근접하여 결합을 이룰 때 두 원자의 오비탈 $phi_A (r), phi_B (r)$에 대해 분자가 가질 오비탈은 결국 두 파동의 선형결합으로 인한 간섭이다. 엄밀히 말하면 이것은 무한차원의 파동함수를 두 기저로 나누어 표현한 것으로 그럴싸한 근사 식을 잡은 것이라고 할 수 있다. 이런 방식을 LCAO(linear combinated atom orbital, 선형결합 원자오비탈)이라고 한다.
$
  psi(r) = c_A phi_A(r) + c_B phi_B(r)
$

파동함수를 이렇게 가정하고 슈뢰딩거 방정식과 변분 원리를 적용해 $c$와 $E$를 구한다.

변분원리란 임의의 가정한 파동함수(trial wave function) $psi_t$에 대해 그 기댓값

#let ham = $hat(cal(H), size: #0pt)$

$
  "E"[psi_t] = (braket(psi_t, ham, psi_t))/braket(psi_t, psi_t)
$
은 항상 실제 에너지 바닥상태보다 크거나 같다는 것이다. 

슈뢰딩거 방정식
$
  ham psi = E psi
$
에서 우리가 원하는 것은 모든 기저에 대해 $ham - E = 0$인 것이다. 그러므로 우선, 양변에 $bra(phi_A)$를 취해서 변분 원리를 사용하도록 하자. #footnote[$bra(psi) = ket(psi)^dagger$]
$
  braket(phi_A, ham, psi) = E braket(phi_A, psi)
$

대입하면
$
  braket(phi_A, ham, (c_A phi_A + c_B phi_B)) = E braket(phi_A, (c_A phi_A + c_B phi_B))
$
해밀토니안과 내적 연산은 모두 선형이므로
$
  c_A braket(phi_A, ham, phi_A) + c_B braket(phi_A, ham, phi_B) = E (c_A braket(phi_A, phi_A) + c_B (phi_A, phi_B))
$

여기서 항을 좀 정리하겠다.

먼저, 파동함수가 중첩하는 것은 내적으로 표현할 수 있다. 이때 복소함수임을 고려해 에르미트 내적을 한다.
$
  S_(A B) = braket(phi_A, phi_B) = integral overline(phi_A) phi_B dif tau
$

또, 브라켓을 간단히 표현할 수 있도록 정리하자.
$
  H_(A B) = braket(phi_A, ham, phi_B)
$

이걸로 전개한 식을 정리하면
$
  c_A H_(A A) + c_B H_(A B) = E(c_A S_(A A) + c_B s_(A B))
$

똑같이 $bra(phi_B)$도 투영시키면 같은 형태로
$
  c_A H_(B A) + c_B H_(B B) = E(c_A S_(B A) + c_B S_(B B))
$

이 두 식은 행렬로 한꺼번에 정리할 수 있다.
$
  mat(H_(A A), H_(A B); H_(B A), H_(B B)) mat(c_A; c_B) = E thin mat(S_(A A), S_(A B); S_(B A), S_(B B)) mat(c_A; c_B)
$
이제 각 행렬을 아래와 같이 치환하자.
$
  vbu(H) = mat(H_(A A), H_(A B); H_(B A), H_(B B)) \
  vbu(S) = mat(S_(A A), S_(A B); S_(B A), S_(B B))
$

그러면 식은
$
  vbu(H) vbu(c) = E vbu(S) vbu(c)
$

이제 이 방정식은 $(vbu(H) - E vbu(S))vbu(c) = 0$이 되므로 이것이 해를 가지려면
$
  det (vbu(H) - E vbu(S)) = 0
$

기저는 정규화이므로 $S_(A A) = S_(B B) = 1, S_(A B) = S_(B A) = S$로 놓고, 또 $H_(A A) = H_(B B), H_(A B) = H_(B A)$라고 가정하면 식이 간단해진다.

그러므로 행렬식은
$
  (H_(A A) - E)^2 - (H_(A B) - E S)^2 = 0
$

합차공식으로 인수분해하면
$
  [(H_(A A) - E) - (H_(A B) - E S)] [(H_(A A) - E) + (H_(A B) - E S)] = 0
$

$E$에 대해 나오는 두 근은
$
  E_(plus.minus) = (H_(A A) plus.minus H_(A B))/(1 plus.minus S)
$

중첩된 정도인 $S$가 충분히 작다고 하면 이렇게 근사할 수 있다.
$
  E_(plus.minus) approx H_(A A) plus.minus H_(A B)
$

즉 $H_(A B)$가 클수록 강한 결합이다.

원자오비탈이 같은 부호로 겹치면 보강 간섭이 일어나서 결합이 강하고 안정해지고, 다른 부호로 겹치면 상쇄 간섭이 일어나서 결합이 약화 또는 소멸된다.

2주기 원소들의 $p$ 오비탈($cal(l) = 1$)은 앞서 보았듯이
$
  & p_x prop x f \
  & p_y prop y f \
  & p_z prop z f \
  & "where " f(r) = r e^(- alpha r)
$

드디어 결합에 대해 보자. 가장 빈번하게(화학Ⅰ 범위 내에서는 항상) 일어나는 공유결합은 딱 두 가지 종류로 나뉜다.
- $sigma$ 결합: 결합 축을 따라 오비탈이 정면으로 겹친다($s-s, s-p_z, p_z-p_z$). 결합 축을 대칭선으로 전자 밀도가 약간 원기둥처럼 생기게 분포한다. 따라서 원자핵간 결합 축을 회전해도 결합이 깨지지 않는다.
- $pi$ 결합: 결합 축에 수직인 $p_x, p_y$ 오비탈이 옆면으로 평행하게 겹친다. 이때 두 오비탈이 중첩되면 전자 밀도는 양 끝 부분에 집중되면서 원자핵부터의 거리가 멀어지는데, 이 때문에 결합 강도도 약하고 회전도 불가능하다.

단일 결합은 모두 시그마 결합이며, 이중 결합은 시그마 결합과 파이 결합 한 개, 삼중 결합은 시그마 결합과 파이 결합 두 개로 되어 있다.

파이 결합 상태로 결합을 회전시킬 시 결합이 깨지기 쉽다는 것을 보여 보겠다#footnote[여기부터는 아무 도움도 안 받고 제가 직접 해보는 것이기 때문에 증명 과정이 틀릴 수 있습니다. 사실 이거 하려고 앞의 내용을 정리한 것입니다...].

#figure(
  grid(columns: 2, image("0_JDkSsCRSUrPtumD3.png", width: 80%), image("270px-Pi-bond.jpg", width: 100%)),
  
  caption: [$sigma$ 결합과 $pi$ 결합의 시각화]
)

회전 연산자를 $hat(R)_z (alpha)$로 놓자. 결합축을 $z$축으로 잡고 그 주위로 회전시키는 각도는 $alpha$라는 뜻이다. 앞서 구면좌표계에서 파동함수를 기술할 때 나왔던 $R$과는 다른 것이다. 이 연산자는 $Y^m_cal(l)$에 위상 변환 연산자로 작용하여 이렇게 될 것이다.
$
  hat(R)_z (alpha) thin Y^m_cal(l) (theta, phi) = e^(i m alpha) thin Y^m_cal(l) (theta, phi)
$

우리의 2주기 원소 상황에서 시그마 결합은 $m = 0$($s$ 오비탈)일 때 일어나므로 $e^(i alpha dot 0) = 1$이 되어 실제 회전이 변하지 않는다. 파이 결합은 $m = plus.minus 1$일 때 일어나므로 회전하면 $e^(plus.minus i alpha)$ 위상인자가 붙어 위상이 돌아간다.

구체적으로 $p$ 오비탈끼리 붙은 파이 결합의 예시를 보자. 이번에는 직관적으로 편하게 결합 축을 $x$로 놓아 보겠다. 두 원자 A, B가 있고 A의 파이 결합 오비탈이 $p_y^((A))$라고 하자. B를 $x$축으로 $theta$만큼 회전하면
$
  p_y^((B)) attach("", tl:') = cos theta p_y^((B)) + sin theta p_z^((B))
$
처럼 되어 성분 간에 선형 결합을 일어나게 한다. 이때 두 오비탈의 중첩은 다음과 같은데,
$
  S(theta) &= braket(p_y^((A)), p_y^((B)) attach("", tl:')) = integral p_y^((A)) p_y^((B)) attach("", tl:') dif tau \
  &= cos theta integral p_y^((A)) p_y^((B)) dif tau + cancel(sin theta integral p_y^((A)) p_z^((B)) dif tau)
$

오비탈이 결합 축에 대칭이므로 기함수의 적분 원리에 따라 마지막 항이 소거된다. 즉
$
  S(theta) = cos theta braket(p_y^((A)), p_y^((B)))
$

$theta$가 $pi/2$에 근접할수록 겹침이 사라지게 된다. 이때 $H_(A B)$도 결국 $S$와 양의 상관관계가 있으므로 아까 에너지 식
$
  E_(plus.minus) approx H_(A A) plus.minus H_(A B)
$
에 따라 보강간섭인 $E_+$와 상쇄간섭인 $E_-$ 간 에너지 차이가 줄어들게 되어 결합이 점점 깨지게 된다.

결론은, 파이 결합을 가진 분자인 경우 결합 구조가 입체가 되게 되면 결합이 돌아가면서 깨지므로 입체가 될 수 없고 평면 상태에서 안정하게 존재한다는 것이다.