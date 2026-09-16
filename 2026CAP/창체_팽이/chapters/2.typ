#import "../template.typ": *


== 곡면 상의 병진, 회전 및 세차운동

평면 상에서 세차운동의 탐구를 참고하였으나 가정하는 상황 자체가 다르므로, 유도 과정은 동일하지 않다. 곡면을 $z=f(x,y)$ 꼴로 잡는다면 평면 상에서의 세차운동은 $z = 0$일 때의 특수한 경우라고 일반화할 수 있다.

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
제1 기본형식은 곡면 위에서의 미소변위 $(dif x, dif y)$에 대해 그 거리 제곱을 나타낸다.
$
  dif s^2 = dif vb(r) dot dif vb(r) = E dif x^2 + 2 F dif x dif y + G dif y^2 =: "I"
$

#definition(title: [벡터의 미분])[
  벡터의 미분은 성분별로 수행한다.
  $
    vb(v) = vec(v_x, v_y, v_z) ==> dot(vb(v)) = vec(dot(v)_x, dot(v)_y, dot(v)_z)
  $
]

#definition(title: [미분기하학의 기본형식])[
  미분기하학의 기본형식(基本型式, fundamental form)은 3차원 유클리드 공간 상에서 곡면의 기하학적 성질을 정의하는 도구이다. *제1 기본형식*과 *제2 기본형식*으로 나뉘며, 곡면의 국소적 구조를 결정한다. 제1 기본형식은 곡면 위에서의 계량(計量, metric)을 정의한다. 제2 기본형식은 법선벡터의 방향 변화, 즉 곡률을 나타낸다.

  곡면 $vb(x)(u, v)$에 대해 제1 기본형식은 다음과 같다. 제1 기본형식은 리만 계량의 일종이다.
  $
    "I" = E dif u^2 + 2 F dif u dif v + G dif v^2
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
    L = vb(x)_(u u) dot vb(n), quad M = vb(x)_(u v) dot vb(n), quad N = vb(x)_(v v) dot vb(n)
  $

]

#remark[
  #jstopic(title: [제1 기본계수])[
    곡면 위의 한 점 $vb(x)(u, v)$에서의 미소변위는 연쇄법칙에 의해 다음과 같이 표현된다.
    $
      dif vb(x) = vb(x)_u dif u + vb(x)_v dif v
    $
    이 미소변위의 제곱을 구하기 위해서는 자신과 내적한다.
    $
      dif s^2 = dif vb(x) dot dif vb(x) = (vb(x)_u dif u + vb(x)_v dif v) dot (vb(x)_u dif u + vb(x)_v dif v)
    $
    이 식을 전개하면 다음과 같이 된다.
    $
      dif s^2 = (vb(x)_u dot vb(x)_u) dif u^2 + 2(vb(x)_u dot vb(x)_v) dif u dif v + (vb(x)_v dot vb(x)_v) dif v^2
    $
    이것을 행렬곱 형태로 정리하면
    $
      dif s^2 = mat(dif u, dif v) mat(E, F; F, G) vec(dif u, dif v)
    $
    이때 이 기본계수의 행렬을 제1 기본형식 행렬이라고 하고 보통 $"I"$라고 쓴다.
  ]

  #jstopic(title: [제2 기본계수])[
    이계도함수와 관련이 있는 곡률을 조사하려면 단위 법선의 방향의 변화를 본다. 제2 기본형식은 따라서 미소변위 $dif vb(x)$에 단위 법선벡터 $dif vb(n)$을 내적하여 정의한다. 이때 접벡터는 항상 법선에 수직, 즉 $vb(x)_(u, v) dot vb(n) = 0$이므로 이를 이용하여 대입하여 정리하면 다음과 같다.
    $
      - dif vb(x) dot dif vb(n) = (vb(x)_(u u) dif vb(u)^2 + 2 (vb(x)_(u v) dot vb(n)) dif u dif v + (vb(x)_(v v) dot vb(n)) dif vb(v)^2
    $
    이것을 행렬곱 형태로 묶으면 제2 기본형식 행렬 $"II"$이 나온다.
    $
      - dif vb(x) dot dif vb(n) = mat(dif u, dif v) mat(L, M; M, N) vec(dif u, dif v)
    $
  ]
]


#definition(title: [벡터의 외적])[
  벡터의 외적(外積, cross product, vector product)은 두 벡터에 모두 직교하는 새로운 벡터를 구하는 연산으로, 주로 3차원 공간에서 정의된다.

  두 벡터 $vb(a), vb(b)$가 다음과 같다고 하자.
  $
    vb(a) = vec(a_1, a_2, a_3), quad vb(b) = vec(b_1, b_2, b_3)
  $
  이때 두 벡터의 외적 $vb(a) times vb(b)$는
  $
    vb(a) times vb(b) &= mdet(vb(i), vb(j), vb(k); a_1, a_2, a_3; b_1, b_2, b_3) = vec(a_2 b_3 - a_3 b_2, a_3 b_1 - a_1 b_3, a_1 b_2 - a_2 b_1)
  $
  $mdet(bullet)$은 행렬식이며, $vb(i), vb(j), vb(k)$는 유클리드 공간의 표준기저이다.
]



#definition(title: [그라디언트])[
  그라디언트(gradient), 기울기벡터, 경도(#ruby[けいど][傾度]) 또는 구배(#ruby[こうばい][勾配])#footnote[모두 일본 번역어입니다. 몇몇 분야에서는 "압력 경도력","농도 구배"등의 말이 사용되지만 수학적인 의미로는 그라디언트라고 영어로 읽는 경우가 많은 것 같습니다.]란 스칼라장 $f$에 대해 델 연산자 $nabla$를 작용하여 각 지점에서의 최대 변화율과 그 방향을 나타내는 벡터 미분 연산자이다. 정의는 다음과 같다#footnote[$vb(i), vb(j), vb(k)$는 유클리드 공간의 표준기저이다.].
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
이때 $vb(n) dot vb(n) = 1$에서 $vb(n)_x dot vb(n) = 0$이고 $vb(n)_y dot vb(n)=0$이므로 법선의 변화는 항상 접평면 위에서, 크기는 일정하고 방향만 변하는 쪽으로 일어난다는 것을 수식적으로도 확인할 수 있다. 이 법선 성분들 또한 두 기저의 생성으로 표현할 수 있다.

제2 기본형식 계수들은 다음과 같다. $vb(r)_(x x)$는 $vb(r)$을 $x$에 대해 두 번 미분했다는 뜻으로, 곡면이 $x$ 방향으로 얼마나 휘어지고 있는지를 나타낸다#footnote[분모는 $abs(vb(r)_x times vb(r)_y)$로 정규화 상수이고 분자는 곡면의 이계도함수이다. 이때 $grad f = vecrow(f_x, f_y)^TT$이다.].
$
  L = (f_(x x))/sqrt(1 + abs(grad f)^2) , quad
  M = (f_(x y))/sqrt(1 + abs(grad f)^2) , quad
  N = (f_(y y))/sqrt(1 + abs(grad f)^2)
$
법선에 대해 각각 전개하면
$
  L = vb(n) dot vb(r)_(x x), & quad M = vb(n) dot vb(r)_(x y), quad N = vb(n) dot vb(r)_(y y) \
                             & ==>"II" = L dif x^2 + 2 M dif x thin dif y + N dif y^2
$
즉 제2 기본형식은 곡면 표면을 따라 움직일 때 표면이 얼마나 바깥쪽으로 휘는지를 나타낸다.

모양연산자(模樣演算子, shape operator, #ruby[かたちさようそ][形作用素])#footnote["모양연산자"라는 말은 일본어와 영어 어휘에서 제가 임의로 번역한 것으로, 정식 용어가 아닐 수 있습니다. 간혹 "모양작용소"라고 해놓은 곳도 있는데, 이는 연산자를 뜻하는 일본어 "作用素"를 그대로 읽어버린 오류입니다. "바인가르텐 사상"이라는 말이 더 자주 나오는 것 같은데, 이 경우에서는 사상보다는 연산자의 의미가 더 강한 것 같아 이 용어를 채택했습니다.] 또는 *바인가르텐 사상*(Weingarten map)은 곡면(접평면) 위에서 접평면 방향으로 움직일 때 법선의 회전(방향의 변화)을 반환하는 선형변환 연산자이며, 기본형식의 행렬꼴을 취하여 계산한다. @mmcm
$
  vb(cal(S)) vb(v) = - D_vb(v) thin vb(n)
$
$
  vb(cal(S)) = "I"^(-1) "II" &= mat(E, F; F, G)^(-1) mat(L, M; M, N) \
  &= 1/(E G - F)^2 mat(G L - F M, G M - F N; E N - F M, E M - F L)
$
이때, 기본형식의 행렬들은 관계식에 따라 면 위 임의의 접선 방향 $vb(v) = alpha vb(r)_x + beta vb(r)_y$에 대해 이것을 벡터 $vb(a) = vec(alpha, beta)$로 나타낼 때 다음과 같다.
$
  "(기본형식)"(vb(v), vb(v)) = vb(a)^TT "(기본형행렬)" vb(a) \
  "I" = mat(E, F; F, G), quad "II" = mat(L, M; M, N)
$



$vb(v)$ 방향으로의 법곡률(法曲率, normal curvature)은 다음과 같이 주어진다. 같은 점이라도 어느 방향으로 가느냐에 따라 곡률이 다르다는 소리다.
$
  kappa_n (vb(v)) = ("변위 대비 방향 변화") equiv frac("II", "I") = (e alpha^2 + 2 f alpha beta + g beta^2)/(E alpha^2 + 2 F alpha beta + G beta^2)
$

이 중 법곡률의 변화가 가장 큰 방향과 작은 방향이 있는데, 이 둘을 주방향(主方向, principal directions)이라고 하고 그때의 곡률을 주곡률(主曲率, principal curvatures)이라고 한다. 가장 많이 휘는 곳의 곡률을 $kappa_1$, 덜 휘는 곳의 곡률을 $kappa_2$라고 하자. 제2 기본형식이 대칭행렬이므로

모양연산자의 정의에 따라 아래가 성립한다#footnote[어떤 접선 방향 $vb(v)$로 움직일 때 법선벡터의 변화량 $-D_vb(v) vb(n)$이 $vb(v)$와 평행하면 그 방향이 주방향이다.].
$
  vb(cal(S)) vb(v) = kappa vb(v)
$
따라서 주곡률을 구하려면 바인가르텐 사상 행렬의 고유값 문제 특성방정식 $det (cal(S) - kappa I) = det("II" - kappa upright(I))=0$을 푼다. 이때 행렬의 고유값들이 주곡률이 된다. 여기서 $I$는 항등행렬, $"I"$는 제1 기본계수 행렬이라는 점에 주의한다.
$
  det mat(L - kappa E, M - kappa F; M - kappa F, N - kappa G) = 0
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

