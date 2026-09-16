#import "../jsarticle.typ": jsvert, jsfont
#import "theme.typ": *

#import "navigation.typ": pf-page-meta

#let pf-page-header = context {
  if here().page-numbering() == none {
    none
  } else {
    let physical = here().page()
    let markers = query(<pf-page>)
    let active = markers
      .filter(item => item.location().page() <= physical)
      .last(default: none)

    if active == none {
      none
    } else {
      let data = active.value
      let continuation = data.at("project-number", default: none) != none and (
        data.at("continuation", default: false) or physical > active.location().page()
      )
      // The profile resets its counter inside the body, after the header's
      // location. Anchor to that effective counter, then advance on overflow.
      let displayed-folio = counter(page).at(active.location()).first() + physical - active.location().page()
      block(width: 100%)[
        #if continuation [
          #jsfont("gothic", size: pf-folio-size, fill: pf-muted)[
            #if data.at("project-number", default: none) != none [#data.at("project-number") #h(0.8em)]#data.at("short-title")
          ]
        ]
        // Keep the marker and folio as one compact margin unit. The marker gets
        // enough vertical room for the longest part label, while the folio
        // follows after a deliberate gap instead of drifting into evidence.
        #place(top + right, dx: pf-marker-offset)[
          #text(size: pf-marker-size, fill: pf-muted)[
            #jsvert(
              flow: "region",
              region-height: pf-marker-height,
              font-family: "body",
              tracking: 0.01em,
            )[#data.at("marker")]
          ]
        ]
        #place(top + right, dx: pf-marker-offset, dy: pf-folio-offset)[
          #jsfont("gothic", size: pf-folio-size, fill: pf-muted)[#displayed-folio]
        ]
      ]
    }
  }
}
