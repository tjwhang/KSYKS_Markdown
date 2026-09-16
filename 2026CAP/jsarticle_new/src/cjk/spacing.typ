#let cjk-script = regex("^[\p{scx:Hangul}\p{scx:Han}\p{scx:Hira}\p{scx:Kana}]$")
#let cjk-latin = regex("^[\p{sc:Latn}\p{sc:Grek}\p{sc:Cyrl}ˈˌːˑ]\p{M}*$")
#let cjk-digit = regex("^[0-9]$")
#let cjk-open-bracket = regex("^[(\[\{<]$")
#let cjk-close-bracket = regex("^[)\]\}>]$")
#let cjk-is-open(kind) = type(kind) == str and (kind == "open" or kind.starts-with("open:"))
#let cjk-is-close(kind) = type(kind) == str and (kind == "close" or kind.starts-with("close:"))

// Compile Unicode category matchers once, not for every grapheme visit.
#let cjk-unicode-open-bracket = regex("^\p{Ps}$")
#let cjk-unicode-close-bracket = regex("^\p{Pe}$")
#let cjk-boundary-kind(cluster) = if cluster.match(cjk-open-bracket) != none {
    "open"
} else if cluster.match(cjk-close-bracket) != none {
    "close"
} else if cluster.match(cjk-unicode-open-bracket) != none {
    "open:" + cluster
} else if cluster.match(cjk-unicode-close-bracket) != none {
    "close:" + cluster
} else if cluster.match(cjk-script) != none {
    "cjk"
} else if cluster.match(cjk-latin) != none {
    "western"
} else if cluster.match(cjk-digit) != none {
    "number"
} else if cluster.match(cjk-open-bracket) != none {
    "open"
} else if cluster.match(cjk-close-bracket) != none {
    "close"
} else {
    none
}

#let cjk-boundary-type(previous, current) = {
    let script = (
        (previous == "cjk" and current == "western")
            or (previous == "western" and current == "cjk")
            or (previous == "cjk" and current == "number")
            or (previous == "number" and current == "cjk")
    )
    let previous-word = previous == "cjk" or previous == "western" or previous == "number"
    let current-word = current == "cjk" or current == "western" or current == "number"
    let bracket = (
        (previous-word and cjk-is-open(current))
            or (cjk-is-close(previous) and current-word)
    )
    if script { "script" } else if bracket { "bracket" } else { none }
}

#let cjk-boundary-gap(kind, amount, previous: none, current: none) = if kind == "script" {
    [#sym.wj#h(amount, weak: true)#sym.wj]
} else if kind == "bracket" {
    let bracket = if cjk-is-open(current) { current } else { previous }
    if type(bracket) == str and bracket.contains(":") {
        context {
            // Measure through the active compositor, including font features
            // and optical scale. Full-width glyphs already supply their space;
            // narrow corner/angle brackets receive the ordinary boundary gap.
            let glyph = bracket.split(":").last()
            // Neutral guards prevent Typst's line-edge punctuation trimming
            // from making a full-width glyph look half-width in isolation.
            let width = measure(text("·" + glyph + "·")).width - measure(text("··")).width
            if width < 0.8 * text.size {
                h(amount, weak: true)
            }
        }
    } else { h(amount, weak: true) }
} else {
    []
}

// Insert boundary spacing within one text node. Word Joiners are used only for
// source-adjacent CJK/Latin-digit pairs: they prevent a break at the newly
// inserted gap without affecting the baseline. Bracket gaps stay breakable.
#let cjk-latin-space(source, amount) = {
    let parts = ()
    let run = ""
    let previous = none
    for cluster in source.clusters() {
        let current = cjk-boundary-kind(cluster)
        let boundary = cjk-boundary-type(previous, current)
        if boundary != none {
            if run != "" {
                parts.push(run)
                run = ""
            }
            parts.push(cjk-boundary-gap(boundary, amount, previous: previous, current: current))
        }
        run += cluster
        previous = current
    }
    if run != "" {
        parts.push(run)
    }
    parts.sum(default: [])
}

// Apply CJK/Latin spacing to one language/region pair. `marker-region` is an
// internal recursion marker: it retains language shaping while excluding the
// generated text from the two selectors below. Defaults preserve Korean use,
// while another template can choose, for example, lang: "ja", region: "JP".
#let cjk-latin-spacing(
    amount,
    body,
    lang: "ko",
    region: "KR",
    marker-region: "KP",
) = {
    let transform = it => text(cjk-latin-space(it.text, amount), lang: lang, region: marker-region)
    show text.where(lang: lang, region: none): transform
    show text.where(lang: lang, region: region): transform
    body
}

// Apply the math clearance at CJK boundaries, retaining typed word spaces
// in addition to it. Walk nested sequences as well because `include`
// preserves its returned document content as a nested sequence.
#let content-sequence-element = ([A] + [B]).func()
#let content-styled-element = math.bold([E]).func()
#let content-strong-element = strong([E]).func()
#let content-emph-element = emph([E]).func()
#let content-link-element = link("https://example.com")[E].func()
#let content-raw-element = raw("E").func()
#let cjk-rendered-inline-math(it) = repr(it.func()) == "inline"
#let cjk-layout-tag(it) = repr(it.func()) == "tag"
#let cjk-raw-boundary-marker(it) = {
    if repr(it.func()) != "metadata" { return none }
    let value = it.value
    if type(value) != dictionary { return none }
    value.at("js-cjk-raw-boundary", default: none)
}

// Longest-match wins so a user can list both `으로` and `로` without the
// shorter particle prematurely consuming the prefix. This is intentionally a
// lexical policy: Korean/Japanese users can adjust their own particle lists
// without changing generic CJK line breaking.
#let cjk-leading-inline-particle(source, particle-lists, language: none) = {
    let matched = none
    let languages = if language == none { ("ko", "ja") } else { (language,) }
    for language in languages {
        for particle in particle-lists.at(language, default: ()) {
            if source.starts-with(particle) and (
                matched == none or particle.len() > matched.len()
            ) {
                matched = particle
            }
        }
    }
    matched
}

#let cjk-split-leading-text(it, prefix) = {
    let tail = it.text.slice(prefix.len())
    // Plain text nodes inherit their style from their surrounding `styled`
    // wrapper, which the visitor reconstructs unchanged around this split.
    (
        // This split happens after the language compositor. Keeping Typst's
        // automatic CJK/Latin spacing enabled here could introduce a second,
        // hidden math-to-particle gap. The protected seam supplies the sole
        // configured gap explicitly.
        head: text(prefix, cjk-latin-spacing: none),
        tail: if tail == "" { none } else { text(tail, cjk-latin-spacing: none) },
    )
}

// Insert gaps only at boundaries between sibling inline fragments. Boundaries
// within a text node stay in `compose`, where classification and font routing
// already share one linear pass. Styled text and links are transparent; inline
// math and raw are explicit boundary atoms; structural elements stop adjacency.
#let cjk-inline-fragment-spacing(gaps, body, inline-atom-particles: (ko: (), ja: ())) = {
    // Keep a particle attached with the same direct word-joiner boundary used
    // for an ordinary CJK/math boundary. It is deliberately not wrapped in a
    // box: a box causes Typst to reintroduce automatic CJK spacing internally.
    // The word joiners suppress the break; the only visible length is `amount`.
    let protected-atom-gap(kind) = {
        let amount = gaps.at(kind, default: none)
        if amount == none { sym.wj } else { [#sym.wj#h(amount, weak: true)#sym.wj] }
    }
    let gap-between(previous, current) = {
        let fragment = cjk-boundary-type(previous, current)
        if fragment != none {
            let amount = gaps.at("cjk-latin", default: none)
            if amount != none { return cjk-boundary-gap(fragment, amount, previous: previous, current: current) }
        }
        let atom = (
            (previous == "cjk" and current == "math")
                or (previous == "math" and current == "cjk")
        )
        if atom {
            let amount = gaps.at("math", default: none)
            if amount != none { return [#sym.wj#h(amount, weak: true)#sym.wj] }
        }
        let raw = (
            (previous == "cjk" and current == "raw")
                or (previous == "raw" and current == "cjk")
        )
        if raw {
            let amount = gaps.at("raw", default: none)
            if amount != none { return [#sym.wj#h(amount, weak: true)#sym.wj] }
        }
        none
    }
    let math-gap(previous, current) = {
        if (previous == "cjk" and current == "math") or (previous == "math" and current == "cjk") {
            let amount = gaps.at("math", default: none)
            if amount != none { return h(amount, weak: true) }
        }
        none
    }
    // Weak horizontal glue normally swallows markup spaces. At an additive
    // boundary, materialize just the bordering spaces as text, preserving
    // their styles and normal line-break/justification behavior.
    let keep-edge-space(it, leading: true) = {
        let func = it.func()
        if repr(func) == "space" {
            (body: text(" "), whitespace: true)
        } else if func == text {
            (body: it, whitespace: it.text.trim() == "")
        } else if func == content-sequence-element {
            let children = it.children
            let indices = range(children.len())
            if not leading { indices = indices.rev() }
            let whitespace = true
            for index in indices {
                let result = keep-edge-space(children.at(index), leading: leading)
                children.at(index) = result.body
                if not result.whitespace { whitespace = false; break }
            }
            (body: children.sum(default: []), whitespace: whitespace)
        } else if func == content-styled-element {
            let result = keep-edge-space(it.child, leading: leading)
            (body: func(result.body, it.styles), whitespace: result.whitespace)
        } else if func == content-strong-element or func == content-emph-element or func == content-link-element {
            let result = keep-edge-space(it.body, leading: leading)
            let body = if func == content-link-element { link(it.dest, result.body) } else { func(result.body) }
            (body: body, whitespace: result.whitespace)
        } else {
            (body: it, whitespace: cjk-layout-tag(it))
        }
    }
    // Return transformed content and both relevant edges together. The former
    // implementation independently descended into every child for its first
    // edge, its transformation, and its final edge; nested emphasis/link
    // trees therefore paid the same traversal several times per paragraph.
    let visit(it) = {
        if it.func() == text and it.text != "" {
            let clusters = it.text.clusters()
            let trimmed = it.text.trim()
            let edges = trimmed.clusters()
            (
                body: it,
                first: cjk-boundary-kind(clusters.first()),
                last: cjk-boundary-kind(clusters.last()),
                particle: cjk-leading-inline-particle(it.text, inline-atom-particles),
                changed: false,
                spaced-first: if edges.len() == 0 { none } else { cjk-boundary-kind(edges.first()) },
                spaced-last: if edges.len() == 0 { none } else { cjk-boundary-kind(edges.last()) },
                whitespace: trimmed == "",
            )
        } else if repr(it.func()) == "space" {
            (body: it, first: none, last: none, changed: false, whitespace: true)
        // The math show rule lowers an inline equation before the paragraph
        // pass runs. Typst exposes that rendered atom as `inline`, not as the
        // original `math.equation`; recognize both forms here.
        } else if (
            (it.func() == math.equation and not it.block)
              or cjk-rendered-inline-math(it)
        ) {
            (body: it, first: "math", last: "math", changed: false)
        } else if it.func() == math.equation {
            // Block equations retain their own block spacing and never form
            // an inline CJK boundary.
            (body: it, first: none, last: none, changed: false)
        } else if it.func() == content-raw-element {
            if it.block {
                // As above, block raw is deliberately outside inline spacing.
                (body: it, first: none, last: none, changed: false)
            } else {
                (body: it, first: "raw", last: "raw", changed: false)
            }
        } else if it.func() == content-sequence-element {
            let output = ()
            let first = none
            let previous = none
            let spaced-first = none
            let spaced-first-set = false
            let spaced-previous = none
            let only-whitespace = true
            let changed = false
            let raw-start = none
            let raw-pieces = ()
            for child in it.children {
                let marker = cjk-raw-boundary-marker(child)
                if raw-start != none {
                    if marker == "end" {
                        let result = (
                            body: raw-pieces.sum(default: []),
                            first: "raw",
                            last: "raw",
                            changed: false,
                        )
                        let gap = gap-between(previous, result.first)
                        if gap != none {
                            output.push(gap)
                            changed = true
                        }
                        output.push(result.body)
                        if first == none { first = result.first }
                        previous = result.last
                        spaced-previous = result.last
                        if not spaced-first-set { spaced-first = result.first; spaced-first-set = true }
                        only-whitespace = false
                        raw-start = none
                        raw-pieces = ()
                    } else {
                        raw-pieces.push(child)
                    }
                    continue
                }
                if marker == "start" {
                    raw-start = child
                    raw-pieces = ()
                    continue
                }
                let result = visit(child)
                if result.at("transparent", default: false) {
                    output.push(result.body)
                    changed = changed or result.changed
                    continue
                }
                let particle = result.at("particle", default: none)
                let join-particle = particle != none and previous in ("math", "raw")
                let gap = gap-between(previous, result.first)
                // A typed space is word separation, not a replacement for
                // math clearance. Keep it breakable and stretchable; add the
                // fixed clearance without a word joiner across that space.
                if gap == none {
                    gap = math-gap(spaced-previous, result.at("spaced-first", default: result.first))
                    if gap != none {
                        for index in range(output.len()).rev() {
                            let edge = keep-edge-space(output.at(index), leading: false)
                            output.at(index) = edge.body
                            if not edge.whitespace { break }
                        }
                        result.body = keep-edge-space(result.body).body
                    }
                }
                if join-particle {
                    // Word joiners constrain only this grammatical seam; the
                    // rest of the sentence remains naturally breakable.
                    let split = cjk-split-leading-text(result.body, particle)
                    let protected-gap = if previous == "math" {
                        protected-atom-gap("math")
                    } else {
                        protected-atom-gap("raw")
                    }
                    output.push(protected-gap)
                    output.push(split.head)
                    if split.tail != none { output.push(split.tail) }
                    changed = true
                } else {
                    if gap != none {
                        output.push(gap)
                        changed = true
                    }
                    output.push(result.body)
                }
                if first == none { first = result.first }
                if result.last != none { previous = result.last } else { previous = none }
                let whitespace = result.at("whitespace", default: false)
                if not whitespace {
                    spaced-previous = result.at("spaced-last", default: result.last)
                    if not spaced-first-set {
                        spaced-first = result.at("spaced-first", default: result.first)
                        spaced-first-set = true
                    }
                    only-whitespace = false
                }
                changed = changed or result.changed
            }
            // A malformed marker pair must never discard source content.
            if raw-start != none {
                output.push(raw-start)
                output.push(raw-pieces.sum(default: []))
            }
            (
                body: if changed { output.sum(default: []) } else { it },
                first: first,
                last: previous,
                changed: changed,
                spaced-first: spaced-first,
                spaced-last: spaced-previous,
                whitespace: only-whitespace,
            )
        } else if it.func() == content-styled-element {
            let fields = it.fields()
            let result = visit(fields.remove("child"))
            let styles = fields.remove("styles")
            (
                body: if result.changed { it.func()(result.body, styles) } else { it },
                first: result.first,
                last: result.last,
                changed: result.changed,
                spaced-first: result.at("spaced-first", default: result.first),
                spaced-last: result.at("spaced-last", default: result.last),
                whitespace: result.at("whitespace", default: false),
            )
        } else if it.func() == content-strong-element or it.func() == content-emph-element {
            let result = visit(it.fields().at("body"))
            (
                body: if result.changed { it.func()(result.body) } else { it },
                first: result.first,
                last: result.last,
                changed: result.changed,
                spaced-first: result.at("spaced-first", default: result.first),
                spaced-last: result.at("spaced-last", default: result.last),
                whitespace: result.at("whitespace", default: false),
            )
        } else if it.func() == content-link-element {
            let fields = it.fields()
            let result = visit(fields.at("body"))
            (
                body: if result.changed { link(fields.at("dest"), result.body) } else { it },
                first: result.first,
                last: result.last,
                changed: result.changed,
                spaced-first: result.at("spaced-first", default: result.first),
                spaced-last: result.at("spaced-last", default: result.last),
                whitespace: result.at("whitespace", default: false),
            )
        } else if cjk-layout-tag(it) {
            // Tags are Typst's transparent show-rule delimiters. They carry
            // no visible content and must not erase an adjacent CJK edge.
            (body: it, first: none, last: none, changed: false, transparent: true)
        } else {
            // Component renderers commonly leave a figure, block, or box
            // around an ordinary paragraph.  Descend through content-valued
            // fields and rebuild only when one has acquired a boundary gap.
            // This keeps the component opaque to its *surroundings* while
            // preserving the normal inline mechanics inside its body.
            let visit-value(value) = {
                if type(value) == content {
                    let result = visit(value)
                    (value: result.body, changed: result.changed)
                } else if type(value) == array {
                    let items = ()
                    let changed = false
                    for item in value {
                        let result = visit-value(item)
                        items.push(result.value)
                        changed = changed or result.changed
                    }
                    (value: if changed { items } else { value }, changed: changed)
                } else {
                    (value: value, changed: false)
                }
            }
            let fields = it.fields()
            let rebuilt = false
            // A changed caption/title can require rebuilding a container whose
            // body is unchanged. Its body must still be passed positionally.
            let child-key = if "body" in fields { "body" } else if "child" in fields { "child" } else { none }
            for key in fields.keys() {
                let value = fields.at(key)
                let result = visit-value(value)
                if result.changed {
                    fields.insert(key, result.value)
                    rebuilt = true
                }
            }
            let rebuilt-body = if not rebuilt {
                it
            } else if child-key != none {
                // Content constructors expose their principal child as a
                // named field, but accept it positionally when rebuilt.
                let child = fields.remove(child-key)
                it.func()(child, ..fields)
            } else if "children" in fields {
                // Grids and tables expose positional cells through a
                // `children` array rather than a content-valued body field.
                let children = fields.remove("children")
                it.func()(..fields, ..children)
            } else {
                it.func()(..fields)
            }
            (
                body: rebuilt-body,
                first: none,
                last: none,
                changed: rebuilt,
                transparent: false,
            )
        }
    }

    visit(body)
}

// Public compatibility entry point. Book rendering uses the shared content
// visitor so nested component bodies remain visible; direct callers retain the
// old `(amount, body)` contract.
#let cjk-inline-math-spacing(amount, body) = {
    cjk-inline-fragment-spacing((
        cjk-latin: none,
        math: amount,
        raw: none,
    ), body).body
}

// Install math/raw boundary spacing outside the language compositor. At this
// point Typst has materialized inline mathematics even inside figures, boxes,
// and component renderers, while the paragraph remains naturally breakable.
#let cjk-inline-boundary-spacing(body, gaps, inline-atom-particles: (ko: (), ja: ())) = context {
    let has-particles = false
    for (_, particles) in inline-atom-particles {
        if particles.len() != 0 { has-particles = true }
    }
    if (
        gaps.at("math", default: none) == none
          and gaps.at("raw", default: none) == none
          and not has-particles
    ) {
        return body
    }
    // Do not install this as a `show par` rule. Component calls have already
    // expanded into block-level figure trees by that point, so their inner
    // paragraphs never enter the rule. The shared visitor can descend from
    // the enclosing document content, rebuild only the changed branch, and
    // retain every container's native layout behavior.
    let result = cjk-inline-fragment-spacing((
        cjk-latin: none,
        math: gaps.at("math", default: none),
        raw: gaps.at("raw", default: none),
    ), body, inline-atom-particles: inline-atom-particles)
    if result.changed { result.body } else { body }
}

// Public compatibility entry point for callers that previously opted into
// equation-only boundary spacing.
#let cjk-inline-math-boundary-spacing(body, amount) = {
    cjk-inline-boundary-spacing(body, (math: amount, raw: none))
}
