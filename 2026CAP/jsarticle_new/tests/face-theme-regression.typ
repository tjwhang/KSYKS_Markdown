#import "../jsarticle.typ": jsarticle-book, jsarticle-options, jsface, jsfont, jsfontset-extend, js-default-composites
#import "../cjk.typ": cjk-resolve-font

#let hangul = jsface("KoPubWorldBatang_Pro", baseline: 0em)
#let punct = jsface("KoPubWorldBatang_Pro", baseline: -1em)
#let serif = jsfontset-extend(js-default-composites.serif,
  (face: punct, covers: regex("[「」]")),
  (face: hangul, covers: "hangul"),
)
#assert(cjk-resolve-font(serif, "한").baseline == 0em)
#assert(cjk-resolve-font(serif, "「").baseline == -1em)

#show: jsarticle-book.with(options: jsarticle-options(
  fonts: (composites: (serif: serif)),
))

= 「한글」 face and theme regression

This fixture uses the current composite API. Coverage belongs to a rule;
baseline adjustment belongs to a face. The retired theme option is not restored.

#jsfont("serif", size: 1.05em)[A role-marked 「한글」 run retains face matching.]
