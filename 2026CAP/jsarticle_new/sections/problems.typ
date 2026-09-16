#import "../preamble.typ": *

#set math.equation(numbering: none)

#set text(lang: "ko")

#problem(title: [$x$좌표 조건의 해석], difficulty: 1)[
    #jspnum[21] 삼차함수 $f(x)$가 $x_1 < x_2$인 임의의 두 실수 $x_1$, $x_2$에 대하여
    #nneq[$
        f(x_1 - t) - f(x_2 - t) < 2 abs(x_2) - 2 abs(x_1)
    $]
    을 만족시키도록 하는 실수 $t$의 범위가 $t>=4$이다.
    #par[]
    $f'(-3)=-2$일 때, $f(3)-f(0)$의 값을 구하시오. [4점]
]

#tip-box[
    $g(x) = f(x-t) + 2 abs(x)$로 놓아 본다.
]

#problem(title: [조임정리], difficulty: 1)[
    #jspnum[0] 실수 전체의 집합에서 미분가능한 함수 $f(x)$가 모든 양수 $h$에 대하여
    #nneq[$
        -h^2 + 8h + 2 < f(1+h) + f(1+3h) < h^3 + 8h + 2
    $]
    를 만족시킬 때, 곡선 $y=f(x)$ 위의 점 $(1, f(1))$에서의 접선이 $(4, k)$를 지난다. $k$의 값은?
]

#problem(title: [초월함수 근의 차수], difficulty: 2)[
    #jspnum[0] 실수 전체의 집합에서 미분가능한 함수 $f(x)$가 $0<=x<=pi$인 모든 실수 $x$와 \ 두 상수 $a, b$에 대하여
    #nneq[$
        x f(cos x + 1) = a (x+b) ln(x^2+1)
    $]
    을 만족시킨다. $f'(2)=-9$일 때, $a+b$의 값은?
]

#problem(title: [탄젠트의 미분], difficulty: 2)[
    #jspnum[0] 실수 전체의 집합에서 미분가능하고 양수 $t$와 모든 실수 $x$에 대하여
    #nneq[$
        tan(t ln f(x)) = t x
    $]
    인 함수 $f(x)$가 있다. 함수 $f(x)/(e^x + 1)$가 극솟값을 갖지 않을 때, $f(2)/(f'(2))$의 최댓값은?
]

#problem(title: [합성함수와 항등식], difficulty: 3)[
    #jspnum[0] $x=0$에서 극소인 삼차함수 $f(x)$와 실수 전체의 집합에서 도함수가 연속인 함수 $g(x)$가 다음 조건을 만족시킬 때, $a + f(1/a)$의 값은? (단, $a$는 상수이다.)

    #jsbox[
        (가) 모든 실수 $x$에 대하여
        #nneq[$
            f(x) = g(x) - a tan g(x), quad g'(x) != 0
        $]
        #h(2em) 이다.

        (나) $lim_(x->-oo) = a pi, quad f(0)>0, quad f'(-1)f(1)=0$
    ]
]
