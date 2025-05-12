#import "@preview/physica:0.9.4": *
#import "@preview/ilm_custom:1.4.1": *
#import "@preview/alchemist:0.1.4": *
#import "@preview/theorion:0.3.2": *
#import "@preview/rich-counters:0.2.1": *
#import "@preview/cetz:0.3.4"
#import "@preview/cetz-plot:0.1.1"
#import cosmos.rainbow: *

// 표지
#let title = [Standard \ Template Document]

#show: ilm.with(
  title: title,
  author: "Taejoon Whang, Dongwoo Nam",
  date: datetime(year: 2025, month: 03, day: 06),
  abstract: [#lorem(30)],
  preface: align(center + horizon)[
    = Preface
    #lorem(100)
  ],
  //bibliography: bibliography(""),
  figure-index: (enabled: false),
  table-index: (enabled: false),
  listing-index: (enabled: false),
)

#set text(
  font: (
    (
      name: "STIX Two Text",
      covers: "latin-in-cjk",
    ),
    "Source Han Serif K",
  ),
  cjk-latin-spacing: none,
)
#show math.equation: set text(font: "STIX Two Math")
#set math.equation(numbering: "(1.1)", supplement: [식. ])
#set outline()
#show raw: set text(font: ("JetBrains Mono", "D2Coding"))
#set page(
  paper: "a4",
  margin: 3.5cm,
  header: align(right, title),
  numbering: "1",
)

#show: show-theorion
#set math.mat(delim: "[")

#set math.equation(numbering: none)

#let tag(content) = {
  math.equation(
    block: true,
    numbering: "(1.1)",
    supplement: [식. ],
    content,
  )
}

// 컴포넌트

#let template = doc => {
  import "@preview/physica:0.9.4": *
  import "@preview/ilm_custom:1.4.1": *
  import "@preview/alchemist:0.1.4": *
  import "@preview/theorion:0.3.2": *
  import "@preview/rich-counters:0.2.1": *
  import "@preview/cetz:0.3.4": *
  import "@preview/cetz-plot:0.1.1": *
  import cosmos.rainbow: *

  show: show-theorion
  set math.mat(delim: "[")

  set math.equation(numbering: none)

  let tag(content) = {
    math.equation(
      block: true,
      numbering: "(1.1)",
      supplement: [식. ],
      content,
    )
  }

  doc
}

// 본문
= Sample Title

목차 글꼴이 깨지는 이유는 알 수 없네요

#lorem(300)

The Schrödinger equation is like the following.
$ i hbar partial / (partial t) psi = {- frac(hbar^2, 2m) nabla^2 + V(x)}psi $

다람쥐 헌 쳇바퀴 타고파.

= Functionality Test

어떤 것들이 가능한지 알아보자.

== 새로운 수열 $delta_n$
위와 같이 제목 안에 수식을 넣을 수 있다.

== 여러가지 문자
한글: 다람쥐 헌 쳇바퀴 타고파. \
일본어: 私はガラスを食べられます。 \
중국 간체: 我爱北京的天安门 \
중국 번체: 我愛北京的天安門 \
키릴: Привет, мир. Сука Блять! \
그리스 문자: Γειά σου, Κόσμε.\
한자: 道吾善者는 是吾賊이오, 道吾惡者는 是吾師니라.

== 표

#table(
  columns: (auto, auto),
  inset: 10pt,
  align: horizon,
  table.header(
    [*Volume*],
    [*Parameters*],
  ),

  $ pi h (D^2 - d^2) / 4 $,
  [
    $h$: height \
    $D$: outer radius \
    $d$: inner radius
  ],

  $ sqrt(2) / 12 a^3 $, [$a$: edge length],
)

== 수식

이렇게 $a^2+b^2=c^2$ 같은 인라인 수식을 쓸 수도 있고, 아래처럼 블록 수식을 쓸 수도 있다

$ E_"k"=1 / 2 m v^2 = p^2 / (2m) $

위 식은 라벨이 없지만,

#tag[$
    hat(p)^2 / (2m)
    = hbar^2 / (2m) partial^2 / (partial x^2)
    = hbar^2 / (2m) nabla^2
  $]

위 식은 라벨이 있다.

== 그림

#figure(
  image("RiemannZetaGraph.png", alt: "Riemann Zeta Graph", width: 10%),
  caption: [Riemann 제타(#sym.zeta) 함수의 그래프],
)

== 그래프
#cetz.canvas({
  cetz.draw.set-style(
    axes: (
      y: (label: (anchor: "north-west", offset: -0.2), mark: (end: "stealth", fill: black)),
      x: (label: (anchor: "north", offset: 0.1), mark: (end: "stealth", fill: black)),
    ),
  )
  cetz-plot.plot.plot(
    size: (8, 5),
    x-label: $x$,
    y-label: $y$,
    y-tick-step: none,
    x-tick-step: none,
    // x-grid: true,
    // y-grid: true,
    legend: "inner-south-east",
    legend-style: (stroke: .5pt),
    axis-style: "school-book",
    {
      // x ln(x) function
      cetz-plot.plot.add(
        style: (stroke: red + 1.5pt),
        domain: (0.01, 2.7), // avoid x=0 since ln(0) is undefined
        samples: 100,
        label: $x ln(x)$,
        x => x * calc.ln(x),
      )

      // ln(x) function
      cetz-plot.plot.add(
        style: (stroke: purple + 1.5pt),
        domain: (0.01, 2.7), // avoid x=0 since ln(0) is undefined
        samples: 100,
        label: $ln(x)$,
        x => calc.ln(x),
      )

      // x-1 function
      cetz-plot.plot.add(
        style: (stroke: blue + 1.5pt),
        domain: (-1, 2.7),
        label: $x-1$,
        x => x - 1,
      )
    },
  )
})

== 라벨

=== Table of Theorems

#outline(title: none, target: figure.where(kind: "theorem"))

=== Basic Theorem Environments

Let's start with the most fundamental definition.

#definition[
  A natural number is called a #highlight[_prime number_] if it is greater than 1
  and cannot be written as the product of two smaller natural numbers.
] <def:prime>

#example[
  The numbers $2$, $3$, and $17$ are prime. As proven in @cor:infinite-prime,
  this list is far from complete! See @thm:euclid for the full proof.
]

#theorem(title: "Euclid's Theorem")[
  There are infinitely many prime numbers.
] <thm:euclid>

#proof[
  By contradiction: Suppose $p_1, p_2, dots, p_n$ is a finite enumeration of all primes.
  Let $P = p_1 p_2 dots p_n$. Since $P + 1$ is not in our list,
  it cannot be prime. Thus, some prime $p_j$ divides $P + 1$.
  Since $p_j$ also divides $P$, it must divide their difference $(P + 1) - P = 1$,
  a contradiction.
]

#corollary[
  There is no largest prime number.
] <cor:infinite-prime>

#lemma[
  There are infinitely many composite numbers.
]

=== Functions and Continuity

#theorem(title: "Continuity Theorem")[
  If a function $f$ is differentiable at every point, then $f$ is continuous.
] <thm:continuous>

#tip-box[
  @thm:continuous tells us that differentiability implies continuity,
  but not vice versa. For example, $f(x) = |x|$ is continuous but not differentiable at $x = 0$.
  For a deeper understanding of continuous functions, see @thm:max-value in the appendix.
]

=== Geometric Theorems

#theorem(title: "Pythagorean Theorem")[
  In a right triangle, the square of the hypotenuse equals the sum of squares of the other two sides:
  $x^2 + y^2 = z^2$
] <thm:pythagoras>

#important-box[
  @thm:pythagoras is one of the most fundamental and important theorems in plane geometry,
  bridging geometry and algebra.
]

#corollary[
  There exists no right triangle with sides measuring 3cm, 4cm, and 6cm.
  This directly follows from @thm:pythagoras.
] <cor:pythagoras>

#lemma[
  Given two line segments of lengths $a$ and $b$, there exists a real number $r$
  such that $b = r a$.
] <lem:proportion>

=== Algebraic Structures

#definition(title: "Ring")[
  Let $R$ be a non-empty set with two binary operations $+$ and $dot$, satisfying:
  1. $(R, +)$ is an abelian group
  2. $(R, dot)$ is a semigroup
  3. The distributive laws hold
  Then $(R, +, dot)$ is called a ring.
] <def:ring>

#proposition[
  Every field is a ring, but not every ring is a field. This concept builds upon @def:ring.
] <prop:ring-field>

#example[
  Consider @def:ring. The ring of integers $ZZ$ is not a field, as no elements except $plus.minus 1$
  have multiplicative inverses.
]

== Theorion Appendices

=== Advanced Analysis

#theorem(title: "Maximum Value Theorem")[
  A continuous function on a closed interval must attain both a maximum and a minimum value.
] <thm:max-value>

#warning-box[
  Both conditions of this theorem are essential:
  - The function must be continuous
  - The domain must be a closed interval
]

=== Advanced Algebra Supplements

#axiom(title: "Group Axioms")[
  A group $(G, \cdot)$ must satisfy:
  1. Closure
  2. Associativity
  3. Identity element exists
  4. Inverse elements exist
] <axiom:group>

#postulate(title: "Fundamental Theorem of Algebra")[
  Every non-zero polynomial with complex coefficients has a complex root.
] <post:fta>

#remark[
  This theorem is also known as Gauss's theorem, as it was first rigorously proved by Gauss.
]

=== Common Problems and Solutions

#problem[
  Prove: For any integer $n > 1$, there exists a sequence of $n$ consecutive composite numbers.
]

#solution[
  Consider the sequence: $n! + 2, n! + 3, ..., n! + n$

  For any $2 <= k <= n$, $n! + k$ is divisible by $k$ because:
  $n! + k = k(n! / k + 1)$

  Thus, this forms a sequence of $n-1$ consecutive composite numbers.
]

#exercise[
  1. Prove: The twin prime conjecture remains unproven.
  2. Try to explain why this problem is so difficult.
]

#conclusion[
  Number theory contains many unsolved problems that appear deceptively simple
  yet are profoundly complex.
]

=== Important Notes

#note-box[
  Remember that mathematical proofs should be both rigorous and clear.
  Clarity without rigor is insufficient, and rigor without clarity is ineffective.
]

#caution-box[
  When dealing with infinite series, always verify convergence before discussing other properties.
]

#quote-box[
  Mathematics is the queen of sciences, and number theory is the queen of mathematics.
  — Gauss
]

#emph-box[
  Chapter Summary:
  - We introduced basic number theory concepts
  - Proved several important theorems
  - Demonstrated different types of mathematical environments
]

