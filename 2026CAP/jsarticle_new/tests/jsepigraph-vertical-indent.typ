#import "../jsarticle.typ": jsarticle-book, jsarticle-options, jsepigraph

#show: jsarticle-book.with(
  options: jsarticle-options(
    document: (title: [Vertical epigraph], title-page: "inline"),
    vertical: (heading-mode: "visual"),
  ),
)

#jsepigraph(style: "vert", scope: "block", attribution: [Author])[
  A compact vertical display.
]

The following paragraph remains in normal horizontal flow and should begin
after only the component's ordinary display spacing, rather than after an
empty fixed-height vertical region.
