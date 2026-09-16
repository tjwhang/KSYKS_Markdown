// src/layout/page.typ
// Rendering columns and pages

#import "../renderer/renderer.typ": render-char-token

// Ruby draws to the right of a vertical line. Its extension is intentionally
// not part of the line width: only the following (left-hand, RTL) line gap is
// widened when the ordinary gap cannot contain it.
#let column-ruby-overhang(tokens) = {
  let result = 0pt
  for token in tokens {
    result = calc.max(result, token.at("ruby-overhang", default: 0pt))
  }
  result
}

#let ruby-aware-gap(tokens, gap) = calc.max(
  measure(h(gap)).width,
  column-ruby-overhang(tokens),
)

/// Renders a single column of tokens as a top-to-bottom vertical stack.
///
/// - tokens (array): Array of token dictionaries for this column.
/// - config (dictionary): Layout configuration.
/// -> content: A vertical stack of rendered character boxes.
#let render-column(tokens, config) = {
  if tokens.len() == 0 {
    return box(width: config.sizing.char-box, height: config.sizing.char-box)
  }

  let tracking = config.sizing.at("tracking", default: 0pt)
  let rendered = tokens.map(token => render-char-token(token, config))

  // A completed vertical line is the paginator's atomic unit. Leaving this
  // stack breakable lets Typst resume the same line on a later page, which
  // destroys column order and produces narrow continuation strips. The
  // neutral fixed-layout marker is applied once by the enclosing page/cell,
  // not once per line, to avoid thousands of identical text scopes.
  box(stack(
    dir: ttb,
    spacing: tracking,
    ..rendered,
  ))
}

/// Renders a single page worth of columns arranged RTL.
///
/// - cols (array): Array of column token arrays for this page.
/// - gap (length): Horizontal gap between columns.
/// - config (dictionary): The layout configuration.
/// -> content: RTL-arranged vertical columns.
#let render-page(cols, gap, config) = {
  if config.layout.hooks.len() > 0 {
    return config.layout.hooks.last()(cols, config.font, gap, config)
  }
  let rendered = ()
  for (index, col) in cols.enumerate() {
    rendered.push(render-column(col, config))
    if index + 1 < cols.len() {
      // In RTL order the next column is to this one’s left, and its ruby lane
      // extends back into the gap we are inserting here.
      rendered.push(h(ruby-aware-gap(cols.at(index + 1), gap)))
    }
  }
  text(lang: "und", features: (jsvm: 1), align(right + top, stack(
      dir: rtl,
      spacing: 0pt,
      ..rendered,
  )))
}
