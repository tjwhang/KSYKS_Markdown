#import "../../cjk.typ": *
#import "../../engine-local.typ": engine-local
#let js-default-faces = (
  new-computer-modern: cjk-face("New Computer Modern", optics: (
    western: (baseline: 0em),
    punctuation: (baseline: 0em),
  )),
  new-computer-modern-math: cjk-face("New Computer Modern Math"),
  arial: cjk-face("Arial"),
  montserrat: cjk-face("Montserrat"),
  kopub-batang: cjk-face("KoPubWorldBatang_Pro", optics: (
    hangul: (baseline: -0.07em, tracking: -0.02em),
    punctuation: (baseline: -0.07em),
  )),
  kopub-dotum: cjk-face("KoPubWorldDotum_Pro", optics: (
    hangul: (baseline: -0.07em, tracking: -0.02em),
    punctuation: (baseline: -0.07em),
  )),
  pretendard: cjk-face("Pretendard"),
  source-han-serif-k: cjk-face(engine-local.serif-k-face),
  source-han-sans-k: cjk-face("Source Han Sans K"),
  source-han-serif-sc: cjk-face("Source Han Serif SC"),
  source-han-sans-sc: cjk-face("Source Han Sans SC"),
  source-han-serif-hc: cjk-face("Source Han Serif HC"),
  source-han-sans-hc: cjk-face("Source Han Sans HC"),
  hiragino-mincho: cjk-face("Hiragino Mincho ProN"),
  hiragino-gothic: cjk-face("Hiragino Kaku Gothic ProN"),
  m-plus-2: cjk-face("M PLUS 2"),
  chosunilbonm: cjk-face("ChosunilboNM"),
  heisei-mincho: cjk-face("Heisei Mincho Std"),
  stix-two-math: cjk-face("STIX Two Math"),
)

#let _js-east-asian-rules(ko, ja, sc, tc, covers) = (
  (face: ko, covers: covers, lang: "ko"),
  (face: ja, covers: covers, lang: "ja"),
  (face: tc, covers: covers, lang: "zh", region: ("TW", "HK", "MO")),
  (face: sc, covers: covers, lang: "zh", region: ("CN", "SG")),
  (face: sc, covers: covers, lang: ("zh", "sc")),
  (face: tc, covers: covers, lang: "tc"),
)

#let _js-punctuation-rules(western, punctuation) = (
  (face: western, covers: "punctuation", lang: "western"),
  .._js-east-asian-rules(punctuation.ko, punctuation.ja, punctuation.sc, punctuation.tc, "punctuation"),
)

#let _js-composite(western, numbers, hangul, kana, han-ko, han-ja, han-sc, han-tc, punctuation,
  hangul-fallback: js-default-faces.source-han-serif-k) = cjk-fontset(
  ..if western.name == "ChosunilboNM" { (
    (face: js-default-faces.new-computer-modern,
      covers: regex("^[ˈˌːˑ]$")),
  ) } else { () },
  .._js-punctuation-rules(western, punctuation),
  (face: western, covers: "western"),
  (face: numbers, covers: "number"),
  (face: hangul-fallback, covers: regex("[\u{1100}-\u{11ff}\u{a960}-\u{a97f}\u{d7b0}-\u{d7ff}]")),
  (face: hangul, covers: "hangul", fallbacks: (hangul-fallback.name,)),
  (face: kana, covers: "kana"),
  .._js-east-asian-rules(han-ko, han-ja, han-sc, han-tc, "han"),
  (face: han-ko, covers: "han"),
  (face: han-ko, covers: "any"),
)

#let js-default-fontsets = {
  let faces = js-default-faces
  let face = name => faces.at(name)
  let result = (
    common: cjk-fontset(
      (face: face("new-computer-modern-math"), covers: "number"),
      (face: face("stix-two-math"), covers: "symbol"),
      (face: face("new-computer-modern"), covers: "any"),
    ),
    serif: _js-composite(
      face("new-computer-modern"),
      face("new-computer-modern-math"),
      face("kopub-batang"),
      face("hiragino-mincho"),
      face("source-han-serif-k"),
      face("hiragino-mincho"),
      face("source-han-serif-sc"),
      face("source-han-serif-hc"),
      (
        ko: face("kopub-batang"),
        ja: face("hiragino-mincho"),
        sc: face("source-han-serif-sc"),
        tc: face("source-han-serif-hc"),
      ),
    ),
    serif-bold: _js-composite(
      face("new-computer-modern"),
      face("new-computer-modern-math"),
      face("kopub-batang"),
      face("hiragino-mincho"),
      face("source-han-serif-k"),
      face("hiragino-mincho"),
      face("source-han-serif-sc"),
      face("source-han-serif-hc"),
      (
        ko: face("kopub-batang"),
        ja: face("hiragino-mincho"),
        sc: face("source-han-serif-sc"),
        tc: face("source-han-serif-hc"),
      ),
    ),
    gothic: _js-composite(
      hangul-fallback: face("source-han-sans-k"),
      face("arial"),
      face("arial"),
      face("kopub-dotum"),
      face("hiragino-gothic"),
      face("hiragino-gothic"),
      face("hiragino-gothic"),
      face("source-han-sans-sc"),
      face("source-han-sans-hc"),
      (
        ko: face("kopub-dotum"),
        ja: face("hiragino-gothic"),
        sc: face("source-han-sans-sc"),
        tc: face("source-han-sans-hc"),
      ),
    ),
    gothic-bold: _js-composite(
      hangul-fallback: face("source-han-sans-k"),
      face("arial"),
      face("arial"),
      face("kopub-dotum"),
      face("hiragino-gothic"),
      face("hiragino-gothic"),
      face("hiragino-gothic"),
      face("source-han-sans-sc"),
      face("source-han-sans-hc"),
      (
        ko: face("kopub-dotum"),
        ja: face("hiragino-gothic"),
        sc: face("source-han-sans-sc"),
        tc: face("source-han-sans-hc"),
      ),
    ),
    maru: _js-composite(
      hangul-fallback: face("source-han-sans-k"),
      face("montserrat"),
      face("montserrat"),
      face("pretendard"),
      face("m-plus-2"),
      face("m-plus-2"),
      face("m-plus-2"),
      face("source-han-sans-sc"),
      face("source-han-sans-hc"),
      (ko: face("kopub-dotum"), ja: face("m-plus-2"), sc: face("source-han-sans-sc"), tc: face("source-han-sans-hc")),
    ),
    footnote: _js-composite(
      face("chosunilbonm"),
      face("chosunilbonm"),
      face("chosunilbonm"),
      face("heisei-mincho"),
      face("heisei-mincho"),
      face("heisei-mincho"),
      face("source-han-serif-sc"),
      face("source-han-serif-hc"),
      (
        ko: face("kopub-batang"),
        ja: face("heisei-mincho"),
        sc: face("source-han-serif-sc"),
        tc: face("source-han-serif-hc"),
      ),
    ),
  )
  result.insert("body", result.serif)
  result.insert("strong", result.gothic-bold)
  result.insert("heading", result.serif-bold)
  result.insert("ruby", result.serif)
  result.insert("title", result.serif-bold)
  result
}
