// src/utils/text.typ
// Utility functions for text/content manipulation

// Apply a vertical-only face override after composite token selection.
// Western punctuation inside rotated runs is deliberately not handled here.
#let upright-font(body, font, config) = {
  let punctuation = config.at("punctuation-font", default: none)
  if punctuation != none and type(body) == str and body.match(regex(
    "^[。、，．！？；：（）〔〕〈〉《》【】「」『』﹁﹂﹃﹄︐︑︒︓︔︕︖︙︰︱︲︳︴︵︶﹇﹈︷︸︹︺︻︼︽︾︿﹀︗︘]+$",
  )) != none { punctuation } else { font }
}

// Upright cells are horizontally shaped and then stacked, not shaped TTB.
// Source Han's `vert` GPOS repositions combining Jamo for true TTB shaping;
// enabling it in these horizontal cells displaces vowels/finals from their L.
// Preserve horizontal Hangul composition locally, including extended Jamo.
// Other glyphs (especially punctuation) retain their vertical alternates.
#let upright-features(body, features) = {
  if type(body) != str or body.match(regex("[\u{1100}-\u{11ff}\u{a960}-\u{a97f}\u{d7b0}-\u{d7ff}]")) == none {
    return features
  }
  let result = if type(features) == dictionary { features } else {
    features.map(feature => (feature, 1)).to-dict()
  }
  result + (vert: 0, vrt2: 0)
}

/// Recursively extracts all plain text from content objects or strings.
///
/// - c (content | str | array): The content to extract text from.
/// -> str: The concatenated plain text.
#let extract-text(c) = {
  if type(c) == str {
    c
  } else if type(c) == array {
    c.map(extract-text).join("")
  } else if type(c) == content {
    if c.has("text") {
      c.text
    } else if c.has("children") {
      c.children.map(extract-text).join("")
    } else if c.has("body") {
      extract-text(c.body)
    } else {
      ""
    }
  } else {
    ""
  }
}
