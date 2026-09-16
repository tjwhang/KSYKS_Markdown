// Broad document compatibility facade. Feature-specific behavior belongs in
// its own adapter; this file intentionally remains an import-friendly surface.

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
#import "@preview/wrap-it:0.1.1": *
#import "@preview/itemize:0.2.0" as el
#import "@preview/in-dexter:0.7.2": *
#import "@preview/metalogo:1.2.0": LaTeX, TeX

#import "jsarticle.typ": *
#import "jsarticle.typ" as jsarticle
#import cosmos.antique: *
#import "src/integrations/theorion.typ": *
#show: show-theorion

#let notag(content) = math.equation(block: true, numbering: none, content)

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

#set math.equation(numbering: n => numbering("(1.1)", counter(heading).get().first(), n))
#set figure(numbering: n => numbering("1.1", counter(heading).get().first(), n))

#let jicover = jsarticle.jsicover
#let epigraph = jsarticle.jsepigraph
#let epipage = jsarticle.jsepigraph.with(align-x: center, scope: "page", style: "dash")
#let nnh1 = jsarticle.js-heading-unnumbered
#let nnoh1 = jsarticle.js-heading-unlisted
#let nneq = jsarticle.js-equation-unnumbered
#let tnumbering = jsarticle.jsnumbering
