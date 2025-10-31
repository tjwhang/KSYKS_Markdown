#import "@preview/bubble_custom:0.2.2": *
#import "@preview/physica:0.9.5": *
#import "@preview/alchemist:0.1.4": *
#import "@preview/theorion:0.3.3": *
#import "@preview/rich-counters:0.2.1": *
#import "@preview/cetz:0.3.4"
#import "@preview/cetz-plot:0.1.1"
#import "@preview/mannot:0.3.0": *
#import "@preview/tyipa:0.1.0" as ipa
#import "@preview/rubby:0.10.2": get-ruby

#import "@preview/whalogen:0.3.0": ce

#import cosmos.clouds: *

#import "template.typ": *

#let title = [#ce("A2B2") 분자 구조의 입체성]

#show: bubble.with(
    title: title,
    subtitle: "2학기 화학Ⅰ 심화탐구",
    author: "20731 황태준",
    affiliation: none,
    date: datetime.today().display(),
    year: "발표일: 2025년 10월 00일",
    class: none,
    other: ("",),
    logo: image("logo.svg"),
    color-words: ("important",),
    main-color: "872434",
)

#show: show-theorion
#set math.mat(delim: "[")
#set math.vec(delim: "[")
#set quote(block: true)

#show math.equation.where(block: false): it => math.display(it)
// show inline math as display

#set page(
    paper: "a4",
    margin: 3.4cm,
    header: [
        #align(horizon, [ \ \ \ \ #box(image("logo.svg", width: 8em), baseline: 3em)])
        #align(right, title)
    ],
    footer: context [
        #align(right, line(length: 5em))
        #text(
            query(
                selector(heading.where(level: 1)).before(here()),
            )
                .last()
                .body,
            size: 9pt,
        )
        #h(1fr) #counter(page).display("1")
    ],
    numbering: "1",
    fill: rgb("c7c1a9").lighten(70%), // comment this when exporting for print
)

#set par(
    justify: false,
    leading: 1.35em,
    spacing: 2em,
)

#show heading: set block(above: 2em, below: 1.3em)

#set text(
    font: (
        // "Source Han Serif K", // 가장 우선순위 폰트
        (
            name: "STIX Two Text", // 라틴 폰트
            covers: "latin-in-cjk",
        ),
        (
            name: "LXGW WenKai",
            covers: regex("[\p{scx:Han}\p{scx:Hira}\p{scx:Kana}]"),
        ), // 한자, 히라가나, 가타가나
        "Source Han Serif K", // CJK fallback 폰트
    ),
    cjk-latin-spacing: none,
)
#show math.equation: set text(
    font: (
        (
            name: "Libertinus Math",
            covers: "latin-in-cjk",
        ),
        "KoPubBatang_Pro",
    ),
    cjk-latin-spacing: none,
    weight: "regular",
    // stylistic-set: (2, 4, 6, 7, 10, 11),
    // ^ Garamond 사용시, hslash -> hbar는 6

    // stylistic-set: (2, 4),
    // ^ STIX Two 사용시, hslash -> hbar는 3
    stylistic-set: 8,
)

#show heading.where(level: 1): it => {
    counter(math.equation).update(0)
    it
}

#set math.equation(numbering: n => {
    numbering("(1.1)", counter(heading).get().first(), n)
    // if you want change the number of number of displayed
    // section numbers, modify it this way:
    /*
    let count = counter(heading).get()
    let h1 = count.first()
    let h2 = count.at(1, default: 0)
    numbering("(1.1.1)", h1, h2, n)
    */
})

#set figure(numbering: n => {
    numbering("1.1", counter(heading).get().first(), n)
    // if you want change the number of number of displayed
    // section numbers, modify it this way:
    /*
    let count = counter(heading).get()
    let h1 = count.first()
    let h2 = count.at(1, default: 0)
    numbering("(1.1.1)", h1, h2, n)
    */
})

#set math.equation(supplement: [식])
#set outline()
#show raw: set text(font: ("JetBrains Mono", "Source Han Sans K"))

#show math.equation: it => {
    let bb-font = "New Computer Modern Math" //Garamond-Math
    show regex(
        "𝔸|𝔹|ℂ|𝔻|𝔼|𝔽|𝔾|ℍ|𝕀|𝕁|𝕂|𝕃|𝕄|ℕ|𝕆|ℙ|ℚ|ℝ|𝕊|𝕋|𝕌|𝕍|𝕎|𝕏|𝕐|ℤ|𝕒|𝕓|𝕔|𝕕|𝕖|𝕗|𝕘|𝕙|𝕚|𝕛|𝕜|𝕝|𝕞|𝕠|𝕡|𝕢|𝕣|𝕤|𝕥|𝕦|𝕧|𝕨|𝕩|𝕪|𝕫",
    ): set text(font: bb-font)
    it
}


#outline(title: [목차], target: heading.where(level: 1))
#pagebreak()

= 탐구 동기

화학 수업 시간에 선생님께서 #ce("A2B2") 꼴의 분자들(예를 들어 #ce("H2O2"), #ce("N2H2"), #ce("C2H2") 등등...)의 결합 구조에 대해 가르쳐 주셨다. 그런데, 두 개의 굽은형이 붙은 듯한 모양의 이 분자들은 이상하게도 어떤 것은 모든 원자들이 한 평면 위에 있고, 어떤 것은 그렇지 않고 꼬여 있다. 이건 왜 그런 것일까? 

찾아본 결과, 간단한 답은 비공유 전자쌍 때문이라는 것이다. 예를 들어 입체구조인 #ce("H2O2")는 중심원자인 #ce("O")의 비공유 전자쌍이 두 개라서 굽은형과 비슷한 모양을 갖고, 평면구조인 #ce("N2H2")는 중심원자인 #ce("N")의 비공유 전자쌍이 한 개라서 비공유 전자쌍을 포함해서 보았을 때 평면삼각형과 비슷한 모양을 갖게 되는 구조가 만들어진다. 실제로도 cis형과 trans형 #ce("N2H2")는 결합각이 $120 degree$에 가깝다고 한다. 이것도 맞는 말이라고 하나, 어딘가 끼워맞추는 설명 같기도 하고 직관적으로 납득이 잘 되지 않는다. 

사실 무기(無機)화학이 대부분인 화학Ⅰ 과정에서는 특히 오비탈과 화학 결합 부분에서 타당한 근거 없이 자명하게 받아들이기 어려운 개념을 일방적으로 선언하거나 우연히 비슷한 특성을 가진 다른 사례로 비유하여 이해시키려는 경향이 강하다. 물론 이것을 고등학생으로서 배우는 우리는 양자역학 위에 쌓아 올려진 이런 미시적인 물리화학 개념들을 아무런 기초 없이 제대로 학습하기가 불가능하다. 하지만 그러려니 하고 넘어가면서 생긴 궁금증은 갈수록 누적되기 마련이고, 결국 심화탐구를 진행하는 계기로 이 심오하고 복잡한 분야에 발만 담가보기로 했다.

#include "chapters/1_orbital.typ"
#include "chapters/2_bond.typ"

= 결론 및 고찰

결론은, 꼭 #ce("A2B2") 꼴의 분자가 아니더라도 파이 결합이 있는 원자와 결합한 부분끼리는 평면 구조를 가져야 결합이 유지될 수 있다는 것이다. 그래서 #ce("H2O2")는 입체 구조인데 #ce("N2H2")나 #ce("C2H2")는 평면 구조인 것이었다. 중심원자끼리 파이 결합이 생겼기 때문에 결합이 돌아가서 말단 원자가 입체 구조를 이루려고 하게 되면 결합이 깨지게 되기 때문이다. 그러므로 수험생들이 올려 놓은 것으로 보이는 비공유 전자쌍으로 결합의 평면 또는 입체 여부를 설명하는 인터넷 글이나 질의응답 내용은 부정확한 내용이었다. 비공유 전자쌍은 여기서는 평면 또는 입체 구조를 결정하는 것이 아니라 반발력을 통해 결합각을 결정하게 된다.

다른 생각해볼 점은 과학 원리를 수식으로 표현하는 것에 대한 것이다. 계산으로 보여야 엄밀하겠다는 생각으로 양자역학적 계산들을 하는 과정을 동원했는데, 물론 식으로 보니 서술이 옳겠다는 느낌이 더 들기는 하지만, 양자역학을 공부하며 느낀 양자역학 식들의 특징인 '써놓은 걸 보면 실제보다 더 어렵게 느껴지는 것'이 여과 없이 드러난 예시이기도 하고, 결국 진짜 입체 구조가 달라지는 이유를 알게 되는데는 식을 통한 증명이 절대로 필수적이지 않았다. 수학과 과학 간 연관 관계의 필연성에 대해 고민하게 되는 부분이다.

과학에서의 공식은 결국 자연에서 일어나는 수많은 현상들 중 관심 있는 현상에 대한 양만 골라서 변수와 상수로 놓고 실험적으로 검증해서 들어맞으면 쓰기로 하는 것이다. 

이 세상을 기술하기 위해 수학과 과학은 서로에게 영향을 주며 발전해 왔다. 그리고 수치적이고 실질적인 계산을 도출해야 하는 상황이 아니더라도 분명히, 수학은 과학에서 큰 부분을 차지한다. 그러나, 인간은 잘 생각해보면 천부적인 미적분 능력을 본능적으로 탑재하고 있다. 뭔가 물체가 날아올 때, 그 궤적을 예측해서 잡기도 하고 피하기도 할 수 있는 능력이 그 증거라고 본다. 즉 수식으로 적을 때, 변수 한두 개로 일계나 이계 미적분을 하여 표현할 수 있는 정도의 내용들은 수식이 없어도 적절한 비유와 예시만 들어주면 여태까지 살아오면서 터득한 자연에 대한 경험적 상식을 토대로 중학생도 '이해'할 수 있다. 그 대표적인 예가 원래는 맥스웰 방정식으로 기술되는 전자기유도일 것이다. 

물론 중학생 때부터 '이해'했다고 생각한 내용들은 사실 이해한 것이 아니다. 이해했다고 착각하고, 막연하게 받아들인 뒤 써먹고 있는 것이다. 정말로 원리에 대해 심층적으로 알아서 과학을 이해한다는 것은, 원리를 기술하는 수식 표현의 의미는 물론, 그 수식 너머에 있는 현상에 대한 의미까지 알아야 할 것이라고 생각한다. 일단 나는 가장 단순해 보이는 식에서조차 그렇게 하지 못하고 있는 것 같다.

#quote([If you want to understand nature, you must understand the language she speaks, and that language is mathematics.], attribution: [Richard Feynman])

("자연을 이해하고 싶다면 자연이 하는 언어를 이해할 수 있어야 한다. 그 언어는 수학이다.", 리처드 파인만.)

= 참고문헌 및 출처

- David J. Griffiths 외, "Introduction to Quantum Mechanics" 3/e
- David J. Griffiths, "Introduction to Electrodynamics" 4/e
- Theodore Brown, "Chemistry : the central science"
- Friedrich Hund, "Zur Deutung der Molekelspektren"
- Paul Falstad, "Hydrogen Atom Orbital Viewer"(https://www.falstad.com/qmatom/)
- Encyclopedia of Mathematics, "Laguerre polynomials"(https://encyclopediaofmath.org/index.php?title=Laguerre_polynomials)
- Encyclopedia of Mathematics, "Legendre polynomials"(https://encyclopediaofmath.org/wiki/Legendre_polynomials)
- https://sites.astro.caltech.edu/~srk/Ay126/Lectures/Lecture2/QMChap7.pdf
- Richard Feynman, "The Character of Physical Law"

감사합니다 ^^