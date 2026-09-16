#import "theme.typ": pf-page-margin

// A zero-size marker outside pf-flow tracks the final physical project page.
#let pf-project-end(id) = [#metadata(id) <pf-project-end>]

#let pf-artwork-layer = context {
    let registries = query(<pf-artwork-registry>)
    let artworks = if registries.len() == 0 { (:) } else { registries.last().value }
    let physical = here().page()
    for marker in query(<pf-project-end>).filter(it => it.location().page() == physical) {
        let art = artworks.at(marker.value, default: none)
        if art != none {
            let width = art.at("width", default: if "height" in art { auto } else { 75mm })
            let height = art.at("height", default: auto)
            place(bottom + right,
                dx: -pf-page-margin.right + art.at("dx", default: 0mm),
                dy: -pf-page-margin.bottom + art.at("dy", default: 0mm),
                image(art.path, width: width, height: height, fit: "contain"))
        }
    }
}
