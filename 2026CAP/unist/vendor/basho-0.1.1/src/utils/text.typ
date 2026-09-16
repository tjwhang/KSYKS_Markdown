// src/utils/text.typ
// Utility functions for text/content manipulation

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
