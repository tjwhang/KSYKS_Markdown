// src/vblock.typ
#let render-vblock(token, config) = {
  let h = config.at("usable-height", default: auto)
  box(
    height: h,
    align(center + horizon, rotate(90deg, reflow: true, box(width: h, token.text))),
  )
}

#let default-vblock = (
  node-renderers: (
    "vblock": render-vblock,
  ),
)
