#import "../template.typ": *
#import "../chart.typ": *

== 연구내용

=== 수학적 추상화

앞서 상정했던 정방 격자 모형을 먼저 도입하겠다. 정방 격자 모형은 단백질 구조를 통계역학적이나 수학적으로 연구할 때 널리 쓰이는 방식으로, 단백질의 1, 2, 3, 4 차 구조와 그 구부러짐(이면각)을 단순화시켜 표현하면서도 실제 단백질 구조 및 형성 과정과 비교했을 때 SAW나 배제 체적 등 중요한 특성을 반영하므로 크게 일반성을 잃지 않는다. 더불어, 20 가지의 아미노산을 소수성과 친수성으로만 분류하는 HP 모형(hydrophobic-polar model)을 도입하겠다. HP 모형은 켄 딜(Ken A. Dill)이 1985년 제안한 모형으로, 이 소수성/친수성 결합 상태가 에너지와 엔트로피에 가장 큰 영향을 주는 요인이 된다. 이렇게 하면, 소수성 단백질끼리 뭉칠 때 에너지가 낮아진다는 규칙을 얻을 수 있다. @hpmodel

단백질이 접히는 과정은 물 속(수용액)에서 일어나는데, 소수성 아미노산들은 접히기 전에는 물에 풀려 있다. 물 분자들은 지속적으로 서로 간 수소 결합을 맺으며 끊임없이 회전하고 이동한다. 즉, 자유도가 높다#footnote[물 분자의 수소결합 때문에 물의 끓는점이 분자량이 비슷한 다른 물질보다 높다거나 얼으면 부피가 커지는 등의 독특한 성질들이 발현한다.]. 하지만 물 분자 옆에 소수성 분자가 있게 되면 물 분자는 소수성 분자와는 결합을 맺을 수 없으므로 소수성 분자를 등지고 물 분자들끼리만 결합을 형성한다. 결과적으로 물 분자들이 소수성 분자를 둘러싸 가두어 둔 채, 마치 얼음 결정 같은 다면체 모양의 포접구조(包接構造, clathrate cage)를 형성한다#footnote[흔히 말하는 포접화합물(包接化合物, clathrate compound)는 가스 하이드레이트(메탄 하이드레이트)를 의미하는 것으로, 바닷속 물 분자들이 메탄을 얼음처럼 둘러싸고 있는 것을 말한다. 미시적으로, 소수성 아미노산에서도 비슷한 일이 일어난다.]. 이런 것을 소수성 효과(疏水性效果, hydrophobic effect)라고 한다. 이때 포접구조를 형성한 물 분자들은 자유도가 떨어지므로, 엔트로피 또한 낮아진다. @clath1 @clath2 @hpeff

열역학 제2법칙에 따라 엔트로피는 증가해야하는데, 엔트로피가 증가하는 가장 쉬운 방법 중 하나는 두 소수성 분자가 붙는 것이다. 그렇게 되면 소수성 분자와 물이 맞닿는 표면적이 좁아져 자유도를 잃는 물 분자들이 적어지게 되고, 따라서 엔트로피가 증가할 수 있다. 그러므로 물 분자는 엔트로피를 "되찾기 위해" 소수성 분자들을 한 군데로 밀고 가서 서로 붙여버리는데, 이것을 소수성 붕괴(疏水性崩壞, hydrophobic collapse) 이론이라고 한다. 정제된 용어로 표현하자면, 극성 용매 내에서 폴리펩타이드나 기타 분자가 취하는 3차원 구조의 형성 과정에서, 소수성 분자와 물이 상호작용하여 가해지는 열역학적 압력으로 분자가 응집되거나 "붕괴"하는 것이다. 이 과정이 반복되면 소수성 아미노산은 단백질 구조의 안쪽으로 몰려 들어가 단단하게 뭉쳐 소수성 핵(hydrophobic core)을 형성하게 되고, 단백질 구조의 바깥쪽은 자연스럽게 친수성 아미노산들이 구성하게 된다. 이런 방식으로 공 모양의 3차 구조가 형성된다.

단백질이 접히는 과정에서 전술한 에너지 및 엔트로피의 변화를 깁스(Gibbs) 자유에너지로 나타내어 알아보자.
$
    Delta G = Delta H - T(Delta S_"단백질" + Delta S_"물")
$
단백질이 알아서 접히려면 $Delta G < 0$이어야 한다. 단백질이 접혀 나가는 과정에서 내부에 수소 결합과 반데르발스(Van der Waals) 인력이 형성되면서 내부 에너지가 낮아지므로 $Delta H < 0$이고, 단백질들은 특정한 구조를 이루게 되므로 $Delta S_"단백질" < 0$이다. 그러므로 소수성 아미노산들이 결합하면서 포접구조가 풀릴 때 증가하는 물의 엔트로피 $Delta S_"물"$가 더 커야 전체적으로 $Delta G < 0$이 된다.

$Delta S_"단백질"$을 계산하기 위해 몇 가지 변수를 설정하자. 아미노산의 개수를 $N$, 풀려 있는 상태에서 자유도를 $mu$라고 하고 편의상 3으로 두자. 그러면 풀려 있을 때 가능한 미시상태의 수 $Omega_u$는 대략 $mu^N$이다. 접힌 후의 구조인 고유 구조의 미시상태 수 $Omega_f$는 당연히 단 한 가지이다. 이제 이걸 볼츠만 엔트로피 공식에 대입한다.
$
    Delta S_"단백질" & = S_f - S_u = k_B ln 1 - k_B ln mu^N \
                     & = - N k_B ln mu approx -1.1 N k_B
$

즉 아미노산 개당 약 $1.1 k_B$만큼의 엔트로피가 손실된다.

이제 $Delta S_"물"$을 구해보자. 전체 아미노산 $N$ 개 중 소수성 아미노산의 비율을 $f$라고 하자. 보통 구형 단백질에서 $f approx 0.5$이다. 또, 소수성 아미노산 한 개가 물에 노출될 때 포접구조를 형성하느라 묶이는 물 분자의 개수를 $n_w$라고 하자. 실험적으로 $n_w$ 는 대략 10에서 15 사이의 값을 가진다. 이때 단백질이 완전히 풀려 있을 때 묶여있게 되는 전체 물 분자의 개수 $W$는 아래와 같다.
$
    W = f N n_w
$

물 분자가 완전히 자유로울 때(bulk water)의 미시상태 수를 $Omega_b$, 소수성 분자의 영향을 받을 때의 미시상태 수를 $Omega_c$라고 하자. 그러면 $Delta S_"물"$은
$
    Delta S_"물" = W dot.op k_B (ln Omega_b - ln Omega_c) = W k_B ln Omega_b/Omega_c
$ <dsw>
여기서 물의 나머지 조건(온도, 내부에너지 등)은 일정하므로 $Omega$ 비율은 수소 결합 시 뻗을 수 있는 팔의 방향 등의 가지수로 결정된다. 따라서 이렇게 표현해 보자.
$
    Omega prop integral_C dif t
$
소수성 분자의 영향을 받을 때는 자유로울 때에 비해 수소 결합 시 팔들을 물과 등지는 방향으로만 뻗을 수 있기 때문에, 실험적 데이터가 없는 상황이므로 그냥 자유로울 때는 $C$를 구로, 소수성 분자에 묶일 때는 $C$를 반구로 하자. 그러면 $Omega$의 비율은 $4 pi r^2$과 $2 pi r^2$의 비이므로 2이다. 이걸 @dsw 에 대입하자.
$
    Delta S_"물" = W k_B ln 2 approx W k_B dot 0.693 = f N n_w k_B dot 0.693
$
$n_w$를 12 정도로 치고 물과 단백질의 엔트로피 증분을 비교하자.
$
    abs((Delta S_"물")/(Delta S_"단백질")) = (12 dot 0.5 dot 0.693 cancel(N k_B))/(1.1 cancel(N k_B)) approx 3.78
$
즉 $Delta S_"물"$이 $Delta S_"단백질"$보다 약 4배나 크다. 그러므로 $Delta G < 0$이다. 이 엔트로피 차이가 엔트로피 변화의 가장 큰 원동력이므로, HP 모형만으로 단백질 구조 변화를 간단하게 설명할 수 있다. 그러나, 언제나 모형과 그에 따른 규칙을 구체화하여 알고리즘을 더 실용적으로 만들 수 있음을 명시하는 바이다. 지금은 발상을 제기하는 것에 더 초점을 맞추도록 하겠다.

=== 상태 변수의 정의

양자컴퓨터도 컴퓨터이고, 큐비트가 그 기반이 되므로 입력 변수를 큐비트의 서열로 설정하고 해밀토니안 에너지 상호작용 관계식으로 알고리즘을 표현해야 한다. 따라서 단백질 사슬이 공간 상에서 어떤 구조를 이루고 있는가 하는 위상적 형태를 어떤 큐비트가 0이고 어떤 큐비트가 1인가 하는 이산적 최적화 문제로 바꾸어야 한다.

먼저 아미노산 서열을 입력받아야 할 것이다. 단백질을 구성하는 총 아미노산의 개수를 $N$이라고 하고, 각 아미노산의 성질(친수성 $"P"$ 또는 소수성 $"H"$)을 이진화된 $s_i$의 순서쌍(또는 $N$ 차원 벡터)로 받는다.
$
    S = (s_1, s_2, s_3, ..., s_N) in {"H", "P"}^N
$
또, 단백질이 존재할 수 있는 2/3 차원 정방 격자의 총 격자점 개수를 $M$이라고 하자. 이제 각 격자점의 좌표를 $alpha, beta, gamma...$의 인덱스로 나타낸다. 그러면 $alpha = 1, ..., M$이다. 그리고 공간의 입체성을 나타내기 위해 격자점들을 그래프로 치환해 인접행렬(隣接行列, adjacency matrix) $A_(alpha beta)$을 사용할 수 있다. 마지막으로 아미노산 $i$가 격자점 $alpha$에 위치하는지 여부를 결정하는 이진변수 $q_(i, alpha)$를 도입하겠다. 이것이 큐비트에 대응되는 값이 된다.

이제 $N times M$ 개의 큐비트가 속하는 상태 공간은 가능한 조합의 가짓수가 $2^(N times M)$ 개인 거대한 힐베르트 공간이다. $N times M$의 큐비트 행렬을 $vb(Q)$라고 하면 $vb(Q)$는 아래와 같다.
$
    vb(Q) = mat(q_(1 comma 1), q_(1 comma 2), ..., q_(1 comma M); q_(2 comma 1), q_(2 comma 2), ..., q_(2 comma M); dots.v, dots.v, dots.down, dots.v; q_(N comma 1), q_(N comma 2), ..., q_(N comma M))
$

=== 해밀토니안 식 세우기

이 행렬 $vb(Q)$는 아무런 값이나 가질 수 있는 것이 아니다. 생물학적, 물리학적으로 의미가 있는 단백질 사슬로 만들기 위해서는 특정한 규칙들이 있는데, 크게 세 가지를 떠올려 보았다. 이 규칙들을 조작하여 알고리즘이 작동하는 방식을 바꿀 수 있다.

1. 하나의 아미노산은 반드시 공간 상에서 딱 한 곳에 존재해야 한다.
2. 한 개의 격자점에는 단 한 개의 아미노산만이 들어갈 수 있다.
3. 서열 상 이어진 아미노산 $i$와 $i+1$은 반드시 인접한 격자 좌표에 있어야 한다.

여기에 추가로 앞서 알아보았던 소수성 효과 규칙을 추가하여 최적화의 방향을 지정해줄 수 있다.
4. 서열 상에서 인접하지 않지만 공간 상으로 인접한 소수성 아미노산끼리 결합하면 에너지가 낮아진다#footnote[서열 상에서 인접해 있는 소수성 아미노산들은 어차피 둘이 붙어있어야만 하는 관계이기 때문에 계산의 대상이 되면 비효율적이다.].

이 규칙들을 반영하여 해밀토니안 식을 세워보면 아래와 같을 것이다.
$
    H_P = lambda(H_1 + H_2 + H_3) + H_4
$
여기서 해밀토니안은 일종의 비용함수(cost function)처럼 작동하고, $lambda$는 페널티를 주는 상수로 아주 큰 값을 가져서, 해당 규칙을 어기고 얻은 물리적 에너지 이득보다 해당 규칙을 어겨서 받는 페널티가 무조건 커야 한다.

먼저 $H_1$부터 세우자. 특정 아미노산 $i$에 대해 모든 좌표 $alpha$를 조사했을 때, $q_(i, alpha)$의 값은 항상 1이어야 한다. 입력에서 지정한 아미노산이 없어서도 안 되고, 두 개 이상이어서도 안 된다. 합이 1에서 벗어나면 양의 값으로 크게 보내버리기 위해 제곱을 취하자.
$
    H_1 = sum_(i=1)^N [1 - sum_(alpha=1)^M q_(i, alpha)]^2
$ <h1>

$H_2$를 판별하는 기준은 한 좌표에 아미노산이 동시에 있는지이므로 두 아미노산 $i, j$에 대해 $q_(i, alpha) q_(j, alpha)$의 값이 0인지 1인지를 확인하면 된다. 1이라면 한 자리에 두 개 이상 있다는 것이므로 $H_2$의 값에 반영한다.
$
    H_2 = sum_(alpha = 1)^M sum_(i < j)^N q_(i, alpha) q_(j, alpha)
$


$H_3$를 판별하기 위해서는 인접행렬 $A_(alpha beta)$를 가져오자. 아미노산 순서쌍 $(i, i+1)$에 대해 그 어떤 두 아미노산이라도 인접행렬 상에서 1의 값을 반환하지 않는다면 규칙을 어기는 것이 된다.
$
    H_3 = sum_(i = 1)^(N - 1) sum_(alpha = 1)^M sum_(beta = 1)^M (1 - A_(alpha beta)) q_(i, alpha) q_(i + 1, beta)
$

마지막으로 $H_4$에 대해, 서열 상 바로 옆에 붙어있지 않지만 공간 상 인접하는 아미노산을 에너지를 낮춰야 한다. 아미노산 $i, j$가 모두 소수성일 때 1, 아니면 0을 가지는 행렬 $delta_(i j)$를 도입하자. 이때 $delta_(i j) = 1$이면 값이 작아져야 하므로 $-$를 붙여주자.
$
    H_4 = - sum_(i < j - 1)^N delta_(i, j) sum_(alpha = 1)^M sum_(beta = 1)^M A_(alpha beta) q_(i, alpha) q_(j, beta)
$

해밀토니안 식은 완성되었지만, 이것을 실제로 AQC 기반의 양자컴퓨터가 실행하게 하려면 QUBO 매핑을 수행해야 한다. QUBO(이차 비제약 이진 최적화, quadratic unconstrained binary optimization)이란, 변수끼리의 곱이 최대 2 개 까지만 허용되고, 어떤 값에 대한 명시적 제한을 두지 않고 대신 페널티로 제약 조건을 설정하며, 변수는 오직 0과 1의 값만 가져야 하는 상태에서 진행하는 최적화 문제이다. 즉 다음과 같다.
$
    "Minimize: " quad y = sum_i a_i x_i + sum_(i < j) b_(i j) x_i x_j
$ <qubo>

$0^2 = 0$이고 $1^2 = 1$로, 이진변수는 제곱해도 그 값이 원래와 다르지 않다는 점($q^2 = q$)을 이용해 해밀토니안 식을 QUBO의 형태로 정리할 수 있다.

$sum q =: S$로 놓고 @h1 를 전개하자.
$
    (1 - S)^2 = 1 - 2 S + S^2 = 1 - 2 sum_alpha q_(i, alpha) + [sum_alpha q_(i, alpha)]^2
$
여기서 제곱항은 모든 조합의 곱이다.
$
    [sum_(alpha = 1)^M q_(i, alpha)]^2 = sum_(alpha = 1)^M q_(i, alpha)^2 + 2 sum_(alpha < beta) q_(i, alpha) q_(i, beta)
$
$q^2=q$이므로
$
    H_1 = sum_i (1 - 2 sum_alpha q_(i, alpha) + sum_alpha q_(i, alpha) + 2 sum_(alpha < beta) q_(i, alpha) q_(i, beta))
$
식을 정리하면
$
    H_1 = sum_i (1 - sum_alpha q_(i comma alpha) + 2 sum_(alpha < beta) q_(i comma alpha) q_(i comma beta))
$
$H_2$, $H_3, H_4$은 이미 QUBO를 만족한다. 위의 식을 아래 모양과 같이 행렬을 포함한 식으로 간단히 정리할 수 있다.
$
    E(vb(x)) = vb(x)^T vb(W) vb(x)
$ <quboE>

그렇게 하기 위해 먼저 $q_(i, alpha)$ 형태였던 $vb(Q)$ 행렬을 1차원 벡터로 평탄화할 필요가 있다. 그 벡터를 $vb(x)$라고 하는 것이다. $vb(Q)$를 $vb(x)$로 $k = (i - 1)M alpha$로 매핑하면 $vb(x)$는 총 변수의 개수는 $K = N times M$ 개 이고 행이 $K$ 개인 열벡터가 된다.
$
    vb(x) = mat(q_(1 comma 1); q_(1 comma 2); dots.v; q_(N comma M)) = mat(x_1; x_2; dots.v; x_K)
$
이렇게 하면 @quboE 는 아래 꼴과 같이 나오게 된다. 이때 $vb(W)$는 계산의 편의를 위해 하삼각 성분을 모두 0으로 하는 상삼각 행렬(上三角行列, upper triangular matrix)로 한다.
$
    E =
    mat(x_1, x_2, dots.c, x_K) thin
    mat(
        W_(1 comma 1), W_(1 comma 2), W_(1 comma 3), dots.c, W_(1 comma K);
        0, W_(2 comma 2), W_(2 comma 3), dots.c, W_(2 comma K);
        0, 0, W_(3 comma 3), dots.c, W_(3 comma K);
        dots.v, dots.v, dots.v, dots.down, dots.v;
        0, 0, 0, dots.c, W_(K comma K)
    ) thin
    mat(x_1; x_2; dots.v; x_K)
$
이 행렬곱을 전개해보면, 대각 성분은 같은 변수의 곱인 1차항이, 비대각 성분은 서로 다른 두 변수의 곱인 2차항이 되면서 @qubo 꼴이 되는 것을 알 수 있다. 행렬 $vb(W)$의 성분들에는 앞서 유도했던 $H$ 식들의 계수가 들어간다. 따라서 전개된 꼴은 아래와 같을 것이다.
$
    E = W_(1, 1) x_1 + W_(2, 2) x_2 + ... + W_(1, 2) x_1 x_2 + W_(1, 3) x_1 x_3 + ...
$

=== 실행 및 출력값 해석

이 보고서에서 D-Wave 社의 컴퓨터 등과 같은 공학적인 양자컴퓨터 설계 방법 등에 대해 다루지는 않을 것이다. 하지만 본 양자 알고리즘의 최종 목표는 앞서 수학적으로 정의한 $vb(W)$ 행렬을 양자컴퓨터에 주입하고#footnote[아미노산의 서열들을 고전컴퓨터에 입력하면, 고전컴퓨터에서 먼저 서열 정보를 행렬 $vb(W)$로 처리하여 양자컴퓨터로 전달한다.] 양자동역학적 과정을 통해 답을 출력해낸 뒤 이것을 다시 생물학적 의미를 가지는 구조로 복원하는 것이다.

가장 먼저, 모든 $K$ 개의 큐비트에 대해 강력한 횡자장(橫磁場, transverse field)을 걸어 가능한 모든 상태의 중첩 상태로 초기화시킨다.
$
    H_0 = - sum sigma_x^((i))
$
여기서 $sigma_x$는 파울리 X 연산자이다. 단일 큐비트 파울리 X 연산자 $sigma_x$는 아래와 같다.
$
    sigma_x = mat(0, 1; 1, 0)
$
이 연산자의 고유값 방정식 $sigma_x ket(psi) = lambda ket(psi)$의 해를 구해보자. 먼저 특성방정식 $det(sigma_x - lambda I) = 0$을 풀자.
$
    mdet(-lambda, 1; 1, -lambda) = lambda^2 - 1 = 0 quad therefore lambda = plus.minus 1
$
이제 각 고유값을 $(sigma_x - lambda I) ket(psi) = 0$에 대입하여 $ket(psi)$를 찾자. $lambda = 1$일 때,
$
    mat(-1, 1; 1, -1) vec(x, y) = vec(0, 0) quad therefore x = y
$
$lambda = -1$일 때,
$
    mat(1, 1; 1, 1) vec(x, y) = vec(0, 0) quad therefore x = -y
$
정규화조건 $x^2 + y^2 = 1$을 만족시키는 $ket(psi)$를 고려하면 최종적으로 해는 다음과 같다.
$
    lambda = plus.minus 1, quad ket(psi) = 1/sqrt(2) (ket(0) plus.minus ket(1)) = ket(plus.minus) wide "(복부호동순)"
$

이때 $H_0$이 최소이려면 $- sigma_x^((i))$의 기댓값이 최소인 -1이어야 하므로 $sigma_x^((i))$의 기댓값은 최대인 1이 되면서 각 큐비트는 고유값이 1인 상태, 즉 $ket(+)$ 상태가 된다.
계의 초기 파동함수 $psi(0)$은 다음과 같이 모든 기저 상태가 동일한 확률 진폭을 갖는 상태로 된다.
$
    ket(psi(0)) = 1/sqrt(2^K) sum_(vb(x) in {0, 1}^K) ket(vb(x))
$
초기화가 완료되었다면 시간에 따라 해밀토니안을 초기 상태 $H_0$에서 아까 세워놓았던 단백질 규칙의 상태 $H_P$로 서서히 변화시킨다. 이것을 어닐링 경로(annealing path)라고 한다.
$
    H(t) = (1 - t/T) H_0 + t/T H_P
$

이때 단열 조건을 만족하기 위해서는, 즉 계가 바닥 상태를 유지하며 가기 위해서는 변화 속도가 매우 느려야 한다. 특히 $1 - t/T$와 $t/T$가 교차하는 지점인 $t = T/2$인 지점에서 에너지 간격이 가장 좁아지므로 이때 계가 들뜬 상태로 튀어나가지 않도록 정교한 속도 제어가 필요하다#footnote[사실 항상 $1 - t/T$와 $t/T$이지 않으며, $H(t) = A(t) H_0 + B(t) H_P$에서 $A(t)$는 1에서 0으로 감소하고 $B(t)$는 0에서 1로 증가한다.].

계가 진화를 마치고 $H = H_P$인 상태가 되었다면 $ket(psi(T)) approx ket(vb(x)_"opt")$로 최적해의 상태에 도달해 있게 된다. 이제 이것을 측정한다. $z$ 축 기저로 양자상태를 측정하면 중첩되어 있던 파동함수가 붕괴하면서 하나의 상태 벡터가 나온다. 예를 들자면 다음과 같이 생겼을 것이다.
$
    vb(x)_"출력" = vec(0, 0, 1, 0, 1, dots.v, 0)
$
이제 이 결과를 다시 $N times M$의 행렬 $vb(X)$로 변환한다.
$
    x_(i, alpha) = (vb(x)_"출력")_((i - 1)M + alpha)
$
이제 몇 번 아미노산이 몇 번째 격자점에 있는지를 알게 되고, 이것을 다시 2차원 또는 3차원 직교좌표계 값으로 변환하여 표현하면 입력한 아미노산 서열로 만들어지는 단백질의 고유 구조를 알 수 있게 되는 것이다.

== 연구 결과

양자컴퓨팅을 이용해, 아미노산의 HP 서열을 입력하면 그 고유구조를 내놓는 알고리즘을 설계했다. 앞에서는 이 문제를 고전컴퓨터로는 풀 수 없다고 하였으나, 어디까지나 시간복잡도와 공간복잡도가 커지기 때문에 그런 것이지 기하급수적인 자원을 때려박고 우주의 나이의 몇 배가 되는 시간을 기다리면 풀어낼 수 있다. 하지만 그것은 서열의 크기가 큰 수로 늘어났을 때를 말하는 것이고, 고전컴퓨터로 짧은 서열을 계산해 내는 것은 가능하다#footnote[복잡도가 $2^N$에 비례한다는 것을 기억하자.]. 따라서 입력과 결과가 어떨지, 그리고 내부적으로는 어떻게 작동할지를 C++를 이용하여 양자 어닐링을 흉내내어 구현해 보았다.

본 문서 하단이나, Github(https://github.com/tjwhang/ProteinAQC/blob/main/main.cpp)에서도 코드를 열람할 수 있다.

싱글벙글 만들고 실행했는데 처음부터 꽝이었다.

#figure(
    image("../assets/image.png", width: 70%),
    caption: "아미노산 겹침",
)

아미노산 4와 6이 격자점 $(2,4)$에서 겹쳐버린 것이었다. 처음에는 코딩을 잘못한 줄 알았으나, 코드 설계의 문제가 아니라 고전컴퓨터의 한계였다. 고전컴퓨터로 시뮬레이션하는 어닐링은 양자터닐링이 없기 때문에 작은 $N$ 값에서도 오류가 많기 때문이다. 그래서 $lambda$ 페널티 상수, 시도 횟수 등 수치를 조절하고 결과 출력 후 해당 결과가 타당한지를 확인하는 코드를 추가했다.

#figure(
    image("../assets/image1.png", width: 60%),
    caption: "올바른 구조",
)

이렇게 잘 나올 때도 있지만, 제대로 되지 않을 때도 있고,
#figure(
    image("../assets/image2.png", width: 60%),
    caption: "사슬 끊어짐",
)
물리적으로는 유효하지만 최적의 고유구조가 아닌 경우도 있다.

#figure(
    image("../assets/image3.png", width: 60%),
    caption: "최적의 고유구조가 아님",
)

이렇게 되는 이유는 무엇보다 고전컴퓨터는 양자컴퓨터가 아니기 때문이다. 부차적인 이유로는 최적 수치를 입력하지 못했기 때문도 있을 것이다. 고전컴퓨터는 아미노산 20개로도 고전할 테지만, 양자컴퓨터는 100개도 거뜬히 계산해낼 수 있다는 점이, 직접 만들어 실행해 보니 새삼스레 신기했다. 양자컴퓨터가 앞으로 수많은 분야에서 불러올 혁명이 기대된다.

```cpp
#include <iostream>
#include <vector>
#include <string>
#include <cmath>
#include <random>
#include <algorithm>

using namespace std;

const int N = 6;           // 아미노산의 개수 (HPHHPH 서열 길이에 맞춤)
const int L = 6;           // 격자축의 크기
const int M = L * L;       // 총 격자점 수
const int K = N * M;       // 총 큐비트 수 (N * M)
const double LAMBDA = 5.0; // 고전 SA 페널티 상수는 적당히
const double DELTA = 2.0;  // 소수성 결합 보상

string sequence = "HPHHPH"; // 아미노산 서열

// 2차원 인덱스를 1차원으로
inline int get_idx(int i, int alpha) { return i * M + alpha; }

// 인접 여부 확인 (맨하튼 거리 = 1)
bool is_adjacent(int a, int b)
{
    int r1 = a / L, c1 = a % L;
    int r2 = b / L, c2 = b % L;
    return abs(r1 - r2) + abs(c1 - c2) == 1;
}

int main()
{
    vector<vector<double>> W(K, vector<double>(K, 0.0));

    // W matrix
    // H_1: 하나의 아미노산은 딱 한 곳에만 있어야 한다
    for (int i = 0; i < N; ++i)
    {
        for (int a = 0; a < M; ++a)
        {
            int u = get_idx(i, a);
            W[u][u] += -LAMBDA; // 1차항
            for (int b = a + 1; b < M; ++b)
            {
                int v = get_idx(i, b);
                W[u][v] += 2.0 * LAMBDA; // 2차항
            }
        }
    }

    // H_2: 하나의 격자점에는 두 개 이상 있으면 안된다
    for (int a = 0; a < M; ++a)
    {
        for (int i = 0; i < N; ++i)
        {
            for (int j = i + 1; j < N; ++j)
            {
                W[get_idx(i, a)][get_idx(j, a)] += LAMBDA;
            }
        }
    }

    // H_3: 서열 상 이웃하면 격자 상에서 이웃해야한다
    for (int i = 0; i < N - 1; ++i)
    {
        for (int a = 0; a < M; ++a)
        {
            for (int b = 0; b < M; ++b)
            {
                if (a == b)
                    continue;
                if (!is_adjacent(a, b))
                {
                    int u = get_idx(i, a), v = get_idx(i + 1, b);
                    if (u < v)
                        W[u][v] += LAMBDA;
                    else
                        W[v][u] += LAMBDA;
                }
            }
        }
    }

    // H_4: H-H 붙으면 에너지 낮아지는거
    for (int i = 0; i < N; ++i)
    {
        for (int j = i + 2; j < N; ++j)
        {
            if (sequence[i] == 'H' && sequence[j] == 'H')
            {
                for (int a = 0; a < M; ++a)
                {
                    for (int b = 0; b < M; ++b)
                    {
                        if (is_adjacent(a, b))
                        {
                            int u = get_idx(i, a), v = get_idx(j, b);
                            if (u < v)
                                W[u][v] -= DELTA;
                            else
                                W[v][u] -= DELTA;
                        }
                    }
                }
            }
        }
    }

    // 가짜 어닐링
    vector<int> x(K, 0);
    random_device rd;
    mt19937 gen(rd()); // RNG
    uniform_real_distribution<> dis(0.0, 1.0);
    uniform_int_distribution<> bit_dis(0, K - 1);

    double T = 100.0;      // 초기 온도
    double T_min = 0.01;   // 최종 온도
    double alpha = 0.9999; // 냉각 속도
    int steps = 1500000;   // 탐색 횟수

    for (int s = 0; s < steps && T > T_min; ++s)
    {
        int k = bit_dis(gen); // 무작위 비트

        double delta_E = 0;
        int x_k_old = x[k];
        int x_k_new = 1 - x_k_old;
        int diff = x_k_new - x_k_old;

        // 대각 성분 1차항 기여
        delta_E += W[k][k] * diff;
        // 비대각 성분 2차항 기여
        for (int j = 0; j < K; ++j)
        {
            if (k == j)
                continue;
            double weight = (k < j) ? W[k][j] : W[j][k];
            delta_E += weight * diff * x[j];
        }

        // Metropolis 수용 조건
        if (delta_E < 0 || dis(gen) < exp(-delta_E / T))
        {
            x[k] = x_k_new;
        }
        T *= alpha; // 냉각
    }

    // 유효성 검증
    vector<int> pos(N, -1);
    bool one_hot_ok = true, overlap_ok = true, connectivity_ok = true;

    for (int i = 0; i < N; ++i)
    {
        int count = 0;
        for (int a = 0; a < M; ++a)
        {
            if (x[get_idx(i, a)] == 1)
            {
                pos[i] = a;
                count++;
            }
        }
        if (count != 1)
            one_hot_ok = false;
    }

    for (int i = 0; i < N; ++i)
    {
        for (int j = i + 1; j < N; ++j)
        {
            if (pos[i] != -1 && pos[i] == pos[j])
                overlap_ok = false;
        }
    }

    for (int i = 0; i < N - 1; ++i)
    {
        if (pos[i] == -1 || pos[i + 1] == -1 || !is_adjacent(pos[i], pos[i + 1]))
            connectivity_ok = false;
    }

    // --- 3. 결과 출력 ---
    cout << "\n====================================\n";
    if (one_hot_ok && overlap_ok && connectivity_ok)
    {
        cout << "✅ 검증: 물리적으로 유효함" << "\n";
    }
    else
    {
        cout << "❌ 검증: 물리적으로 유효하지 않음" << "\n";
        cout << "   (사유: " << (!one_hot_ok ? "위치오류 " : "")
             << (!overlap_ok ? "좌표중첩 " : "")
             << (!connectivity_ok ? "사슬끊어짐" : "") << ")" << "\n";
    }
    cout << "====================================\n";

    vector<string> grid(L, string(L, '.'));
    cout << "도출된 고유구조" << "\n";
    for (int i = 0; i < N; ++i)
    {
        if (pos[i] != -1)
        {
            grid[pos[i] / L][pos[i] % L] = sequence[i];
            cout << "아미노산 " << i + 1 << "(" << sequence[i] << ") ~ (" << pos[i] / L << "," << pos[i] % L << ")" << "\n";
        }
    }

    cout << "\n[2차원 격자]\n";
    for (int r = 0; r < L; ++r)
    {
        for (int c = 0; c < L; ++c)
            cout << grid[r][c] << " ";
        cout << "\n";
    }

    cout << "\n최종 온도: " << T << "\n";

    return 0;
}
```
