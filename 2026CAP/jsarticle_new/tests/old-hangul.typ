#import "../jsarticle.typ": *
#import "../vendor/basho-0.1.1/src/utils/text.typ": upright-features
#let features = if sys.inputs.at("reference", default: "no") == "yes" { () } else { ("vert", "vrt2") }
#assert(upright-features("「。ーあ가", ("vert", "vrt2")) == ("vert", "vrt2"))
#assert(upright-features("ᅇᅧ", ("vert", "vrt2", "kern")) == (vert: 0, vrt2: 0, kern: 1))
#assert(upright-features("\u{a960}\u{1161}\u{d7cb}", ("vert",)).vert == 0)
#show: jsarticle-book.with(options: jsarticle-options(
  document: (title-page: "none"), page: (h1-break: "continuous"), typography: (ambient-language: "ko"),
))
#set text(size: 22pt)
#let sample = "ᄒᆞᆯ ᄊᆡ ᄍᆞᆼ ᄒᆡᅇᅧ ᄫᅵ ᅙᅡᆫ ᄒᆞᇙ"
Native horizontal:
#text(font: "Source Han Serif K", features: (vert: 0, vrt2: 0), sample)

Vertical cells:
#jsvert(language: "ko", font: "Source Han Serif K", features: features, flow: "region", region-height: 90mm)[ᄒᆞᆯᄊᆡᄍᆞᆼᄒᆡᅇᅧᄫᅵᅙᅡᆫᄒᆞᇙ]

#pagebreak()
Inline:
#jsvert(language: "ko", font: "Source Han Serif K", features: features, flow: "inline")[ᅇᅧᄒᆞᇙ]

Heading and ruby:
#jsvert(language: "ko", font: "Source Han Serif K", strong-font: "Source Han Serif K", heading-font: "Source Han Serif K", ruby-font: "Source Han Serif K", features: features, flow: "region", region-height: 90mm)[
    = ᅇᅧᄒᆞᇙ
    *ᅇᅧ* #ruby[ᅇᅧ][ᄒᆞᇙ]
]

#pagebreak()
#jsvert(language: "ko", font: "Source Han Serif K", features: features, flow: "page", rows: 1)[
    ᅇᅧᄒᆞᇙᄊᆡᄍᆞᆼ
]
