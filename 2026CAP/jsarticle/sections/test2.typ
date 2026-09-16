#import "../preamble.typ": *

= 세차운동

== 곡면 상의 병진, 회전 및 세차운동 曲面

#jsbox[
    《곡면 상에서의 세차운동》 장에서는 내용 이해가 어렵다는 피드백을 받아 이해에 도움이 될만한 정의, 정리 등을 제시하고 과정을 더 구체적으로 보이고 각주를 다는 등 보충 설명을 추가했습니다. 주로 정시원 학생이 의문을 제기한 부분들을 추가로 다루었습니다.
]
#par[]

평면 상에서 세차운동의 탐구를 참고하였으나 가정하는 상황 자체가 다르므로, 유도 과정은 동일하지 않다#footnote[내 맘대로 할거다 이런 얘기예요!!!]. 곡면을 $z=f(x,y)$ 꼴로 잡는다면 평면 상에서의 세차운동은 $z = 0$일 때의 특수한 경우라고 일반화할 수 있다.

=== 미분기하학 기초

곡면 상에서 회전운동을 하고 그때 세차운동을 따지는 것이므로, 가장 먼저 할 것은 곡면을 정의하는 것이다. 곡면을 $z=f(x,y)$로 두면 그에 따라 매개화된 위치벡터는 다음과 같다고 할 수 있다.
$
    vb(r)(x,y) = vec(x, y, f(x,y))
$
$x$와 $y$ 성분을 편미분하면
$
    vb(r)_x = pdv(vb(r), x) = vec(pdv(x, x), pdv(y, x), pdv(f, x)) = vec(1, 0, f_x) \
    vb(r)_y = pdv(vb(r), y) = vec(pdv(x, y), pdv(y, y), pdv(f, y)) = vec(0, 1, f_y)
$

$vb(r)_x$와 $vb(r)_y$는 $x$, $y$ 방향으로 미소변위를 움직였을 때 접선 벡터로 곡면 상의 접평면(接平面, tangent plane)을 생성(生成, span)하는 두 기저 벡터이다. 즉, 곡면(접평면) 위에서 $vb(r)_x$와 $vb(r)_y$가 생성하므로 모든 접선 벡터는 $alpha vb(r)_x + beta vb(r)_y$ 꼴이다.

이제 제1 기본형식의 계수 성분을 둔다.
$
    E = vb(r)_x dot vb(r)_x, quad F = vb(r)_x dot vb(r)_y, quad G = vb(r)_y dot vb(r)_y
$
이 값들을 직접 계산하면
$
    E = 1 + f_x^2, quad F = f_x thin f_y, quad G = 1 + f_y^2
$
이 계수들은 곡면 위에서의 미소변위 $(dif x, dif y)$에 대해 그 거리 제곱을 나타낸다.
$
    dif s^2 = dif vb(r) dot dif vb(r) = E dif x^2 + 2 F dif x dif y + G dif y^2 =: "I"
$

#definition(title: [미분기하학의 기본형식])[
    미분기하학의 기본형식(基本型式, fundamental form)은 3차원 유클리드 공간 상에서 곡면의 기하학적 성질을 정의하는 도구이다. 제1 기본형식과 제2 기본형식으로 나뉘며, 곡면의 국소적 구조를 결정한다. 제1 기본형식은 곡면 위에서의 계량(計量, metric)을 정의한다. 제2 기본형식은 법선벡터의 방향 변화를 나타낸다.

    곡면 $vb(x)(u, v)$에 대해 제1 기본형식은 다음과 같다. 제1 기본형식은 리만 계량의 일종이다.
    $
        "I" = E dif u^2 + 2 F dif u dif v + G dif v^2 quad "微分"
    $
    이때 각 항의 계수들을 제1 기본계수라고 한다.
    $
        E = vb(x)_u dot vb(x)_u, quad F = vb(x)_u dot vb(x)_v, quad G = vb(x)_v dot vb(x)_v
    $

    제2 기본형식은 다음과 같다.
    $
        "II" = L dif u^2 + 2 M dif u dif v + N dif v^2
    $
    이때 각 항의 계수들을 제2 기본계수라고 한다. 상황에 따라 $L, M, N$ 또는 $e, f, g$ 등으로 쓴다.
    $
        L = vb(x)_(u u) dot vb(n), quad F = vb(x)_(u v) dot vb(n), quad G = vb(x)_(v v) dot vb(n)
    $

]

#definition(title: [벡터의 외적])[
    벡터의 외적(外積, cross product, outer product, vector product)은 두 벡터에 모두 직교하는 새로운 벡터를 구하는 연산으로, 주로 3차원 공간에서 정의된다.

    두 벡터 $vb(a), vb(b)$가 다음과 같다고 하자.
    $
        vb(a) = vec(a_1, a_2, a_3), quad vb(b) = vec(b_1, b_2, b_3)
    $
    이때 두 벡터의 외적 $vb(a) times vb(b)$는
    $
        vb(a) times vb(b) &= mdet(vb(i), vb(j), vb(k); a_1, a_2, a_3; b_1, b_2, b_3) = vec(a_2 b_3 - a_3 b_2, a_3 b_1 - a_1 b_3, a_1 b_2 - a_2 b_1)
    $
    $mdet(bullet)$은 행렬식이며, $vb(i), vb(j), vb(k)$는 유클리드 공간의 표준기저이다#footnote[여기서 이거까지 설명할 수는 없다.].
    #block[]
]

#definition(title: [벡터의 미분])[
    벡터의 미분은 성분별로 수행한다.
    $
        vb(v) = vec(v_x, v_y, v_z) ==> dot(vb(v)) = vec(dot(v)_x, dot(v)_y, dot(v)_z)
    $
]

#definition(title: [그라디언트])[
    그라디언트(gradient), 기울기벡터, 경도(#rb[けいど][傾度]) 또는 구배(#rb[こうばい][勾配])란 스칼라장 $f$에 대해 델 연산자 $nabla$를 작용하여 각 지점에서의 최대 변화율과 그 방향을 나타내는 벡터 미분 연산자이다. 정의는 다음과 같다#footnote[$vb(i), vb(j), vb(k)$는 유클리드 공간의 표준기저로 벡터 수식의 모양이 못생겨서 병기했다.].
    $
        grad f = pdv(f, x) vb(i) + pdv(f, y) vb(j) + pdv(f, z) vb(k) = vec(pdv(f, x), pdv(f, y), pdv(f, z))
    $
]

곡면의 법선벡터 $vb(n)$을 구하기 위해 두 기저를 외적하면#footnote[$z - f(x,y)$는 현재 위치가 곡면 표면에 비해 얼마나 떨어져 있는가를 나타내는 값으로, 항상 0인 것이 아니다. $y = f(x)$라는 함수를 정의했다고 $y - f(x)$가 항상 0인 것은 아닌 것을 생각하자.]
$
    vb(r)_x times vb(r)_y & = mdet(vb(i), vb(j), vb(k); 1, 0, f_x; 0, 1, f_y) = vec(-f_x, -f_y, 1) \
                          & quad ==> grad(z - f(x,y)) = vec(-f_x, -f_y, 1)
$
이 벡터를 정규화하기 위해 그 크기를 계산하면
$
    abs(vb(r)_x times vb(r)_y) = sqrt(f_x^2 + f_y^2 +1)
$
따라서
$
    vb(n) = 1/sqrt(f_x^2 + f_y^2 + 1) vec(-f_x, -f_y, 1)
$
곡면의 위치에 따라 법선 방향이 변화하므로 법선벡터 $vb(n)(x,y)$로서 함수이다. 따라서 아래도 생각할 수 있다.
$
    vb(n)_x = pdv(vb(n), x), quad vb(n)_y = pdv(vb(n), y)
$
이때 $vb(n) dot vb(n) = 1$에서 $vb(n)_x dot vb(n) = 0$이고#footnote[당연한 거다. $dv(, x) (vb(n) dot vb(n)) = 2 vb(n)_x dot vb(n) = dv(, x) 1 = 0$ $vb(n)_y dot vb(n)=0$이므로 법선의 변화는 항상 접평면 위에서, 크기는 일정하고 방향만 변하는 쪽으로 일어난다는 것을 수식적으로도 확인할 수 있다. 이 법선 성분들 또한 두 기저의 생성으로 표현할 수 있다.] 제2 기본형식 계수들은 다음과 같다. $vb(r)_(x x)$는 $vb(r)$을 $x$에 대해 두 번 미분했다는 뜻으로, 곡면이 $x$ 방향으로 얼마나 휘어지고 있는지를 나타낸다. 혼동을 피하기 위해 $f$ 위에는 물결표(tilde, $tilde$)를 붙이겠다#footnote[분모는 $abs(vb(r)_x times vb(r)_y)$로 정규화 상수이고 분자는 곡면의 이계도함수이다. 이때 $grad f = vecrow(f_x, f_y)^TT$이다.].
$
    e = (f_(x x))/sqrt(1 + abs(grad f)^2) , quad
    tilde(f) = (f_(x y))/sqrt(1 + abs(grad f)^2) , quad
    g = (f_(y y))/sqrt(1 + abs(grad f)^2)
$
법선에 대해 각각 전개하면
$
    e = vb(n) dot vb(r)_(x x), & quad tilde(f) = vb(n) dot vb(r)_(x y), quad g = vb(n) dot vb(r)_(y y) \
                               & ==>"II" = e dif x^2 + 2 tilde(f) dif x thin dif y + g dif y^2
$
즉 제2 기본형식은 곡면 표면을 따라 움직일 때 표면이 얼마나 바깥쪽으로 휘는지를 나타낸다.

모양연산자(模樣演算子, shape operator, #rb[かたちさようそ][形作用素]) 또는 바인가르텐 사상(Weingarten map)은 곡면(접평면) 위에서 접평면 방향으로 움직일 때 법선의 회전(방향의 변화)을 반환하는 선형변환 연산자이며, 기본형식의 행렬꼴을 취하여 계산한다. @mmcm
$
    vb(cal(S)) vb(v) = - D_vb(v) thin vb(n) ~ "I"^(-1) "II"
$
이때, 기본형식의 행렬들은 관계식에 따라 면 위 임의의 접선 방향 $vb(v) = alpha vb(r)_x + beta vb(r)_y$에 대해 이것을 벡터 $vb(a) = vec(alpha, beta)$로 나타낼 때 다음과 같다.
$
    "기본형식"(vb(v), vb(v)) = vb(a)^TT "기본형행렬" vb(a) \
    "I" = mat(E, F; F, G), quad "II" = mat(e, tilde(f); tilde(f), g)
$

$vb(v)$ 방향으로의 법곡률(法曲率, normal curvature)은 다음과 같이 주어진다. 같은 점이라도 어느 방향으로 가느냐에 따라 곡률이 다르다는 소리다.
$
    kappa_n (vb(v)) = ("변위 대비 방향 변화") equiv frac("II", "I") = (e alpha^2 + 2 f alpha beta + g beta^2)/(E alpha^2 + 2 F alpha beta + G beta^2)
$

이 중 법곡률의 변화가 가장 큰 방향과 작은 방향이 있는데, 이 둘을 주방향(主方向, principal directions)이라고 하고 그때의 곡률을 주곡률(主曲率, principal curvatures)이라고 한다. 가장 많이 휘는 곳의 곡률을 $kappa_1$, 덜 휘는 곳의 곡률을 $kappa_2$라고 하자. 모양연산자의 정의에 따라 아래가 성립한다#footnote[만약 어떤 방향 $vb(v)$로 움직였더니 법선벡터가 해당 방향과 정확히 일치하는 방향을 가진다면 그 방향이 곡률 변화가 가장 큰 주방향이다.  ].
$
    vb(cal(S)) vb(v) = kappa vb(v)
$
따라서 주곡률을 구하려면 바인가르텐 사상 행렬의 고유값 문제 특성방정식 $det (S - kappa I) = det("II" - kappa upright(I))=0$을 푼다. 이때 행렬의 고유값들이 주곡률이 된다.
$
    det mat(e - kappa E, tilde(f) - kappa F; tilde(f) - kappa F, g - kappa G) = 0
$
이때 그 해는 이차방정식 $kappa^2 - tr vb(cal(S)) kappa + det vb(cal(S)) = 0$ 꼴로, 다음과 같다.
$
    kappa_(1, 2)
    = H plus.minus sqrt(H^2 - K)
$
이때 $K$는 가우스곡률, $H$는 평균곡률로 가우스곡률은 곡선의 모양을 판별하는 의미를, 평균곡률은 두 방향 곡률의 평균을 그 의미로 가지며, 식은 다음과 같다.
$
    K &= det vb(cal(S)) =
    (f_(x x) f_(y y) - f_(x y)^2)/((1 + f_x^2 + f_y^2)^2) = kappa_1 kappa_2 \
    quad H &= 1/2 tr vb(cal(S)) \
    &=
    ((1 + f_y^2) f_(x x) - 2 f_x f_y f_(x y) + (1 + f_x^2) f_(y y))/(2(1 + f_x^2 + f_y^2)^inline(3 / 2))= (kappa_1 + kappa_2)/2
$

=== 회전축의 변화

곡면 위를 움직일 때 속도 벡터가
$
    dot(vb(r)) = dot(x) vb(r)_x + dot(y) vb(r)_y
$
라면 법선의 변화는
$
    dot(vb(n)) = - vb(cal(S)) dot(vb(r)) = - kappa_1 v_1 vb(e)_1 - kappa_2 v_2 vb(e)_2
$
팽이가 접점 부분에서 빨리 움직일수록 표면의 법선도 빨리 움직인다. 즉, 곡면 위에서는 세차운동 자체의 축이 변한다는 뜻이다. 특히 곡률 반경 $R_i = 1/abs(kappa_i)$가 작을수록 법선의 회전이 강하다. 예를 들어 구면에서는 모든 방향이 같은 값을 갖는다.

팽이를 축에 대해 대칭인 강체로 두고 질량을 $m$, 중심에서 접점까지의 거리를 $l$, 팽이의 각 방향#footnote[팽이 기준으로 놓은 직교좌표축을 말하는 것으로, 전역 곡면에 놓은 $x, y, z$ 방향과 다르다.]에 대한 관성모멘트를 $I_1 = I_2 = I_perp$과 $I_3$으로 두고 팽이의 대칭축의 단위벡터를 $vb(u)$라고 하면 팽이가 충분히 빨리 돈다고 할 때 각운동량은 다음과 같다고 봐도 좋다. 이렇게 장동운동을 무시($omega_3 >> dot(theta), dot(phi)$, 즉 $L_perp << I_3 omega$라고 가정)하는 것을 '빠른 팽이 근사'(fast top approximation)이라고 하기도 한다.
$
    vb(L) = cancel(vb(L)_perp)^(thin approx 0) + I_3 omega vb(u) approx I_3 omega_3 vb(u) = L vb(u)
$
$dot(vb(L)) = vb(tau)$이므로 중력에 의한 토크는 접점 기준으로
$
    vb(tau) = m g l vb(u) times vb(e)_z
$
이고, 따라서
$
    I_3 omega_3 dot(vb(u)) = m g l vb(u) times vb(e)_z
$
이때 세차각속도는 다음과 같다고 할 수 있다.
$
    Omega_p ~ (m g l)/(I_3 omega_3)
$
평면 상에서의 회전이라면 $L dot(vb(u))_"토크" = vb(u) times vb(tau)$라고 할 때 $dot(vb(u))$는 다음으로 일정하다.
$
    dot(vb(u)) = dot(vb(u))_"토크" = vb(Omega)_p vb(u) times vb(n)
$
하지만 곡면 상에서는 $dot(vb(n)) != 0$이라 $vb(n) = vb(e)_z$가 아니고 $dot(vb(n)) = - vb(cal(S)) vb(v)$이므로 $dot(vb(u))_"곡면" = -vb(cal(S)) vb(v)$ 항이 추가되어 전체 $dot(vb(u))$가 아래와 같이 된다.
$
    dot(vb(u)) = underbrace(vb(Omega)_p vb(u)times vb(n), "중력 토크에 의한 세차") + overbrace(- vb(cal(S)) vb(v), "곡면에 의한 회전")
$
$
    markrect(dot(vb(u)) = vb(Omega)_p vb(u)times vb(n) - vb(cal(S)) vb(v))
$

=== 접점의 궤적과 넘어짐

현재까지 상황을 정리해 보자. 접점 $vb(r)(t) in f$이고 이때 속도는 $vb(v) := dot(vb(r))$, 팽이의 대칭축은 $vb(u)$이다. 팽이가 접점에서 넘어지지 않고 서 있다는 것은 법선과 팽이의 대칭축이 큰 각을 이루지 않는다는 뜻이므로 아래와 같이 가정하자.
$
    vb(u) dot vb(n) approx 1
$
법선 방향과 접평면 방향을 분리하면 아래와 같다. 이때 $vb(u)_parallel perp vb(n)$이다.
$
    vb(u) = (vb(u) dot vb(n)) + vb(u)_parallel
$
팽이가 넘어진다는 것은 $vb(u)_parallel$이 유의미하게 커진다는 것으로 해석할 수 있다.

이제 앞의 운동 방정식에서 접평면 방향 성분을 분리해내자. $dot(vb(u))_parallel$에 대해
$
    dot(vb(u))_parallel = Omega_p (vb(u) times vb(n))_parallel - vb(cal(S)) vb(v)
$ <ve1>
접점 속도는 크게 팽이 축의 기울기 변화와 중력 퍼텐셜의 변화에 의한다. 이중 지배적인 항은 전자이다. 위치변화 자체가 축변화에 의해 나타나기 때문이다. 팽이 중심의 위치는 접점으로부터 $l vb(u)$만큼 떨어져 있으므로
$
    vb(R) = vb(r) + l vb(u)
$
미분하면
$
    dot(vb(R)) = vb(v) + l dot(vb(u))
$
접점에서 미끄러져 넘어지지 않는다는 조건은
$
    dot(vb(R))_parallel = 0
$
따라서
$
    vb(v) = - l dot(vb(u))_parallel
$ <ve2>

@ve1 과 @ve2 을 연립하면
$
    dot(vb(u))_parallel = Omega_p vb(u) times vb(n) + l vb(cal(S)) dot(vb(u))_parallel
$
정리하면
$
    (I - l vb(cal(S))) dot(vb(u))_parallel = Omega_p vb(u) times vb(n)
$

이 팽이가 안정하려면 $1 - l kappa_i != 1$을 만족해야 한다. 즉,
$
    l < R_i := 1/abs(kappa_i)
$

만약 $l kappa_i = 1$이라면 해당 방향 $i$에서 $dot(u)_i -> oo$이라는 뜻이다. 즉, 아주 작은 토크에도 $vb(u)_parallel$이 크게 증가해 팽이가 그 방향으로 쓰러지게 된다. 한편, $vb(v) = - l dot(vb(u))_parallel$이므로
$
    vb(v)_i = - l Omega_p/(1 - l kappa_i) vb(u)_i times vb(n)_i
$
이 속도 식을 시간에 대해 적분하면 위치벡터가 나오게 되어 접점의 궤적을 구할 수 있다. $kappa_1$과 $kappa_2$가 해당 지점에서 곡면이 어떤 모양인지 결정하고 그에 따라 궤적이 정해짐을 알 수 있다.

#jstopic(title: "크로네커 델타")[아암ㄴ아ㅓㄹ];

#pagebreak()

