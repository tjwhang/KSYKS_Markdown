// src/renderer.typ
// Character box rendering with OpenType vertical glyph features

#import "../kinsoku/kinsoku.typ": is-forbidden-end, is-forbidden-start

#import "../components/char-box.typ": char-box
#import "../utils/text.typ": extract-text

#let cjk-punctuation-token = regex(
  "^[。、，．！？；：（）〔〕〈〉《》【】「」『』﹁﹂﹃﹄︐︑︒︓︔︕︖︙︰︱︲︳︴︵︶﹇﹈︷︸︹︺︻︼︽︾︿﹀︗︘]+$",
)

#let token-font(token, config) = {
  if "text" not in token { return config.font }
  // CJK adapters may resolve a physical selector during preparation.  Basho
  // consumes that native value only; it never receives document composites or
  // face optics.  A resolved token also takes precedence over the broad
  // punctuation fallback below.
  if token.at("font", default: none) != none { return token.font }
  let punctuation-font = config.at("punctuation-font", default: none)
  let value = extract-text(token.text)
  if (
    punctuation-font != none
      and token.type in ("char", "hanging")
      and value.match(cjk-punctuation-token) != none
  ) {
    punctuation-font
  } else {
    config.font
  }
}

/// Renders a TCY (tate-chu-yoko / 縦中横) run: short horizontal text displayed
/// with normal horizontal glyphs, centered within a 1em × 1em slot in the
/// vertical column flow. No rotation, no vertical OpenType features.
/// Typically used for 2-digit numbers ("42") or short abbreviations ("IT").
/// Font size adapts to string length so text fits within the 1em column width.
///
/// - token (dictionary): A token with type "tcy" and text field.
/// - config (dictionary): The layout configuration.
/// -> content: Horizontal text in a 1em × 1em box.
#let render-tcy(token, config) = {
  let font = token-font(token, config)
  let f-opt = if font != none { (font: font) } else { (:) }
  let tcy-module = config.tcy.first()
  let sizes = tcy-module.sizes

  let txt = extract-text(token.text)
  let len = calc.max(1, txt.clusters().len())
  let sz = if len <= 2 { sizes.at(0) } else if len <= 3 { sizes.at(1) } else {
    calc.min(sizes.at(2) / 1em, 1.0 / len) * config.sizing.char-box
  }

  let inner = text(..f-opt, size: sz, token.text)

  box(
    width: config.sizing.char-box,
    height: config.sizing.char-box,
    align(center + horizon, inner),
  )
}

/// Renders hanging punctuation (kinsoku shori): the character is drawn
/// in a zero-height box so it visually overflows into the gutter below
/// the column without affecting the column height.
///
/// - token (dictionary): A token with type "hanging" and text field.
/// - config (dictionary): The layout configuration.
/// -> content: Zero-height box with the character.
#let render-hanging(token, config) = {
  let font = token-font(token, config)
  let f-opt = if font != none { (font: font) } else { (:) }
  box(
    width: config.sizing.char-box,
    height: 0pt,
    clip: false,
    align(center + top, text(
      ..f-opt,
      features: config.features,
      token.text,
    )),
  )
}

#import "ruby.typ": render-ruby

/// Renders a single token based on its type.
/// Dispatches "char" → char-box, "tcy" → render-tcy, "hanging" → render-hanging, "ruby" → render-ruby.
///
/// - token (dictionary): A token dictionary with at least a `type` and `text` field.
/// - config (dictionary): The layout configuration.
/// -> content: Rendered content for the token.
#let render-char-token(token, config) = {
  // Font-family selection is supplied by the surrounding template. Basho only
  // switches to that supplied family for a semantically strong source token.
  if token.at("font", default: none) == none and token.at("bold", default: false) and config.at("strong-font", default: none) != none {
    config.insert("font", config.at("strong-font"))
  }
  let font = token-font(token, config)
  let f-opt = if font != none { (font: font) } else { (:) }
  let heading-font = token.at("font", default: config.at("heading-font", default: none))
  let heading-f-opt = if heading-font != none {
    (font: heading-font)
  } else { f-opt }

  let rendered = none
  let node-renderers = config.at("node-renderers", default: (:))
  if token.type in node-renderers {
    rendered = (node-renderers.at(token.type))(token, config)
  }

  if rendered == none {
    let heading-level = token.at("heading", default: none)
    let scales = config.sizing.heading-scales
    let font-scale = if heading-level == 1 { scales.at(0) } else if (
      heading-level == 2
    ) { scales.at(1) } else if (
      heading-level == 3
    ) { scales.at(2) } else { 1.0 }

    // Determine kinsoku-aware alignment from config.kinsoku character sets
    let check-opening = token.at("opening-punctuation", default: none)
    let check-closing = token.at("closing-punctuation", default: none)
    if check-opening == none {
      check-opening = is-forbidden-end(token, config.kinsoku.forbidden-end)
    }
    if check-closing == none {
      check-closing = is-forbidden-start(token, config.kinsoku.forbidden-start)
    }

    rendered = if token.type == "char" {
      // Determine horizontal alignment based on bracket type
      let h-align = if check-opening { right } else if check-closing {
        left
      } else { center }
      // Determine vertical alignment based on bracket type to fix spacing when compressed
      let v-align = horizon

      let cb = config.at("char-box-abs", default: config.sizing.char-box)
      let base = token.at("base-width", default: 1.0)
      let applied = token.at("compression-applied", default: 0pt)
      let box-height = base * cb - applied

      if heading-level != none {
        // Heading characters: scaled box
        let sz = config.sizing.char-box * font-scale
        if token.text == " " {
          // A heading space is still an inter-word space. The former square
          // heading box silently promoted it to a full-width CJK cell.
          box(
            width: sz,
            height: token.at(
              "space-width",
              default: config.at("space-width", default: 0.25em),
            ) * font-scale,
          )
        } else {
          box(
            width: sz,
            height: sz,
            align(h-align + v-align, text(
              ..heading-f-opt,
              size: config.sizing.char-box * font-scale,
              features: config.features,
              weight: "bold",
              token.text,
            )),
          )
        }
      } else {
        char-box(
          token.text,
          font,
          config,
          h-align: h-align,
          v-align: v-align,
          height: box-height,
          space-width: token.at("space-width", default: none),
        )
      }
    } else if token.type == "tcy" {
      render-tcy(token, config)
    } else if token.type == "hanging" {
      render-hanging(token, config)
    } else if token.type == "ruby" {
      render-ruby(token, config)
    } else if token.type == "heading-anchor" {
      if config.at("heading-mode", default: "semantic") == "semantic" {
        // Anchors are emitted only by final column rendering. The metric
        // pipeline assigns them a zero analytic box and never instantiates
        // this heading while measuring or planning pages.
        text(lang: config.language, region: config.at("region", default: none), box(
          width: 0pt,
          height: 0pt,
          clip: true,
          heading(
            level: token.level,
            outlined: true,
            bookmarked: true,
            token.body,
          ),
        ))
      } else {
        box(width: 0pt, height: 0pt)
      }
    } else {
      none
    }
  }

  if rendered != none and token.type != "turn" {
    if token.at("bold", default: false) { rendered = strong(rendered) }
    if token.at("italic", default: false) { rendered = emph(rendered) }
    if "dest" in token { rendered = link(token.dest, rendered) }
  }

  let space-after = token.at("space-after", default: 0pt)
  if space-after != 0pt and rendered != none {
    rendered = stack(dir: ttb, spacing: 0pt, rendered, box(
      width: config.sizing.char-box,
      height: space-after,
    ))
  }

  rendered
}
