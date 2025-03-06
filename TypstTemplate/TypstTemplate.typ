#import "@preview/physica:0.9.4": *
#import "@preview/ilm:1.4.1": *
#import "@preview/alchemist:0.1.4": *
#import "@preview/great-theorems:0.1.2": *
#import "@preview/rich-counters:0.2.1": *


#show: ilm.with(
  title: [Standard \ Template Document],
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
  listing-index: (enabled: false)
)

#set text(font: (
  (
    name: "STIX Two Text",
    covers: "latin-in-cjk",
  ),
  "Source Han Serif K"
))
#show math.equation: set text(font: "STIX Two Math")
#set math.equation(numbering: "(1)")
#set outline()
#show raw: set text(font: ("JetBrains Mono", "D2Coding"))
#set page(
  paper: "a4",
  margin: 3.5cm,
  header: align(right)[
    Standard Template Document
  ],
  numbering: "1",
)
#set math.equation(numbering: none)

#let tag(content) = {
  math.equation(
    block: true, 
    numbering: "(1)", 
    content
  )
}

#show: great-theorems-init

#let mathcounter = rich-counter(
  identifier: "mathblocks",
  inherited_levels: 1
)

#let theorem = mathblock(
  blocktitle: "Theorem",
  counter: mathcounter,
)

#let lemma = mathblock(
  blocktitle: "Lemma",
  counter: mathcounter,
)

#let remark = mathblock(
  blocktitle: "Remark",
  prefix: [_Remark._],
  inset: 5pt,
  fill: lime,
  radius: 5pt,
)

#let proof = proofblock()

// 본문
= Sample Title

목차 글꼴이 깨지는 이유는 알 수 없네요

#lorem(300)

The Schrödinger equation is like the following.
$ i hbar partial / (partial t) psi = {- frac(hbar^2,2m) nabla^2 + V(x)}psi $

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
키릴:  Привет, мир. Сука Блять! \
그리스 문자:  Γειά σου, Κόσμε.\
한자: 道吾善者는 是吾賊이오, 道吾惡者는 是吾師니라.

== 표

#table(
  columns: (auto, auto),
  inset: 10pt,
  align: horizon,
  table.header(
    [*Volume*], [*Parameters*],
  ),
  $ pi h (D^2 - d^2) / 4 $,
  [
    $h$: height \
    $D$: outer radius \
    $d$: inner radius
  ],
  $ sqrt(2) / 12 a^3 $,
  [$a$: edge length]
)

== 수식

이렇게 $a^2+b^2=c^2$ 같은 인라인 수식을 쓸 수도 있고, 아래처럼 블록 수식을 쓸 수도 있다

$ E_"k"=1/2 m v^2 = p^2/(2m) $

위 식은 라벨이 없지만,

#tag[$ 
  hat(p)^2/(2m)
  = hbar^2/(2m) partial^2/(partial x^2)
  = hbar^2/(2m) nabla^2 
  $]

위 식은 라벨이 있다.

== 그림

#figure(
  image("RiemannZetaGraph.png", alt: "Riemann Zeta Graph", width: 10%),
  caption: [Riemann 제타(#sym.zeta) 함수의 그래프]
)

