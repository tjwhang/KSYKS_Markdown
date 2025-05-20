#import "@preview/physica:0.9.5": *
#import "@preview/ilm_custom:1.4.1": *
#import "@preview/alchemist:0.1.4": *
#import "@preview/theorion:0.3.3": *
#import "@preview/rich-counters:0.2.1": *
#import "@preview/cetz:0.3.4": *
#import "@preview/cetz-plot:0.1.1": *
#import cosmos.rainbow: *

// 표지
#let title = [러시아어]

#show: ilm.with(
  title: title,
  author: "Taejoon Whang",
  date: datetime(year: 2025, month: 04, day: 29),
  abstract: [최대한 빠르게 원어민적 사고를 하도록.],
  preface: align(center + horizon)[
    = 시작하기 전에
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
  import "@preview/physica:0.9.5": *
  import "@preview/ilm_custom:1.4.1": *
  import "@preview/alchemist:0.1.4": *
  import "@preview/theorion:0.3.3": *
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

= 러시아어 왕초보

== 키릴 문자 읽기

== 자기 소개와 기초 인사말

=== 대화

#emph-box[
  격식 있는 대화

  A: Здравствуйте. Меня зовут Оксана. \
  B: Здравствуйте, а меня - Эрик. \
  A: Очень приятно. \
  B: Взаимно.
]

A: 안녕, 내 이름은 옥사나야.\
B: 안녕, 그리고 나는 에릭이야.\
C: 만나서 반가워.\
D: 마찬가지야.\

#emph-box[
  편한 대화

  A: Привет, я - Оксана.\
  B: Привет, Оксана, а я - Эрик.\
  A: Очень приятно.\
  B: Мне тоже.\
]

A: 안녕, 난 옥사나야. \
B: 안녕 옥사나, 난 에릭이야.\
A: 만나서 반가워.\
B: 나도.

=== 어휘
- приятно: 즐겁게, 유쾌하게, 쾌적하게, 상냥하게, 쾌활하게.
- Привет: 안녕
- меня зовут: 내 이름은
- oчень: 매우
- здравствуйте: 안녕, 안녕하세요
- взаимно: 서로, 상호간에, 공동으로, 피차
- a: 그리고
- я: 나
- мне тоже: 나도

=== 설명
첫 번째, 격식 있는 대화를 보자.

Оксана: Здравствуйте. Меня зовут Оксана.\
Эрик: Здравствуйте, а меня - Эрик.\
Оксана: Очень приятно.\
Эрик: Взаимно.\

*Здравствуйте*는 직역하면 '건강을 기원한다' 정도가 된다. 하지만 그 뜻은 쇠퇴했고 지금은 인사말로 자리잡았는데, 한국어의 '안녕(安寧)'과 상통하는 부분이 있다.

*Меня зовут*은 '내 이름은' 이라는 뜻이다.\
직역하면 '내 호칭', '나를 부르는 방법' 정도가 된다. 지금은 문법은 신경쓰지 말고 이런 표현을 익히는 것에 초점을 두자.

"*A*"는 '그리고' 또는 '그러나'의 뜻을 가지는 접속사다.

#example[
  1. очень хорошо: 아주 좋다
  2. очень красивый: 매우 아름답다
  3. Вам холодно? / Очень!: 너 추워? / 아주!
]

*Приятно*는 '좋은'의 뜻을 가진다.\ "Очень приятно"와 "Приятно познакомиться"가 보통 만나서 반갑다는 뜻으로 쓰인다.

*Взаимно*는 서로, 상호 간의, 공동으로 등의 뜻을 가지며, 여기서는 '마찬가지다' 정도의 뜻으로 쓰였다.

누군가의 이름을 예의 있는 방법으로 묻고 싶다면 이렇게 말할 수 있다.

*Как вас зовут?*

직역하면 당신을 어떻게 부르냐는 뜻이다.

이제, 편한 대화(비격식 대화)를 보자.

Оксана: Привет, я - Оксана.\
Эрик: Привет, Оксана, а я - Эрик.\
Оксана: Очень приятно.\
Эрик: Мне тоже.\

*Привет*은 '안녕'이라는 뜻이고, 가벼운 말이다. 처음보는 사람에게는 하지 않는 것이 좋다.

*Я*는 '나'를 뜻한다.

#example[
  1. Я Эрик: 나는 에릭이다.
  2. Я американец: 나는 미국인이다.
  3. Я голодный: 나는 배고프다.
]

Мне тоже는 "나도" 정도로 해석될 수 있다. Мне는 지금은 대명사 Я의 변형 정도로 생각하면 된다.
그런데, тоже를 "나도 그렇다"라는 의미로 사용하려면 Мне가 아니라 Я를 써야 한다.

#example[
  1. Я устал: 나는 피곤하다.
  2. Я тоже: 나도 그렇다.
]

다른 사람이 자신을 "Меня зовут..."로 소개한다면 답할 때는 зовут를 생략할 수 있다.

#example[
  1. Меня зовут Маша.: 내 이름은 마샤야.
  2. А меня - Саша.: 그리고 난 사샤야.
]

== 국적 말하기
