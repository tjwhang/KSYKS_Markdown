#import "../cjk.typ": cjk-profile, cjk-vertical-region
#import "../vendor/basho-0.1.1/lib.typ": basho-config, tate-region

#set page(width: 100mm, height: 100mm, margin: 10mm)

#let profile = cjk-profile(
  locale: (language: "ja"),
  vertical: (layout: (gap: 0.4em, min-fragment-chars: 2)),
)

#cjk-vertical-region(40mm, profile: profile)[縦書きの検証です。]

#let config = basho-config((language: "ko", layout: (min-fragment-chars: 2)))
#tate-region(40mm, config: config)[세로쓰기 검증입니다.]
