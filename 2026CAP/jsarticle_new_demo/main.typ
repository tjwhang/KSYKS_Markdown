#import "preamble.typ": *

#import "fonts.typ": document-composites

#show: show-theorion
#import "jsarticle.typ": *

#show: jsarticle-book.with(
  options: jsarticle-options(
    document: (
      title: [다국어 조판 예제],
      subtitle: [견본에 아무말이나 적어보기],
      author: [(저작자)],
      date: [날짜]
    ),
    page: (
      paper-size: "a4",
      cols: 1,
    ),
    typography: (
      cjk-spacing: 0.2em,
      ambient-language: "ko",
    ),
    fonts:(
      composites: document-composites,
    )
  )
)

= 제목

일반적인 본문은 그대로 작성합니다.

#include "specimen.typ"