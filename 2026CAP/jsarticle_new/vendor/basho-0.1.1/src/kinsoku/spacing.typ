// src/kinsoku/spacing.typ
// Automatic spacing module (Shikiri / Wou-Kan Kakaku)

#import "../pipeline/token.typ": merge-token, token
#import "../kinsoku/kinsoku.typ": (
  is-forbidden-end, is-forbidden-start, is-unbreakable-pair,
)

#let western-pattern = regex("^[A-Za-z0-9,.!?:;]+$")
#let cjk-pattern = regex("^[\p{sc:Hangul}\p{sc:Han}\p{sc:Hiragana}\p{sc:Katakana}\p{sc:Bopomofo}]+$")
#let closing-brackets = "）〕］｝〉》」』】)]}〞”’︶﹈︸︺︼︾﹀﹂﹄︘"
#let half-aki-punctuation = "、。，．︐︑︒"

#let is-western(t) = {
  if t == none or (t.type != "char" and t.type != "tcy" and t.type != "turn") {
    return false
  }
  // Inline equations and arbitrary rotated Western content are represented as
  // non-string turn tokens. Treat the whole atomic token as Western so its
  // boundary receives the same aki as a Latin run.
  if t.type == "turn" and type(t.text) != str { return true }
  if type(t.text) != str { return false }
  t.text.match(western-pattern) != none
}

#let is-cjk(t) = {
  if t == none or t.type != "char" { return false }
  if type(t.text) != str { return false }
  t.text.match(cjk-pattern) != none
}

#let is-opening-bracket(t, chars) = {
  is-forbidden-end(t, chars)
}

#let is-closing-bracket(t) = {
  if t == none or t.type != "char" or type(t.text) != str { return false }
  closing-brackets.contains(t.text)
}

#let is-justification-point(t, forbidden-start, forbidden-end) = {
  if not is-cjk(t) { return false }
  (
    not is-opening-bracket(t, forbidden-end)
      and not is-forbidden-start(t, forbidden-start)
  )
}

/// Default spacing rendering module factory.
/// Automatically assigns `space-after` values according to adjacency rules.
///
/// - cjk-european-gap (length): Gap after a CJK char before a European char. Default: 0.25em.
/// - european-cjk-gap (length): Gap after a European char before a CJK char. Default: 0.25em.
/// - bracket-gap (length): Optional gap after a closing bracket before an opening bracket.
///   Default: 0pt; punctuation glyphs already carry conditional half-em space.
/// -> dictionary: A rendering module dict with `node-renderers` and `transform`.
#let default-spacing(
  cjk-european-gap: 0.25em,
  european-cjk-gap: 0.25em,
  bracket-gap: 0pt,
) = {
  (
    node-renderers: (
      "spacing": (token, config) => box(
        width: config.sizing.char-box,
        height: token.width,
      ),
    ),
    transform: (tokens, config) => {
      let result = ()
      let len = tokens.len()
      let forbidden-start = config.kinsoku.forbidden-start
      let forbidden-end = config.kinsoku.forbidden-end
      let unbreakable-chars = config.kinsoku.unbreakable-chars
      let buntetsu-kinsoku = config.kinsoku.at("buntetsu-kinsoku", default: true)
      let cjk-western = config.at("cjk-western-gap", default: cjk-european-gap)
      let western-cjk = config.at("western-cjk-gap", default: european-cjk-gap)
      for i in range(len) {
        let t = tokens.at(i)
        let next-t = if i + 1 < len { tokens.at(i + 1) } else { none }
        let opening = is-opening-bracket(t, forbidden-end)
        let forbidden-at-start = is-forbidden-start(t, forbidden-start)
        // A breakable U+0020 is forbidden at a vertical line head, but it is
        // not closing punctuation. Keeping those concepts separate prevents
        // the space from acquiring half-em punctuation aki/alignment.
        let break-space = t.type == "char" and type(t.text) == str and t.text == " "
        let closing = not break-space and forbidden-at-start
        let closing-bracket = is-closing-bracket(t)
        let next-opening = is-opening-bracket(next-t, forbidden-end)
        let t-western = is-western(t)
        let t-cjk = is-cjk(t)
        let next-western = is-western(next-t)
        let next-cjk = is-cjk(next-t)

        let space-after = 0pt
        if t-western and next-cjk {
          space-after = western-cjk
        } else if t-cjk and next-western {
          space-after = cjk-western
        } else if closing-bracket and next-opening {
          space-after = bracket-gap
        }

        let is-jp = t-cjk and not opening and not closing

        if (
          buntetsu-kinsoku and is-unbreakable-pair(t, next-t, unbreakable-chars)
        ) {
          space-after = 0pt
          is-jp = false
        }

        let base-width = 1.0
        let internal-aki = 0.0
        if (
          opening or closing-bracket
        ) {
          internal-aki = 0.5
        } else if (
          t != none
            and t.type == "char"
            and type(t.text) == str
            and half-aki-punctuation.contains(t.text)
        ) {
          internal-aki = 0.5
        }

        t = merge-token(t, (
          space-after: space-after,
          justification-point: is-jp,
          base-width: base-width,
          internal-aki: internal-aki,
          compression-applied: 0pt,
          opening-punctuation: opening,
          closing-punctuation: closing,
          forbidden-start: forbidden-at-start,
          forbidden-end: opening,
          hanging-punctuation: (
            t.type == "char" and type(t.text) == str
              and config.kinsoku.hanging.contains(t.text)
          ),
          compressible-punctuation: (
            t.type == "char" and type(t.text) == str
              and config.kinsoku.compressible-punctuation.contains(t.text)
          ),
        ))
        result.push(t)
      }
      result
    },
  )
}
