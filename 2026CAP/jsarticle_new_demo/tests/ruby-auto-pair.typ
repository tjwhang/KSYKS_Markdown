#import "../jsarticle.typ": *
#import "../vendor/basho-0.1.1/src/utils/ruby-pair.typ": ruby-auto-pair
#import "../vendor/basho-0.1.1/src/pipeline/flatten.typ": flatten
#import "../vendor/basho-0.1.1/src/config.typ": default-opts
#import "../vendor/basho-0.1.1/src/utils/ruby-space.typ": ruby-text-height
#assert(ruby-text-height("身 體", 10pt, 5pt) == 25pt)
#assert(ruby-text-height("身　體", 10pt, 5pt) == 30pt)
#assert(ruby-text-height("신 체", 5pt, 2.5pt) == 12.5pt)
#let example = ruby-auto-pair([신체발부 수지부모], [身體髮膚 受之父母])
#assert(example.reading == "신|체|발|부||수|지|부|모")
#assert(example.base == "身|體|髮|膚| |受|之|父|母")
#assert(ruby-auto-pair("신체", "身體").reading == "신|체")
#assert(ruby-auto-pair("ㄅㄆ", "甲乙").reading == "ㄅ|ㄆ")
#assert(ruby-auto-pair("ㄅㄚˊ", "甲乙丙").reading == "ㄅㄚˊ")
#assert(ruby-auto-pair("しんたい", "身體").reading == "しんたい")
#assert(ruby-auto-pair("신체", "身體", enabled: false).reading == "신체")
#assert(ruby-auto-pair("い||かえ|", "行|き|帰|り").reading == "い||かえ|")
#assert(ruby-auto-pair("신 체", "身體").reading == "신 체")
#assert(ruby-auto-pair([*신체*], [身體]).reading == [*신체*])
#assert(ruby-auto-pair("", "").reading == "")
#let token = flatten(ruby[신체발부 수지부모][身體髮膚 受之父母], default-opts).first()
#assert(token.at("ruby-segments").len() == 9)
#assert(token.text == "身體髮膚 受之父母")
#let off = default-opts + (ruby-auto-pair: false)
#assert("ruby-segments" not in flatten(ruby[신체][身體], off).first())
#assert("ruby-segments" in flatten(ruby(auto-pair: true)[신체][身體], off).first())
#assert("ruby-segments" not in flatten(ruby(auto-pair: false)[신체][身體], default-opts).first())
#let enabled = sys.inputs.at("pair", default: "true") == "true"
#show: jsarticle-book.with(options: jsarticle-options(
  document: (title-page: "none"),
  page: (h1-break: "continuous"),
  typography: (ambient-language: "ko", font-size: 18pt, ruby-auto-pair: enabled),
))
Default:
#ruby[신체발부 수지부모][身體髮膚 受之父母]

Explicit reference:
#ruby[신|체|발|부||수|지|부|모][身|體|髮|膚| |受|之|父|母]

Grouped:
#ruby(auto-pair: false)[신체발부 수지부모][身體髮膚 受之父母]

Forced pairing:
#ruby(auto-pair: true)[신체발부 수지부모][身體髮膚 受之父母]

#jsvert(flow: "region", region-height: 75mm)[
  #ruby[신체발부 수지부모][身體髮膚 受之父母]
  #ruby[신|체|발|부||수|지|부|모][身|體|髮|膚| |受|之|父|母]
  #ruby(auto-pair: false)[신체발부 수지부모][身體髮膚 受之父母]
]

#jsvert(flow: "inline")[#ruby[신체][身體]]
#jsvert(flow: "page")[#ruby[신체발부 수지부모][身體髮膚 受之父母]]
