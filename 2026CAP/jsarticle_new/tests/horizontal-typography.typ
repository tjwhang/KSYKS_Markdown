#import "../jsarticle.typ": *
#import "../cjk.typ": cjk-resolve-font
#assert.eq(cjk-resolve-font(js-default-composites.footnote, "ɪ̯").category, "western")
#assert.eq(cjk-resolve-font(js-default-composites.footnote, "ˈ").category, "western")
#assert.eq(cjk-resolve-font(js-default-composites.footnote, "ɡ").selector, "ChosunilboNM")
#assert.eq(cjk-resolve-font(js-default-composites.footnote, "ˈ").selector, "New Computer Modern")
#assert.eq(cjk-resolve-font(js-default-composites.footnote, "ɪ̯").selector, "ChosunilboNM")
#let custom-footnote = jsfontset-override(js-default-composites.footnote, western: jsface("Minion Pro"))
#assert.eq(cjk-resolve-font(custom-footnote, "ˈ").selector, "Minion Pro")
#assert.eq(cjk-resolve-font(custom-footnote, "ɪ̯").selector, "Minion Pro")
#let gap = if sys.inputs.at("gap", default: "normal") == "zero" { 0em } else { 0.2em }
#show: jsarticle-book.with(options: jsarticle-options(
  typography: (font-size: 11pt, cjk-spacing: gap),
  page: (h1-break: "continuous"),
))
#set par(first-line-indent: 0pt, justify: false)
#let ipa = "[ˈvaɪ̯nˌɡaʁ.tən]"
#jsfont("footnote")[#ipa]

#jsfont("footnote", weight: "bold")[#ipa]

#jsipa[ˈvaɪ̯nˌɡaʁ.tən]

#for pair in ("()", "[]", "{}", "<>", "｢｣", "「」", "『』", "〈〉", "《》", "（）") {
  [#text("가" + pair.clusters().at(0) + "나" + pair.clusters().at(1) + "다")#parbreak()]
}

#text(font: "KoPubWorldBatang_Pro")[가「나」다 가『나』다]

#text(font: "Heisei Mincho Std")[가「나」다 가『나』다]

#text(font: "KoPubWorldBatang_Pro")[가〈나〉다 가《나》다]

#text(font: "Heisei Mincho Std")[가〈나〉다 가《나》다]


#pagebreak()
#for size in (8pt, 12pt, 16pt) {
  jsfont("body", size: size)[
    #block(width: 40mm)[가나다라 ABC#linebreak()가나다라 ABC]
  ]
}
#for width in (10mm, 11mm, 12mm, 13mm, 14mm) {
  block(width: width)[가나다#footnote[#ipa] 라마]
}
