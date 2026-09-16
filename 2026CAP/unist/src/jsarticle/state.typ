// The book publishes resolved geometry; components read it at their location.
#let js-body-height = state("jsarticle-body-height", none)
#let js-column-width = state("jsarticle-column-width", none)
#let js-marginal-outset = state("jsarticle-marginal-outset", none)
#let js-baseline = state("jsarticle-baseline", none)
#let js-current-fonts = state("jsarticle-current-fonts", none)
#let js-current-fontsets = state("jsarticle-current-fontsets", none)
#let js-single-page-margin = state("jsarticle-single-page-margin", auto)
#let js-vertical-config = state("jsarticle-vertical-config", (
  ambient-language: "ko",
  page-margin: auto,
  page-start: false,
  heading-mode: "semantic",
  unicode-vertical-fallbacks: false,
  collapse-space-after-punctuation: true,
  korean-fullwidth-cjk-spaces: false,
  boundary-spacing: 0.15em,
  inline-atom-particles: (ko: (), ja: ()),
  latin-orientation: "rotate",
  tcy-max-digits: 2,
  tracking: 0pt,
  ruby-size: 0.5em,
  ruby-gap: 0em,
  ruby-overflow: "reserve",
  ruby-overhang: 0.5em,
  width: auto,
  height: auto,
  columns: 1,
  rows: 1,
  line-gap: 0.6em,
  column-gap: 2em,
  row-gap: 2em,
  row-fit-threshold: 1.5,
  line-overhang-threshold: 0.5em,
  min-final-line-chars: 2,
  min-fragment-chars: 2,
  // Korean agglutinative prose benefits from fragment balancing and full
  // vertical justification. Other CJK languages retain their native kinsoku
  // defaults unless a book or wrapper opts them in explicitly.
  min-fragment-languages: ("ko",),
  justify-languages: ("ko",),
  justify: true,
  orphan-lines: 2,
  widow-lines: 2,
  stream-gap: 0.6em,
  font-family: "body",
  strong-family: "gothic",
  heading-family: "gothic",
  ruby-family: "body",
))
#let js-horizontal-normalization-config = state("jsarticle-horizontal-normalization-config", (
  language: "ko",
  enabled: false,
  punctuation: true,
  spaces: true,
  collapse-punctuation-space: true,
))
// Inline math/raw spacing needs neighbouring fragments, unlike ordinary font
// composition. Components that defer their bodies through `context` therefore
// opt into this contextual helper before the body becomes opaque. The book
// publishes the fully resolved policy below; outside jsarticle-book this is a
// deliberate no-op.
#let js-inline-boundary-config = state("jsarticle-inline-boundary-config", (
  gaps: (cjk-latin: none, math: none, raw: none),
  inline-atom-particles: (ko: (), ja: ()),
))

#let js-running-heads = state("js-running-heads", false)
