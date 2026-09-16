#import "@preview/meander:0.4.4": normalize
#let scope-key = "pf-flow-stream-scope"
#let scope-of(node) = {
    if repr(node.func()) != "styled" { return none }
    let child = node.child
    let last = if child.func() == [].func() { child.children.last(default: []) } else { child }
    if last.func() == metadata and type(last.value) == dictionary {
        last.value.at(scope-key, default: none)
    } else { none }
}
#let without-end(child) = {
    if child.func() == [].func() { child.children.slice(0, -1).sum(default: []) } else { [] }
}
#let coalesce(nodes, rejoin) = {
    let result = ()
    let run = ()
    let finish(run) = {
        if run.len() == 1 { run.first() } else {
            let first = run.first()
            let child = run.map(node => without-end(node.child)).sum(default: [])
            first.func()(rejoin(child + metadata(((scope-key): scope-of(first)))), first.styles)
        }
    }
    for node in nodes {
        let scope = scope-of(node)
        if run.len() > 0 and (scope == none or scope-of(run.first()) != scope) {
            result.push(finish(run))
            run = ()
        }
        if scope == none { result.push(node) } else { run.push(node) }
    }
    if run.len() > 0 { result.push(finish(run)) }
    result
}
// Restore original style scopes before measuring or handing off to native
// columns. In particular, a repeated `set par` scope is NOT a paragraph break.
#let pf-flow-rejoin(body) = {
    if body.func() == [].func() { coalesce(body.children.map(pf-flow-rejoin), pf-flow-rejoin).sum(default: []) }
    else if repr(body.func()) == "styled" { body.func()(pf-flow-rejoin(body.child), body.styles) }
    else { body }
}
#let pf-flow-normalize(nodes) = normalize.box-refs(coalesce(nodes.map(pf-flow-rejoin), pf-flow-rejoin))
// Source-only working windows: no paragraph/block wrappers are introduced.
// Opaque layout elements remain atomic, preserving their own break semantics.
#let pf-flow-chunks(body, limit: 1024) = {
    let sequence = [].func()
    let pack(parts) = {
        let result = ()
        let pending = ()
        let weight = 0
        for part in parts {
            if pending.len() > 0 and (weight + part.cost > limit or pending.len() >= 32) {
                result.push((body: pending.sum(default: []), cost: weight))
                pending = ()
                weight = 0
            }
            pending.push(part.body)
            weight += part.cost
        }
        if pending.len() > 0 { result.push((body: pending.sum(default: []), cost: weight)) }
        result
    }
    let flatten(node, path: ()) = {
        if node.func() == sequence {
            // Resolve automatic enumeration and adjacent references before a
            // working-window boundary can separate them.
            normalize.normalize-seq(node.children, (:)).enumerate().map(((i, child)) => flatten(child, path: path + (i,))).flatten()
        } else if repr(node.func()) == "styled" {
            let fields = node.fields()
            // Keep a complete local window inside the style scope. Wrapping
            // every whitespace atom separately changes paragraph semantics.
            pack(flatten(fields.child, path: path + (-1,))).map(part => (
                body: node.func()(part.body + metadata(((scope-key): path)), fields.styles),
                cost: part.cost,
            ))
        } else if node.func() == text {
            let fields = node.fields()
            let value = fields.remove("text")
            // Prefer whitespace boundaries so a window never invents a word
            // boundary in ordinary prose. Unspaced runs remain atomic: even
            // grapheme-safe cuts can change CJK line breaking and shaping.
            let parts = ()
            let pending = ""
            for token in value.matches(regex("\\S+\\s*|\\s+")) {
                let word = token.text
                if pending != "" and pending.len() + word.len() > limit {
                    parts.push((body: text(pending, ..fields), cost: pending.len()))
                    pending = ""
                }
                if word.len() > limit {
                    parts.push((body: text(word, ..fields), cost: word.len()))
                } else { pending += word }
            }
            if pending != "" { parts.push((body: text(pending, ..fields), cost: pending.len())) }
            parts
        } else { ((body: node, cost: 64),) }
    }
    pack(flatten(body)).map(part => part.body)
}
