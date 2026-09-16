// src/layout/paginate.typ
// Deterministic vertical-line construction and kinsoku-aware pagination.

#import "../kinsoku/kinsoku.typ": (
  apply-spacing-compression, is-forbidden-start, is-valid-line-end,
  justify-line,
)
#import "../pipeline/token.typ": merge-token

#let token-height(token, config) = {
  if token.type == "hanging" { return token.space-after }
  calc.max(0pt, token.layout-height - token.compression-applied) + token.space-after
}

#let column-height(tokens, config) = {
  if tokens.len() == 0 { return 0pt }
  let height = 0pt
  for token in tokens { height += token-height(token, config) }
  let tracking = config.at("tracking-abs", default: 0pt)
  height + tracking * calc.max(0, tokens.len() - 1)
}

#let is-break-space(token, config) = {
  (
    token != none
    and token.type == "char"
    and type(token.text) == str
    and token.text == " "
  )
}

#let cjk-prose-char = regex("^[\\p{sc:Hangul}\\p{sc:Han}\\p{sc:Hiragana}\\p{sc:Katakana}]$")
#let cjk-attached-punctuation = regex("^[。、，．！？；：…‥、〕〉》】」』）]$")

#let is-cjk-prose-token(token) = (
  token != none
    and token.type == "char"
    and type(token.text) == str
    and not token.at("footnote-marker", default: false)
    and token.text.match(cjk-prose-char) != none
)

#let is-footnote-marker(token) = (
  token != none and token.at("footnote-marker", default: false)
)

#let is-forbidden-line-start(token, forbidden-start) = (
  is-footnote-marker(token) or is-forbidden-start(token, forbidden-start)
)

#let is-attached-punctuation(token) = (
  token != none
    and token.type == "char"
    and type(token.text) == str
    and token.text.match(cjk-attached-punctuation) != none
)

// Return the number of already-buffered tokens in a particle immediately
// following an inline atom. Basho represents equations, raw text, and
// rotated/TCY Latin uniformly as `turn`; inspecting the source sequence keeps
// multi-character particles such as `으로` and `から` intact as well.
#let inline-atom-particle-prefix(tokens, index, config) = {
  let lists = config.at("inline-atom-particles", default: (:))
  let particles = lists.at(config.language, default: ())
  for particle in particles {
    let clusters = particle.clusters()
    if clusters.len() == 0 { continue }
    for prefix in range(1, clusters.len() + 1) {
      let start = index - prefix + 1
      if start <= 0 or tokens.at(start - 1).type != "turn" { continue }
      let matches = true
      for offset in range(prefix) {
        let candidate = tokens.at(start + offset)
        if candidate.type != "char" or candidate.text != clusters.at(offset) {
          matches = false
        }
      }
      if matches { return prefix }
    }
  }
  0
}

#let trailing-cjk-run-length(tokens) = {
  let count = 0
  for token in tokens.rev() {
    // A note call is attached to the preceding glyph but is not prose. It
    // must be transparent to fragment accounting rather than terminating a
    // run or inflating it by one cell.
    if is-footnote-marker(token) { continue }
    if not is-cjk-prose-token(token) { break }
    count += 1
  }
  count
}

// Forward CJK-run lengths are queried at every candidate wrap. Build them in
// one reverse pass rather than copying and scanning the remaining suffix.
#let leading-cjk-run-lengths(tokens) = {
  let reversed = ()
  let count = 0
  for token in tokens.rev() {
    if not is-footnote-marker(token) {
      // Keep the adjacent source run visible to a later overflow candidate.
      if is-cjk-prose-token(token) { count += 1 } else { count = 0 }
    }
    reversed.push(count)
  }
  reversed.rev()
}

#let has-visible-token(tokens) = tokens.any(token => not token.at("synthetic", default: false))

#let next-list-flags(tokens) = {
  let reversed = ()
  let next-list = false
  for token in tokens.rev() {
    if token.type == "bullet-list-marker" or token.at("list-marker", default: false) {
      next-list = true
    } else if not (token.type in ("newline", "parbreak", "heading-anchor")) {
      next-list = false
    }
    reversed.push(next-list)
  }
  reversed.rev()
}

// Compute every remaining paragraph-run length once. The former helper sliced
// and rescanned the whole suffix at each wrap, making long prose quadratic.
#let remaining-run-lengths(tokens) = {
  let reversed = ()
  let count = 0
  for token in tokens.rev() {
    if token.type in ("newline", "parbreak") {
      count = 0
      reversed.push(0)
    } else {
      if token.type != "heading-anchor" { count += 1 }
      reversed.push(count)
    }
  }
  reversed.rev()
}

#let spacing-token(width, absolute-height) = (
  type: "spacing",
  text: "",
  width: width,
  layout-height: absolute-height,
  space-after: 0pt,
  compression-applied: 0pt,
  synthetic: true,
)

#let trim-trailing-break-spaces(tokens, config) = {
  while tokens.len() > 0 and is-break-space(tokens.last(), config) {
    let _ = tokens.pop()
  }
  tokens
}

// A source space is a legal break opportunity, never visible end-of-line
// material. Trim it before measuring the distributable remainder so Korean
// justification cannot spend blank space after the final glyph.
#let finish-line(tokens, available-space, config, justify: true) = {
  let trimmed = tokens
  let removed = ()
  while trimmed.len() > 0 and is-break-space(trimmed.last(), config) {
    removed.push(trimmed.pop())
  }
  // `available-space` is computed from the incremental line cursor. Recover
  // only the removed trailing spaces and their former tracking joins instead
  // of rescanning both the untrimmed and trimmed lines at every wrap.
  let reclaimed = removed.map(token => token-height(token, config)).sum(default: 0pt)
  if removed.len() > 0 {
    let joins = if trimmed.len() == 0 {
      calc.max(0, removed.len() - 1)
    } else { removed.len() }
    reclaimed += config.at("tracking-abs", default: 0pt) * joins
  }
  let usable = calc.max(0pt, available-space + reclaimed)
  if justify and config.layout.at("justify", default: true) {
    justify-line(trimmed, usable, config)
  } else { trimmed }
}

/// Splits tokens into top-to-bottom vertical lines. Original source positions
/// are retained on every non-synthetic token so a first partial page can be
/// continued without reverse-engineering consumption from rendered output.
#let paginate(tokens, max-height, config, paragraph-start: true) = {
  let columns = ()
  let current = ()
  let occupied = 0pt
  let previous-break = none
  let tail-lengths = remaining-run-lengths(tokens)
  let leading-lengths = leading-cjk-run-lengths(tokens)
  let list-flags = next-list-flags(tokens)
  let tracking = config.at("tracking-abs", default: 0pt)

  let indent-tokens(start) = {
    let amount = config.at("paragraph-indent-abs", default: 0pt)
    let starts-list = start < list-flags.len() and list-flags.at(start)
    if amount > 0pt and not starts-list {
      (spacing-token(
        config.layout.at("paragraph-indent", default: 1em),
        amount,
      ),)
    } else { () }
  }

  // A continuation page can begin in the middle of a source paragraph. Its
  // first vertical line must not acquire the normal paragraph indent merely
  // because pagination restarted with a sliced token stream.
  if paragraph-start { current += indent-tokens(0) }
  occupied = column-height(current, config)

  // A source token is consumed at most once. Using a source iteration rather
  // than a long index-controlled `while` also avoids Typst's infinite-loop
  // safeguard on legitimate book-length streams.
  for (i, item) in tokens.enumerate() {

    if item.type == "newline" or item.type == "parbreak" {
      // One forced break ends the current line. Repeated breaks deliberately
      // create blank lines instead of being silently collapsed. A source
      // newline/parbreak is a paragraph-final line, so it is trimmed but
      // intentionally never expanded by automatic justification.
      if current.len() > 0 {
        columns.push(trim-trailing-break-spaces(current, config))
      } else if previous-break != none {
        columns.push(())
      }
      current = ()
      occupied = 0pt

      if item.type == "parbreak" {
        let spacing = config.at("paragraph-spacing-abs", default: 0pt)
        if spacing > 0pt {
          current.push(spacing-token(
            config.layout.at("paragraph-spacing", default: 0em),
            spacing,
          ))
        }
        current += indent-tokens(i + 1)
        occupied = column-height(current, config)
      }

      previous-break = item.type
      continue
    }
    previous-break = none

    // Ordinary inter-word space is a discardable line separator in vertical
    // composition. It must neither survive at the head of a new line nor be
    // handled as punctuation by generic kinsoku push-back.
    if is-break-space(item, config) and not has-visible-token(current) {
      continue
    }

    // A marker immediately following an explicit source break still belongs
    // to the preceding visible line. Prefer that legal attachment to a lone
    // marker at the top of a new vertical line.
    if is-footnote-marker(item) and not has-visible-token(current) and columns.len() > 0 {
      let previous = columns.pop()
      previous.push(item)
      columns.push(previous)
      continue
    }

    // These blocks intentionally occupy an isolated vertical line. They no
    // longer participate in source-count guessing because source-index stays
    // attached to the block token.
    if item.type == "vblock" or item.type == "hblock" {
      if current.len() > 0 {
        // `occupied` is maintained for every ordinary push. A block closes
        // that untouched line, so rescanning every glyph here is redundant.
        let remaining = calc.max(0pt, max-height - occupied)
        // An isolated block closes the preceding paragraph line just like an
        // explicit paragraph break. It must not be stretched to the full
        // vertical measure before the equation, figure, or other block.
        columns.push(finish-line(current, remaining, config, justify: false))
      }
      columns.push((item,))
      current = ()
      occupied = 0pt
      continue
    }

    let join = if current.len() > 0 { tracking } else { 0pt }
    let item-height = token-height(item, config)

    let overflows = current.len() > 0 and occupied + join + item-height > max-height

    if not overflows {
      current.push(item)
      occupied += join + item-height
      continue
    }

    // Keep a native note call with the preceding text. It occupies a normal
    // marker cell for rendering but neither starts a line nor counts as prose
    // when the fragment balancer evaluates an otherwise avoidable break.
    if is-footnote-marker(item) and has-visible-token(current) {
      current.push(item)
      columns.push(current)
      current = ()
      occupied = 0pt
      continue
    }


    if is-break-space(item, config) {
      let remaining = calc.max(0pt, max-height - occupied)
      columns.push(finish-line(current, remaining, config))
      current = ()
      occupied = 0pt
      continue
    }

    // Keep `$a$는`, `` `raw`는 ``, and `Latin은` together vertically. Move
    // the atom plus a partial multi-character particle to the next line when
    // its preceding line remains legal; otherwise preserve the complete unit
    // with a minimal overhang rather than beginning a line with the particle.
    // This is a companion to full-line CJK justification: ragged vertical
    // composition must retain its ordinary source break opportunities.
    let particle-prefix = if config.layout.at("justify", default: true) {
      inline-atom-particle-prefix(tokens, i, config)
    } else { 0 }
    if particle-prefix > 0 {
      let original = current
      let moved = ()
      while current.len() > 0 and moved.len() < particle-prefix {
        moved.insert(0, current.pop())
      }
      let movable = (
        moved.len() == particle-prefix
          and moved.first().type == "turn"
          and has-visible-token(current)
          and is-valid-line-end(current.last(), config.kinsoku.forbidden-end)
      )
      if movable {
        let remaining = calc.max(0pt, max-height - column-height(current, config))
        columns.push(finish-line(current, remaining, config))
        current = moved + (item,)
        occupied = column-height(current, config)
      } else {
        original.push(item)
        columns.push(original)
        current = ()
        occupied = 0pt
      }
      continue
    }

    // Repair a short CJK fragment before kinsoku considers overflow
    // exceptions. A following comma, for example, may otherwise choose
    // oikomi and lock in `...한다 / 면,` before this guard gets a chance to
    // borrow the preceding cell. Source spaces still remain legal breaks.
    let min-fragment = config.layout.at("min-fragment-chars", default: 2)
    let trailing = trailing-cjk-run-length(current)
    let leading = leading-lengths.at(i)
    if (
      min-fragment > 1
        and is-cjk-prose-token(item)
        and leading > 0
        and (
          (leading < min-fragment and trailing > 0)
            or (leading >= min-fragment and trailing > 0 and trailing < min-fragment)
        )
    ) {
      let original-current = current
      let moved = ()
      let required = if leading < min-fragment {
        min-fragment - leading
      } else {
        trailing
      }
      while (
        current.len() > 0
          and moved.len() < required
          and is-cjk-prose-token(current.last())
      ) {
        moved.insert(0, current.pop())
      }
      // Do not simply trade one orphan for another at a source word boundary.
      let remaining-trailing = trailing-cjk-run-length(current)
      while (
        current.len() > 0
          and remaining-trailing > 0
          and remaining-trailing < min-fragment
          and is-cjk-prose-token(current.last())
      ) {
        moved.insert(0, current.pop())
        remaining-trailing = trailing-cjk-run-length(current)
      }
      current = trim-trailing-break-spaces(current, config)
      let valid-break = (
        moved.len() > 0
          and has-visible-token(current)
          and is-valid-line-end(current.last(), config.kinsoku.forbidden-end)
          and not is-forbidden-line-start(
            moved.first(), config.kinsoku.forbidden-start,
          )
      )
      if valid-break {
        let remaining = calc.max(0pt, max-height - column-height(current, config))
        columns.push(finish-line(current, remaining, config))
        current = moved + (item,)
        occupied = column-height(current, config)
        continue
      }
      current = original-current
      occupied = column-height(current, config)
    }

    // A closing mark belongs visually to the Korean run before it. Let it
    // overhang that line before considering a fragment-moving repair. This
    // preserves `...보존한다면,/` instead of manufacturing `...한다/면,`.
    if (
      min-fragment > 1
        and is-attached-punctuation(item)
        and trailing > 0
    ) {
      current.push(merge-token(item, (type: "hanging")))
      columns.push(current)
      current = ()
      occupied = 0pt
      continue
    }

    let kinsoku = config.kinsoku
    kinsoku.insert("next-token", if i + 1 < tokens.len() { tokens.at(i + 1) } else { none })
    let decision = (kinsoku.resolve)(
      current,
      item,
      item-height,
      config,
      occupied,
      max-height,
    )

    if decision.action == "burasagari" {
      current.push(merge-token(item, (type: "hanging")))
      columns.push(current)
      current = ()
      occupied = 0pt
      continue
    }

    if decision.action == "oikomi" {
      current = apply-spacing-compression(
        current,
        decision.compression-amount,
        config,
      )
      current.push(item)
      columns.push(current)
      current = ()
      occupied = 0pt
      continue
    }

    if decision.action == "push-previous" {
      let original = current
      let moved = ()
      while current.len() > 0 {
        moved.insert(0, current.pop())
        let last = if current.len() > 0 { current.last() } else { none }
        if is-valid-line-end(last, kinsoku.forbidden-end) {
          let item-forbidden = is-forbidden-line-start(item, kinsoku.forbidden-start)
          let moved-forbidden = moved.len() > 0 and is-forbidden-line-start(
            moved.first(),
            kinsoku.forbidden-start,
          )
          if not (item-forbidden and moved-forbidden) { break }
        }
      }

      if current.len() == 0 {
        // No legal break exists before a forbidden-start character. Keep the
        // punctuation with the preceding line even if that line must overhang;
        // never create a new line whose first token violates kinsoku.
        columns.push(original + (item,))
        current = ()
        occupied = 0pt
      } else {
        occupied = column-height(current, config)
        let remaining = calc.max(0pt, max-height - occupied)
        columns.push(finish-line(current, remaining, config))
        current = moved + (item,)
        occupied = column-height(current, config)
      }
      continue
    }

    // Avoid a one-character final column by making the preceding automatic
    // line slightly shorter. Preserve both start/end kinsoku at the new break.
    let min-final = config.layout.at("min-final-line-chars", default: 2)
    let tail-length = tail-lengths.at(i)
    if tail-length > 0 and tail-length < min-final and current.len() > 1 {
      let original-current = current
      let moved = ()
      while current.len() > 1 and moved.len() + tail-length < min-final {
        moved.insert(0, current.pop())
      }
      while current.len() > 1 and (
        not is-valid-line-end(current.last(), config.kinsoku.forbidden-end)
          or (moved.len() > 0 and is-forbidden-line-start(
            moved.first(), config.kinsoku.forbidden-start,
          ))
      ) {
        moved.insert(0, current.pop())
      }
      if moved.len() > 0 and current.len() >= min-final and not is-forbidden-line-start(
        moved.first(), config.kinsoku.forbidden-start,
      ) {
        let shortened-remaining = calc.max(
          0pt,
          max-height - column-height(current, config),
        )
        columns.push(finish-line(current, shortened-remaining, config))
        current = moved + (item,)
        occupied = column-height(current, config)
        continue
      }
      current = original-current
      occupied = column-height(current, config)
    }

    // Normal oidashi: justify only automatically wrapped non-final lines.
    let remaining = calc.max(0pt, max-height - occupied)
    columns.push(finish-line(current, remaining, config))
    current = (item,)
    occupied = item-height
  }

  if current.len() > 0 { columns.push(current) }
  columns
}
