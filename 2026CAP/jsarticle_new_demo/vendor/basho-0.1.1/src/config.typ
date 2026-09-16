// src/config.typ
// Configuration state and merge engine for Basho DI architecture

#import "kinsoku/kinsoku.typ": default-resolver
#import "components/tcy.typ": default-tcy
#import "kinsoku/spacing.typ": default-spacing

// ---------------------------------------------------------------------------
// Default rendering module factory — self-contained
// ---------------------------------------------------------------------------

/// Default rendering module factory.
/// Bundles character normalization, dash scaling, and custom node renderers.
///
/// - dash-scale (length): Font size for horizontal-bar character. Default: 1.25em.
/// - node-renderers (dictionary): Custom token-type renderers. Default: (:).
/// -> dictionary: A rendering module dict with `dash-scale`, `node-renderers`, and `transform`.
#let default-rendering-params(
  dash-scale: 1.25em,
  node-renderers: (:),
  unicode-vertical-fallbacks: false,
  collapse-space-after-punctuation: auto,
) = {
  (
    dash-scale: dash-scale,
    node-renderers: node-renderers,
    unicode-vertical-fallbacks: unicode-vertical-fallbacks,
    transform: (tokens, config) => {
      let vertical-map = (
        "(": "︵", ")": "︶",
        "（": "︵", "）": "︶",
        "[": "﹇", "]": "﹈",
        "［": "﹇", "］": "﹈",
        "{": "︷", "}": "︸",
        "｛": "︷", "｝": "︸",
        "<": "︿", ">": "﹀",
        "〈": "︿", "〉": "﹀",
        "〔": "︹", "〕": "︺",
        "【": "︻", "】": "︼",
        "《": "︽", "》": "︾",
        "〖": "︗", "〗": "︘",
        "!": "︕", "！": "︕",
        "?": "︖", "？": "︖",
        "、": "︑", "，": "︐", "。": "︒", "．": "︒",
        "｡": "︒", "､": "︑",
        ";": "︔", "；": "︔",
        ":": "︓", "：": "︓",
        "…": "︙", "‥": "︰",
        "—": "︱", "―": "︱", "–": "︲",
        "･": "・", "~": "～",
        "‘": "﹁", "’": "﹂",
        "“": "﹃", "”": "﹄",
        "『": "﹃", "』": "﹄",
        "「": "﹁", "」": "﹂",
      )

      let cjk-cluster = regex("^[\p{scx:Hangul}\p{scx:Han}\p{scx:Hiragana}\p{scx:Katakana}\p{scx:Bopomofo}]$")
      let latin-cluster = regex("^[\p{sc:Latn}\p{sc:Cyrl}\p{sc:Grek}0-9]$")
      let token-script(t) = if t.type == "char" and type(t.text) == str {
        if t.text.match(cjk-cluster) != none { "cjk" } else if (
          t.text.match(latin-cluster) != none
        ) { "western" } else { none }
      } else if t.type in ("tcy", "turn") {
        "western"
      } else { none }
      let region = config.at("region", default: none)
      let upper-region = if region == none { "" } else { upper(region) }
      let contextual-punctuation(mark) = if config.language == "zh" {
        if ("TW", "HK", "MO").contains(upper-region) {
          if mark == "," { "、" } else { "。" }
        } else {
          if mark == "," { "，" } else { "。" }
        }
      } else {
        if mark == "," { "、" } else { "。" }
      }
      let apply-vertical-fallback(mark) = if (
        unicode-vertical-fallbacks and mark in vertical-map
      ) { vertical-map.at(mark) } else { mark }

      let result = ()
      let previous-script = none
      let suppress-next-space = false
      // Cache the next substantive script once. Looking it up with
      // `tokens.slice(index + 1)` at every space copied large suffixes and made
      // space-rich Korean input scale quadratically.
      let next-scripts-reversed = ()
      let next-substantive = none
      for t in tokens.rev() {
        next-scripts-reversed.push(next-substantive)
        if t.type in ("newline", "parbreak") {
          next-substantive = none
        } else {
          let script = token-script(t)
          if script != none { next-substantive = script }
        }
      }
      let next-scripts = next-scripts-reversed.rev()
      for (index, t) in tokens.enumerate() {
        if (
          suppress-next-space
            and t.type == "char"
            and type(t.text) == str
            and t.text == " "
        ) {
          suppress-next-space = false
          continue
        }
        suppress-next-space = false
        if t.type in ("newline", "parbreak") {
          result.push(t)
          previous-script = none
        } else if t.type == "char" and type(t.text) == str {
          let new-text = t.text
          if new-text == " " {
            let next-script = next-scripts.at(index)
            let fullwidth = (
              config.language == "ko"
                and config.at("korean-fullwidth-cjk-spaces", default: false)
                and previous-script != "western"
                and next-script != "western"
                and (previous-script == "cjk" or next-script == "cjk")
            )
            result.push(t + (space-width: if fullwidth { 1em } else {
              config.at("space-width", default: 0.5em)
            }))
            continue
          }
          if new-text == "—" or new-text == "─" { new-text = "―" }
          if (new-text == "," or new-text == ".") and previous-script == "cjk" {
            new-text = contextual-punctuation(new-text)
          }
          new-text = apply-vertical-fallback(new-text)
          result.push(t + (text: new-text))
          if config.at("collapse-space-after-punctuation", default: false) {
            suppress-next-space = "、。，．︐︑︒".contains(new-text)
          }
          if t.text.match(cjk-cluster) != none {
            previous-script = "cjk"
          } else if t.text.match(latin-cluster) != none {
            previous-script = "western"
          }
        } else if (
          t.type == "tcy" and type(t.text) == str
            and not t.at("forced", default: false)
        ) {
          // ASCII punctuation is initially part of a Western run. Split only
          // a comma/full stop whose preceding substantive character is CJK;
          // decimal points and punctuation following Western text remain in
          // the rotated run.
          let western-run = ""
          for cluster in t.text.clusters() {
            if (cluster == "," or cluster == ".") and previous-script == "cjk" {
              if western-run != "" {
                result.push(t + (text: western-run))
                western-run = ""
              }
              let mark = apply-vertical-fallback(contextual-punctuation(cluster))
              result.push(t + (type: "char", text: mark))
              if config.at("collapse-space-after-punctuation", default: false) {
                suppress-next-space = true
              }
            } else {
              western-run += cluster
              // The converted mark is no longer the immediate predecessor;
              // never eat a later space after intervening Western text.
              suppress-next-space = false
              if cluster.match(latin-cluster) != none {
                previous-script = "western"
              } else if cluster.match(cjk-cluster) != none {
                previous-script = "cjk"
              }
            }
          }
          if western-run != "" { result.push(t + (text: western-run)) }
        } else {
          result.push(t)
        }
      }
      result
    },
  )
}

// ---------------------------------------------------------------------------
// Default sizing factory
// ---------------------------------------------------------------------------

/// Sizing parameters factory.
///
/// - char-box (length): Width/height of the character box. Default: 1em.
/// - ruby-size (length): Font size for ruby text. Default: 0.5em.
/// - ruby-offset (length): Horizontal offset for ruby text from the left edge. Default: 1em.
/// - heading-scales (array): Font scale factors for h1, h2, h3. Default: (1.5, 1.3, 1.15).
/// - tracking (length): Extra vertical letter spacing. Default: 0pt.
/// -> dictionary: A sizing dict.
#let default-sizing-params(
  char-box: 1em,
  ruby-size: 0.5em,
  ruby-offset: 1em,
  heading-scales: (1.5, 1.3, 1.15),
  tracking: 0pt,
) = {
  (
    char-box: char-box,
    ruby-size: ruby-size,
    ruby-offset: ruby-offset,
    heading-scales: heading-scales,
    tracking: tracking,
  )
}

// ---------------------------------------------------------------------------
// Default categories factory
// ---------------------------------------------------------------------------

/// Categories parameters factory.
/// Provides the TCY classification function used by the default TCY filter.
///
/// - classify (function): (text, config) => "horizontal" | "rotated" | "char".
///   Default: 1-2 digit numbers → "horizontal", rest → "rotated".
/// -> dictionary: A categories dict.
#let default-categories(
  latin_orientation: "rotate",
  tcy_max_digits: 2,
  classify: none,
) = {
  let classify-fn = if classify != none { classify } else { (text, config) => {
    if text.match(regex("^[0-9]+$")) != none and text.clusters().len() <= tcy_max_digits {
      return "horizontal"
    }
    if latin_orientation == "upright" { return "char" }
    return "rotated"
  } }
  (classify: classify-fn)
}

// ---------------------------------------------------------------------------
// Default layout factory
// ---------------------------------------------------------------------------

/// Layout parameters factory.
///
/// - width (auto | relative): Total width of the vertical-writing block.
/// - height (auto | relative): Total height of the full-page block.
/// - columns (int): Legacy alias for region columns. Default: 1.
/// - rows (auto | int): Number of region rows. Default: 1.
/// - columns-per-row (auto | int): Number of text regions across each row;
///   retained as a compatibility name. Each region contains multiple lines.
/// - gap (length): Gap between vertical text lines inside a region.
/// - column-gap (length): Horizontal gutter between text regions.
/// - row-gap (length): Vertical gutter between region rows.
/// - row-fit-threshold (float): Nominal-row interval used when fitting rows on
///   a partial page. With 1.5, one row fits through 1.5 nominal rows, two
///   through 3.0, and so on; a full region always uses all configured rows.
/// - paragraph-indent (length): First-line indent for each paragraph (字下げ). Default: 1em.
/// - paragraph-spacing (length): Extra spacing inserted between paragraphs. Default: 0em.
/// - orphan-lines (int): Minimum paragraph lines allowed at a page end. Default: 2.
/// - widow-lines (int): Minimum paragraph lines allowed at a page start. Default: 2.
/// - min-fragment-chars (int): Minimum CJK characters retained on either side
///   of an avoidable intra-run line break. Default: 2; 1 disables balancing.
/// - justify (bool): Stretch eligible CJK inter-character slots in automatic
///   non-final lines. Default: true.
/// - ruby-overflow ("reserve" | "overhang"): Whether a long ruby reading
///   reserves vertical advance or may paint beyond an isolated base. Default:
///   "reserve".
/// - ruby-overhang (length): Maximum paint overhang on each end of an
///   isolated ruby reading in "overhang" mode. Default: 0.5em.
/// - hooks (array): Array of (cols, font, gap, config) => content; last wins. Default: ().
/// -> dictionary: A layout config dict.
#let default-layout-params(
  width: auto,
  height: auto,
  columns: 1,
  rows: 1,
  columns-per-row: 1,
  gap: 0.6em,
  column-gap: 2em,
  row-gap: 2em,
  row-fit-threshold: 1.5,
  line-overhang-threshold: 0.5em,
  min-final-line-chars: 2,
  min-fragment-chars: 2,
  justify: true,
  ruby-overflow: "reserve",
  ruby-overhang: 0.5em,
  orphan-lines: 2,
  widow-lines: 2,
  paragraph-indent: 1em,
  paragraph-spacing: 0em,
  hooks: (),
) = {
  (
    width: width,
    height: height,
    columns: columns,
    rows: rows,
    columns-per-row: columns-per-row,
    gap: gap,
    column-gap: column-gap,
    row-gap: row-gap,
    row-fit-threshold: row-fit-threshold,
    line-overhang-threshold: line-overhang-threshold,
    min-final-line-chars: min-final-line-chars,
    min-fragment-chars: min-fragment-chars,
    justify: justify,
    ruby-overflow: ruby-overflow,
    ruby-overhang: ruby-overhang,
    orphan-lines: orphan-lines,
    widow-lines: widow-lines,
    paragraph-indent: paragraph-indent,
    paragraph-spacing: paragraph-spacing,
    hooks: hooks,
  )
}

#import "components/turn.typ": default-turn
#import "components/vblock.typ": default-vblock
#import "components/hblock.typ": default-hblock
#import "components/list.typ": (
  default-bullet-list-params, default-numbered-list-params,
)


// ---------------------------------------------------------------------------
// Default options
// ---------------------------------------------------------------------------

/// Default options dictionary for Basho.
#let default-opts = (
  language: "ja",
  region: none,
  font: none,
  punctuation-font: none,
  ruby-auto-pair: true,
  strong-font: none,
  heading-font: none,
  features: ("vert", "vrt2"),
  space-width: auto,
  cjk-western-gap: 0.25em,
  western-cjk-gap: 0.25em,
  unicode-vertical-fallbacks: false,
  collapse-space-after-punctuation: auto,
  korean-fullwidth-cjk-spaces: false,
  // Korean/Japanese particles that cannot begin a vertical line directly
  // after an inline Latin, raw, or equation atom. Empty by default so Basho
  // remains language-policy neutral outside a host template.
  inline-atom-particles: (ko: (), ja: ()),
  page-start: false,
  heading-mode: "semantic",
  latin-orientation: "rotate",
  tcy-max-digits: 2,
  sizing: default-sizing-params(),
  categories: default-categories(),
  layout: default-layout-params(),
  kinsoku: default-resolver(),
  tcy: (default-tcy(),),
  rendering: (
    default-rendering-params(),
    default-spacing(),
    default-turn,
    default-vblock,
    default-hblock,
  ),
  list: (
    bullet: default-bullet-list-params(),
    numbered: default-numbered-list-params(),
  ),
)

// Public configuration is deliberately strict at the package boundary. The
// rendering, TCY, kinsoku, and category modules remain open extension points;
// their internals are dependency-injection payloads rather than option schema.
#let validate-user-config(config) = {
  assert(type(config) == dictionary, message: "basho: config must be a dictionary")
  for key in config.keys() {
    if key not in default-opts {
      panic("basho: unknown config option config." + key)
    }
  }
  for key in ("sizing", "layout", "list") {
    if key in config {
      assert(
        type(config.at(key)) == dictionary,
        message: "basho: config." + key + " must be a dictionary",
      )
      let defaults = default-opts.at(key)
      for nested in config.at(key).keys() {
        if nested not in defaults {
          panic("basho: unknown config option config." + key + "." + nested)
        }
      }
    }
  }
}

// ---------------------------------------------------------------------------
// Merge engine
// ---------------------------------------------------------------------------

/// Recursively merges a user configuration dictionary into a base configuration.
/// Ensures nested dictionaries are merged rather than overwritten completely.
/// Arrays (like kinsoku, tcy, rendering) are replaced wholesale — this is
/// intentional so users can swap out entire module arrays.
///
/// - base (dictionary): The base configuration (e.g., default-opts).
/// - user (dictionary): The user's configuration overrides.
/// -> dictionary: The merged configuration.
#let merge-config(base, user) = {
  let result = base
  for (key, val) in user {
    if (
      key in result
        and type(result.at(key)) == dictionary
        and type(val) == dictionary
    ) {
      result.insert(key, merge-config(result.at(key), val))
    } else {
      result.insert(key, val)
    }
  }
  result
}
