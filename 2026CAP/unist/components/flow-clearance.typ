#import "@preview/meander:0.4.4" as meander
#import "flow-stream.typ": pf-flow-normalize

// Pure preflight: use the same bounded windows and fitting predicate as the
// rendered flow. No query/state feedback, no hidden laid-out note instances.
#let pf-flow-reachable(chunks, pages, column, size) = {
    let queue = chunks.rev()
    let selected = ()
    let current = []
    for region in pages {
        for height in (region.height - 1pt, region.height - region.used - 1pt) {
            if height <= 0pt { continue }
            while queue.len() > 0 {
                let chunk = queue.pop()
                let combined = current + chunk
                let (fits, overflow) = meander.internals.fill-box(
                    (width: column, height: height), combined, size: size,
                    cfg: (normalize: ((repr(meander.normalize.box-refs)): pf-flow-normalize)),
                )
                if fits == none {
                    queue.push(chunk)
                    break
                }
                current = fits
                if overflow != none {
                    queue.push(overflow)
                    break
                }
            }
            selected.push(current)
            current = []
        }
    }
    selected
}
