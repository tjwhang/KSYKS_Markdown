// src/ruby.typ
// Ruby (furigana) rendering

#import "../components/char-box.typ": char-box

/// Renders a character with ruby (furigana) on the right side.
/// The base box stays one character wide. Ruby's vertical span is prepared
/// before pagination, so long readings retain their font size without
/// changing cursors or being squeezed after a page break.
///
/// - token (dictionary): Token with type "ruby", `text` (base), and `ruby` (reading).
/// - config (dictionary): The layout configuration.
/// -> content: Rendered ruby box.
#let render-ruby(token, config) = {
  let base-font = token.at("font", default: config.font)
  let reading-font = token.at("ruby-font", default: base-font)
  let base-is-str = type(token.text) == str
  let base-chars = if base-is-str { token.text.clusters() } else {
    (token.text,)
  }
  let ruby-is-str = type(token.ruby) == str
  if (ruby-is-str and token.ruby == "") or token.ruby == none {
    return stack(
      dir: ttb,
      spacing: 0pt,
      ..base-chars.map(ch => char-box(ch, base-font, config)),
    )
  }

  let ruby-stack-for(chars, reading-height) = {
    if chars.len() == 0 { return box(width: 0pt, height: reading-height) }
    let glyphs = stack(
      dir: ttb,
      spacing: 0pt,
      ..chars.map(ch => {
      let ruby-char = if type(ch) == str {
        text(
          size: config.sizing.ruby-size,
          ..(if reading-font != none { (font: reading-font) } else { (:) }),
          features: config.features,
          ch,
        )
      } else { ch }
      box(
        width: config.sizing.ruby-size,
        height: config.sizing.ruby-size,
        align(center + horizon, ruby-char),
      )
      }),
    )
    box(
      width: config.sizing.ruby-size,
      height: reading-height,
      align(center + horizon, glyphs),
    )
  }

  let render-pair(base, reading, span) = {
    let base-chars = if type(base) == str { base.clusters() } else { (base,) }
    let ruby-chars = if type(reading) == str { reading.clusters() } else { (reading,) }
    let base-height = span.at("base-height")
    let reading-height = span.at("reading-height")
    let span-height = span.at("span-height")
    let base-stack = stack(
      dir: ttb,
      spacing: 0pt,
      ..base-chars.map(ch => char-box(ch, base-font, config)),
    )
    let ruby-stack = ruby-stack-for(ruby-chars, reading-height)
    box(
      width: config.sizing.char-box,
      height: span-height,
      clip: false,
      {
        place(left + top, dy: (span-height - base-height) / 2, base-stack)
        place(
          left + top,
          dx: config.sizing.ruby-offset,
          dy: (span-height - reading-height) / 2,
          ruby-stack,
        )
      },
    )
  }

  let spans = token.at("ruby-layout-spans", default: ())
  if "ruby-segments" in token {
    return stack(
      dir: ttb,
      spacing: 0pt,
      ..token.at("ruby-segments").enumerate().map(((index, pair)) =>
        render-pair(
          pair.base,
          pair.ruby,
          spans.at(index, default: (
            base-height: pair.base.clusters().len() * config.sizing.char-box,
            reading-height: pair.ruby.clusters().len() * config.sizing.ruby-size,
            span-height: pair.base.clusters().len() * config.sizing.char-box,
          )),
        ),
      ),
    )
  }

  let ruby-chars = if ruby-is-str { token.ruby.clusters() } else { (token.ruby,) }
  let span = spans.at(0, default: (
    base-height: base-chars.len() * config.sizing.char-box,
    reading-height: ruby-chars.len() * config.sizing.ruby-size,
    span-height: base-chars.len() * config.sizing.char-box,
  ))
  render-pair(token.text, token.ruby, span)
}
