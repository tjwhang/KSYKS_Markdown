#import "../jsarticle.typ": jsarticle-book, jsarticle-options, jsface, jsfont, jsfontset

#let test-western = jsface("Arial")
#let test-hangul = jsface("KoPubWorldBatang_Pro", optics: (hangul: (baseline: -0.07em)))
#let test-font = jsfontset(
  (face: test-western, covers: "western"),
  (face: test-hangul, covers: "hangul"),
  (face: test-western, covers: "any"),
)

#show: jsarticle-book.with(options: jsarticle-options(
  fonts: (composites: (body: test-font, gothic-bold: test-font)),
))

#jsfont(test-font, size: 1.05em)[English 한국어]
#jsfont("gothic-bold")[Role-selected 한국어 text]

The body composite is routed by the regular CJK dispatcher: English 한국어.
