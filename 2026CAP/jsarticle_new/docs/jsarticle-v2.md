# jsarticle V2

`jsarticle` V2 uses three layers:

```text
jsarticle: pages, title matter, columns, headers, body segmentation
    -> cjk: language policy, composite faces, writing-mode adaptation
        -> Basho: tokenization, breaking, pagination, glyph rendering
```

This is a strict ownership boundary. `jsarticle` owns physical pages, `cjk`
owns language and font adaptation, and Basho owns vertical token layout.

This page is the V2 orientation guide. Read the linked documents for the
complete framework contract:

- [Documentation index](README.md) for a task-oriented reading path.
- [Framework guide](framework.md) for every author-facing feature and option.
- [API reference](api-reference.md) for supported signatures and scopes.
- [Internal architecture](internals.md) for page segmentation, CJK adaptation,
  Basho pipeline stages, and the continuation invariants.
- [Migration guide](migration-v2.md) for the intentional V2 breaks.

## Getting started

Install one book show rule with one validated option record.

```typst
#import "jsarticle.typ": *

#show: jsarticle-book.with(
  options: jsarticle-options(
    document: (
      title: [A small book],
      subtitle: [Optional subtitle],
      author: [Author],
      title-page: "cover-vert",
    ),
    page: (paper-size: "a4", bind: "center", cols: 2, h1-break: "adaptive"),
    typography: (ambient-language: "ko", cjk-scale: 0.925em),
    fonts: (
      body-family: "serif",
      strong-family: "gothic",
      heading-family: "serif-bold",
      footnote-family: "footnote",
    ),
    vertical: (
      rows: 1,
      columns: 1,
      justify: true,
      min-fragment-chars: 2,
      min-final-line-chars: 2,
    ),
  ),
)

= First chapter
```

`jsarticle-options` recursively merges provided groups with V2 defaults. An
unknown key fails at the public boundary with its full path, for example
`options.page.colz`. The renderer receives this resolved record; do not rebuild
the former flat `jsarticle-book` arguments in document code.

## Public option groups

| Group | Responsibility | Main fields |
| --- | --- | --- |
| `document` | Metadata and title matter | `title`, `subtitle`, `author`, `authors`, `date`, `logo`, `abstract`, `keywords`, `title-page`, `author-layout` |
| `page` | Physical page and horizontal columns | `paper-size`, `bind`, `margin-ratio`, `doc-type`, `cols`, `h1-break`, `column-gutter`, `chapter-format` |
| `typography` | Type area, baseline, shared optical fallbacks, math | `font-size`, `text-width`, `lines-per-page`, `baseline-ratio`, `cjk-scale`, `latin-light-weight`, `ambient-language`, `optical-profiles`, `math-font`, `cjk-spacing` |
| `fonts` | Ordered role composites and aliases | `composites`, `body-family`, `strong-family`, `heading-family`, `footnote-family`, `ruby-family`, `strong-weight` |
| `horizontal` | CJK-aware horizontal normalization | `normalization.enabled`, `.punctuation`, `.spaces`, `.collapse-punctuation-space` |
| `vertical` | Shared `jsvert` policy | Grid, language spacing, line breaking, stream flow, and vertical font roles |

`typography.cjk-spacing` accepts `none`, `auto`, one length, or a record with
`cjk-latin`, `math`, and `raw`. A scalar applies to all three; its `cjk-latin`
measure also applies to CJK/digit pairs. `auto` is
`0.15em` for them; omitted `math`/`raw` fields inherit `cjk-latin`. It affects
only direct CJK adjacency with inline
math/raw and does not add a second gap where the source already contains
whitespace. Block math and block raw are not boundary atoms. The
post-composition boundary pass descends through content and grid/table child
arrays, so local component structure cannot suppress the same paragraph
behavior.

`typography.inline-atom-particles` is the horizontal agglutinative-break
policy. Its default `auto` lists bind a directly preceding inline math, raw, or
Latin atom to the following Korean/Japanese particle; `none` disables it; a
`(ko: (...), ja: (...))` record supplies replacement lists. The protected
no-break seam ends after the matched particle, not after the surrounding
phrase. In vertical writing it is enabled only for streams with resolved
`justify: true`.

`page.cols` controls horizontal Typst columns only. It never changes the
geometry or continuation margins of a page-flow vertical surface.

### Faces, composites, and roles

Physical faces and their optical calibration are separate from routing. Define
a `jsface` once per physical family; use `jsfontset` rules to specify coverage
and optional language/region conditions. Each role receives one direct
composite. Language remains a condition on a rule rather than another table of
Korean, Japanese, Chinese, and Western stacks.

The built-in composites are the fallback source. A document can extend them
without copying locale-sensitive Han and punctuation rules:

```typst
#let document-composites = (
  serif: jsfontset-override(
    js-default-composites.serif,
    hangul: jsface("My Face", optics: (hangul: (baseline: -0.07em))),
  ),
)
```

The resolver applies the first matching active-composite rule, then consults
`common` once, then leaves glyph fallback to Typst. Optical precedence is rule,
face category, face common values, language/category profile, then neutral.
`auto` inherits; `0em` and scale `1` explicitly stop inheritance.

Inside an active book, a component can access the already-resolved role:

```typst
#let body = js-font-family("body")
#let heading = js-font-family("heading")
#let footnote = js-font-family("footnote")
#let all-roles = js-font-families()
```

These helpers are intentionally contextual. They fail outside `jsarticle-book`
because no role set has been installed. Prefer `jsfont("role")` for components:
it applies the selected composite and preserves its role identity through
nested layout. Use `js-font-family` only where native-stack access is required.

Keep a font-specific punctuation or Hangul correction on its face. Use
`typography.optical-profiles` only for the shared fallback policy when no face
or rule supplies that property. There are no role-wide CJK adjustment tables
or font-name-based Latin exceptions in V2.

Use `latin-light-weight: true` when ordinary Latin should use its font's named
light weight, or supply an integer variable-font weight such as `350`. It
applies only through the resolved `body` role and does not alter CJK glyphs,
other font roles, or semantic strong text.

### Vertical defaults

The `vertical` group supplies defaults for every `jsvert` call:

| Fields | Purpose |
| --- | --- |
| `page-start`, `heading-mode` | Page ownership and semantic versus visual heading anchors |
| `unicode-fallbacks`, `collapse-punctuation-space`, `korean-fullwidth-spaces`, `boundary-spacing` | Language-sensitive vertical spacing and substitution policy |
| `latin-orientation`, `tcy-max-digits` | Latin rotation/upright behavior and automatic TCY limit |
| `tracking`, `ruby-size`, `ruby-gap`, `ruby-overflow`, `ruby-overhang`, `width`, `height` | Character advance, vertical-ruby dimensions and overflow policy, and requested surface geometry |
| `columns`, `rows`, `line-gap`, `column-gap`, `row-gap`, `row-fit-threshold`, `line-overhang-threshold` | The vertical grid and line packing |
| `min-final-line-chars`, `min-fragment-chars`, `orphan-lines`, `widow-lines` | Runt and paragraph-fragment prevention |
| `justify` | Justify eligible CJK gaps on automatic non-final lines |
| `stream-gap` | Minimum separation of separate streams in a shared surface |
| `font-family`, `strong-family`, `heading-family`, `ruby-family` | Per-vertical font-role overrides; `ruby-family` styles the reading only |

`stream-gap` never accumulates a second gap after `line-gap`; the effective
stream separator is the larger of the two values.

## `jsvert`

`jsvert` is the only public vertical-writing wrapper:

```typst
#jsvert[Default automatic flow]
#jsvert(flow: "inline")[A local label]
#jsvert(flow: "region", region-height: 80mm)[A bounded local passage]
#jsvert(flow: "page")[Always use the page-surface planner]
```

Language, region, font roles, grid sizes, gaps, justification, and all
runt/orphan/widow settings can be overridden per call.

```typst
// Preferred: compatible top-level calls are collected automatically.
#jsvert(language: "ja", region: "JP")[日本語の先行ストリーム]
#jsvert(language: "ko", region: "KR")[뒤따르는 한글 스트림]

// Equivalent variadic form for programmatic stream construction.
#jsvert(
  (language: "ja", region: "JP", body: [日本語]),
  (language: "ko", region: "KR", body: [한글]),
)
```

### Flow behavior

| Flow | Valid location | Behavior |
| --- | --- | --- |
| `"inline"` | Any local container | A local vertical object. Short labels are intrinsic; longer content uses the available container height and wraps left. It never emits a page break. |
| `"region"` | Any local container | A local normal-flow region with `region-height:`. It reports its geometry to Typst and never emits a page break. |
| `auto` | Top-level book flow when promotion is possible | First tries an intrinsic one-column surface; if it cannot fit, it promotes to page flow. |
| `"page"` | Top-level book flow | Uses the same page-surface planner but always enables wrapping/pagination. |

Do not put page-flow `auto` or `"page"` inside a figure, table, grid, box, or
another opaque local container. Use `"inline"` or `"region"` there. The
classifier fails clearly rather than moving page-flow content with absolute
coordinates.

## Book-flow mechanics

For page-flow calls, `jsvert` emits an inert descriptor. The book body pass:

1. Flattens transparent sequences and `text(lang:, region:)` wrappers while
   preserving inherited language and region.
2. Collects adjacent compatible `auto` or `"page"` descriptors. Whitespace
   and empty paragraphs are ignored.
3. Ends a group at visible horizontal content, an explicit page/column break,
   `page-start: true`, or changed resolved surface geometry.
4. Sends the group to CJK as independent prepared streams.

Compatibility includes width/height, rows/columns, gaps, fit thresholds,
runt policy, and page-start policy. Language, region, fonts, heading mode,
punctuation behavior, and TCY remain per-stream.

The physical sequence is:

```text
horizontal columns -> full-width vertical surface -> horizontal columns
```

The first stream is exhausted before the second begins at the top of the next
vertical line to its left. Multi-column books always give a page-flow surface
normal one-column side margins. A compact surface may be followed by horizontal
content on the same page; a paginating surface owns its continuation pages and
horizontal flow resumes afterward.

## Vertical rendering pipeline

```text
Typst content
  -> Basho flatten
  -> rendering transforms
  -> TCY classification
  -> analytic metrics
  -> kinsoku-aware vertical lines
  -> shared stream/grid pagination
  -> glyph rendering
```

### Tokens and source identity

Basho flattens character clusters, spaces, explicit line/paragraph breaks,
headings, ruby, TCY, lists, equations, and opaque blocks into tokens. Every
printable source token retains a `source-index`. Continuation pages resume from
this identity; they never infer a cursor from drawn glyphs.

With `heading-mode: "semantic"`, Basho emits zero-size semantic heading
anchors for outline and running-head queries without drawing a duplicate
horizontal heading. `"visual"` leaves the heading visual only.

### Language, font, and TCY adaptation

CJK resolves each stream once into a validated Basho config: language/region,
body/strong/heading/punctuation fonts, vertical OpenType features, spacing,
orientation, and the language kinsoku resolver. Japanese, Korean, Simplified
Chinese, and Traditional Chinese streams can therefore share one surface while
keeping their own language and region conditions within their selected composites.

Rendering transforms run before TCY classifiers. Explicit helpers are present
when automatic classification is not wanted:

```typst
#cjk-tcy[24]
#cjk-upright[JIS]
#cjk-turn[rotated native Typst content]
#rb[かんじ][漢字]
```

`#rb[reading][base]` is the shared ruby interface. In horizontal text it uses
the vendored Rubby renderer, preserving its reading-first syntax and optional
`alignment:` argument. Inside `jsvert`, including inline and region flows, the
same marker is consumed by Basho as vertical ruby. Its base remains the atomic
line-breaking unit, but the reading retains `ruby-size` instead of being
compressed to the base span. Use `vertical.ruby-size` and `vertical.ruby-gap`
as book defaults, or override either per `#jsvert(...)`. `ruby-gap` is the
extra space after the base cell.

`vertical.ruby-overflow` controls an overlong reading. The default
`"reserve"` extends the prepared base/reading span symmetrically, which the
paginator sees before it selects a line or continuation page. `"overhang"`
allows an isolated unsegmented annotation to paint at most
`vertical.ruby-overhang` beyond each end; any excess still reserves space.
Consecutive ruby and `|`-aligned pairs always reserve space to avoid reading
collisions.

`fonts.ruby-family` selects the reading composite in both modes. It defaults to
the body family. `fonts: (ruby-family: "footnote")` uses the footnote composite
for horizontal Rubby and vertical Basho readings. `vertical.ruby-family` or a
per-`jsvert` `ruby-family:` override changes only that vertical stream.

The familiar Rubby separator is shared across both writing modes:
`#rb[신|체|발|부][身|體|髮|膚]` aligns each reading segment with its matching
base segment. The `|` characters are separators and never print. Both sides
must contain the same number of segments; otherwise the call retains ordinary
whole-word ruby behavior.

### Metrics and break decisions

`prepare-layout` resolves character-box, tracking, paragraph-indent, and
paragraph-spacing lengths once. Ordinary glyphs use analytic cell metrics;
only opaque material, such as equations or arbitrary rotated content, is
measured. This avoids contextual measurement of every glyph.

The paginator constructs top-to-bottom vertical lines. An ordinary space is a
discardable legal boundary and is never left at the head of the next line.
Explicit newline and paragraph-break tokens force boundaries; repeated breaks
intentionally preserve blank structural lines.

At overflow, it applies these safeguards in order:

1. `min-fragment-chars` tries to avoid a short CJK fragment on either side of
   an ordinary wrap.
2. Attached punctuation stays with preceding CJK text where possible.
3. The language kinsoku resolver chooses hanging punctuation, spacing
   compression/oikomi, or a legal push-back. Forbidden line starts/ends are
   avoided whenever a legal alternative exists.
4. `min-final-line-chars` may shorten the preceding automatic line to avoid a
   one-character final line.
5. `justify: true` distributes only eligible CJK gaps on automatic non-final
   lines. Use `false` for ragged vertical line ends.

These are safeguards, not an absolute word-boundary rule. Breaks like
`문자/문자` remain legal when available height and kinsoku make a
better break impossible, while space/punctuation and non-isolating boundaries
are preferred.

### Shared-stream continuation

For a grouped surface, Basho prepares each stream once and caches line widths,
paragraph metadata, and **cumulative** source endpoints. It fills the grid
right-to-left. Adjacent lines from one stream use `line-gap`; moving to another
stream uses the effective `stream-gap`.

Rows and columns divide the surface into independent cells. The first page may
have less remaining height, so its row count is fitted using
`row-fit-threshold`; continuation pages use the full configured grid.

The crucial invariant is: a stream whose cursor equals its prepared line count
is complete, even if the source ends in paragraph-break tokens. Cached source
ends are prefix maxima rather than local per-line values. A trailing blank line
therefore cannot restart completed Japanese text while a later Korean stream
continues.

## Direct CJK and Basho APIs

Use `jsvert` in documents. Use CJK/Basho directly only for reusable components
or templates that do not need book composition.

```typst
#import "cjk.typ": cjk-profile, cjk-vertical-inline, cjk-vertical-region

#let profile = cjk-profile(
  locale: (language: "ja", region: "JP"),
  fonts: (body: "Hiragino Mincho ProN"),
  vertical: (layout: (gap: 0.5em, min-fragment-chars: 2)),
)

#cjk-vertical-inline(profile: profile)[短冊]
#cjk-vertical-region(40mm, profile: profile)[領域内の縦組]
```

`cjk-profile` validates `locale` and `fonts`, inherits ambient language/region
from `auto`, then translates the profile into one Basho config.

```typst
#import "vendor/basho-0.1.1/lib.typ": basho-config, prepare-tate, tate-prepared

#let config = basho-config((
  language: "ko",
  layout: (min-fragment-chars: 2, justify: true),
))
#let prepared = prepare-tate([세로쓰기 검증입니다.], config: config)
#tate-prepared(prepared)
```

`basho-config` validates its known top-level, `sizing`, `layout`, and `list`
keys, resolves defaults and kinsoku once, and marks the record resolved.
`prepare-tate` returns reusable `(tokens:, config:)` data for
`tate-prepared`, `tate-region-prepared`, or `tate-regions-prepared`.

## Components and maintenance

```typst
#jsepigraph(style: "vert", scope: "block", attribution: [Author])[Quote]
#jsquote(delim: "「", attribution: [Source])[Quoted passage]
#jsbox[Boxed content]
```

`jsepigraph` accepts `style: "line" | "dash" | "vert"`,
`scope: "page" | "block"`, `align-x`, `width`, `region-height`,
`attribution`, and `delim`. Horizontal epigraphs default to no delimiter;
vertical epigraphs default to `「…」`, including their vertical attribution.
Automatic block-scope vertical epigraphs use their intrinsic local height up
to 30% of their local area, wrapping longer quotations left so the body can
resume below the display; page scope retains a deliberately restrained 44%
height. `jsquote` accepts `attribution`, `indent`, and
the delimiters `none`, `'`, `"`, `〈`, `《`, `「`, `『`, and `【`.

When changing internals:

- Add public options only to `jsarticle-default-options`; do not create a
  second defaults table in the renderer.
- Keep page ownership in `jsarticle`, language/font adaptation in `cjk`, and
  token layout in Basho. Basho must not import the book template.
- Preserve `source-index`, cumulative endpoints, and the paginator no-progress
  guard.
- Add a focused Typst fixture under `tests/`, compile with
  `typst compile --root .`, and visually inspect representative pages.
- Do not use absolute overlays, coordinate movement, location-query sibling
  collection, or mutable global state for page-flow vertical placement.

See `tests/mixed-vertical-continuation*.typ` for continuation coverage and
`tests/v2-*.typ` for option/CJK/Basho validation.
