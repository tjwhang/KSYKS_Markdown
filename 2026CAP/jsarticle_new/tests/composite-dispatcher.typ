#import "../cjk.typ": cjk-face, cjk-fontset, cjk-font-role-features, cjk-fontset-native, cjk-language-layout

#let western = cjk-face("New Computer Modern")
#let hangul = cjk-face("KoPubWorldBatang_Pro", optics: (
  hangul: (baseline: -0.07em, tracking: -0.08em),
))
#let han = cjk-face("Hiragino Mincho ProN")
#let body = cjk-fontset(
  (face: western, covers: "western"),
  (face: western, covers: "number"),
  (face: hangul, covers: "hangul"),
  (face: han, covers: "han", lang: "ja"),
  (face: hangul, covers: "punctuation", lang: "ko"),
  (face: han, covers: "punctuation", lang: "ja"),
  (face: hangul, covers: "any"),
)

#set text(lang: "ko", size: 11pt)
#set text(
  font: cjk-fontset-native(body),
  features: cjk-font-role-features("body"),
)
#cjk-language-layout(
  [English 한국어 123],
  11pt,
  fontsets: (body: body),
  config: (
    boundary-spacing: none,
  ),
)

#text(lang: "ja")[
  #cjk-language-layout(
    [「日本語」English],
    11pt,
    fontsets: (body: body),
    config: (
      boundary-spacing: none,
    ),
  )
]
