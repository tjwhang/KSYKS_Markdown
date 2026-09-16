#import "@preview/springer-spaniel:0.1.0"
#import "@preview/physica:0.9.5": *
#import "@preview/alchemist:0.1.4": *
#import "@preview/theorion:0.3.3": *
#import "@preview/rich-counters:0.2.1": *
#import "@preview/cetz:0.3.4"
#import "@preview/cetz-plot:0.1.1"
#import "@preview/mannot:0.3.0": *
#import "@preview/tyipa:0.1.0" as ipa
#import "@preview/rubby:0.10.2": get-ruby

#import "template.typ": *

#set text(
    font: (
        // "Source Han Serif K", // 가장 우선순위 폰트
        (
            name: "STIX Two Text", // 라틴 폰트
            covers: "latin-in-cjk",
        ),
        (
            name: "LXGW WenKai",
            covers: regex("[\p{scx:Han}\p{scx:Hira}\p{scx:Kana}]"),
        ), // 한자, 히라가나, 가타카나
        //"STIX Two Text",
        "Source Han Serif K", // CJK Fallback 폰트
    ),
    cjk-latin-spacing: none,
    weight: "regular"
)

#show math.equation: set text(
    font: (
        (
            name: "stix two math",
            covers: "latin-in-cjk",
        ),
        "KoPubBatang_Pro",
    ),
    cjk-latin-spacing: none,
    // stylistic-set: (2, 4, 6, 7, 10, 11),
    // ^ Garamond 사용시, hslash -> hbar는 6

    stylistic-set: (2, 4),
    // ^ STIX Two 사용시, hslash -> hbar는 3
    weight: "regular",
)

#show: springer-spaniel.template(
  title: [어린이 대공원 놀이기구: 자이로드롭],
  authors: (
    (
      name: "황태준",
      institute: "중앙고등학교",
      address: "20731",
      email: none
    ),
    // ... and so on
  ),
  affiliation: [중앙고등학교],
  abstract: [자이로드롭의 원리와 그것을 기술하는 식들을 통해 어린이대공원 자이로드롭의 물리량들을 근사치로 계산해본다.],

  // debug: true, // Highlights structural elements and links
  // frame: 1pt, // A border around the page for white on white display
  // printer-test: true, // Suitably placed CMYK printer tests
)

#show: show-theorion
#set math.mat(delim: "[")
#set math.vec(delim: "[")

#set quote(block: true)

// show inline math as display
#show math.equation.where(block: false): it => math.display(it)

#set par(
    justify: false,
    leading: 1.2em,
    spacing: 1.8em,
)


#show heading.where(level: 1): it => {
    counter(math.equation).update(0)
    it
}

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


#include "chapters/chapter1.typ"