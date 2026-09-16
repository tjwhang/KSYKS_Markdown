#import "../jsarticle.typ": *
#show: jsarticle-book.with(options: jsarticle-options(typography: (font-size: 11pt)))
#let row = [#rb[가나다][漢字] #rb(dy: -0.1em)[가나다][漢字] #rb(dy: 0.05em)[가나다][漢字] #rb(dy: -1pt)[가나다][漢字]]
본문 #row

#text(size: 8pt)[작은 글씨 #row]

#block[#set par(leading: 20pt)
  긴 행간 #row
]

각주#footnote[#row]

#rb[かんじ][漢字] #rb[신|체|발|부][身|體|髮|膚]
