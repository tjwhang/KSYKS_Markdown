#import "../jsarticle.typ": jsarticle-book, jsarticle-options, jsepigraph

#show: jsarticle-book.with(
  options: jsarticle-options(
    document: (title: [Adaptive vertical epigraph], title-page: "inline"),
    vertical: (heading-mode: "visual"),
  ),
)

#jsepigraph(style: "vert", scope: "block", attribution: [Author])[
  This deliberately longer vertical epigraph has an explicit source break \
  and must reserve only its longest visible vertical line.
]

The following paragraph must remain on this page, directly below the bounded
vertical epigraph. It proves that a long display does not consume the entire
remaining text area.
