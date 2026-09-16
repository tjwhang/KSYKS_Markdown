// src/main.typ
// Implementation — all functions re-exported through lib.typ

#import "layout/layout.typ": layout-tate
#import "layout/region.typ": (
  layout-tate-region, layout-tate-region-rows, measure-tate-region-width,
  plan-tate-region-prepared, render-tate-region-plan,
)
#import "layout/regions.typ": layout-tate-regions
#import "layout/metrics.typ": prepare-layout
#import "pipeline/flatten.typ": flatten
#import "pipeline/transform.typ": apply-transforms
#import "pipeline/classify.typ": apply-classifiers
#import "config.typ": (
  default-categories, default-opts, default-rendering-params, merge-config,
  validate-user-config,
)
#import "kinsoku/kinsoku.typ": default-resolver
#import "utils/validate.typ": validate-config
#import "renderer/renderer.typ": render-char-token

#let prepare-config(config) = {
  if type(config) == dictionary and config.at("_basho-resolved", default: false) {
    return config
  }
  validate-user-config(config)
  let language = config.at("language", default: default-opts.language)
  let region = config.at("region", default: default-opts.region)
  let base = default-opts
  base.insert("language", language)
  base.insert("region", region)
  base.insert("kinsoku", default-resolver(language: language, region: region))
  base.insert("space-width", if language == "ko" { 0.5em } else { 0.25em })
  let fallback = config.at(
    "unicode-vertical-fallbacks",
    default: default-opts.at("unicode-vertical-fallbacks"),
  )
  if "rendering" not in config {
    let rendering = (default-rendering-params(
      unicode-vertical-fallbacks: fallback,
    ),) + base.rendering.slice(1)
    base.insert("rendering", rendering)
  }
  if "categories" not in config {
    base.insert("categories", default-categories(
      latin_orientation: config.at(
        "latin-orientation",
        default: default-opts.at("latin-orientation"),
      ),
      tcy_max_digits: config.at(
        "tcy-max-digits",
        default: default-opts.at("tcy-max-digits"),
      ),
    ))
  }

  let cfg = merge-config(base, config)
  if cfg.at("space-width") == auto {
    cfg.insert("space-width", if language == "ko" { 0.5em } else { 0.25em })
  }
  if cfg.at("collapse-space-after-punctuation") == auto {
    cfg.insert("collapse-space-after-punctuation", language == "ko")
  }
  // Appending list renderers is local and deterministic. Mutating the shared
  // rendering array made repeated/nested calls accumulate modules.
  cfg.insert("rendering", cfg.rendering + (cfg.list.bullet, cfg.list.numbered))
  // Rendering modules remain independently configurable, but token rendering
  // is a hot path. Resolve their first-match dispatch policy once here instead
  // of searching every module for every glyph on every layout pass.
  let node-renderers = (:)
  for module in cfg.rendering {
    if "node-renderers" in module {
      for (kind, renderer) in module.node-renderers {
        if kind not in node-renderers { node-renderers.insert(kind, renderer) }
      }
    }
  }
  cfg.insert("node-renderers", node-renderers)
  validate-config(cfg)
  cfg.insert("_basho-resolved", true)
  cfg
}

/// Builds an immutable, fully resolved Basho configuration once. Passing this
/// record to any rendering entry point avoids repeating default assembly,
/// module dispatch creation, and validation.
#let basho-config(config) = prepare-config(config)

/// Forces a sequence of characters to be rendered as Tate-chu-yoko (inline horizontal).
///
/// - body (content): The text or content to render horizontally.
/// -> content: Metadata tag instructing the engine to render as TCY.
#let tcy(body) = metadata((type: "tcy", text: body, forced: true))

/// Forces content to be rendered as a single character box.
///
/// - body (content): The content to render in a single character box.
/// -> content: Metadata tag instructing the engine to render as a character box.
#let char(body) = metadata((type: "char", text: body))

/// Forces a sequence of characters to be rendered upright (vertical), one per box.
/// Useful for short Latin abbreviations (e.g. "JIS") that should appear upright
/// in vertical text rather than rotated.
///
/// - body (content): The text or content to render upright.
/// -> content: Metadata tag instructing the engine to render as upright chars.
#let vert(body) = metadata((type: "tcy", text: body, forced: "char"))

/// Renders arbitrary content rotated 90 degrees clockwise.
/// Useful for vertical equations, figures, or nested blocks where you want
/// to preserve native font settings.
///
/// - body (content): The content to rotate.
/// -> content: Metadata tag instructing the engine to render as rotated content.
#let turn(body) = metadata((type: "turn", text: body))

/// Renders arbitrary content rotated 90 degrees clockwise without restricting width.
/// Ideal for multiline equations or block elements that stretch horizontally forever.
#let vblock(body) = metadata((type: "vblock", text: body))

/// Renders arbitrary content upright (not rotated) in the middle of a paragraph.
/// Ideal for figures, images, or elements that should maintain their original orientation.
#let hblock(body) = metadata((type: "hblock", text: body))

/// Attaches phonetic ruby (furigana) to base characters.
///
/// - body (content): The base text or content (e.g. "漢字").
/// - rt (content): The ruby text or content (e.g. "かんじ").
/// -> content: Metadata tag instructing the engine to render with ruby.
#let ruby(body, rt) = metadata((type: "ruby", text: body, ruby: rt))

/// Renders native Typst content vertically (tategaki / 縦書き).
///
/// - body (content | str): The content to render vertically.
/// - config (dictionary): Custom Dependency Injection configuration.
/// -> content: Vertically rendered paginated content.
#let prepare-tate(body, config: (:)) = {
  let cfg = prepare-config(config)
  let tokens = flatten(body, cfg)
  tokens = apply-transforms(tokens, cfg)
  tokens = apply-classifiers(tokens, cfg)

  (tokens: tokens, config: cfg)
}

/// Resolve the exact intrinsic height of a prepared inline strip without
/// constructing its thousands of glyph boxes. Opaque caller content is still
/// measured by the shared metric pipeline.
#let tate-inline-height(prepared) = {
  let layout = prepare-layout(prepared.tokens, prepared.config)
  layout.tokens.map(token => token.layout-height + token.space-after).sum(default: 0pt)
}

/// Resolve the height required by the longest explicitly separated vertical
/// line. Unlike an inline strip, a region renders newline/parbreak segments
/// side by side, so summing those segments would reserve invisible height.
#let tate-region-natural-height(prepared) = {
  let layout = prepare-layout(prepared.tokens, prepared.config)
  let longest = 0pt
  let current = 0pt
  for token in layout.tokens {
    if token.type in ("newline", "parbreak") {
      longest = calc.max(longest, current)
      current = 0pt
    } else if token.type != "heading-anchor" {
      current += token.layout-height + token.space-after
    }
  }
  calc.max(longest, current)
}

/// Renders an immutable prepared stream. Source traversal and language
/// transforms are shared by all finalized continuation pages.
#let tate-prepared(
  prepared,
  part: "all",
  initial-height: auto,
) = {
  let cfg = prepared.config

  if cfg.at("page-start", default: false) {
    pagebreak(weak: true)
  }
  layout-tate(
    prepared.tokens,
    cfg,
    part: part,
    initial-height: initial-height,
  )
}

#let tate(
  body,
  config: (:),
  part: "all",
  initial-height: auto,
) = {
  tate-prepared(
    prepare-tate(body, config: config),
    part: part,
    initial-height: initial-height,
  )
}

/// Renders native Typst content vertically inline (no pagination).
/// Use when you need vertical text inside shapes or inline blocks.
///
/// - body (content | str): The content to render vertically.
/// - config (dictionary): Custom Dependency Injection configuration.
/// -> content: Inline vertical stack of rendered glyphs.
#let tate-inline-prepared(prepared) = {
  let cfg = prepared.config
  let rendered = prepared.tokens
    .filter(token => (
      token.type != "newline"
        and token.type != "parbreak"
        and token.type != "heading-anchor"
    ))
    .map(token => render-char-token(token, cfg))

  // An inline vertical strip must be atomic. A naked stack can be fragmented
  // or acquire paragraph line geometry when two strips are source-adjacent.
  let region = box(
    inset: 0pt,
    stack(dir: ttb, spacing: cfg.sizing.tracking, ..rendered),
  )
  // A vertical region is an RTL inline object. Directional marks are part of
  // Basho's region primitive (not a caller-side sibling heuristic), allowing
  // consecutive independent tate-inline calls to read right-to-left.
  [‏#region‏]
}

#let tate-inline(body, config: (:)) = {
  tate-inline-prepared(prepare-tate(body, config: config))
}

/// Renders one vertical stream into a fixed-height intrinsic-width region.
/// This is the safe primitive for placing independent streams side by side;
/// it emits no page breaks and retains the normal paginator and kinsoku rules.
#let tate-region-width(prepared, height) = {
  measure-tate-region-width(prepared.tokens, height, prepared.config)
}

#let tate-region-plan-prepared(prepared, height) = {
  plan-tate-region-prepared(prepared, height)
}

#let tate-region-from-plan(plan, height) = {
  render-tate-region-plan(plan, height)
}

#let tate-region-prepared(prepared, height) = {
  layout-tate-region(prepared.tokens, height, prepared.config)
}

#let tate-region-rows-prepared(
  prepared,
  available-height,
  full-height,
  width,
  rows: 1,
  row-gap: 2em,
  row-fit-threshold: 1.5,
) = {
  layout-tate-region-rows(
    prepared.tokens,
    available-height,
    full-height,
    width,
    rows,
    row-gap,
    row-fit-threshold,
    prepared.config,
  )
}

#let tate-region(body, height, config: (:)) = {
  tate-region-prepared(prepare-tate(body, config: config), height)
}

/// Compose multiple independent streams in a page region and continue their
/// unconsumed lines on later pages. Each stream is `(body:, config:)`.
#let prepare-tate-streams(streams) = streams.map(stream => {
  prepare-tate(stream.body, config: stream.at("config", default: (:)))
})

#let tate-regions-natural-height(prepared) = if prepared.len() == 0 {
  0pt
} else {
  calc.max(..prepared.map(stream => tate-inline-height(stream)))
}

#let tate-regions-natural-width(prepared, height, gap: 1em) = {
  if prepared.len() == 0 { return 0pt }
  let total = 0pt
  for stream in prepared { total += tate-region-width(stream, height) }
  total + calc.max(0, prepared.len() - 1) * measure(h(gap)).width
}

#let tate-regions-intrinsic-prepared(prepared, height, gap: 1em, width: auto) = {
  let regions = prepared.map(stream => box(tate-region-prepared(stream, height)))
  let content = stack(dir: rtl, spacing: gap, ..regions)
  if width == auto {
    content
  } else {
    box(width: width, height: height, align(right + top, content))
  }
}

#let tate-regions-prepared(
  prepared,
  height,
  full-height,
  width,
  gap: 1em,
  columns: 1,
  rows: 1,
  column-gap: 2em,
  row-gap: 2em,
  row-fit-threshold: 1.5,
  line-overhang-threshold: 0.5em,
  part: "all",
) = {
  layout-tate-regions(
    prepared,
    height,
    full-height,
    width,
    gap,
    columns,
    rows,
    column-gap,
    row-gap,
    row-fit-threshold,
    line-overhang-threshold,
    part: part,
  )
}

#let tate-regions(
  streams,
  height,
  full-height,
  width,
  gap: 1em,
  columns: 1,
  rows: 1,
  column-gap: 2em,
  row-gap: 2em,
  row-fit-threshold: 1.5,
  line-overhang-threshold: 0.5em,
  part: "all",
) = tate-regions-prepared(
  prepare-tate-streams(streams),
  height,
  full-height,
  width,
  gap: gap,
  columns: columns,
  rows: rows,
  column-gap: column-gap,
  row-gap: row-gap,
  row-fit-threshold: row-fit-threshold,
  line-overhang-threshold: line-overhang-threshold,
  part: part,
)
