#import "../jsarticle.typ": jsarticle-book, jsarticle-options, js-default-composites, js-font-family, jsface, jsfontset-extend
#import "../fonts.typ": document-composites
#import "../src/cjk/fonts.typ": cjk-fontset-native, cjk-fontset-runs, cjk-resolve-font

#let assert(value, message) = if not value { panic(message) }
#let composites = js-default-composites
#assert(cjk-resolve-font(composites.serif, "2").selector == "New Computer Modern Math", "default serif numerals must use New Computer Modern Math")
#assert(cjk-resolve-font(composites.at("serif-bold"), "2").selector == "New Computer Modern Math", "default serif-bold numerals must preserve the framework face")
#assert(cjk-resolve-font(composites.gothic, "2").selector == "Arial", "gothic numerals must use Arial")
#assert(cjk-resolve-font(composites.maru, "漢", language: "ja").selector == "M PLUS 2", "maru Han must use M PLUS 2")
#assert(cjk-resolve-font(composites.maru, "あ", language: "ja").selector == "M PLUS 2", "maru Kana must use M PLUS 2")
#assert(cjk-resolve-font(composites.strong, "漢", language: "ja").selector == "Hiragino Kaku Gothic ProN", "strong Han must use Gothic")
#assert(cjk-resolve-font(composites.strong, "あ", language: "ja").selector == "Hiragino Kaku Gothic ProN", "strong Kana must use Gothic")
#assert(cjk-resolve-font(composites.footnote, "한").selector == "ChosunilboNM", "footnote Hangul must use ChosunilboNM")
#assert(cjk-resolve-font(composites.footnote, "漢", language: "ja").selector == "Heisei Mincho Std", "footnote Han must use Heisei Mincho")
#assert(cjk-resolve-font(composites.serif, "汉", language: "zh", region: "CN").selector == "Source Han Serif SC", "Simplified Han must use its explicit face")
#assert(cjk-resolve-font(composites.serif, "汉", language: "zh", region: "SG").selector == "Source Han Serif SC", "Singapore Han must use its Simplified face")
#assert(cjk-resolve-font(composites.serif, "漢", language: "zh", region: "TW").selector == "Source Han Serif HC", "Traditional Han must use its explicit face")
#assert(cjk-resolve-font(composites.serif, "漢", language: "zh", region: "HK").selector == "Source Han Serif HC", "Hong Kong Han must use its Traditional face")
#assert(cjk-resolve-font(composites.serif, "“", language: "en", region: "US").selector == "New Computer Modern", "Western punctuation must use the Western face")
#assert(cjk-resolve-font(composites.serif, "“", language: "en", region: "US").category == "punctuation", "en-US quotes must retain the ordinary punctuation rule")
#assert(cjk-fontset-native(composites.serif, language: "en", region: "US").first() == "New Computer Modern", "the English native signature must lead with NCM")
#assert(cjk-fontset-native(composites.serif, language: "ja", region: "JP").first() == "Hiragino Mincho ProN", "the Japanese native signature must lead with Hiragino")
#assert(cjk-fontset-native(composites.serif, language: "ko", region: "KR").first() == "KoPubWorldBatang_Pro", "the Korean native signature must lead with the Korean punctuation face")
#assert(cjk-fontset-native(composites.serif, language: "zh", region: "TW").first() == "Source Han Serif HC", "the Traditional-Chinese native signature must lead with its regional punctuation face")
#let western-quote-runs = cjk-fontset-runs(
  document-composites.serif,
  "Typography becomes ‘convincing’ when",
  language: "en",
  region: "US",
)
#assert(western-quote-runs.all(run => run.selector == "New Computer Modern"), "en-US spaces and quotes must remain in NCM rather than a CJK fallback")
#assert(cjk-resolve-font(composites.serif, "“", language: "ja", region: "JP").selector == "Hiragino Mincho ProN", "Japanese punctuation must not be captured by the Western rule")
#assert(cjk-resolve-font(composites.serif, "“", language: "zh", region: "TW").selector == "Source Han Serif HC", "Traditional punctuation must respect Chinese region")
#let diagnostic-optics = (ko: (
  hangul: (baseline: -0.07em),
  punctuation: (baseline: -0.07em),
))
#assert(cjk-resolve-font(document-composites.serif, "한", global-optics: diagnostic-optics).selector == "AppleMyungjo", "document serif must select its AppleMyungjo override")
#assert(cjk-resolve-font(document-composites.serif, "한", global-optics: diagnostic-optics).baseline == 0em, "AppleMyungjo must opt out of generic Hangul baseline shifts")
#assert(cjk-resolve-font(document-composites.serif, "한").fallbacks.contains("KoPubWorldBatang_Pro"), "a document face must retain the framework role as native fallback")
#assert(cjk-resolve-font(document-composites.at("serif-bold"), "2").selector == "Minion Pro", "document serif-bold must select Minion Pro")
#assert(cjk-resolve-font(composites.serif, "“", language: "en", global-optics: diagnostic-optics).baseline == 0em, "Western punctuation must opt out of generic Korean punctuation shifts")
#let custom-hangul = jsface("Bookk Myungjo")
#let extended-serif = jsfontset-extend(composites.serif, (face: custom-hangul, covers: "hangul"))
#assert(cjk-resolve-font(extended-serif, "한").selector == "Bookk Myungjo", "a document override must precede the default role rules")
#assert(cjk-resolve-font(extended-serif, "“", language: "ja").selector == "Hiragino Mincho ProN", "a focused override must retain the default locale rules")

#show: jsarticle-book.with(options: jsarticle-options(
  fonts: (
    composites: document-composites,
    body-family: "serif",
    strong-family: "gothic-bold",
    heading-family: "serif-bold",
  ),
))

#context {
  assert(js-font-family("body").first() == "AppleMyungjo", "body-family: serif must activate the document serif composite")
  assert(js-font-family("strong").first() == "IBM Plex Sans", "strong-family must activate the document gothic-bold composite")
  assert(js-font-family("heading").first() == "Minion Pro", "heading-family must activate the document serif-bold composite")
}

English 한국어 日本語 漢文 123 「括弧」.

#text(lang: "en", region: "US")[Western “quotes”, (parentheses), and commas.] \
#text(lang: "en", region: "US")['Single quotes' and "double quotes" remain language-aware smartquote elements.] \
#text(lang: "ja", region: "JP")[日本語の“引用”と「括弧」。] \
#text(lang: "zh", region: "CN")[简体汉字“标点”。] \
#text(lang: "zh", region: "TW")[繁體漢字「標點」。]

*강조 Strong 日本語*
