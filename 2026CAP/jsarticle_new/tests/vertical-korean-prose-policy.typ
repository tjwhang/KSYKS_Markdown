#import "../jsarticle.typ": jsarticle-book, jsarticle-options, jsvert, jsepigraph

#show: jsarticle-book.with(
  options: jsarticle-options(
    document: (title: [Korean vertical prose policy], title-page: "inline"),
    vertical: (
      min-fragment-chars: 2,
      min-fragment-languages: ("ko",),
      justify: true,
      justify-languages: ("ko",),
      korean-fullwidth-spaces: false,
    ),
  ),
)

#jsepigraph(style: "line", scope: "block", width: 55%)[
  This quotation must begin at the left edge of its epigraph block.
]

#jsvert(flow: "region", language: "ko", region-height: 29mm)[
보존한다면, 안정된 문장은 어말의 쉼표와 함께 남는다. 그의 준칙은 짧은 낱자를 고립시키지 않는다#footnote[The marker must remain with its preceding vertical text.].
]

#jsvert(flow: "region", language: "ja", region-height: 29mm)[
日本語の行末は均等割りを既定では行わず、禁則だけを守る。
]
