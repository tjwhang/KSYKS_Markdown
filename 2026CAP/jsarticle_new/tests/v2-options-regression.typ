#import "../jsarticle.typ": jsarticle-book, jsarticle-options, jsvert

#show: jsarticle-book.with(
  options: jsarticle-options(
    document: (title: [V2 option record], title-page: "inline"),
    page: (paper-size: "a5", cols: 2, h1-break: "continuous"),
    typography: (ambient-language: "ko", cjk-scale: 0.925em),
    horizontal: (normalization: (enabled: true, punctuation: true, spaces: true)),
    vertical: (rows: 1, columns: 1, stream-gap: 0.6em),
  ),
)

= Grouped configuration

The public book interface receives one validated record. Korean 문장 and
Japanese text(lang: "ja")[日本語] retain their language-specific stacks.

#block(width: 45mm)[
  #jsvert(flow: "region", region-height: 30mm)[
    縦書きの短い検証文です。
  ]
]
