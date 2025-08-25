#import "@preview/physica:0.9.5": *
#import "@preview/alchemist:0.1.4": *
#import "@preview/theorion:0.3.3": *
#import "@preview/rich-counters:0.2.1": *
#import "@preview/cetz:0.3.4"
#import "@preview/cetz-plot:0.1.1"
#show: show-theorion

#import cosmos.rainbow: *

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

