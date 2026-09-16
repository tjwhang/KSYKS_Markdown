# jsarticle V2 API reference

This page lists callable public APIs. Names beginning with an underscore are
internal. `auto` means inherit from surrounding context or book policy.

## Book

### `jsarticle-options(..groups) -> dictionary`

Creates the validated V2 record. Supported groups are `document`, `page`,
`typography`, `fonts`, `horizontal`, and `vertical`. All are optional and
unknown nested keys produce an error naming their complete option path.

`page.margin` accepts `auto` or `(inside:, outside:, top:, bottom:)`.
`page.header` and `page.footer` accept `auto`, `none`, or page content. An
explicit margin also determines the published column width used by local
components and adaptive frames.

### `jsarticle-book(options: jsarticle-options(), body) -> content`

The top-level show-rule function. It resolves page/type/font state, installs
horizontal composition, segments page-flow vertical descriptors, and renders
the full body.

jsarticle ships complete NCM/Arial/Montserrat/KoPub-based composites;
`fonts.composites` is optional. A document supplies only roles it wants to
replace, and those entries merge onto the framework catalogue. A composite is
an ordered set of rules; each rule chooses one physical `jsface` by category,
language, or region. The first matching rule supplies both the native font and
its optical values. Font-name lists and role-wide CJK adjustments are retired:
put a font's baseline, tracking, and scale on its face (or on one explicit
composite rule) instead.

`options.typography.latin-light-weight` accepts `false`, `true` (the named
light face), or an integer weight from `1` to `1000`, such as `350`. It affects
ordinary Latin, Greek, Cyrillic, and digit runs in the resolved `body` role
only.

`options.fonts.ruby-family` selects the composite for ruby readings in both
horizontal Rubby output and vertical Basho output. It defaults to `auto`
(the resolved body family). Set it to `"footnote"` to reuse the document's
footnote composite.

### `jsvert(body, ..options) -> content or page descriptor`

The only public vertical wrapper.

| Option family | Named options |
| --- | --- |
| Flow | `flow: auto | "inline" | "region" | "page"`; `region-height` |
| Locale/profile | `language`, `region`, `font-family`, `strong-family`, `heading-family`, `ruby-family`; native `font`, `strong-font`, `heading-font`, and `ruby-font` remain deliberate escape hatches |
| Geometry | `width`, `height`, `rows`, `columns`, `gap`, `column-gap`, `row-gap`, `row-fit-threshold`, `line-overhang-threshold` |
| Local paragraph layout | For `inline`/`region`, `paragraph-indent` and `paragraph-spacing` are Basho settings, not Typst `par` settings. |
| Break policy | `min-final-line-chars`, `min-fragment-chars`, `orphan-lines`, `widow-lines`, `justify` |
| Vertical behavior | `heading-mode`, `page-start`, `latin-orientation`, `tcy-max-digits`, `tracking`, `ruby-size`, `ruby-gap`, `ruby-overflow`, `ruby-overhang` |

The positional variadic form accepts `(body:, ..options)` stream dictionaries.
Separate compatible top-level calls are normally clearer.

## Resolved fonts and horizontal helpers

| Function | Result |
| --- | --- |
| `js-font-families()` | All resolved role stacks for the active book. |
| `js-font-family(family)` | One active-book role stack. |
| `jsface(name, baseline:, tracking:, scale:, optics:)` | One physical face. `optics` can override `western`, `number`, `hangul`, `han`, `kana`, `punctuation`, or `symbol`. |
| `jsfontset(..rules)` | Ordered composite. Rules require `face` and `covers`; may add `lang`, `region`, `fallbacks`, and rule-local `optics`. |
| `js-default-composites` | Complete built-in role catalogue. It is always available, even when a document has no `fonts.typ`. |
| `jsfontset-extend(base, ..rules)` | Put focused document rules before an existing role while retaining its built-in locale-routing rules and native fallback stack. |
| `jsfontset-override(base, western:, hangul:, han-ko:, ..., punct-ko:, ...)` | Face-only role override; jsarticle supplies the category, locale, and fallback rules. |
| `jsfont(role-or-fontset, ..text-options)[body]` | Apply a known document role or local composite while preserving its identity through nested layout. |
| `jsheading-anchor(title, level:, outlined:, destination:)` | Register an invisible component heading for outlines and references without article-heading geometry. |
| `jscjk-normalize(body, language:, punctuation:, spaces:, collapse-punctuation-space:, skip-features:)` | Horizontal CJK normalization only. |
| `jsgrid` | Compatibility alias for `jscjk-normalize`. |
| `jsstyle-bypass(body)` | Exclude local specialized content from CJK composition. |

## jsarticle components

| Function | Behavior |
| --- | --- |
| `transnote(body)` | Translation-note marker and footnote with independent counter. |
| `jspart(title, num: none)` | Odd-page part divider and outline anchor. |
| `jsicover(title, subtitle: none, author: none, size: 2.7em)` | Standalone cover page. |
| `jsdinkus(sym: "*　*　*")` | Centered scene/section divider. |
| `jsepigraph(attribution:, style:, scope:, align-x:, width:, region-height:, delim:, body)` | Line, dash, or bounded vertical epigraph. |
| `jsquote(attribution: none, indent: false, delim: none, body)` | Quote block with optional attribution. |
| `jsbox(body)` | Stroked box without horizontal first-line indent. |
| `jstopic(title: [], body)` | Compact non-breakable topic block. |
| `jsans(content)` | Small framed label. |
| `jsnnh1(title)` / `jsnnoh1(title)` | Unnumbered H1 / unnumbered unoutlined H1. |
| `jsnneq` | Unnumbered block equation constructor. |
| `jspnum(num)` | Prominent contextual page-number display. |
| `jsnumbering(format, ..args)` | Numbering helper with East-Asian substitutions. |

`jsepigraph.style` is `"line"`, `"dash"`, or `"vert"`. Its `scope` is
`"block"` or `"page"`. Vertical epigraphs default to `「…」`, use a vertical
attribution, use intrinsic block height capped at 30% or a 44% page gesture,
disable justification, and set
`paragraph-indent: 0em` in their Basho region. Both quotation helpers accept
`none`, `'`, `"`, `〈`, `《`, `「`, `『`, and `【`.

## CJK

Import direct CJK functions from `cjk.typ`.

| Function | Behavior |
| --- | --- |
| `cjk-profile(locale: (:), fonts: (:), vertical: (:))` | Validated direct-vertical profile. |
| `cjk-face`, `cjk-fontset`, `cjk-resolve-font` | CJK-owned face, composite, and trace resolver. |
| `cjk-fontset-native(fontset, common:, language:, region:)` | Native fallback signature. With `language` and `region`, matching locale rules lead generic fallback rules. |
| `cjk-fontset-extend`, `cjk-fontset-override` | Generic multilingual extension helpers. They own locale conditions and fallback-chain construction without choosing physical fonts. |
| `cjk-normalize-optical-profiles(profiles)` | Validate optical-profile vocabulary. |
| `cjk-vertical(body, profile:, part:, initial-height:)` | Paginated direct vertical stream. |
| `cjk-vertical-inline(body, profile:)` | Atomic direct vertical strip. |
| `cjk-vertical-region(body, height, profile:)` | Fixed-height direct local region. |
| `cjk-vertical-regions(streams, height, full-height, width, ...)` | Shared direct vertical grid. |
| `cjk-vertical-flow(body, defaults:, ..options)` | Book-oriented flow helper. |
| `cjk-vertical-flow-streams(streams, defaults:, ..options)` | Descriptor-stream companion. |
| `cjkvert` | Alias for `cjk-vertical`. |
| `rb(reading, base, alignment:)` | Shared ruby facade: vendored Rubby in horizontal flow and full-size, span-aware Basho ruby in `jsvert`; use `#rb[reading][base]`. |
| `cjk-tcy`, `cjk-upright`, `cjk-turn`, `cjk-ruby`, `cjk-vblock`, `cjk-hblock` | Low-level vertical content metadata helpers. |
| `cjk-normalize-horizontal-text(...)` / `cjk-normalize-horizontal(...)` | String normalizer / contextual normalizer. |
| `cjk-grid-normalize-text` / `cjk-grid-normalize` | Compatibility aliases. |
| `cjk-language-layout(body, text-size, fontsets:, common-fontset:, config:)` | Full language-aware horizontal compositor using direct composites only. |
| `cjk-latin-space`, `cjk-latin-spacing`, `cjk-inline-math-spacing` | Explicit CJK/Western directional spacing helpers. |
| `cjk-math(body, before:, after:, gap:)` / `cjk-raw` | Explicit math/raw gap helper and alias. |
| `cjk-style-bypass(body)` | CJK compositor bypass marker. |

### Composite locale rules

A `jsfontset` rule may constrain a face by `lang` and `region` as well as by
`covers`. It may supply a native `fallbacks` list for the selected face. Rules
are tested in order. Use the actual Typst language code for a
language rule, for example `lang: "ja"` or `lang: "zh"`; `"western"` is the
locale alias for non-CJK languages. Region rules use uppercase ISO region codes
and must occur before a generic language fallback. The framework defaults, for
example, route `zh` with `TW`, `HK`, or `MO` to Traditional Han faces and `CN`
or `SG` to Simplified Han faces. Western punctuation is also locale-scoped, so
it does not override Japanese, Korean, or Chinese punctuation in those scopes.
The same locale order applies when CJK styles a Typst-owned inline element,
such as a language-aware smart quote.

## Basho

Import the standalone engine from `vendor/basho-0.1.1/lib.typ`.

| Function family | Public entries |
| --- | --- |
| Config and preparation | `basho-config`, `prepare-tate`, `prepare-tate-streams` |
| One stream | `tate-prepared`, `tate` |
| Inline | `tate-inline-prepared`, `tate-inline`, `tate-inline-height` |
| Local region | `tate-region-prepared`, `tate-region`, `tate-region-width`, `tate-region-plan-prepared`, `tate-region-from-plan`, `tate-region-rows-prepared` |
| Shared surface | `tate-regions-natural-height`, `tate-regions-natural-width`, `tate-regions-intrinsic-prepared`, `tate-regions-prepared`, `tate-regions` |
| Content metadata | `tcy`, `char`, `vert`, `turn`, `vblock`, `hblock`, `ruby` |

`basho-config` validates known top-level settings and nested `sizing`, `layout`,
and `list` fields. Important `layout` keys are `gap`, `rows`, `columns`,
`column-gap`, `row-gap`, `row-fit-threshold`, `line-overhang-threshold`,
`paragraph-indent`, `paragraph-spacing`, `min-final-line-chars`,
`min-fragment-chars`, `justify`, `orphan-lines`, and `widow-lines`.

The `kinsoku` export contains resolver and spacing extension helpers.
`token-schema` exposes token construction and merge helpers for advanced Basho
transform/render modules.

## Scope rule

Document code should stop at `jsvert`. Component code may use `cjk-profile`
and direct CJK rendering. Only engine/template code should call Basho
preparation/region APIs. Preserve resolved-config reuse, source indices,
cumulative endpoints, and the no-progress guard when changing lower layers.
