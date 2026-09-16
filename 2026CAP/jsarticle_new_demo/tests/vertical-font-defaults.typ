#import "../jsarticle.typ": *
#import "../src/cjk/fonts.typ": cjk-resolve-font
#import "../src/jsarticle/state.typ": js-vertical-config
#import "../vendor/basho-0.1.1/src/kinsoku/spacing.typ": is-cjk
#assert(is-cjk((type: "char", text: "ᅇᅧ")))
#assert(cjk-resolve-font(js-default-composites.serif, "가").selector == "KoPubWorldBatang_Pro")
#assert(cjk-resolve-font(js-default-composites.gothic, "가").selector == "KoPubWorldDotum_Pro")
#assert(cjk-resolve-font(js-default-composites.serif, "ᅇᅧ").selector == "Source Han Serif K")
#assert(cjk-resolve-font(js-default-composites.gothic, "ᅇᅧ").selector == "Source Han Sans K")
#show: jsarticle-book.with(options: jsarticle-options(
  document: (title-page: "none"), page: (h1-break: "continuous"),
  typography: (ambient-language: "ko", font-size: 18pt),
))
#context {
  assert(js-vertical-config.get().at("boundary-spacing") == 0.2em)
  assert(js-vertical-config.get().at("punctuation-font") == "Hiragino Mincho ProN")
}
Horizontal control: 「가나다。」

Serif region:
#jsvert(flow: "region", region-height: 65mm)[「가ᅇᅧAᄒᆞᇙ나다。」]
Sans inline:
#jsvert(flow: "inline", font-family: "gothic")[「가ᅇᅧAᄒᆞᇙ나다。」]

Heading and ruby:
#jsvert(flow: "region", region-height: 65mm)[
  == 「가ᅇᅧ」
  *「가ᅇᅧ」* #ruby[ᅇᅧ][「가」]
]
#pagebreak()
#jsvert(flow: "page", font-family: "gothic")[「가ᅇᅧAᄒᆞᇙ나다。」]
#pagebreak()
Explicit punctuation override:
#jsvert(flow: "region", punctuation-font: "Source Han Serif K", region-height: 65mm)[「가ᅇᅧ。」]
