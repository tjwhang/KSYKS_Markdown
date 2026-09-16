#import "@preview/physica:0.9.5": *
#import "@preview/alchemist:0.1.4": *
#import "@preview/theorion:0.3.3": *
#import "@preview/rich-counters:0.2.1": *
#import "@preview/cetz:0.3.4"
#import "@preview/cetz-plot:0.1.1"
#import "@preview/mannot:0.3.0": *
#import "@preview/tyipa:0.1.0" as ipa
#import "@preview/rubby:0.10.2": get-ruby

#show: show-theorion

#import cosmos.fancy: *

#let notag(content) = {
  math.equation(
    block: true,
    numbering: none,
    content,
  )
}

#let cal(it) = math.class("normal", context {
  show math.equation: set text(font: "Garamond-Math", stylistic-set: 8)

  let scaling = 100% * (1em.to-absolute() / text.size)
  let wrapper = if scaling < 60% { math.sscript }
                else if scaling < 100% { math.script }
                else { it => it }
  
  box(text(top-edge: "bounds", $wrapper(math.cal(it))$))
})

#let scr(it) = math.class("normal", context {
  show math.equation: set text(font: "Garamond-Math", stylistic-set: 1)

  let scaling = 100% * (1em.to-absolute() / text.size)
  let wrapper = if scaling < 60% { math.sscript }
                else if scaling < 100% { math.script }
                else { it => it }
  
  box(text(top-edge: "bounds", $wrapper(math.cal(it))$))
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
  size: 0.5em,         // Ruby font size
  dy: 0pt,             // Vertical offset of the ruby
  pos: top,            // Ruby position (top or bottom)
  alignment: "center", // Ruby alignment ("center", "start", "between", "around")
  delimiter: "|",      // The delimiter between words
  auto-spacing: true,  // Automatically add necessary space around words
)