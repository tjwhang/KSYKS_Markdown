#import "../jsarticle.typ": *

#jsarticle-book(options: jsarticle-options(
  document: (title: [Ruby flow], title-page: "inline"),
  typography: (ambient-language: "ja"),
  fonts: (ruby-family: "footnote"),
  vertical: (ruby-family: "footnote"),
))[

= Horizontal Rubby

#rb[かんじ][漢字]を読む。#rb(alignment: "start")[とうきょう][東京]へ行く。
#rb[신|체|발|부][身|體|髮|膚]

= Vertical Basho ruby

#jsvert(
  flow: "region",
  language: "ja",
  region-height: 12em,
  paragraph-indent: 0em,
  ruby-size: 0.45em,
  ruby-gap: 0.1em,
)[
  #rb[かんじ][漢字]を読む。#rb[とうきょう][東京]へ行く。
  #rb[しんたいはつぷ][身體髮膚]を大切にする。
  #rb[신체발부][身體髮膚] #rb[수지부모][受之父母]
  #rb[신|체|발|부][身|體|髮|膚]
]

= Delimited vertical ruby

#jsepigraph(style: "vert", scope: "block", attribution: none)[
  #rb[신체발부][身體髮膚] #rb[수지부모][受之父母]
]

= Long vertical ruby

The first sample reserves its own vertical span. The second may overhang only
while it is isolated from another ruby annotation.

#jsvert(
  flow: "region",
  language: "ja",
  region-height: 12em,
  paragraph-indent: 0em,
  ruby-overflow: "reserve",
)[
  #rb[とうきょうとうきょう][東京]へ行く。
  #rb[とうきょう][東京]#rb[おおさか][大阪]
]

#jsvert(
  flow: "region",
  language: "ja",
  region-height: 12em,
  paragraph-indent: 0em,
  ruby-overflow: "overhang",
  ruby-overhang: 0.5em,
)[
  #rb[とうきょうとうきょう][東京]へ行く。
  #rb[とうきょう][東京]#rb[おおさか][大阪]
]
]
