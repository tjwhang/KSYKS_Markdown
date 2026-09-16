// Shared, conservative inference for jsarticle ruby. Never flatten styling:
// callers with structured content retain their existing renderer behavior.
#let ruby-pair-plain(value) = {
  if type(value) == str { return value }
  if type(value) != content { return none }
  let name = repr(value.func())
  if name == "text" { return value.text }
  if name == "space" { return " " }
  if name == "sequence" {
    let parts = value.children.map(ruby-pair-plain)
    if parts.any(it => it == none) { return none }
    return parts.join("")
  }
  none
}

// Grapheme clusters keep decomposed/archaic Hangul together. Whitespace must
// match on both sides; it gets an empty reading, never a printed ruby space.
// This is character pairing, not a phonetic parser: multi-symbol Bopomofo
// syllables (including tone marks) still require explicit | boundaries.
#let ruby-auto-pair(reading, base, enabled: true) = {
  let unchanged = (reading: reading, base: base)
  if not enabled { return unchanged }
  let r = ruby-pair-plain(reading)
  let b = ruby-pair-plain(base)
  if r == none or b == none or r.contains("|") or b.contains("|") { return unchanged }
  let rs = r.clusters()
  let bs = b.clusters()
  if rs.len() < 2 or rs.len() != bs.len() { return unchanged }
  let cjk = regex("^[\p{Hangul}\p{Han}\p{Hiragana}\p{Katakana}\p{Bopomofo}]+$")
  let readings = ()
  for (r, b) in rs.zip(bs) {
    if r.trim() == "" or b.trim() == "" {
      if r != b { return unchanged }
      readings.push("")
    } else {
      if r.match(cjk) == none or b.match(cjk) == none { return unchanged }
      readings.push(r)
    }
  }
  // Leading/trailing empty readings conflict with delimiter edge sentinels.
  if rs.first().trim() == "" or rs.last().trim() == "" { return unchanged }
  (reading: readings.join("|"), base: bs.join("|"))
}
