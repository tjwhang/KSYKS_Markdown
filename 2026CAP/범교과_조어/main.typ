#import "@preview/physica:0.9.5": *
#import "@preview/alchemist:0.1.4": *
#import "@preview/theorion:0.5.0": *
#import "@preview/rich-counters:0.2.1": *
#import "@preview/cetz:0.3.4"
#import "@preview/cetz-plot:0.1.1"
#import "@preview/mannot:0.3.0": *
#import "@preview/codly:1.3.0": *
#import "@preview/codly-languages:0.1.1": *
#import "@preview/tyipa:0.1.0" as ipa
#import "@preview/rubby:0.10.2": get-ruby
#import "@preview/linguify:0.5.0": *
#import "@preview/parize:0.1.0": *
#import "@preview/wrap-it:0.1.1": *
#import "@preview/itemize:0.2.0" as el
#import "@preview/in-dexter:0.7.2": *
#import "@preview/metalogo:1.2.0": LaTeX, TeX


#show: show-theorion
#import cosmos.antique: *
#show: el.default-enum-list.with(
  auto-base-level: true,
)
// #show: par-indent.with(
//     exclude-elem: (
//         /*excludes specific block-level elements*/
//     ),
// )

#set text(lang: "ko", region: "kr")

#import "preamble.typ": *
#import "jsarticle.typ": *

#let title = [고유어와 한자어의 효용성 비교와 \ 새로운 조어법 제안 및 그 수학적 근거]

#show: jsarticle-book.with(
  title: title,
  subtitle: none,
  date: "2026년 7월 13일",
  author: "중앙고등학교",
  other: [
    30829 황태준
  ],
  paper-size: "a4",
  bind: "top",
  chapter-format: ("", ""),
  logo: image("logo.svg", width: 18%)
)

#pagebreak(to: "odd")

// 목차 앞부분은 로마자 페이지 번호 (vii 등)
#set page(numbering: "i")

#nnoh1[요약]

1. 배경과 필요성: 고유어가 한자어에 밀리는 것은 단순한 음절 수, 문법형태소 수, 의미의 특정성 및 추상성의 정도, 어감 등 여러 인자에 의해 결정되는 경쟁력에서 열위이기 때문이고, 앞으로 이러한 상태가 지속된다면 갈수록 고유어가 사라져 나갈 것이다.
2. 단어 경쟁력 지수: 단어 경쟁력 지수(WCI)를 정보 엔트로피, 합성 투명도, 경제성 등을 고려해, 미분이 용이하도록 물리학의 자유에너지에서 영감을 얻은 꼴의 수식으로 정의해 수립하고 이것이 타당한 지표임을 보인다.
3. 조어법 제안: WCI를 높일 수 있도록 하는 조어법을 제시한다. 크게 체언에서는 명사파생접사를 확대 사용하는 방법, 비통사적으로 어간을 어근에 바로 붙이는 방법, 용언에서는 어간에 어간 또는 어근을 바로 붙이는 방법을 제시한다.
4. 통시적 변화 모형과 성공적인 정착: WCI를 미분하고 복제자 동역학 원리에서 영감을 받은 WCI와 점유율 진화 모형을 도입하여 신조어가 성공적으로 언어 습관으로 정착하려면 어떻게 해야 하는지를 확인한다.  


#outline(
  title: "목차",
  // indent: n => n * n * 1em,
  depth: 3,
)

#pagebreak()



// ====================
// 본문 시작 (아라비아 숫자로 변경)
// ====================
#set page(numbering: "1")
#counter(page).update(1)

#include "sections/1.typ"
#include "sections/2.typ"

#bibliography("bib.yaml", title: "참고문헌")

국립국어원 표준국어대사전

한글학회 큰사전

角川外來語辭典

大槻文彦, 復軒雑纂

Shannon, Claude E. (1948), A Mathematical Theory of Communication, (Bell System Technical Journal)

MacKay, David. J. C. (2003), Information Theory, Inference, and Learning Algorithms (Cambridge University Press)

김광해(서울대학교 사범대학 국어교육과, 1995), 조망-국어에 대한 일본어의 간섭, 특집 (국립국어원 새국어생활): https://www.korean.go.kr/nkview/nklife/1995_2/5_1.html

Hofbauer, J., Sigmund, K. (2003), Evolutionary game dynamics, Bulletin of the American Mathematical Society