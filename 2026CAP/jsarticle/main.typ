#import "@preview/physica:0.9.5": *
#import "@preview/alchemist:0.1.4": *
#import "@preview/theorion:0.5.0": *
#import "@preview/rich-counters:0.2.1": *
#import "@preview/cetz:0.3.4"
#import "@preview/cetz-plot:0.1.1"
#import "@preview/mannot:0.3.0": *
#import "@preview/codly:1.3.0": *
#import "@preview/codly-languages:0.1.1": *
#import "@preview/tyipa:0.1.0" as ipa
#import "@preview/rubby:0.10.2": get-ruby
#import "@preview/linguify:0.5.0": *
#import "@preview/parize:0.1.0": *
#import "@preview/wrap-it:0.1.1": *
#import "@preview/itemize:0.2.0" as el
#import "@preview/in-dexter:0.7.2": *
#import "@preview/metalogo:1.2.0": LaTeX, TeX


#show: show-theorion
#import cosmos.antique: *
#show: el.default-enum-list.with(
  auto-base-level: true,
)
// #show: par-indent.with(
//     exclude-elem: (
//         /*excludes specific block-level elements*/
//     ),
// )

#set text(lang: "ko", region: "kr")

#import "preamble.typ": *
#import "jsarticle.typ": *

#let title = [数学]

#show: jsarticle-book.with(
  title: title,
  subtitle: "物理を学び楽しむために",
  date: "暫定版（2026年 4月）",
  author: "田崎 晴明",
  other: [
    非公式 韓國語 飜譯本
  ],
  paper-size: "a4",
  // bind: "center",
  // type: "novel"
)

#pagebreak(to: "odd")

#jicover(title, subtitle: [물리를 배우고 즐기기 위하여], author: [타사키 하루아키])
// 목차 앞부분은 로마자 페이지 번호 (vii 등)
#set page(numbering: "i")

#include "sections/0_preface.typ"

#outline(
  title: "目次",
  // indent: n => n * n * 1em,
  depth: 3,
)

#pagebreak()



// ====================
// 본문 시작 (아라비아 숫자로 변경)
// ====================
#set page(numbering: "1")
#counter(page).update(1)



// #include "sections/test2.typ"
#include "sections/1_hajimeni.typ"
#include "sections/2_ronri.typ"

#jsdinkus()

#bibliography("bib.yaml", title: "參考文献")

#pagebreak()
#set page(paper: "jis-b5", flipped: true, margin: auto)
#tate[
  弟の直治でさえ、ママにはかなわねえ、と言っているが、つくづく私も、お母さまの真似は困難で、絶望みたいなものをさえ感じる事がある。いつか、西片町のおうちの奥庭で、秋のはじめの月のいい夜であったが、私はお母さまと二人でお池の端のあずまやで、お月見をして、狐の嫁入りと鼠の嫁入りとは、お嫁のお支度がどうちがうか、など笑いながら話合っているうちに、お母さまは、つとお立ちになって、あずまやの傍の萩のしげみの奥へおはいりになり、それから、萩の白い花のあいだから、もっとあざやかに白いお顔をお出しになって、少し笑って、

  「かず子や、お母さまがいま何をなさっているか、あててごらん」

  とおっしゃった。

  「お花を折っていらっしゃる」

  と申し上げたら、小さい声を挙げてお笑いになり、

  「おしっこよ」

  とおっしゃった。

  ちっともしゃがんでいらっしゃらないのには驚いたが、けれども、私などにはとても真似られない、しんから可愛らしい感じがあった。

  복녀는 돈 이십 원이라는 말에 커다란 충동을 받았다。그 전날까지만 하여도、복녀의 머릿속에는 『도덕』이니 『정직』이니 하는 관념이 있었다。그러나、돈 이십 원이라는 말은 그 모든 관념을 여지없이 무참하게 박살하여 버렸다。


]