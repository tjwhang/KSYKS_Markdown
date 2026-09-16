# Migrating to jsarticle V2

V2 has one public book entry point and one validated configuration record:

```typst
#import "jsarticle.typ": *

#show: jsarticle-book.with(
  options: jsarticle-options(
    document: (...),
    page: (...),
    typography: (...),
    fonts: (...),
    horizontal: (...),
    vertical: (...),
  ),
)
```

Flat arguments to `jsarticle-book` are intentionally unsupported. This makes
misspellings fail at the public boundary and prevents the page, font, and
vertical systems from each maintaining a competing copy of the same setting.

For the complete API, behavior, and implementation guide, see
[jsarticle V2 guide](jsarticle-v2.md), [framework guide](framework.md),
[API reference](api-reference.md), and
[internal architecture](internals.md).

## Old-to-new mapping

| Earlier flat setting | V2 path |
| --- | --- |
| `title`, `subtitle`, `author`, `authors`, `other`, `date`, `logo`, `abstract`, `keywords`, `title-page`, `author-layout` | `document.*` |
| `paper-size`, `bind`, `margin-ratio`, `doc-type`, `cols`, `h1-break`, `column-gutter`, `chapter-format` | `page.*` |
| `font-size`, `text-width`, `marginal-outset`, `lines-per-page`, `baseline-ratio`, `cjk-height`, `cjk-scale`, `latin-light-weight`, language scales/leading ratios, math options, shared optical settings, `cjk-spacing` | `typography.*` |
| `font-common`, `font-western`, `font-hangul`, `font-han-kr`, `font-han-ja`, `font-kana`, `font-han-sc`, `font-han-tc` | Removed. Define physical `jsface` values and use `jsfontset-extend` or `jsfontset-override` to build `fonts.composites`. |
| `cjk-role-adjustments`, font-name-based Latin adjustments | Removed. Put font-specific baseline, tracking, and scale on the corresponding `jsface` or a composite rule. |
| `body-family`, `strong-family`, `heading-family`, `footnote-family`, `strong-weight` | `fonts.body-family`, `fonts.strong-family`, `fonts.heading-family`, `fonts.footnote-family`, `fonts.strong-weight` |
| `horizontal-normalization` | `horizontal.normalization` |
| `vertical` | `vertical` |

## Vertical wrapper migration

`jsvert` is the only public vertical-writing wrapper. The former
`jsvert-page`, `jsvert-inline`, and `wrapper-gap` APIs have no compatibility
aliases.

```typst
// Earlier
#jsvert-inline[短冊]

// V2
#jsvert(flow: "inline")[短冊]
```

Use `flow: "region"` with `region-height:` for a bounded local vertical
region, and use the default `flow: auto` or `flow: "page"` only at the
top-level book flow. Consecutive compatible page-flow calls automatically form
one right-to-left vertical surface.

## CJK V3 composite migration

CJK V3 removes the old language-owned `fonts.common`, `fonts.western`,
`fonts.hangul`, `fonts.han-*`, and `fonts.kana` records. Keep each document's
physical choices in a document-owned `fonts.typ`, declare them with `jsface`,
and replace only the affected role composites.

```typst
// fonts.typ
#import "jsarticle.typ": jsface, jsfontset-override, js-default-composites

#let essay-mincho = jsface("Essay Mincho", optics: (
  hangul: (baseline: -0.07em, tracking: -0.04em),
))

#let document-composites = (
  serif: jsfontset-override(
    js-default-composites.serif,
    hangul: essay-mincho,
  ),
)
```

Then import `document-composites` in the document and provide it as
`fonts.composites`. Omitted roles—including the framework footnote composite
using ChosunilboNM and Heisei Mincho—remain intact. Language and region belong
to the framework's ordered composite rules; document files only replace
physical faces or whole roles.
