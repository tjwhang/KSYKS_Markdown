// jsarticle's local Theorion/Antique adapter.
// Counters, identifiers, answer visibility, and frame construction stay in
// Theorion. This module owns only document typography and adaptive placement.

#import "@preview/theorion:0.5.0": *
#import cosmos.antique: *
#import "../../jsarticle.typ" as jsarticle

// The upstream Korean map lists Hanja first. With no explicit region, use
// Hangul; explicit ko-HJ and every other language/region retain their labels.
#let upstream-i18n-map = theorion-i18n-map
#let theorion-i18n-map = {
  let labels = upstream-i18n-map
  for (name, translations) in labels {
    let korean = translations.at("ko", default: none)
    if type(korean) == dictionary and "kr" in korean {
      let regions = (kr: korean.kr)
      for (region, value) in korean {
        if region != "kr" { regions.insert(region, value) }
      }
      translations.insert("ko", regions)
      labels.insert(name, translations)
    }
  }
  labels
}

#let _proof = proof
#let proof(title: theorion-i18n-map.at("proof"), qed: auto, body) = {
  _proof(title: title, qed: qed)[#jsarticle.jscjk-inline-boundaries(body)]
}

#let render-slash-box(
  color: c-maroon, prefix: none, title: "", full-title: none,
  breakable: false, ..args, body,
) = block(
  width: 100%, stroke: (top: 1.5pt + color, bottom: 0.5pt + c-line),
  inset: (top: 1em, bottom: 1.5em, x: 0.5em), breakable: breakable, spacing: 2.2em,
  [
    #block(sticky: true, width: 100%, below: 1.2em)[
      #jsarticle.jsfont("gothic-bold", fill: color, weight: "bold", size: 1.1em)[#prefix]
      #if title != "" [#h(0.6em)#text(fill: luma(180), weight: "light")[/]#h(0.6em)#jsarticle.jsfont("gothic", fill: c-dark, weight: "bold")[#jsarticle.jscjk-inline-boundaries([#title])]]
    ]
    #set par(first-line-indent: 0pt)
    #jsarticle.jscjk-inline-boundaries(body)
  ],
)

#let adaptive-slash-box(
  color: c-maroon, prefix: none, title: "", full-title: none,
  breakable: auto, floating: auto, float-placement: bottom, block-spacing: auto,
  float-clearance: auto, float-threshold: 18%, frame-outset: auto, ..args, body,
) = context {
  let available = jsarticle.js-body-height.get()
  let column-width = jsarticle.js-column-width.get()
  let template-outset = jsarticle.js-marginal-outset.get()
  let template-baseline = jsarticle.js-baseline.get()
  let resolved-outset = if frame-outset == auto {
    if template-outset == none { 1em.to-absolute() } else { template-outset }
  } else { frame-outset }
  let resolved-spacing = if block-spacing == auto {
    if template-baseline == none { 3.2em.to-absolute() } else { 2 * template-baseline }
  } else { block-spacing }
  let resolved-clearance = if float-clearance == auto { resolved-spacing } else { float-clearance }
  let slash-box(is-breakable) = move(
    dx: -resolved-outset,
    block(
      width: 100% + 2 * resolved-outset, spacing: resolved-spacing,
      render-slash-box(
        color: color, prefix: prefix, title: title, full-title: full-title,
        breakable: is-breakable, ..args, body,
      ),
    ),
  )
  let unbroken = slash-box(false)
  let measured = if column-width == none { measure(unbroken).height } else {
    measure(width: column-width, unbroken).height
  }
  let clearance-height = resolved-clearance.to-absolute()
  let too-tall = available != none and measured + clearance-height > available
  let resolved-breakable = if breakable == auto { too-tall } else { breakable }
  let resolved-floating = if floating == auto {
    available != none and measured >= float-threshold * available
  } else { floating }
  place.flush()
  if resolved-floating and not resolved-breakable {
    place(float-placement, scope: "column", float: true, clearance: resolved-clearance, align(start, unbroken))
  } else { slash-box(resolved-breakable) }
}

#let adaptive-slash-frame(identifier, frame-counter, color) = make-frame(
  identifier, theorion-i18n-map.at(identifier), counter: frame-counter,
  render: adaptive-slash-box.with(color: color),
)

#let (_, theorem-box, theorem, _) = adaptive-slash-frame("theorem", theorem-counter, c-maroon)
#let (_, lemma-box, lemma, _) = adaptive-slash-frame("lemma", lemma-counter, c-maroon)
#let (_, corollary-box, corollary, _) = adaptive-slash-frame("corollary", corollary-counter, c-maroon)
#let (_, definition-box, definition, _) = adaptive-slash-frame("definition", definition-counter, c-forest)
#let (_, axiom-box, axiom, _) = adaptive-slash-frame("axiom", axiom-counter, c-forest)
#let (_, postulate-box, postulate, _) = adaptive-slash-frame("postulate", postulate-counter, c-forest)
#let (_, proposition-box, proposition, _) = adaptive-slash-frame("proposition", proposition-counter, c-navy)
#let (_, property-box, property, _) = adaptive-slash-frame("property", property-counter, luma(100))
#let (_, assumption-box, assumption, _) = adaptive-slash-frame("assumption", assumption-counter, c-forest)

#let document-problem-render(prefix: none, title: "", difficulty: 0, full-title: auto, ..args, body) = {
  let color = if difficulty == 1 { c-navy } else if difficulty == 2 { c-forest } else if difficulty == 3 { c-maroon } else { c-dark }
  block(
    width: 110%, stroke: (right: 1pt + color), inset: (y: 1.4em, x: 1em),
    breakable: false, spacing: 1.2em,
    [
      #pad(right: 1em)[
        #set par(first-line-indent: 0pt)
        #jsarticle.jsfont("gothic-bold", fill: color, weight: "bold")[#prefix]
        #if title != "" [#h(0.5em)#text(fill: luma(150))[/]#h(0.5em)#jsarticle.jsfont("gothic", fill: luma(60))[#jsarticle.jscjk-inline-boundaries([#title])]]
        #v(0.6em)
        #place(left, dx: -1.4em, dy: 0.15em, rect(fill: color, width: 8pt, height: 8pt))
        #jsarticle.jscjk-inline-boundaries(body)
      ]
    ],
  )
}

#let (_, problem-box, problem, _) = make-frame(
  "problem", theorion-i18n-map.at("problem"), inherited-from: exercise-counter,
  render: document-problem-render,
)

#let document-render-badge(label-text: "", title-text: "", color: c-dark, body) = {
  let badge = align(left, box(
    stroke: 0.5pt + color, outset: (x: 0.4em, y: 0.2em), radius: 1pt, baseline: 0.3em,
    jsarticle.jsfont("gothic-bold", fill: color, weight: "bold", size: 0.85em)[#label-text],
  ))
  let content = block(width: 100%)[
    #set par(first-line-indent: 0pt)
    #if title-text != "" and title-text != none [#block(sticky: true, below: 1.618em)[#jsarticle.jsfont("gothic", fill: color.darken(20%), weight: "bold")[#jsarticle.jscjk-inline-boundaries([#title-text])]]]
    #jsarticle.jscjk-inline-boundaries(body)
  ]
  pad(y: 0.3em, grid(columns: (3em, 1fr), column-gutter: 0.618em, move(dy: 0em, badge), content))
}

#let tip-box(title: "", body) = document-render-badge(
  label-text: theorion-i18n(theorion-i18n-map.at("tip")), title-text: title, color: c-ochre, body,
)

#let solution(title: theorion-i18n-map.at("solution"), body) = context if get-result(here()) == "noanswer" {
  none
} else {
  document-render-badge(label-text: theorion-i18n(title), color: c-maroon, body)
}

// Keep the remaining Antique environments' renderers, counters and signatures.
// Prepare content before their private contextual renderers hide its edges.
#let adapt-environment(render) = (..args) => context {
  set text(region: if text.lang == "ko" and text.region not in ("kr", "hj") { "kr" } else { text.region })
  let prepare(value) = if type(value) == content { jsarticle.jscjk-inline-boundaries(value) } else { value }
  let named = args.named()
  for (key, value) in named { named.insert(key, prepare(value)) }
  render(..args.pos().map(prepare), ..named)
}

// Adapt renderers, not whole figures: labels must attach to the figure itself.
#let (_, exercise-box, exercise, _) = make-frame(
  "exercise", theorion-i18n-map.at("exercise"), counter: exercise-counter,
  render: adapt-environment(render-full-bar.with(main-color: c-maroon)),
)
#let (_, topic-box, topic, _) = make-frame(
  "topic", (en: "Topic", ja: "主題", ko: (kr: "주제", hj: "主題")), counter: topic-counter,
  render: adapt-environment(render-full-bar.with(main-color: c-dark)),
)
#let example = adapt-environment(example)
#let (_, remark-box, remark, _) = make-frame(
  "remark", theorion-i18n-map.at("remark"), counter: remark-counter,
  render: adapt-environment(render-remark-wrapper),
)
#let note-box = adapt-environment(note-box)
#let important-box = adapt-environment(important-box)
#let warning-box = adapt-environment(warning-box)
#let caution-box = adapt-environment(caution-box)
#let (_, conclusion-box, conclusion, _) = make-frame(
  "conclusion", theorion-i18n-map.at("conclusion"), counter: conclusion-counter,
  render: adapt-environment(render-conclusion-box),
)
