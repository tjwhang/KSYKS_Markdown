# Building documents with jsarticle

This guide explains the document-facing framework. It assumes V2: configure a
book with `jsarticle-options`, write normal Typst for horizontal content, and
use `jsvert` when text should be vertical.

## Minimal and practical setup

```typst
#import "jsarticle.typ": *

#show: jsarticle-book.with(
  options: jsarticle-options(
    document: (
      title: [Writing systems],
      subtitle: [A practical study],
      author: [Author],
      date: datetime.today().display(),
      title-page: "cover",
    ),
    page: (paper-size: "a4", cols: 1),
    typography: (ambient-language: "ko"),
  ),
)

= Introduction

This is regular Typst prose.
```

The show rule supplies page setup, headings, running heads, language-aware
composition, paragraphs, math defaults, and book components. Do not wrap the
body in another page or column rule unless creating a deliberately local Typst
object.

## Complete V2 configuration map

V2 accepts only `options: jsarticle-options(...)`. Each group is a dictionary;
unknown keys and invalid nesting are errors rather than silently ignored.

### `document`: metadata and title matter

| Key | Type / typical value | Effect |
| --- | --- | --- |
| `title`, `subtitle`, `author`, `other`, `date`, `logo` | content or text | Primary title-matter fields. |
| `authors` | array or `none` | Multi-author alternative to `author`. |
| `abstract` | content | Abstract shown by title layouts that support it. |
| `keywords` | array | Keywords for title matter. |
| `title-page` | `"cover"`, `"cover-vert"`, `"inline"` | Select title-matter composition. |
| `author-layout` | `"inline"` or supported layout name | Arrange author information in title matter. |

`cover-vert` derives title size from paper geometry and content length. It uses
vertical title composition without imposing a text boundary that would create
an accidental title/subtitle break.

### `page`: physical structure

| Key | Effect |
| --- | --- |
| `paper-size` | Named paper such as `"a4"`, `"a5"`, JIS B sizes, or a Typst size pair. |
| `bind` | Binding policy, including center/edge variants recognized by the template. |
| `margin-ratio` | Optical page-margin policy. |
| `doc-type` | Document profile such as article/novel; affects automatic type-area choices. |
| `cols` | Number of horizontal content columns. Never a vertical setting. |
| `column-gutter` | Gutter between horizontal columns. |
| `h1-break` | `"continuous"`, `"adaptive"`, or `"page"` chapter-start behavior. |
| `chapter-format` | Pair used to format numbered chapter labels. |

The template derives font size, body height, type width, and normal margins
from paper, document type, baseline parameters, and columns. Vertical page
surfaces use the resolved one-column margin, even in a `cols: 2` or `cols: 3`
book.

### `typography`: horizontal type and optical control

| Area | Keys |
| --- | --- |
| Geometry | `font-size`, `text-width`, `marginal-outset`, `lines-per-page`, `baseline-ratio`, `cjk-height`, `cjk-scale` |
| Language | `ambient-language`, `language-aware`, `japanese-scale`, `chinese-scale`, Korean/Western/Japanese/Chinese leading ratios |
| Latin | `latin-scale`, `latin-baseline`, `latin-tracking`, `latin-light-weight`, `strong-latin-scale`, `strong-latin-baseline` |
| Optical profiles | `optical-adjustments`, `optical-profiles` |
| Math and CJK spacing | `inline-math-display-style`, `inline-math-bounds`, `math-font`, `cjk-spacing` |

An optical profile is the shared language/category fallback for `scale`,
`baseline`, and `tracking`. Corrections that belong to a physical font belong
on that face instead; see the composite-font section below.

`typography.cjk-spacing` controls horizontal boundaries around CJK prose. A
single length applies equally to CJK/Latin (including digits), CJK/inline-math,
and CJK/inline-raw adjacency. `auto` resolves each of those to `0.15em`; `none`
disables all of them. Use a record when the three measures should differ:

```typst
typography: (
  cjk-spacing: (
    cjk-latin: 0.15em,
    math: 0.12em,
    raw: 0.10em,
  ),
)
```

Omitted `math` and `raw` fields inherit `cjk-latin`. Any individual field may be `none`. Gaps are
inserted only at direct CJK adjacency, never on top of an explicit source
space, and block equations/raw remain untouched. The same visitor descends
through paragraph children and grid/table children in figures, boxes, links,
and other component containers, rebuilding only the changed content branch.

`typography.inline-atom-particles` prevents an inline math/raw/Latin atom from
ending a line immediately before a Korean or Japanese particle. It is `auto`
by default and uses built-in `ko` and `ja` lists; `none` disables the rule, and
a record replaces either language list. The protected unit is only the atom
plus the matched particle, so a normal break remains legal afterwards. In
vertical writing the same rule is active only when `justify: true` is resolved
for that stream.

```typst
typography: (
  inline-atom-particles: (
    ko: ("은", "는", "을", "를"),
    ja: ("は", "が", "を", "に", "で"),
  ),
)
```

```typst
typography: (
  ambient-language: "ko",
  cjk-scale: 0.925em,
  optical-profiles: (
    ko: (
      hangul: (baseline: -0.07em, tracking: -0.08em),
      punctuation: (baseline: 0.08em),
    ),
  ),
)
```

These adjustments are deliberately local. A Hangul adjustment does not alter
Kana, Han, or Latin; a punctuation adjustment can be set without moving the
full CJK run.

Set `latin-light-weight: true` to request the font's named light face, or pass
a numeric variable-font weight such as `350`. It applies to ordinary Latin,
Greek, Cyrillic, and digits in the resolved `body` role only. It leaves CJK
text, headings, other named font roles, and semantic strong text unchanged.
Typst selects the nearest available weight when the body family cannot supply
the requested value.

```typst
typography: (
  latin-light-weight: 350,
)
```

### `fonts`: composites first, locale conditions inside rules

`jsface` describes one physical font and its optical values. `jsfontset` is an
ordered routing rule list. A rule selects a face by category (`western`,
`number`, `hangul`, `han`, `kana`, `punctuation`, `symbol`, or `any`) and may
also constrain `lang` and `region`. The first matching rule wins.

jsarticle supplies `js-default-composites`, built from its own NCM, Arial,
Montserrat, KoPub, Hiragino, and Source Han faces. A document normally defines
only its physical replacements in `fonts.typ`:

```typst
#import "jsarticle.typ": jsface, jsfontset-override, js-default-composites

#let myungjo = jsface("Myungjo", optics: (
  hangul: (baseline: -0.07em, tracking: -0.04em),
  punctuation: (baseline: -0.07em),
))

#let document-composites = (
  serif: jsfontset-override(
    js-default-composites.serif,
    hangul: myungjo,
    punct-ko: myungjo,
  ),
)
```

```typst
#show: jsarticle-book.with(options: jsarticle-options(
  fonts: (
    composites: document-composites,
    body-family: "serif",
    strong-family: "gothic-bold",
    heading-family: "serif-bold",
  ),
))
```

`jsfontset-override` replaces named script/locale slots while retaining the
default rule order and fallback chain. Use `jsfontset-extend` when inserting a
new, more-specific rule. A punctuation rule is explicit, so it cannot claim an
adjacent Han or Hangul glyph.

For every grapheme, optical values resolve as: rule override, face category,
face common value, `typography.optical-profiles`, then neutral value. `auto`
falls through; explicit `0em` and scale `1` are real overrides. The former
script-stack configuration and `cjk-role-adjustments` do not exist.

Roles are `body`, `serif`, `serif-bold`, `gothic`, `gothic-bold`, `maru`,
`strong`, `heading`, `footnote`, `ruby`, and `title`. Use
`jsfont("gothic-bold")[...]` in components that require a role. The contextual
`js-font-family` accessor is a native-stack escape hatch; it does not itself
apply the face optics.

`fonts.ruby-family` selects the reading composite used by `#rb` in both writing
modes. Its default, `auto`, follows the resolved body family. Use
`fonts: (ruby-family: "footnote")` for note-style readings. It changes the
reading only; annotated base text retains its surrounding role.

### `horizontal`: normalization before composition

`horizontal.normalization` has `enabled`, `punctuation`, `spaces`, and
`collapse-punctuation-space`. When enabled, it normalizes horizontal CJK
punctuation/spacing while preserving each text node's language, region, font,
script, direction, and feature settings. It does not replace the language
profile compositor.

### `vertical`: shared page and local policy

| Category | Keys |
| --- | --- |
| Flow and heading | `page-start`, `heading-mode` |
| Language spacing | `unicode-fallbacks`, `collapse-punctuation-space`, `korean-fullwidth-spaces`, `boundary-spacing` |
| Orientation | `latin-orientation`, `tcy-max-digits` |
| Geometry | `tracking`, `width`, `height`, `columns`, `rows`, `line-gap`, `column-gap`, `row-gap`, `row-fit-threshold`, `line-overhang-threshold` |
| Break policy | `min-final-line-chars`, `min-fragment-chars`, `justify`, `orphan-lines`, `widow-lines` |
| Stream and roles | `stream-gap`, `font-family`, `strong-family`, `heading-family`, `ruby-family` |

`heading-mode: "semantic"` provides outline and running-head anchors for
vertical headings. `"visual"` preserves only their vertical appearance.
`justify: true` justifies eligible inter-character CJK gaps on automatic,
non-final lines. `stream-gap` is a minimum inter-stream separation: it is not
added on top of normal `line-gap`.

## Horizontal language-aware writing

Normal text uses the ambient language unless a range specifies another one:

```typst
Korean prose with #text(lang: "ja", region: "JP")[日本語の引用] and
#text(lang: "zh", region: "TW")[繁體中文].
```

The CJK layer dispatches by effective `text.lang` and region. It forms script
runs, selects the correct font-role stack, applies language-specific horizontal
features, optical corrections, paragraph profile, and CJK/Western boundary
spacing. Latin stays in the Western role; it is not replaced by a Japanese or
Korean body font merely because it appears next to CJK text.

Use `#jscjk-normalize[...]` when only normalization is wanted, and
`#jsstyle-bypass[...]` to protect locally special content from the language
composition pass. `#jsgrid` is a compatibility alias of `jscjk-normalize`, not
a physical grid.

## Vertical writing in normal documents

Use `jsvert`; the former `jsvert-page` and `jsvert-inline` names do not exist.

```typst
// Local label or figure content.
#jsvert(flow: "inline")[短冊]

// Local region that wraps within a block, figure, or grid cell.
#jsvert(flow: "region", region-height: 60mm)[
  この文章は指定されたローカル領域で左へ折り返す。
]

// Top-level automatic page flow.
#jsvert(language: "ja", region: "JP")[日本語の縦組]
#jsvert(language: "ko", region: "KR")[뒤따르는 한글 세로쓰기]
```

`inline` never emits a page break. Short labels are intrinsic; long material
uses the available local height and wraps left. `region` is also local and
never paginates; use `region-height:` as a length, ratio, or `auto`.

At the top-level book flow, `auto` tries a compact surface first and promotes
only material that needs it to page flow. `flow: "page"` always uses the
page-surface planner. Page-flow calls inside opaque local containers are an
error; choose local flow instead.

Consecutive compatible top-level `auto`/`"page"` calls share one right-to-left
surface. The first stream completes, then the next begins at the top of the
next line to the left. Visible horizontal content, explicit breaks,
`page-start: true`, and geometry changes end the group.

### Per-call vertical overrides

Every stream can set language/profile, grid, font, and break-policy fields
without changing the book default. Local flows additionally accept direct
Basho paragraph-layout fields:

```typst
#jsvert(
  flow: "region",
  language: "ja",
  region: "JP",
  region-height: 60mm,
  rows: 2,
  columns: 1,
  row-gap: 2em,
  justify: false,
  paragraph-indent: 0em,
)[
  == A visual heading

  Display text begins flush because this stream overrides Basho paragraph
  indentation only for itself.
]
```

For `inline` and `region`, `paragraph-indent` and `paragraph-spacing` are
direct Basho layout overrides. They are separate from Typst's horizontal
`set par(...)` values. Shared page-flow streams currently carry the common
book paragraph policy; use a dedicated local region for display material such
as an epigraph that needs a different paragraph indent.

## Title and special matter

| Helper | Use |
| --- | --- |
| `jspart(title, num: none)` | Odd-page part divider, outline anchor, and centered title. |
| `jsicover(title, subtitle: none, author: none, size: 2.7em)` | A standalone inner cover page. |
| `jsdinkus(sym: "*　*　*")` | Centered scene/section divider with vertical space. |
| `transnote(body)` | Translation-note marker plus footnote, with its independent counter. |

`transnote` coordinates its own marker with the ordinary footnote counter so
the translation note marker does not consume the next ordinary footnote number.
Vertical footnote markers are rendered as vertical-aware token content by
Basho rather than consuming an entire character line.

## Quotations, epigraphs, and boxes

```typst
#jsepigraph(style: "vert", attribution: [Author])[Quote]
#jsquote(delim: "「", attribution: [Source])[Quoted passage]
#jsbox[Boxed explanatory content]
#jstopic(title: [Note])[A compact topic block]
```

`jsepigraph` accepts `style: "line" | "dash" | "vert"`,
`scope: "block" | "page"`, `align-x`, `width`, `region-height`,
`attribution`, and `delim`. Horizontal epigraphs default to no delimiter;
vertical epigraphs default to `「…」`. Their attribution is vertical too.
Automatic block-scope vertical epigraphs use their intrinsic local height up
to 30% of the available local area. Longer quotations wrap left at that cap,
so following body text resumes directly after the display rather than after a
tall single vertical line. Page-scope epigraphs retain a restrained 44%
height for intentional empty space. Its local `jsvert` call uses
`paragraph-indent: 0em`, so an epigraph begins flush rather than as prose.

`jsquote` supports `attribution`, `indent`, and a delimiter. `jsbox` removes
first-line paragraph indentation inside a stroked box. `jstopic` creates a
non-breakable compact topic heading and body. Allowed quote/epigraph delimiters
are `none`, `'`, `"`, `〈`, `《`, `「`, `『`, and `【`.

## Math, code, and small semantic helpers

| Helper | Meaning |
| --- | --- |
| `jsnnh1(title)` | Level-one heading without numbering. |
| `jsnnoh1(title)` | Level-one heading without numbering or outline entry. |
| `jsnneq` | Block equation constructor without numbering. |
| `jsans(content)` | Small framed answer/annotation label. |
| `jspnum(content)` | Simple problem number display. |
| `cjk-math(body, before:, after:, gap:)` | Explicit CJK-safe gap around inline math. |
| `cjk-raw(...)` | Alias for the same explicit raw/math gap contract. |

The book installs math fonts and numbering rules, preserves CJK prose within
mathematical/opaque content where necessary, and prevents the normal CJK show
rules from corrupting fixed-layout math metrics.

## Recommended author workflow

1. Select page and typography policy with the grouped V2 record.
2. Define script stacks and named roles only if project defaults are unsuitable.
3. Mark local language changes with `text(lang:, region:)` rather than changing
   fonts manually in every run.
4. Use `jsvert` only for vertical text; choose local flows in figures/boxes.
5. Keep page-flow `jsvert` at top level and let consecutive wrappers group.
6. Add a minimal fixture before changing an option whose effect is subtle.

For the exact function signatures see [API reference](api-reference.md). For
why the engine makes these decisions see [internal architecture](internals.md).
