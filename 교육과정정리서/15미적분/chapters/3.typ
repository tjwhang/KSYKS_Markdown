#import "../template.typ": *

#topic(title: [삼각함수의 정의])[삼각함수에는 우리가 이미 알고 있는 사인, 코사인, 탄젠트 외에도 각각 이 값들의 역수인 코시컨트, 시컨트, 코탄젠트가 있다. 즉 $x^2+y^2=r^2$의 원 위에서 삼각함수들의 아래와 같이 정의된다. ]

#definition(title: [삼각함수의 정의])[
  원 $x^2+y^2=r^2$에서
  $
    sin theta =^Delta y/r wide csc theta =^Delta r/y \
    cos theta =^Delta x/r wide sec theta =^Delta r/x \
    tan theta =^Delta y/x wide cot theta =^Delta x/y
  $
]
$sin$은 sine(sinusoidal), $cos$은 cosine(complementary#footnote[한국어로는 '여각'(餘角)이라고 하며, 더해서 90#sym.degree\가 되는 각을 여각 관계에 있다고 한다.] sine), $tan$는 tangent#footnote["tangent"는 "tangent line"에서 따온 말로 접선과 관련이 있다.], $sec$는 secant#footnote["secant"는 "secant line"에서 따온 말로 할선과 관련이 있다.], $csc$는 cosecant(complementary secant)#footnote[옛날 책에서는 $csc$를 $"cosec"$라고 쓰기도 하나, 현재 국제 표준에 맞지 않으므로 지양해야 한다.], $cot$는 cotangent(complementary tangent)에서 따온 약자이다#footnote[한자어로는 여섯 가지 삼각함수를 사인, 코사인, 탄젠트, 코시컨트, 시컨트, 코탄젠트 순서대로 정현(正弦), 여현(餘弦), 정접(正接), 여할(餘割), 정할(正割), 여접(餘接)이라고 부르며 아직도 일본과 중국에서는 널리 사용한다. 한자에서 명칭의 의미가 그대로 드러나는 것을 볼 수 있다. 명나라 말기에 서양의 삼각함수를 들여오면서 생겨난 번역어라고 한다.].

#property(title: [삼각함수의 피타고라스 항등식])[
일반각 $theta$에 대해, $theta$의 값에 무관하게 다음이 항상 성립한다.
$
  cos^2 theta + sin^2 theta = 1 \
  1 + tan^2 theta = sec^2 theta \
  cot^2 theta + 1 = csc^2 theta
$
]

#proof[원의 정의 또는 피타고라스 정리에 의해 아래의 자명한 관계식을 유도할 수 있었다.
$
  cos^2 theta + sin^2 theta = 1
$

이 식의 양변을 $cos^2 theta$로 나누면 아래와 같은 식이 나온다.
$
  1 + tan^2 theta = sec^2 theta
$

또한, 식의 양변을 $cos^2 theta$가 아니라 $sin^2 theta$로 나눈다면 이렇게 된다.
$
  cot^2 theta + 1 = csc^2 theta
$
이 세 개의 식은 삼각함수의 자명한 성질이므로 꼭 숙지한다#footnote[유치하지만 쉽게 외우는 방법을 소개한다. $1 + tan^2 theta = sec^2 theta$는 "한 번 타면 새까맣다"로, $1 + cot^2 theta = csc^2 theta$는 "코가 한 번 타면 코가 새까맣다"로 쉽게 외울 수 있다. 그런데 이것은 외우는 방법일 뿐이고, 결국은 아무 연상법 없이 이 식 자체의 형태를 익히는 것이 중요하다.]. ]

#important-box(title: [$bold(sqrt(m^2 + 1))$ 의 의미])[
  수험 수학 공부를 계속하다 보면, 특히 도형 관련 공식에서 자주 보이는 꼴이 있다. 바로 아래 두 꼴이다.
  $
    sqrt(m^2 + 1)
  $ 
  이 꼴이 등장하는 예시로 몇 가지를 들자면, 원의 기울기가 $m$인 접선의 방정식 공식이나 이차함수와 직선의 교점을 이은 선분의 길이 공식 등이 있다.
  $
    y = m x plus.minus r sqrt(m^2+1) \
    L = sqrt(D)/abs(a) sqrt(m^2+1)
  $
  공통점은, 이때 $m$이 기울기라는 것이다. 직선과 $x$축이 이루는 각을 $theta$라고 한다면 $m = tan theta$이다. 그러므로 $sqrt(m^2+1)$은 $sec theta$인 것이다. 왜 이 식이 필요한 것일까? 
  
  이 꼴은 보통 수평 거리를 실제 대각선 거리로 바꾸어야 할 때 등장한다. 기울기가 $m$인 직선 위의 점이 $x$축 방향으로 1만큼 움직였다면 $y$축 방향으로는 $m$만큼 움직이게 되므로 이때 해당 구간에서 선분의 길이는 $sqrt(m^2 + 1^2)$이 되기 때문이다. 단위원에서 생각해 본다면 시컨트가 탄젠트를 의미하는 선분의 끝점까지의 동경의 일부분의 길이를 의미한다는 것을 직관적으로 이해할 수 있다. $sqrt(m^2+1)$이 수직으로 $x$축에 투영된 그림자의 길이가 $1$인 것이라고 정사영의 개념으로 이해해도 된다.
  
  그러므로 식의 꼴이 $sqrt(m^2 + 1)$이나 $sqrt(1-x^2)$ 꼴이 나온다면 $m$이 $sec t$ 또는 $ csc t$, $x$가 $sin t$ 또는 $ cos t$가 될 수 없는지 의심해보도록 하자.
]

#note-box(title: [역삼각함수])[
  삼각함수의 정의역을 제한하여 일대일 대응이 되도록 만들면 그 역함수를 정의할 수 있고, 아래와 같이 쓴다.
  $
    sin^(-1) x equiv arcsin x wide csc^(-1) x equiv arccsc x\
    cos^(-1) x equiv arccos x wide sec^(-1) x equiv arcsec x\
    tan^(-1) x equiv arctan x wide cot^(-1) x equiv arccot x
  $
  여기서 arc는 호(弧)를 의미하며, 삼각함수의 이름 앞에 arc가 붙는 것이 역삼각함수가 되는 것은, 삼각함수의 값이 주어졌을 때 호도법을 통해 호의 길이를 알 수 있다고 하여 붙여진 이름이다.
]

#note-box(title: [쌍곡함수])[
  '쌍곡함수'(雙曲函數, hyperbolic function)는 삼각함수와 비슷한 성질을 갖는 함수들이며, 지수함수를 통해 아래와 같이 정의된다.
  $
    sinh x =^Delta (e^x - e^(-x))/2 wide csch x =^Delta 2/(e^x - e^(-x)) \
    cosh x =^Delta (e^x + e^(-x))/2 wide sech x =^Delta 2/(e^x + e^(-x)) \
    tanh x =^Delta (e^x - e^(-x))/(e^x + e^(-x)) wide coth x =^Delta (e^x + e^(-x))/(e^x - e^(-x))
  $
  여기서 h는 쌍곡선을 뜻하는 라틴어 "hyperbolicus"의 약자이며, $sinh$를 읽을 때는 "쌍곡사인", "hyperbolic sine" 이외에도 "shine", "sinch" 등의 방법도 있다#footnote[이상하게 읽는 방법도 재미있는데, 이것이 실제로 쓰이는 방법이므로 궁금하면 찾아보도록 하자].
  
  이것이 삼각함수와 어떤 연관점이 있을까? 아래의 식을 오일러 공식이라고 한다.
  $
    e^(i x) = cos x + i sin x
  $
  $x$에 $-x$를 대입하면, $cos x$는 우함수, $sin x$는 기함수이므로
  $
    e^(- i x) = cos x - i sin x
  $
  둘을 더하고 2로 나누면 이렇게 된다.
  $
    cos x = (e^(i x) + e^(- i x))/2
  $
  그러므로 $cos x = cosh i x$이다.

  이런 식으로 삼각함수와 쌍곡함수 간에는 아래와 같은 복소수 관계가 성립한다.
  $
    sin i x = i sinh x wide cos i x = cosh x \
    sinh i x = i sin x wide cosh i x = cos x
  $
  또, 삼각함수와 비슷하게 아래 세 식이 성립한다.
  $
    cosh^2 x - sinh^2 x = 1 \
    1 - tanh^2 x = sech^2 x \
    coth^2 x - 1 = csch^2 x
  $
  이것이 성립하는 이유는, 삼각함수가 원과 관련이 있다면 쌍곡함수는 쌍곡선과 관련이 있기 때문인데, 이름이 쌍곡함수인 이유도 이 때문이다. 이후에 더 자세히 다루겠지만, 아래와 같은 식을 매개변수로 정의된 함수라고 한다.
  $
    cases(
      x = cos theta,
      y = sin theta
    )
  $
  이 도형은 원 $x^2 + y^2 = 1$임을 꽤 자명하게 알 수 있다. 그렇다면 이 도형은 무엇일까?
  $
    cases(
      x = cosh phi,
      y = sinh phi
    )
  $
  $x$와 $y$에 대해 아래의 값을 구하자.
  $
    x+y = cosh phi + sinh phi = e^phi \
    x-y = cosh phi - sinh phi = e^(-phi)
  $
  이제
  $
    (x+y)(x-y) = e^phi e^(-phi) = 1
  $
  즉 다음의 쌍곡선을 얻는다.
  $
    x^2 - y^2 = 1
  $
  $cos$과 $sin$이 원을 만든다면 $cosh$와 $sinh$는 쌍곡선을 만드는 것이다.

  우리가 사용하는 각 체계는 원 위의 각이며, 이에 집중하여 생각할 때 '원각'(圓角, circular angle)이라고 부른다. 이 각을 $theta$라고 하면, 단위원 상에서 $theta$가 차지하는 부채꼴의 면적은 $A = theta/2$이다. 이 원각과 대비되는 개념이 '쌍곡각'(雙曲角, hyperbolic angle)이다. 비유적으로 말해 쌍곡선을 원으로 본 공간에서의 각이다. 정확히 말하면, 단위 쌍곡선 $x^2-y^2=1$에 대해 원점 $"O"$, $x$축 위의 점 $(1, 0)$, 쌍곡선 위의 점 $"P"(cosh phi, sinh phi)$에 대해 이 점들을 이은 직선과 곡선이 이루는 도형인 쌍곡부채꼴의 면적으로 정의한다. 이 면적은 원각에서와 비슷하게 $A = phi/2$이고, 따라서 쌍곡각을 $phi = 2 A$로 정의한다. 

  일반적으로 원각과 쌍곡각을 함께 다룰 때는 원각을 $theta$, 쌍곡각을 $phi$로 표기하며 대표적인 적용 예시는 상대성 이론의 민코프스키 시공간과 로렌츠 변환에서의 등장이다.
  
]

#topic(title: [삼각함수의 덧셈정리])[
  우리는 여태까지 $0, pi/6, pi/4, pi/3, pi/2...$ 등 특수각에 대한 삼각함수의 값만을 알고 있었다. $pi/12, 5/12 pi$에 대한 값도 알고 있는 훌륭한 독자도 있었을 것이다. 삼각함수의 덧셈정리는 삼각함수의 매개변수로 들어가는 각을 자유롭게 정할 수 있게 해주어 다양한 각에 대한 삼각함수의 값을 구할 수 있게 한다.
]
#theorem(title: [삼각함수의 덧셈정리])[
  일반각 $alpha, beta$에 대해 일반적으로 다음이 성립한다.
  $
    & sin (alpha plus.minus beta) = sin alpha cos beta plus.minus cos alpha sin beta \
    & cos (alpha plus.minus beta) = cos alpha cos beta minus.plus sin alpha sin beta \
    & tan (alpha plus.minus beta) = (tan alpha plus.minus tan beta) / (1 minus.plus tan alpha tan beta) \
  $
]
#proof[
  단위원 위의 두 점 $"P"(cos beta, sin beta)$와 $"Q"(cos alpha, sin alpha)$를 잡으면 코사인 법칙에 의해 아래가 성립한다.
  $
    overline("PQ")^2 = 1 + 1 - 2 cos (alpha - beta)
  $
  그런데 피타고라스 정리에 의해 다음이 성립하므로
  $
    overline("PQ")^2 = 1 + 1 - 2 cos alpha cos beta - 2 sin alpha sin beta
  $
  다음을 얻는다.
  $
    therefore cos (alpha - beta) = cos alpha cos beta - sin alpha sin beta
  $
  이 식은 항등식이므로 이 식에 적절한 $alpha, beta$를 대입하여 나머지 공식들을 모두 구해낼 수 있다. 한 번 도전해 보자.
]

#note-box(title: [15#sym.degree\와 75#sym.degree\에서의 삼각함수 값])[
  $pi/12$와 $5/12 pi$에서의 값들은 자주 등장하는 값이므로 특수각이 아니더라도 미리 알아두도록 하자.
  $
    sin pi/12 = cos 5/12 pi = (sqrt(6) - sqrt(2))/4 \
    cos pi/12 = sin 5/12 pi = (sqrt(6)+sqrt(2))/2 \
  $
  나머지 함수들은 이 값을 통해 자명하게 구해낼 수 있으므로 따로 다루지 않는다.
]

#note-box(title: [합 - 곱 변환 공식])[
  덧셈정리의 식들을 서로 더하고 빼면 이런 꼴의 식을 얻을 수 있다.
  $
    & 2 display(sin alpha cos beta = sin(alpha + beta) + sin(alpha - beta)) \
    & 2 display(cos alpha sin beta = sin(alpha + beta) - sin(alpha - beta)) \
    & 2 display(cos alpha cos beta = cos(alpha + beta) + cos(alpha - beta)) \
    & 2 display(sin alpha sin beta = - cos(alpha + beta) - cos(alpha - beta))
  $
  이것이 삼각함수의 곱을 합으로 바꾸는 공식이다.

  또한, 다음과 같이 문자를 치환해 놓고
  $
    display(alpha &= (A + B)/2 wide beta &= (A - B)/2)
  $
  이것을 각각 곱을 합으로 바꾸는 공식에 대입하면 아래 네 식을 얻는다.
  $
    display(sin A + sin B &= 2 sin (A + B)/2 cos (A - B)/2 \ sin A - sin B &= 2 cos (A + B)/2 sin (A - B)/2 \ cos A + cos B &= 2 cos (A + B)/2 cos (A - B)/2 \ cos A - cos B &= - 2 sin (A + B)/2 sin (A - B)/2)
  $
  이것이 삼각함수의 합을 곱으로 바꾸는 공식이다.

  이 공식들은 문제 풀이 상황에서 유용할 뿐 아니라, 로그의 발견/발명 이전에는 로그를 대신해 큰 수를 계산하는 역할을 하기도 했다.

  쉽게 외우기 위해서는, 앞쪽 괄호에는 항상 $alpha + beta$ 또는 $(A + B)/2$ 꼴이, 뒤쪽 괄호에는 $alpha - beta$ 또는 $(A - B)/2$ 꼴이 온다는 점을 생각해볼 수 있다.
]

#topic(title: [삼각함수의 배각의 공식])[
각이 몇 배가 되었을 때 삼각함수의 값이 어떻게 되는지를 나타낸다고 하여 이 공식들을 배각공식이라고 하지만, 일반적으로 배각공식이라고 하면 2배각 공식을 이른다. 이 공식들의 증명은 삼각함수의 덧셈정리로 상당히 자명하게 해볼 수 있다. 이 공식들은 여러 상황에서 계속해서 쓰이므로 꼭 익혀 두어야 한다.
]

#theorem(title: [삼각함수의 2배각의 공식])[
  $
    sin 2 theta &= 2 sin theta cos theta \
    cos 2 theta &= cos^2 theta - sin ^2 theta \
    &= 2 cos^2 theta - 1 = 1 - 2 sin^2 theta \
    tan 2 theta &= (2 tan theta)/(1 - tan^2 theta)
  $
]

#theorem(title: [삼각함수의 3배각의 공식])[
  $
    & sin 3 theta = 3 sin theta - 4 sin^3 theta \
    & cos 3 theta = 4 cos^3 theta - 3 cos theta \
    & tan 3 theta = (3 tan theta - tan^3 theta)/(1 - 3 tan^2 theta)
  $
]
3배각 공식은 잘 등장하지 않지만 간단하므로 숙지해 두자는 의미이다. 그러므로 복잡한 탄젠트의 3배각 공식은 암기하지 않는다.

#theorem(title: [삼각함수의 반각의 공식])[
  $
    & sin^2 theta/2 = (1 - cos theta)/2 \
    & cos^2 theta/2 = (1 + cos theta)/2 \
    & tan^2 theta/2 = (1 - cos theta)/(1 + cos theta)
  $
]
반각 공식은 제곱이 있다는 것이 특징이다. 탄젠트의 반각은 사인에서 코사인을 나눈 것이므로 따로 외우지 말도록 하자.

#topic(title: [삼각함수의 극한])[
  사인과 코사인 곡선은 기본적으로 실수 전체에서 연속이며 파동의 개형을 가지므로 모든 점에서 극한값과 함숫값이 같고, 무한대에서는 값이 진동하여 발산한다. 탄젠트 곡선은 주기적으로 나타나는 점근선들과 무한대에서 값이 발산한다.

그 외에 숙지해야할 극한값은 아래와 같다. 
]

#theorem(title: [삼각함수의 주요 극한])[
  $
    & lim_(x->0) (sin x)/x = 1 \
    & lim_(x->0) (tan x)/x = 1 \
    & lim_(x->0) (1 - cos x)/x = 0 \
    & lim_(x->0) (1 - cos x)/x^2 = 1/2
  $
]
#proof[
  단위원 상의 어떤 점 $"A"$를 잡자. $"A"$에서 $x$축에 내린 수선의 발을 $"H"$로 하고, $"B"$에서 $x$축으로 내린 수선이 단위원에 접하도록 하는 동경 $arrow("OA")$ 위의 점 $"B"$를 잡자. 이때 그 접점이자 수선의 발이 되는 점을 $"T"$라고 하자. 그러면 아래 관계가 성립한다.
  $
    overline("AH") < overparen("AB") < overline("BT")
  $
  이 길이들을 각각 삼각함수로서 나타내면 다음과 같다.
  $
    sin x < x < tan x
  $
  부등식의 변변을 $sin x$로 나누면
  $
    1 < x/(sin x) < 1/(cos x)
  $
  이제 $x -> 0$의 극한을 취하면
  $
    lim_(x->0) 1 < lim_(x->0) x/(sin x) < lim_(x->0) 1/(cos x)
  $
  이므로 조임 정리에 의해 아래가 성립한다.
  $
    lim_(x->0) x/(sin x) = 1 = lim_(x->0) (sin x)/x
  $
  $tan x = (sin x)/(cos x)$이므로 다음도 성립한다.
  $
    lim_(x->0) (tan x)/x = lim_(x->0) (sin x)/x dot 1 / (cos x) = 1
  $

  다만 코사인에 대해서는 이런 관계가 성립하지 않는데, 이는 $y=cos x$의 그래프와 $y=x$의 그래프를 비교해 보면 왜 그럴지 납득할 수 있다.
  $
    lim_(x->0) (cos x)/x = oo wide lim_(x->0) x/(cos x) = 0
  $

  대신 아래 식이 다음과 같이 전개된다.
  $
    lim_(x->0) (1 - cos x)/x = lim_(x->0) (sin^2 x)/(x (1 + cos x)) = lim_(x->0) (sin x)/(1 + cos x) = 0
  $
  또 아래 식은 위 식에 의해 다음과 같이 전개된다.
  $
    lim_(x->0) (1 - cos x)/x^2 = lim_(x->0) (sin x)/x dot 1/(1 + cos x) = 1/2
  $
]

특히, 세 번째 식을 증명하는 데는 여러 가지 방법이 있으니 시도해 보자. 몇 가지 아이디어를 주자면, 반각 공식의 꼴을 만들어서 할 수도 있고, 로피탈 정리로 할 수도 있고, 매클로린 급수로 이차 근사할 수도 있다.

#corollary(title: [삼각함수의 주요 극한값의 응용])[
  $a, b in RR$에 대해 아래가 성립한다.
  $
    & lim_(x->0) (sin b x)/(a x) = b/a \
    & lim_(x->0) (tan b x)/(a x) = b/a \
    & lim_(x->0) (1 - cos a x)/x^2 = a^2/2 
  $
]

#note-box(title: [매클로린 급수와 선형근사])[
  아래와 같이 어떤 함수를 무한차수의 다항식 형태로 나타낸 것을 '테일러 급수'(Taylor series)라고 한다.
  $
    T_f (x) = sum_(n = 0)^oo (f^((n)) (a))/n! (x-a)^n
  $
  함수를 근사하는 용도로, $a$에 0을 대입한 것을 '매클로린 급수'(Maclaurin series)라고 한다. 수렴반경 안에서 이 근사는 정확히 함숫값으로 수렴한다. 

  선형근사란 $n=1$일 때 테일러 전개를 한 것으로, 곧 접선의 방정식이다.
  $
    f(x) ~ f(a) + f'(a) (x-a) + R
  $
  $x->a$라면 이 근사는 같은 차수 내에서 정확하다. 여기에 다시 $a=0$을 취해 매클로린 급수로 만들면 $x->0$일 때 근사가 정확하다고 할 수 있다.

  여러 가지 함수의 근사를 알아보자. 주의할 점은, 분수 형태의 극한을 계산할 때는 차수를 맞춰 주어야 한다.
  $
    & sin x tilde.eq x - x^3/3! + x^5/5! + ... \
    & cos x tilde.eq 1 - 1/2 x^2 + x^4/4! + ... \
    & tan x tilde.eq x + x^3/3 + 2/15 x^5 + ... \
    & 1/(1-x) tilde.eq 1 + x + x^2 + ... \
    & e^x tilde.eq 1 + x + x^2/2 + x^3/3! + ... \
    & ln(1+x) tilde.eq x - x^2/2 + x^3/3 + ...
  $

  예를 들어 $lim_(x->0) (sin x)/x$를 계산할 때는 분모가 1차이므로 $sin x$ 근사도 1차까지만 취해 $x$라고 하면 되지만, 아래와 같은 식을 얄팍한 근사로 풀게 되면 틀리는 것이다. 
  $
    lim_(x->0) (tan x - sin x)/x^3
  $
  $sin x, tan x$ 모두 $x$라고 놓고 풀면 안 되고, 분모가 3차이므로 분자의 근사도 3차항까지 취해야 한다. 그러면 답은 $1/2$이 된다.

  사인, 코사인, 탄젠트, 지수, 로그의 매클로린 근사는 숙지해 두었다가 필요한 상황에 적절히 사용해 보도록 하자.
]

#topic(title: [삼각함수의 미분])[
  삼각함수의 미분 과정에는 도함수의 정의에 등장하는 $f(x+h)$를 삼각함수의 덧셈정리로 처리하는 것과, 분수로 표현될 수 있는 삼각함수를 몫의 미분법으로 처리하는 것이 핵심이다. 
]
바로 뒤에 나올 것이지만 몫의 미분법을 미리 보도록 하자면 다음과 같다.
$
  (g/f)' = (g' f - g f')/f^2 wide (1/f)' = - (f')/f^2 
$

이제 함수들의 미분들을 살펴보자.
#theorem(title: [삼각함수의 도함수])[
  $
    & (sin x)' = cos x &wide &(csc x)' = - csc x cot x \
    & (cos x)' = - sin x &wide &(sec x)' = sec x tan x \
    & (tan x)' = sec^2 x &wide &(cot x)' = - csc^2 x
  $
]
#proof[$
  (sin x)' &= lim_(h->0) (sin(x+h) - sin x)/h \
  &= lim_(h->0) (sin x cos h + cos x sin h - sin x)/h \
  &= lim_(h->0) (cos x sin h)/h \
  &= cos x
$
$
  (cos x)' &= lim_(h->0) (cos(x+h) - cos x)/h \
  &= lim_(h->0) (cos x cos h - sin x sin h - cos x)/h \
  &= lim_(h->0) - (sin x sin h)/h \
  &= - sin x  
$
$
  & (tan x)' = ((sin x)/(cos x))' = 1/(cos^2 x) = sec^2 x \
  & (csc x)' = (1/(sin x))' = -csc x cot x \
  & (sec x)' = (1/(cos x))' = sec x tan x \
  & (cot x)' = (1/(tan x))' = -csc^2 x
$]

#caution-box(title: [로피탈 정리는 만능이 아니다])[
  대부분의 극한 문제는 따로 식을 정리하여 계산하지 않고, 그저 분모 분자를 미분하는 로피탈 정리를 사용하면 풀리는 경우가 많지만, 삼각함수가 포함되어 있다면 미분을 해도 또 다른 삼각함수가 나오기 때문에 쉽지 않아진다. 즉, 삼각함수가 등장하면 로피탈은 되도록 쓸 생각을 하지 말자. 예를 들어 아래 극한값을 구하려고 로피탈 정리를 쓰면 미분을 할수록 식이 복잡해지게 된다.
  $
    lim_(x->0) (e^(1- sin x) - e^(1 - tan x))/(tan x - sin x)
  $

  이 문제의 경우 정직하게 $lim_(x->0) (e^x-1)/x = 1$을 이용하는 것이 맞다.
  $
    lim_(x->0) e^(1 - tan x) dot ((e^(tan x - sin x) - 1)/(tan x - sin x)) = e
  $
]
