#import "../jsarticle.typ": jsarticle-book, jsarticle-options
#import "../cjk.typ": cjk-inline-math-boundary-spacing

#show: jsarticle-book.with(
  options: jsarticle-options(
    typography: (
      ambient-language: "ko",
      cjk-spacing: 1em,
    ),
  ),
)

= Plain paragraph
한글$x$좌표와 삼차함수 $f(x)$가 있다.
한글`raw`좌표와 `raw`한글이 있다.
한글1좌표와 2한글은 숫자 경계를 유지한다.
한글 $x$ 좌표는 수식 간격에 원래 공백을 더하고, 한글 `raw` 좌표는 원래 공백만 쓴다.

= External post-composition check
#cjk-inline-math-boundary-spacing([한글$x$좌표와 삼차함수 $f(x)$가 있다.], 1em)

= Nested container
#figure(block(inset: 1em)[한글$x$좌표와 삼차함수 $f(x)$가 있다.])
#figure(block(inset: 1em)[한글`raw`좌표와 `raw`한글이 있다.])

= Nested source-scope container
#cjk-inline-math-boundary-spacing([
  #figure(block(inset: 1em)[한글$x$좌표와 삼차함수 $f(x)$가 있다.])
], 1em)

= Particle-bound inline atoms
#block(width: 8em)[
  가나다라마바사 $a$는 다음과 같이 설명한다.
  가나다라마바사 `raw`는 다음과 같이 설명한다.
  가나다라마바사 Latin은 다음과 같이 설명한다.
]

#text(lang: "ja")[
  #block(width: 8em)[
    あいうえおかきく $a$は、次のように説明する。
    あいうえおかきく `raw`は、次のように説明する。
    あいうえおかきく Latinは、次のように説明する。
  ]
]
