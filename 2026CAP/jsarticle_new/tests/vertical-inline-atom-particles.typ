#import "../jsarticle.typ": jsarticle-book, jsarticle-options, jsvert

#show: jsarticle-book.with(
  options: jsarticle-options(
    document: (title: [Vertical inline-atom particles], title-page: "inline"),
    typography: (ambient-language: "ko"),
  ),
)

// The first line must end with 가; the rotated equation and 는 begin together
// on the next vertical line. The same policy covers raw and Latin atoms.
#jsvert(flow: "region", language: "ko", region-height: 2.5em, paragraph-indent: 0em)[가$a$는]
#jsvert(flow: "region", language: "ko", region-height: 2.5em, paragraph-indent: 0em)[가`raw`는]
#jsvert(flow: "region", language: "ko", region-height: 2.5em, paragraph-indent: 0em)[가Latin은]

// With ragged vertical lines the particle seam deliberately remains breakable.
#jsvert(flow: "region", language: "ko", justify: false, region-height: 2.5em, paragraph-indent: 0em)[가$a$는]

#text(lang: "ja")[
  // Japanese opts into the same constraint only when it also opts into
  // vertical justification.
  #jsvert(flow: "region", language: "ja", justify: true, region-height: 2.5em, paragraph-indent: 0em)[あ$a$から]
]
