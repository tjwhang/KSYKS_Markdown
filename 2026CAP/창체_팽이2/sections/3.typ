#import "../preamble.typ": *

== 회전체의 식 유도

곡면 위를 움직일 때 속도 벡터를 $vb(v) = v_1 vb(e)_1 + v_2 vb(e)_2$ 처럼 써 보자. 
이때 $vb(e)_1$과 $vb(e)_2$는 두 주방향으로의 정규직교기저로 삼을 수 있다. 곡면에서 주방향은 항상 직교함이 알려져 있다#footnote[
  $"I"$과 $"II"$가 모두 대칭행렬이기 때문이다. 모양연산자의 정의에 따라 $upright(I) cal(vb(S)) = upright(I I)$이고 $cal(vb(S))^TT upright(I) = upright(I) cal(vb(S))$이다. 고윳값과 고유벡터의 정의에 의해 $vb(cal(S)) vb(v)_i = kappa_i vb(v)_i$이고, 곡면 상에서 내적인 $vb(v)_1 dot vb(v)_2 = vb(v)_1 ^TT upright(I) vb(v)_2$를 위 성질에 따라 계산해 보면, 그 값이 0이 된다.
].

#definition(title: [유클리드 공간 상에서 벡터장의 방향 미분])[
    유클리드 공간 상의 벡터장 $vb(X): RR^n -> RR^n$과 점 $p$에서의 벡터 $vb(v) in RR^n$에 대해 방향미분 $D_vb(v)$는 다음과 같다.
    $
        D_vb(v) vb(X) equiv eval(dv(, t) vb(X)(p + t vb(v)))_(t=0)
    $
]

#remark[
  점 $p$에서 $vb(v)$로 아주 짧은 시간 $t$ 동안 움직이고자 할 때, 새로운 위치가 $p + t vb(v)$가 된다. 따라서 $vb(X)(p + t vb(v))$는 해당 지점에서 벡터장의 값을 의미하게 된다. 이것을 미분함으로써 순간변화율을 구하고, 출발하기 시작하는 시점인 $t=0$일 때를 보는 것이다. 
]
#par[]

팽이가 접점을 따라 속도 $vb(v)$로 움직일 때, 법선의 시간에 따른 변화는 방향미분의 정의에 따라 다음과 같다.
$
    D_vb(v) vb(n) = - vb(cal(S)) vb(v) = - kappa_1 v_1 vb(e)_1 - kappa_2 v_2 vb(e)_2
$
팽이가 곡면 위를 빨리 움직일수록, 표면 곡률이 클수록 팽이의 법선이 빠르게 회전한다는 해석을 할 수 있다. 이때 $R_i := 1/abs(kappa_i)$를 *곡률반경*(曲率半徑, radius of curvature)이라고 한다. 곡률반경은 해당 지점에서 곡률에 가장 잘 맞도록 접하는 가상의 원(구)인 접촉원(接觸圓, osculating circle)의 반지름으로, 곡률의 역수가 된다. 정확히는, 곡면 상의 접점과 나머지 두 점을 지나는 원에 대해, 접점을 제외한 두 점을 접점에 한 없이 가까워지도록 극한을 취한 것이 접촉원이다. 곡면이 평평할수록 $R_i$는 무한대에 가까워지고 $kappa_i$는 0에 가까워진다. 반대로 곡면이 가파를수록 $R_i$는 작아지고 $kappa_i$는 커진다. $R_i$가 작을수록 $vb(n)$의 변화가 크다.

팽이 자체의 운동을 정의하자. 팽이를 축에 대해 대칭인 강체로 두고 질량을 $m$, 바닥(접점)에서 질량중심까지의 거리를 $l$로 둔다. 팽이에 고정된 직교좌표계를 상정하면, 팽이의 대칭축(회전축) 방향의 단위벡터를 $vb(u)$라고 하고 팽이의 대칭축 방향의 관성모멘트를 $I_3$이라고 하자. 팽이가 축에 대해 회전대칭이라고 가정하므로 $I_1 = I_2$이고 이 값을 $I_perp$라고 하자. 

이때 팽이의 각운동량은 대칭축 방향의 각운동량과 대칭축에 수직인 방향의 각운동량의 합으로 표현된다. 이때 팽이의 자전 속도가 충분히 빨라 대칭축에 수직인 각운동량 성분보다 훨씬 크다고 하면 수직방향 각운동량 성분은 무시할 수 있다($L_perp< I_3 omega_3$). 이것을 *빠른 팽이 근사*(fast top approximation)라고 한다.
$
    vb(L) = cancel(vb(L)_perp)^(thin approx 0) + I_3 omega vb(u) approx I_3 omega_3 vb(u) = L vb(u)
$

#h(1em)각운동량 변화율은 외부에서 작용하는 토크 $vb(tau)$와 같다 ($dot(vb(L)) = vb(tau)$). 앞선 근사에 의해 $I_3 omega_3$는 상수이므로, 좌변은 다음과 같이 대칭축의 변화율 $dot(vb(u))$에 대한 식이 된다.
$
    I_3 omega_3 dot(vb(u)) = vb(tau)
$
회전 중심점을 곡면과의 접점으로 놓으면, 질량중심까지의 위치벡터는 $vb(r) = l vb(u)$이다. 곡면 위에서 팽이를 표면에 밀착시키는 중력의 방향이 곡면의 아래쪽, 즉 $- vb(n)$ 방향으로 작용한다고 할 때, 질량중심에 작용하는 힘은 $-m g vb(n)$이다. 따라서 토크는 다음과 같다.
$
    vb(tau) = (l vb(u)) times (-m g vb(n)) = -m g l (vb(u) times vb(n)) = m g l (vb(n) times vb(u))
$
편의를 위해 외적 순서를 $m g l vb(u) times vb(n)$ 크기에 비례하는 꼴로 둔다#footnote[이때 부호는 세차운동의 회전 방향을 어느 쪽으로 양수로 잡느냐에 따라 달라진다.]. 따라서 운동방정식으로 다음을 얻는다.
$
    I_3 omega_3 dot(vb(u)) = m g l (vb(u) times vb(n)) \
    ==> dot(vb(u)) = (m g l)/(I_3 omega_3) (vb(u) times vb(n))
$
여기서 계수 $(m g l)/(I_3 omega_3)$를 세차각속도로 한다. 이 값은 팽이가 중력 때문에 쓰러지지 않고 세차 축으로 작용하는 법선 $vb(n)$을 중심으로 도는 각속도이다. 팽이가 무거울수록, 질량중심이 높이 있을수록 세차운동이 빨라지며, 팽이가 빨리 자전할수록 세차운동이 느려진다.
$
    Omega_p := (m g l)/(I_3 omega_3)
$
결과적으로, 평면 위에서 중력 토크만을 받을 때 회전축의 변화는 다음과 같다.
$
    dot(vb(u))_"토크" = Omega_p vb(u) times vb(n)
$

하지만 팽이가 곡면 상에 있다면 $vb(n)$이 일정하지 않다. 팽이의 회전축은 세차운동 뿐아니라, 곡면의 기하적 요인에 의한 변화 또한 적용받는다. 
$
    dot(vb(u)) = underbrace(vb(Omega)_p vb(u)times vb(n), "중력 토크에 의한 세차") + overbrace(- vb(cal(S)) vb(v), "곡면에 의한 회전")
$
따라서 아래를 얻을 수 있다.
$
    markrect(dot(vb(u)) = vb(Omega)_p vb(u)times vb(n) - vb(cal(S)) vb(v))
$

#par[]
현재까지 상황을 정리해 보자. 접점 $vb(r)(t)$에서의 속도는 $vb(v) := dot(vb(r))$이고, 팽이의 대칭축은 $vb(u)$이다. 팽이의 대칭축 $vb(u)$와 법선 $vb(n)$이 편각(偏角)을 $theta$라고 한다면 $vb(u) dot vb(n) = cos theta$이다. 축 $vb(u)$를 법선 방향 성분과 접평면 방향 성분 $vb(u)_parallel$로 분리하면 다음과 같다. 이때 분리했으므로 $vb(u)_parallel perp vb(n)$이다.
$
  vb(u) = (cos theta) vb(n) + vb(u)_parallel
$
이때 세차운동을 일으키는 외적(外積) 항은 다음과 같이 오직 접평면 방향의 기울어짐($vb(u)_parallel$)에 의해서만 결정된다.
$
    vb(u) times vb(n) = ((cos theta) vb(n) + vb(u)_parallel) times vb(n) = vb(u)_parallel times vb(n)
$
한편, 곡면 위를 이동할 때 팽이의 좌표계 자체가 회전하는 각속도를 $vb(omega)_"좌표계"$라고 하면, $dot(vb(n)) = - vb(cal(S)) vb(v)$이므로 $vb(omega)_"좌표계" = vb(n) times (- vb(cal(S)) vb(v))$이다. 이것이 회전축에 미치는 영향 $vb(omega)_"좌표계" times vb(u)$를 벡터 삼중곱을 통해 전개한 뒤 접평면 방향 성분만 남기면 다음을 얻는다.
$
    (vb(omega)_"좌표계" times vb(u))_parallel = - (cos theta) vb(cal(S)) vb(v)
$
따라서 앞서 구한 팽이의 축 방정식에서 접평면 방향 성분 $dot(vb(u))_parallel$를 분리하면 다음과 같다.
$
    dot(vb(u))_parallel = Omega_p (vb(u)_parallel times vb(n)) - cos theta vb(cal(S)) vb(v)
$ <ve1>

팽이 질량중심의 위치는 $vb(R) := vb(r) + l vb(u)$이므로 미분하면 $dot(vb(R)) = vb(v) + l dot(vb(u))$이다. 접점에서 팽이가 미끄러지거나 날아가는 등 이탈하지 않고 안정적인 궤도를 유지하기 위해서는 질량중심의 접평면 방향으로의 이탈이 없어야 하므로 $dot(vb(R))_parallel = 0$이라는 비홀로노믹 제약조건#footnote[
    홀로노믹(holonomic) 제약조건이란 물체의 위치와 시간만으로 나타낼 수 있는 제약조건을 말한다. 비홀로노믹 제약조건이란 위치 뿐 아니라 속도 등 미분 값까지 포함하는 제약을 말한다. 대표적인 비홀로노믹 문제로 전진 및 회전만으로 차를 주차해야하는 평행주차 문제가 있다.
]이 부여된다. 따라서
$
    vb(v) = - l dot(vb(u))_parallel
$ <ve2>

@ve1 과 @ve2 을 연립하여 $vb(v)$를 소거하면
$
    dot(vb(u))_parallel = Omega_p (vb(u)_parallel times vb(n)) + l (cos theta) vb(cal(S)) dot(vb(u))_parallel
$
정리한 뒤 주곡률이 각각 $kappa_1, kappa_2$인 주방향 $i$ 성분에 대해 풀면 다음과 같다.
$
    (1 - l (cos theta) kappa_i) dot(vb(u))_i = Omega_p (vb(u)_i times vb(n))
$
주방향 성분에도 $vb(v)_i = - l dot(vb(u))$ 라는 관계가 성립하므로#footnote[
  $vb(v) = v_1 vb(e)_1 + v_2 vb(e)_2 = - l dot(vb(u))_parallel = - l  (dot(u)_1 vb(e)_1 + dot(u)_2 vb(e)_2)$의 관계에서 성립함을 알 수 있다.
] 양변에 $-l$을 곱하여 원래의 접점 속도 $vb(v)_i$로 정리하면, 팽이의 궤적을 결정하는 방정식이 도출된다.
$
    markrect(vb(v)_i = - (l thin Omega_p)/(1 - l cos theta kappa_i) vb(u)_i times vb(n))
$ <dotu>
이 속도 식을 시간에 대해 적분하면 위치벡터가 나오게 되어 접점의 궤적을 구할 수 있다. $kappa_1$과 $kappa_2$가 해당 지점에서 곡면이 어떤 모양인지 결정하고 그에 따라 궤적이 정해짐을 알 수 있다.
