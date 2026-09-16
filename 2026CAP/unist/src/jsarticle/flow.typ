#import "../../cjk.typ": *
#import "fonts.typ": *
#import "state.typ": *
#import "inline.typ": *
#import "options.typ": *
#import "defaults.typ": *
#import "geometry.typ": *

#let make-body-flow(cols, vertical-options, single-page-margins) = {
  let is-vertical-marker(node) = (
    type(node) == content
      and repr(node.func()) == "metadata"
      and type(node.value) == dictionary
      and node.value.at("kind", default: none) == _js-vertical-marker
  )
  let is-empty-flow-node(node) = if type(node) == content {
    let name = repr(node.func())
    (
      name in ("space", "parbreak")
        or (
          node.has("text") and node.text == ""
        )
        or (
          name == "sequence" and node.has("children") and node.children.all(is-empty-flow-node)
        )
    )
  } else if type(node) == str { node.trim() == "" } else { false }

  let flatten-flow(node) = if (
    type(node) == content
      and (
        repr(node.func()) == "sequence" and node.has("children")
      )
  ) {
    node.children.map(flatten-flow).flatten()
  } else if type(node) == array {
    node.map(flatten-flow).flatten()
  } else { (node,) }

  let apply-inherited-context(payload, inherited) = {
    let result = payload
    let opts = result.options
    for key in ("language", "region") {
      let value = inherited.at(key, default: auto)
      if value != auto and key not in opts { opts.insert(key, value) }
    }
    result.insert("options", opts)
    result
  }

  // One recursive classification pass replaces the former independent
  // flatten/extract/contains scans. `vertical` is present only when a node
  // is made solely of transparent wrappers, markers, and harmless empty
  // flow; `contains` still records markers trapped by opaque content so the
  // public error remains precise.
  let classify-flow-node(node, inherited: (:)) = {
    if is-vertical-marker(node) {
      return (
        contains: true,
        vertical: (apply-inherited-context(node.value, inherited),),
      )
    }
    if type(node) == array {
      let contains = false
      let found = ()
      let transparent = true
      for child in node {
        let nested = classify-flow-node(child, inherited: inherited)
        contains = contains or nested.contains
        if is-empty-flow-node(child) { continue }
        if nested.vertical == none { transparent = false } else { found += nested.vertical }
      }
      return (
        contains: contains,
        vertical: if transparent and found.len() > 0 { found } else { none },
      )
    }
    if type(node) != content { return (contains: false, vertical: none) }
    let name = repr(node.func())
    let next-inherited = inherited
    if name == "text" {
      let lang = node.at("lang", default: auto)
      let region = node.at("region", default: auto)
      if lang != auto { next-inherited.insert("language", lang) }
      if region != auto { next-inherited.insert("region", region) }
    }
    let children = if node.has("children") {
      node.children
    } else if node.has("child") {
      (node.child,)
    } else if node.has("body") {
      (node.body,)
    } else { () }
    let contains = false
    let found = ()
    let transparent = name in ("sequence", "styled", "text")
    for child in children {
      let nested = classify-flow-node(child, inherited: next-inherited)
      contains = contains or nested.contains
      if is-empty-flow-node(child) { continue }
      if nested.vertical == none { transparent = false } else { found += nested.vertical }
    }
    (
      contains: contains,
      vertical: if transparent and found.len() > 0 { found } else { none },
    )
  }

  let vertical-geometry(payload) = {
    let opts = payload.options
    (
      width: opts.at("width", default: vertical-options.width),
      height: opts.at("height", default: vertical-options.height),
      columns: opts.at("columns", default: vertical-options.columns),
      rows: opts.at("rows", default: vertical-options.rows),
      line-gap: opts.at("gap", default: opts.at(
        "line-gap",
        default: vertical-options.at("line-gap"),
      )),
      column-gap: opts.at("column-gap", default: vertical-options.at("column-gap")),
      row-gap: opts.at("row-gap", default: vertical-options.at("row-gap")),
      row-fit-threshold: opts.at(
        "row-fit-threshold",
        default: vertical-options.at("row-fit-threshold"),
      ),
      line-overhang-threshold: opts.at(
        "line-overhang-threshold",
        default: vertical-options.at("line-overhang-threshold"),
      ),
      min-final-line-chars: opts.at(
        "min-final-line-chars",
        default: vertical-options.at("min-final-line-chars"),
      ),
      min-fragment-chars: opts.at(
        "min-fragment-chars",
        default: vertical-options.at("min-fragment-chars"),
      ),
      orphan-lines: opts.at("orphan-lines", default: vertical-options.at("orphan-lines")),
      widow-lines: opts.at("widow-lines", default: vertical-options.at("widow-lines")),
      stream-gap: opts.at("stream-gap", default: vertical-options.at("stream-gap")),
      page-start: opts.at("page-start", default: vertical-options.at("page-start")),
    )
  }

  let render-vertical-group(group, surface-id: none) = {
    let render = context {
      let streams = ()
      let force-page = false
      for payload in group {
        let stream-options = payload.options
        let stream-flow = stream-options.at("flow", default: auto)
        if stream-flow == "page" { force-page = true }
        if "flow" in stream-options { let _ = stream-options.remove("flow") }
        for stream-body in payload.bodies {
          let stream = if type(stream-body) == dictionary and "body" in stream-body {
            stream-body
          } else { (body: stream-body) }
          for (key, value) in stream-options {
            if key not in stream { stream.insert(key, value) }
          }
          streams.push(stream)
        }
      }
      let common = group.first().options
      common.insert("flow", if force-page { "page" } else { auto })
      common.insert("_page-ready", cols > 1)
      // `cjk-vertical-flow-streams` uses this only to keep a first-page
      // layout hand-off isolated from every other vertical surface.
      common.insert(
        "_surface-id",
        if surface-id == none { repr(group) } else { surface-id },
      )
      cjk-vertical-flow-streams(
        streams,
        defaults: js-vertical-config.get(),
        ..common,
      )
    }
    if cols == 1 {
      render
    } else {
      {
        set page(columns: 1, margin: single-page-margins)
        render
      }
    }
  }

  let render-horizontal-run(nodes) = {
    if nodes.len() == 0 { return [] }
    // This rule is deliberately installed only for horizontal segments.
    // Page/local `jsvert` renderers receive the unchanged Basho-compatible
    // token above, rather than an opaque Rubby box.
    show metadata: it => {
      let value = it.value
      if type(value) != dictionary or not value.at(_js-ruby-marker, default: false) {
        return it
      }
      _js-horizontal-ruby(
        value.at("ruby"), value.at("text"),
        alignment: value.at("alignment", default: auto),
        dy: value.at("dy", default: 0em),
      )
    }
    nodes.sum(default: [])
  }

  let segment-body(source, surface-scope: "root") = {
    let source-classification = if (
      type(source) == content and repr(source.func()) == "styled"
    ) { classify-flow-node(source) } else { none }
    if (
      type(source) == content and repr(source.func()) == "styled" and source-classification.contains
    ) {
      let fields = source.fields()
      return source.func()(
        segment-body(
          fields.child,
          surface-scope: surface-scope,
        ),
        fields.styles,
      )
    }
    let output = ()
    let horizontal = ()
    let vertical = ()
    let pending-empty = ()
    let geometry = none
    let surface-index = 0
    let structural-index = 0

    for node in flatten-flow(source) {
      let classified = classify-flow-node(node)
      let structural-style = (
        type(node) == content and repr(node.func()) == "styled" and classified.contains
      )
      if structural-style {
        if vertical.len() > 0 {
          surface-index += 1
          output.push(render-vertical-group(
            vertical,
            surface-id: surface-scope + ":" + str(surface-index),
          ))
          vertical = ()
          geometry = none
          pending-empty = ()
        }
        if horizontal.len() > 0 {
          output.push(render-horizontal-run(horizontal))
          horizontal = ()
        }
        structural-index += 1
        output.push(segment-body(
          node,
          surface-scope: surface-scope + "." + str(structural-index),
        ))
        continue
      }
      let extracted = classified.vertical
      if extracted != none {
        for payload in extracted {
          let next-geometry = vertical-geometry(payload)
          let starts-page = next-geometry.at("page-start")
          if vertical.len() > 0 and (starts-page or next-geometry != geometry) {
            surface-index += 1
            output.push(render-vertical-group(
              vertical,
              surface-id: surface-scope + ":" + str(surface-index),
            ))
            vertical = ()
            geometry = none
            pending-empty = ()
          }
          if vertical.len() == 0 {
            if horizontal.len() > 0 {
              output.push(render-horizontal-run(horizontal))
              horizontal = ()
            }
            geometry = next-geometry
          }
          vertical.push(payload)
        }
      } else if is-empty-flow-node(node) and vertical.len() > 0 {
        pending-empty.push(node)
      } else {
        if classified.contains {
          panic(
            "jsvert: page-flow vertical text must occur in the top-level book flow; "
              + "use flow: \"inline\" or flow: \"region\" inside figures, tables, boxes, and other local containers"
              + ". Trapped outer element: "
              + if type(node) == content { repr(node.func()) } else { repr(type(node)) },
          )
        }
        if vertical.len() > 0 {
          surface-index += 1
          output.push(render-vertical-group(
            vertical,
            surface-id: surface-scope + ":" + str(surface-index),
          ))
          vertical = ()
          geometry = none
          // Whitespace separating a vertical surface from the next visible
          // horizontal node is structural, not a new empty paragraph.
          pending-empty = ()
        } else {
          horizontal += pending-empty
          pending-empty = ()
        }
        horizontal.push(node)
      }
    }
    if vertical.len() > 0 {
      surface-index += 1
      output.push(render-vertical-group(
        vertical,
        surface-id: surface-scope + ":" + str(surface-index),
      ))
      vertical = ()
      pending-empty = ()
    }
    horizontal += pending-empty
    if horizontal.len() > 0 {
      output.push(render-horizontal-run(horizontal))
    }
    output.sum(default: [])
  }


  segment-body
}
