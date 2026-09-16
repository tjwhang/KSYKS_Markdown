// src/flatten.typ
// Content tree traversal for Typst native markup

#import "../pipeline/parser.typ": tokenize
#import "../pipeline/token.typ": merge-token, token
#import "../utils/ruby-pair.typ": ruby-auto-pair

// Ruby bracket syntax carries Typst content, but the vertical engine needs
// grapheme strings to assign an analytic cell to every base/reading glyph.
// Normalize at Basho's boundary so every caller shares the same behavior.
#let _ruby-plain-text(value, role) = {
  if type(value) == str { return value }
  if type(value) == array {
    let result = ""
    for item in value { result += _ruby-plain-text(item, role) }
    return result
  }
  if type(value) != content { panic("basho ruby " + role + " must be plain text") }
  let name = repr(value.func())
  if value.has("text") { return value.text }
  if name == "space" { return " " }
  if name == "sequence" and value.has("children") {
    return _ruby-plain-text(value.children, role)
  }
  if name in (
    "strong", "emph", "underline", "strike", "overline", "highlight",
    "link", "styled",
  ) {
    if value.has("body") { return _ruby-plain-text(value.body, role) }
    if value.has("child") { return _ruby-plain-text(value.child, role) }
    if value.has("children") { return _ruby-plain-text(value.children, role) }
  }
  panic(
    "basho ruby " + role
      + " must contain text or ordinary inline styling; opaque content is not supported in vertical ruby",
  )
}

// Match Rubby's `delimiter: "|"` behavior for vertical ruby. Separators are
// not glyphs: when both sides have the same number of segments, each reading
// segment is aligned against its corresponding base segment. A mismatched
// pair deliberately falls back to ordinary whole-word ruby, just as Rubby
// does.
#let _ruby-split-segments(text) = {
  let pieces = text.split("|")
  let first = if pieces.len() > 0 and pieces.first() == "" { 1 } else { 0 }
  let last = if pieces.len() > first and pieces.last() == "" {
    pieces.len() - 1
  } else { pieces.len() }
  pieces.slice(first, last)
}

#let _ruby-aligned-segments(reading, base) = {
  let bases = _ruby-split-segments(base)
  // Authored empty readings are significant when they match the base count.
  let authored = reading.split("|")
  let readings = if authored.len() == bases.len() { authored } else {
    _ruby-split-segments(reading)
  }
  if readings.len() < 2 or readings.len() != bases.len() {
    return none
  }
  if bases.any(segment => segment == "") { return none }
  let result = ()
  for index in range(bases.len()) {
    result.push((base: bases.at(index), ruby: readings.at(index)))
  }
  result
}

// ---------------------------------------------------------------------------
// Element Handlers
// ---------------------------------------------------------------------------

#let _handle-heading(c, config, flatten-fn) = {
  let tokens = ()
  tokens.push(token("newline", fields: (text: "\n")))
  let level = c.at("depth", default: c.at("level", default: 1))
  tokens.push(token("heading-anchor", fields: (level: level, body: c.body)))
  let inner = flatten-fn(c.body, config)
  inner = inner.map(t => merge-token(t, (heading: level)))
  tokens += inner
  tokens.push(token("parbreak", fields: (text: "\n")))
  tokens
}

#let _handle-link(c, config, flatten-fn) = {
  let dest = c.dest
  let inner = flatten-fn(c.body, config)
  inner.map(t => merge-token(t, (dest: dest)))
}

#let _handle-style(c, config, flatten-fn, fname) = {
  let inner = flatten-fn(c.body, config)
  if fname == "strong" {
    inner.map(t => merge-token(t, (bold: true)))
  } else if fname == "emph" {
    inner.map(t => merge-token(t, (italic: true)))
  } else {
    inner
  }
}

#let _handle-enum(c, config, flatten-fn) = {
  let tokens = ()
  let items = ()
  if c.has("children") {
    if c.children.len() == 1 {
      let only = c.children.at(0)
      if type(only) == content and repr(only.func()) == "item" {
        let inner = only.body
        if (
          type(inner) == content
            and repr(inner.func()) == "sequence"
            and inner.has("children")
        ) {
          for child in inner.children {
            if type(child) == content and repr(child.func()) == "item" {
              items.push(child)
            }
          }
        }
      }
    } else {
      for child in c.children {
        if type(child) == content and repr(child.func()) == "item" {
          items.push(child)
        }
      }
    }
  }

  if items.len() > 0 {
    let start = c.at("start", default: 1)
    for i in range(items.len()) {
      if i > 0 { tokens.push(token("newline", fields: (text: "\n"))) }
      let num = (config.list.numbered.format)(start + i)
      tokens.push(token("tcy", fields: (
        text: num,
        forced: true,
        list-marker: true,
      )))
      let gap = config.list.numbered.gap
      if gap != 0pt { tokens.push(token("spacing", fields: (width: gap))) }
      tokens += flatten-fn(items.at(i).body, config)
    }
  } else {
    tokens += (config.list.numbered.flatten)(c, flatten-fn, config)
  }
  tokens
}

#let _handle-sequence(c, config, flatten-fn) = {
  let tokens = ()
  let seen-item = false
  for (index, child) in c.children.enumerate() {
    if type(child) == content and repr(child.func()) == "item" {
      if seen-item { tokens.push(token("newline", fields: (text: "\n"))) }
      tokens.push(token("bullet-list-marker"))
      tokens += flatten-fn(child.body, config)
      seen-item = true
    } else if type(child) == content and repr(child.func()) == "space" {
      // Typst materializes source whitespace around inline functions as a
      // `space` node. It is meaningful between adjacent ruby pairs and other
      // vertical inline atoms. Only discard the formatting whitespace that
      // separates list items from their enclosing list syntax.
      let adjacent-item = (
        (index > 0 and type(c.children.at(index - 1)) == content
          and repr(c.children.at(index - 1).func()) == "item")
          or (index + 1 < c.children.len()
            and type(c.children.at(index + 1)) == content
            and repr(c.children.at(index + 1).func()) == "item")
      )
      // A component such as jsepigraph may wrap an indented body in opening
      // and closing CJK delimiters. That indentation is source formatting,
      // not a requested space after 「 or before 」.
      let has-previous-text = (
        index > 0
          and type(c.children.at(index - 1)) == content
          and c.children.at(index - 1).has("text")
      )
      let previous-text = if has-previous-text {
        c.children.at(index - 1).text
      } else { "" }
      let has-next-text = (
        index + 1 < c.children.len()
          and type(c.children.at(index + 1)) == content
          and c.children.at(index + 1).has("text")
      )
      let next-text = if has-next-text {
        c.children.at(index + 1).text
      } else { "" }
      let delimiter-adjacent = (
        previous-text in ("「", "『", "【", "〈", "《", "（", "〔")
          or next-text in ("」", "』", "】", "〉", "》", "）", "〕")
      )
      // Leading/trailing sequence whitespace is indentation around an inline
      // body. In particular, the delimited epigraph body is nested one level
      // below its 「, so this removes the same formatting space there without
      // touching deliberate spaces between two Ruby markers.
      let edge-space = index == 0 or index + 1 == c.children.len()
      if not adjacent-item and not delimiter-adjacent and not edge-space {
        tokens.push(token("char", fields: (text: " ")))
      }
    } else if (
      type(child) == content
        and child.has("children")
        and child.children.len() == 0
    ) {
      // Ignore empty sequence children from list syntax.
    } else if (
      type(child) == content and child.has("text") and child.text == ""
    ) {
      // Ignore empty text nodes.
    } else {
      tokens += flatten-fn(child, config)
    }
  }
  tokens
}

// ---------------------------------------------------------------------------
// Main Flatten Logic
// ---------------------------------------------------------------------------

/// Flattens a native Typst content tree into an array of Basho tokens.
/// This enables support for inline macros (like `#ruby`) and native styling (like `*bold*`).
///
/// - c (content | str | array): The content to flatten.
/// - config (dictionary): The layout configuration.
/// -> array: An array of token dictionaries.
#let flatten(c, config) = {
  let tokens = ()

  if type(c) == array {
    for child in c {
      tokens += flatten(child, config)
    }
  } else if type(c) == str {
    tokens += tokenize(c, config)
  } else if type(c) == content {
    let fname = repr(c.func())
    // Be tolerant to list element shapes to avoid falling back to hblock.
    let is-bullet-list = (
      fname == "list" or (c.has("children") and c.has("marker"))
    )
    let is-numbered-list = (
      fname == "enum" or (c.has("children") and c.has("numbering"))
    )

    if fname == "metadata" {
      if type(c.value) == dictionary and "type" in c.value {
        // Custom macros like ruby() or tcy() injected via metadata
        let value = c.value
        if value.type == "ruby" {
          if value.at("jsarticle-ruby", default: false) {
            let enabled = value.at("auto-pair", default: auto)
            let pair = ruby-auto-pair(value.ruby, value.text, enabled: if enabled == auto {
              config.at("ruby-auto-pair", default: true)
            } else { enabled })
            value.insert("text", pair.base)
            value.insert("ruby", pair.reading)
          }
          let base = _ruby-plain-text(value.text, "base")
          let reading = _ruby-plain-text(value.ruby, "reading")
          let segments = _ruby-aligned-segments(reading, base)
          if segments != none {
            value.insert("text", segments.map(pair => pair.base).join(""))
            value.insert("ruby", segments.map(pair => pair.ruby).join(""))
            value.insert("ruby-segments", segments)
          } else {
            value.insert("text", base)
            value.insert("ruby", reading)
          }
        }
        tokens.push(value)
      }
    } else if fname == "equation" {
      let is-block = c.at("block", default: false)
      if is-block {
        tokens.push(token("vblock", fields: (text: c)))
      } else {
        tokens.push(token("turn", fields: (text: c)))
      }
    } else if fname == "space" {
      tokens.push(token("char", fields: (text: " ")))
    } else if fname == "parbreak" {
      tokens.push(token("parbreak", fields: (text: "\n")))
    } else if fname == "linebreak" {
      tokens.push(token("newline", fields: (text: "\n")))
    } else if fname == "footnote" {
      // Keep the native footnote element in the final rendering pass so Typst
      // still owns its numbering and page-bottom note. Treat its marker as a
      // single CJK cell instead of an opaque block that consumes a whole
      // vertical line. This also covers template wrappers such as transnote.
      tokens.push(token("char", fields: (
        text: c,
        footnote-marker: true,
        // This is a kinsoku-like line-start prohibition handled by the
        // paginator, independent of the literal marker glyph Typst chooses.
        forbid-line-start: true,
      )))
    } else if fname == "heading" {
      tokens += _handle-heading(c, config, flatten)
    } else if fname == "link" {
      tokens += _handle-link(c, config, flatten)
    } else if (
      fname
        in ("strong", "emph", "underline", "strike", "overline", "highlight")
    ) {
      tokens += _handle-style(c, config, flatten, fname)
    } else if fname == "enum" {
      tokens += _handle-enum(c, config, flatten)
    } else if fname == "sequence" and c.has("children") {
      tokens += _handle-sequence(c, config, flatten)
    } else if is-bullet-list {
      tokens += (config.list.bullet.flatten)(c, flatten, config)
    } else if is-numbered-list {
      tokens += (config.list.numbered.flatten)(c, flatten, config)
    } else if c.has("children") {
      for child in c.children {
        tokens += flatten(child, config)
      }
    } else if c.has("text") {
      // Native text elements
      tokens += tokenize(c.text, config)
    } else {
      // Anything else (figures, images, shapes, unhandled blocks)
      tokens.push(token("hblock", fields: (text: c)))
    }
  }

  tokens
}
