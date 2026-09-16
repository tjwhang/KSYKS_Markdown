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
#import "@preview/wrap-it:0.1.1": *
#import "@preview/itemize:0.2.0" as el
#import "@preview/in-dexter:0.7.2": *
#import "@preview/metalogo:1.2.0": LaTeX, TeX

#import "jsarticle.typ"

#show: show-theorion

#import cosmos.simple: *

#let notag(content) = {
    math.equation(
        block: true,
        numbering: none,
        content,
    )
}

#let cal(it) = math.class("normal", context {
    show math.equation: set text(font: "Garamond-Math", stylistic-set: 3)

    let scaling = 100% * (1em.to-absolute() / text.size)
    let wrapper = if scaling < 60% { math.sscript } else if scaling < 100% { math.script } else { it => it }

    box(text(top-edge: "bounds", bottom-edge: "bounds", $wrapper(math.cal(it))$))
})

#let scr(it) = math.class("normal", context {
    show math.equation: set text(font: "Garamond-Math", stylistic-set: 1)

    let scaling = 100% * (1em.to-absolute() / text.size)
    let wrapper = if scaling < 60% { math.sscript } else if scaling < 100% { math.script } else { it => it }

    box(text(top-edge: "bounds", bottom-edge: "bounds", $wrapper(math.cal(it))$))
})

#set math.equation(numbering: n => {
    numbering("(1.1)", counter(heading).get().first(), n)
    // if you want change the number of number of displayed
    // section numbers, modify it this way:
    /*
    let count = counter(heading).get()
    let h1 = count.first()
    let h2 = count.at(1, default: 0)
    numbering("(1.1.1)", h1, h2, n)
    */
})

#set figure(numbering: n => {
    numbering("1.1", counter(heading).get().first(), n)
    // if you want change the number of number of displayed
    // section numbers, modify it this way:
    /*
    let count = counter(heading).get()
    let h1 = count.first()
    let h2 = count.at(1, default: 0)
    numbering("(1.1.1)", h1, h2, n)
    */
})


#let ruby = get-ruby(
    size: 0.55em, // Ruby font size
    dy: -0.25em, // Vertical offset of the ruby
    pos: top, // Ruby position (top or bottom)
    alignment: "center", // Ruby alignment ("center", "start", "between", "around")
    delimiter: "|", // The delimiter between words
    auto-spacing: true, // Automatically add necessary space around words
)

#let traditional-numbering(format, ..args) = {
    let result = numbering(format, ..args)

    let n = args.pos().first()

    if format == "가" {
        // 유니코드 한글 조합 공식: 0xAC00 + (자음인덱스 * 21 * 28) + (모음인덱스 * 28)
        // 1. 순수 14자음 인덱스 (유니코드상 ㄱ, ㄴ, ㄷ, ㄹ, ㅁ, ㅂ, ㅅ, ㅇ, ㅈ, ㅊ, ㅋ, ㅌ, ㅍ, ㅎ의 위치)
        let c_map = (0, 2, 3, 5, 6, 7, 9, 11, 12, 14, 15, 16, 17, 18)
        // 2. 모음 순서 인덱스 (ㅏ, ㅓ, ㅗ, ㅜ, ㅡ, ㅣ)
        let v_map = (0, 4, 8, 13, 18, 20)

        let c_idx = calc.rem(n - 1, 14)
        let v_idx = calc.floor((n - 1) / 14)

        if v_idx < v_map.len() {
            let char_code = 0xAC00 + (c_map.at(c_idx) * 21 * 28) + (v_map.at(v_idx) * 28)
            result = str.from-unicode(char_code)
        } else {
            result = numbering(format, ..args)
        }
    } else {
        result = numbering(format, ..args)
    }

    result
        .replace("贰", "貳") // 2 (신자체는 弐, 번체는 貳)
        .replace("叁", "參") // 3 (신자체는 参, 번체는 參)
        .replace("陆", "陸") // 6
        //    .replace("万", "萬") // 10,000
        .replace("亿", "億") // 억
}

#let jspart = jsarticle.jspart
#let transnote = jsarticle.transnote
#let jsdinkus = jsarticle.jsdinkus
#let jsquote = jsarticle.jsquote
#let jsbox = jsarticle.jsbox
#let jstopic = jsarticle.jstopic
#let jsans = jsarticle.jsans
#let jicover = jsarticle.jsicover