// Stable token metrics for vertical layout.
//
// Ordinary vertical glyphs occupy known character cells. Measuring those
// glyphs is both unnecessary and dangerous: a surrounding contextual show
// rule can make the result depend on the page that is currently being built.
// Only opaque caller content is measured, exactly once during preparation.

#import "../renderer/renderer.typ": render-char-token
#import "../pipeline/token.typ": merge-token

// Host templates can install contextual `show text` composition rules.
// Metrics need a stable, font-directed measurement pass rather than a second
// host-language transform, so this local no-op rule forms a scope boundary
// for the two measurement-only nodes below.
#let measure-token-stably(body) = {
  show text: it => it
  body
}

#let heading-scale(token, config) = {
  let level = token.at("heading", default: none)
  let scales = config.sizing.heading-scales
  if level == 1 { scales.at(0) } else if level == 2 { scales.at(1) } else if (
    level == 3
  ) { scales.at(2) } else { 1.0 }
}

#let resolve-y(value) = if value == 0pt { 0pt } else { measure(v(value)).height }
#let resolve-x(value) = if value == 0pt { 0pt } else { measure(h(value)).width }

#let prepare-layout(tokens, config, usable-height: auto) = {
  let cfg = config
  // A continuation receives the prior prepared queue's configuration. Its
  // physical cell metrics are immutable for this surface, so measuring them
  // again per stream and per continuation page is duplicate work. Height-
  // sensitive opaque blocks below still receive the current usable height.
  let resolved = (
    "char-box-abs" in cfg
      and "ruby-size-abs" in cfg
      and "ruby-offset-abs" in cfg
      and "ruby-overhang-limit-abs" in cfg
      and "tracking-abs" in cfg
      and "paragraph-indent-abs" in cfg
      and "paragraph-spacing-abs" in cfg
  )
  if not resolved {
    let char-box = measure(box(
      width: cfg.sizing.char-box,
      height: cfg.sizing.char-box,
    )).height
    let ruby-size = measure(box(
      width: cfg.sizing.ruby-size,
      height: cfg.sizing.ruby-size,
    )).height
    cfg.insert("char-box-abs", char-box)
    cfg.insert("ruby-size-abs", ruby-size)
    cfg.insert("ruby-offset-abs", resolve-x(cfg.sizing.ruby-offset))
    cfg.insert("ruby-overhang-limit-abs", resolve-y(cfg.layout.at(
      "ruby-overhang", default: 0.5em,
    )))
    cfg.insert("tracking-abs", resolve-y(cfg.sizing.tracking))
    cfg.insert("paragraph-indent-abs", resolve-y(
      cfg.layout.at("paragraph-indent", default: 1em),
    ))
    cfg.insert("paragraph-spacing-abs", resolve-y(
      cfg.layout.at("paragraph-spacing", default: 0em),
    ))
  }
  if usable-height != auto { cfg.insert("usable-height", usable-height) }
  let char-box = cfg.at("char-box-abs")
  let ruby-size = cfg.at("ruby-size-abs")
  let ruby-offset = cfg.at("ruby-offset-abs")
  let ruby-overhang-limit = cfg.at("ruby-overhang-limit-abs")
  if cfg.at("tracking-abs") <= -char-box {
    panic("basho: sizing.tracking must leave a positive character advance")
  }

  let prepared = ()
  let scales = cfg.sizing.heading-scales
  let default-space-width = cfg.at("space-width", default: 0.25em)
  for (index, source) in tokens.enumerate() {
    let token = source
    let kind = token.type
    // Continuation queues slice columns from a prior `prepare-layout` result.
    // Analytic tokens already carry their exact resolved metrics; recomputing
    // their character boxes, spacing, and headings on every continuation page
    // is duplicate work. Opaque blocks remain geometry-sensitive below.
    if (
      "layout-height" in token
        and "layout-width" in token
        and kind not in ("vblock", "hblock")
    ) {
      prepared.push(token)
      continue
    }
    let after = token.at("space-after", default: 0pt)
    let after-abs = resolve-y(after)
    let level = token.at("heading", default: none)
    let scale = if level == 1 { scales.at(0) } else if level == 2 {
      scales.at(1)
    } else if level == 3 { scales.at(2) } else { 1.0 }
    let height = 0pt
    let width = char-box * scale
    let ruby-overhang = 0pt
    let ruby-layout-spans = ()

    if kind in ("newline", "parbreak", "heading-anchor") {
      height = 0pt
      width = 0pt
    } else if kind == "char" {
      if token.text == " " {
        height = resolve-y(token.at(
          "space-width",
          default: default-space-width,
        )) * scale
      } else {
        height = token.at("base-width", default: 1.0) * char-box * scale
      }
    } else if kind == "tcy" or kind == "bullet-list-marker" {
      height = char-box * scale
    } else if kind == "ruby" {
      let base-count = if type(token.text) == str {
        calc.max(1, token.text.clusters().len())
      } else { 1 }
      let ruby-count = if type(token.ruby) == str {
        token.ruby.clusters().len()
      } else if token.ruby == none { 0 } else { 1 }
      let base-height = base-count * char-box
      // A reading must retain its requested ruby size. Every segment gets a
      // physical span that both the renderer and paginator share. Segment
      // boundaries always reserve their own space: an internal overhang could
      // collide with the next annotated base.
      if "ruby-segments" in token {
        for pair in token.at("ruby-segments") {
          let pair-base = pair.base.clusters().len() * char-box
          let pair-reading = pair.ruby.clusters().len() * ruby-size
          let pair-span = calc.max(pair-base, pair-reading)
          ruby-layout-spans.push((
            base-height: pair-base,
            reading-height: pair-reading,
            span-height: pair-span,
          ))
          height += pair-span
        }
      } else {
        let reading-height = ruby-count * ruby-size
        let previous-is-ruby = index > 0 and tokens.at(index - 1).type == "ruby"
        let next-is-ruby = index + 1 < tokens.len() and tokens.at(index + 1).type == "ruby"
        // Centered paint overhang is safe only for an isolated, unsegmented
        // annotation. Otherwise reservation keeps neighbouring ruby clear.
        let allow-overhang = (
          cfg.layout.at("ruby-overflow", default: "reserve") == "overhang"
            and not previous-is-ruby
            and not next-is-ruby
        )
        let span-height = if allow-overhang {
          calc.max(base-height, reading-height - 2 * ruby-overhang-limit)
        } else { calc.max(base-height, reading-height) }
        ruby-layout-spans.push((
          base-height: base-height,
          reading-height: reading-height,
          span-height: span-height,
        ))
        height = span-height
      }
      if ruby-count > 0 {
        // Ruby belongs in the *gap between lines*, not in the line's own
        // width. Store only its extension; page/region placement expands the
        // immediately adjacent gap when the normal gap is not enough.
        ruby-overhang = calc.max(0pt, ruby-offset + ruby-size - char-box)
      }
    } else if kind == "spacing" {
      height = resolve-y(token.at("width", default: 0pt))
    } else if kind == "hanging" {
      height = 0pt
    } else if kind in ("vblock", "hblock") and usable-height != auto {
      // These are deliberately isolated by the paginator and fill one line.
      height = usable-height
      let measured = measure(measure-token-stably(text(
        lang: "und", features: (jsvm: 1), render-char-token(token, cfg),
      )))
      width = measured.width
    } else {
      // Equations, rotated arbitrary content, and extension nodes have no
      // analytic character-box metric. Measure the prepared node once.
      let measured = measure(measure-token-stably(text(
        lang: "und", features: (jsvm: 1), render-char-token(token, cfg),
      )))
      height = measured.height - after-abs
      width = measured.width
    }

    let metrics = (
      source-index: token.at("source-index", default: index),
      layout-height: calc.max(0pt, height),
      layout-width: calc.max(0pt, width),
      ruby-overhang: ruby-overhang,
      space-after: after-abs,
    )
    // Ruby is the only token kind that needs a prepared sub-span array.
    // Keeping ordinary analytic tokens lean matters on long vertical streams.
    if kind == "ruby" { metrics.insert("ruby-layout-spans", ruby-layout-spans) }
    prepared.push(merge-token(token, metrics))
  }
  (tokens: prepared, config: cfg)
}

#let column-width(tokens, config) = {
  if tokens.len() == 0 { return config.at("char-box-abs", default: 1em) }
  let result = config.at("char-box-abs", default: 1em)
  for token in tokens {
    result = calc.max(result, token.at("layout-width", default: result))
  }
  result
}
