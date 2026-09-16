#import "../src/cjk/fonts.typ": cjk-face, cjk-fontset, cjk-fontset-apply, cjk-fontset-runs, cjk-resolve-font

#let western = cjk-face("New Computer Modern", optics: (western: (scale: 1.0)))
#let korean = cjk-face("KoPubWorldBatang_Pro", optics: (
  hangul: (baseline: -0.07em, tracking: -0.1em),
  punctuation: (baseline: 0.08em),
))
#let japanese = cjk-face("Hiragino Mincho ProN")
#let composite = cjk-fontset(
  (face: japanese, covers: "punctuation", lang: "ja"),
  (face: western, covers: "western"),
  (face: korean, covers: "hangul"),
  (face: japanese, covers: "han", lang: "ja"),
  (face: korean, covers: "any"),
)

#let assert(value, message) = if not value { panic(message) }
#let ko = cjk-resolve-font(composite, "한", language: "ko")
#let ja-punct = cjk-resolve-font(composite, "「", language: "ja")
#let ja-han = cjk-resolve-font(composite, "漢", language: "ja")
#let latin = cjk-resolve-font(composite, "A", language: "ko")
#assert(ko.selector == "KoPubWorldBatang_Pro", "Hangul routing failed")
#assert(ko.baseline == -0.07em, "face Hangul baseline failed")
#assert(ja-punct.selector == "Hiragino Mincho ProN", "language punctuation routing failed")
#assert(ja-han.selector == "Hiragino Mincho ProN", "language Han routing failed")
#assert(latin.selector == "New Computer Modern", "Western routing failed")

#let only-hangul = cjk-fontset((face: korean, covers: "hangul"))
#let common = cjk-fontset((face: western, covers: "western"))
#let common-latin = cjk-resolve-font(only-hangul, "A", common: common)
#assert(common-latin != none and common-latin.source == "common", "common fallback routing failed")

#let explicit-zero = cjk-face("Arial", baseline: 0em, optics: (hangul: (baseline: auto)))
#let zero-fontset = cjk-fontset((face: explicit-zero, covers: "any"))
#let zero = cjk-resolve-font(
  zero-fontset,
  "한",
  global-optics: (ko: (hangul: (baseline: -0.07em))),
)
#assert(zero.baseline == 0em, "explicit face zero must stop fallback optics")
#let runs = cjk-fontset-runs(composite, "A한B", language: "ko")
#assert(
  runs.len() == 3 and runs.at(1).selector == "KoPubWorldBatang_Pro",
  "run assembly failed: " + repr(runs),
)

// Western spaces must resolve with Western text. Curly quotes deliberately
// retain their normal punctuation category and NCM punctuation rule.
#let quote-face = cjk-face("New Computer Modern", optics: (
  western: (baseline: 0em, tracking: 0em, scale: 1),
  punctuation: (baseline: 0em, tracking: 0em, scale: 1),
))
#let quote-fontset = cjk-fontset(
  (face: quote-face, covers: "punctuation", lang: "western"),
  (face: quote-face, covers: "western"),
  (face: quote-face, covers: "any"),
)
#let western-space = cjk-resolve-font(quote-fontset, " ", language: "en")
#let western-quote = cjk-resolve-font(quote-fontset, "‘", language: "en")
#assert(western-space.selector == "New Computer Modern" and western-space.category == "western", "Western spaces must not use a CJK fallback")
#assert(western-quote.selector == "New Computer Modern" and western-quote.category == "punctuation", "Western quotes must use the ordinary punctuation rule")

#cjk-fontset-apply(composite)[
  한국어 日本語 English 123「」
  #text(font: "Arial")[native Arial]
]

Composite routing checks passed.
