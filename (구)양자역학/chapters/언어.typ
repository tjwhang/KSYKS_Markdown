#import "../../TypstTemplate/TypstTemplate.typ": *

= 양자역학의 언어

앞에서는 전체 맥락을 이해하려면 필요한 사전 지식에 대해 이야기했다면, 여기서부터는 실제로 양자역학을 수학적으로 이해하고 계산하는 데 필요한, 양자역학의 언어에 대해 공부합니다.

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


== 디랙 표기법
디랙(Paul Dirac)이 고안한 브라-켓 표기법(bra-ket notation)은 벡터를 표기하는 새로운 방법입니다. 이름의 유래는 $angle.l angle.r$(bracket)를 반으로 잘라서 $angle.l$를 bra, $angle.r$를 ket이라고 하는데서 왔습니다.

먼저, 우리가 아는 벡터 표기법은 아래와 같습니다. 굵은 글씨로 쓰는 것은 위에 화살표를 쓰는 것보다 가독성이 좋다는 장점이 있으며, 기울일지 바로 세울지는 정해져 있지 않습니다.
$
  va(v) = vb(v) = vb(v)
$
켓을 사용한 표기는 아래와 같습니다.
$
  va(v) = ket(v)
$

브라는 일종의 연산자로서, 옆에 오는 항과의 내적(inner product, dot product)을 의미합니다.
$
  va(v) dot {} = innerproduct(vb(v), {}) = bra(v)
$

어떤 벡터가 브라에 결합하면 아래와 같이 됩니다.
$
  bra(a) ket(b) = braket(a, b) = vb(a) dot vb(b)
$

이러한 브라-켓 표기법으로, 힐베르트 공간의 원소인 벡터를 통해 양자 상태를 $ket(psi)$처럼 표현하게 됩니다. 이것에 대한 이야기도 나중에 자세히 하겠습니다.

