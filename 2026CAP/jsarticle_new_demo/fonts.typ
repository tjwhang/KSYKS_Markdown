#import "jsarticle.typ": jsface, jsfontset-override, js-default-composites

#let minion-pro = jsface("Minion Pro")
#let inter = jsface("Inter")
#let ibm-plex-sans = jsface("IBM Plex Sans")
#let song-myung = jsface("Song Myung")

#let bookk-myungjo = jsface("Bookk Myungjo", optics: (
  hangul: (baseline: -0.07em, tracking: -0em),
  punctuation: (baseline: -0.08em),
))
#let apple-myungjo = jsface("AppleMyungjo", optics: (
  hangul: (baseline: 0em, tracking: -0.09em),
))
#let sm-kmyungjo = jsface("munhwa myungjo std", optics: (
  hangul: (baseline: -0.07em, tracking: -0.05em),
))
#let bookk-gothic = jsface("Bookk Gothic", optics: (
  hangul: (baseline: -0.07em),
  punctuation: (baseline: -0.07em),
))
#let sm-kgothic = jsface("Bookk Gothic", optics: (
  hangul: (baseline: -0.07em, tracking: -0.05em),
))

#let document-composites = (
  serif: jsfontset-override(
    js-default-composites.serif,
    hangul: apple-myungjo,
    punct-ko: bookk-myungjo,
  ),
  serif-bold: jsfontset-override(
    js-default-composites.at("serif-bold"),
    western: minion-pro,
    number: minion-pro,
    hangul: sm-kmyungjo,
    punct-ko: bookk-myungjo,
  ),
  gothic: jsfontset-override(
    js-default-composites.gothic,
    western: inter,
    hangul: bookk-gothic,
    punct-ko: bookk-gothic,
  ),
  gothic-bold: jsfontset-override(
    js-default-composites.at("gothic-bold"),
    western: ibm-plex-sans,
    hangul: sm-kgothic,
    punct-ko: bookk-gothic,
  ),
  maru: jsfontset-override(
    js-default-composites.maru,
    punct-ko: bookk-gothic,
  ),
  footnote: jsfontset-override(
    js-default-composites.footnote,
    punct-ko: bookk-myungjo,
  ),
  title: jsfontset-override(
    js-default-composites.title,
    western: minion-pro,
    number: minion-pro,
    hangul: song-myung,
    punct-ko: bookk-myungjo,
  ),
)
