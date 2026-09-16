// Normalize compatibility spellings once, before rendering.
#let pf-normalize-project(project) = {
    let result = project
    result.insert("short-title", project.at("short-title", default: project.at("short_title", default: project.title)))
    result.insert("pages", project.at("pages", default: ()))
    result
}

#let pf-profile-content(overview: auto, background: auto, main: [], cap: []) = (
    overview: if overview == auto { main } else { overview },
    background: if background == auto { cap } else { background },
)

#let pf-metadata-items(project) = {
    let items = ()
    for key in ("field", "period", "tools") {
        let value = project.at(key, default: none)
        if type(value) == array { items += value } else { items.push(value) }
    }
    items.filter(value => value != none and value != "" and value != [])
}
