#import "theme.typ": pf-page-margin

#let pf-specimen(body, anchor: none, gap: 6mm, bottom-clearance: 2mm) = [
    #metadata((body: body, anchor: anchor, gap: gap,
        bottom-clearance: bottom-clearance)) <pf-specimen-registry>
]

// A stable page style reads the registry; it never captures mutable specimen
// content in the styles inherited by pf-flow's expensive measurements.
#let pf-specimen-layer = context {
    let physical = here().page()
    for entry in query(<pf-specimen-registry>) {
        let spec = entry.value
        let anchors = query(spec.anchor)
        assert(anchors.len() == 1, message: "pf-specimen: anchor must occur exactly once.")
        let position = anchors.first().location().position()
        if position.page == physical {
            let y = position.y + spec.gap
            let area = (
                width: page.width - pf-page-margin.left - pf-page-margin.right,
                height: page.height - pf-page-margin.bottom - y - spec.bottom-clearance,
            )
            assert(area.height > 0pt, message: "pf-specimen: no space below the prose anchor.")
            let body = if type(spec.body) == function { (spec.body)(area) } else { spec.body }
            let natural = measure(block(width: area.width, above: 0pt, below: 0pt)[#body], width: area.width)
            assert(natural.height <= area.height + 0.01pt,
                message: "pf-specimen: content exceeds the available height; shorten it or bound regions using area.height.")
            place(top + left, dx: pf-page-margin.left, dy: y,
                block(width: area.width, height: area.height, above: 0pt, below: 0pt,
                    breakable: false)[#body])
        }
    }
}
