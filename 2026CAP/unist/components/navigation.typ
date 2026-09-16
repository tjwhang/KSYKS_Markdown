// Shared destinations and page context for the cover and project pages.
#let pf-project-destination(id) = label("pf-project-" + id)

#let pf-page-meta(marker, project-number: none, short-title: "", continuation: false) = [
  #metadata((
    kind: "pf-page",
    marker: marker,
    project-number: project-number,
    short-title: short-title,
    continuation: continuation,
  )) <pf-page>
]

#let pf-project-page(project) = context {
  let override = project.at("displayed-page", default: project.at("page", default: auto))
  if override != auto {
    override
  } else {
    let destination = pf-project-destination(project.id)
    if query(destination).len() == 0 { [—] } else {
      counter(page).at(destination).first()
    }
  }
}
