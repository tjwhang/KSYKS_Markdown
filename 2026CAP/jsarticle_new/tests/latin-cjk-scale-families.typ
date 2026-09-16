#import "../jsarticle.typ": jsarticle-book, jsarticle-options, js-default-composites, jsface, jsfontset-extend

#let hiragino = jsface("Hiragino Mincho ProN", optics: (
  han: (baseline: -0.015em, tracking: 0em),
  western: (scale: 0.925),
))
#let japanese-serif = jsfontset-extend(
  js-default-composites.serif,
  (face: hiragino, covers: "han", lang: "ja"),
  (face: hiragino, covers: "western", lang: "ja"),
)

#show: jsarticle-book.with(
  options: jsarticle-options(
    document: (title: [Latin CJK-scale family matching], title-page: "inline"),
    typography: (
      ambient-language: "ja",
      cjk-scale: 0.925em,
      latin-scale: 1em,
      latin-light-weight: 350,
    ),
    fonts: (composites: (serif: japanese-serif)),
  ),
)

#text(lang: "ja")[漢字 Latin 123 日本語と*強調 Latin 456*]

#text(lang: "en")[Plain English remains governed by the active western font stack.]
