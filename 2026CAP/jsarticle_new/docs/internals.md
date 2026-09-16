# jsarticle internal architecture

This guide is for maintainers. It describes V2 control flow and its
pagination, font, and vertical-continuation invariants.

## Ownership boundaries

```text
jsarticle: pages, title matter, columns, headers, composite roles, body segmentation
    -> cjk: face resolution, language policy, writing-mode adaptation
        -> Basho: tokens, breaking, pagination, glyph rendering
```

`jsarticle` owns physical pages, title matter, horizontal columns, running
heads, counters, body segmentation, and the normal one-column margin used by
a vertical surface.

`cjk` owns language and region selection, locale-sensitive punctuation and Han
routing, composite-face resolution,
horizontal script composition, optical adjustments, paragraph profiles,
vertical native-font attachment, and local/page vertical-flow decisions.

Basho owns tokens, source identity, transforms, metrics, vertical line breaks,
kinsoku, grids, continuation cursors, and glyph rendering. It must not import
a book template or decide page margins, chapter counters, or title matter.

`src/integrations/theorion.typ` is the local Theorion/Antique bridge. It keeps
package counters and frame primitives intact while applying jsarticle roles and
deferred inline-boundary preparation exactly once.

## Current source map

The root files re-export the stable public API. Implementation lives in
`src/jsarticle/` and `src/cjk/`; see the [module map](refactor.md) for owners
and dependencies. `src/integrations/theorion.typ` remains the package bridge.
Document-owned `fonts.typ` files supply physical faces without duplicating
CJK language routing. The book orchestrator retains show-rule order.

## Configuration lifecycle

### Public V2 record

`jsarticle-options` merges input into `jsarticle-default-options` through
`resolve-options`. Each incoming key must be declared in the default
record. A typo such as `options.vertical.colums` therefore fails before layout.

`flatten-book-options` is the only bridge from grouped public options to the
private renderer. It maps grouped font stacks and horizontal normalization into
private names. The renderer consumes already-resolved records; it must not
create another vertical or horizontal defaults table.

### Faces and composites

A face records one physical family plus common and category-specific optics.
A composite is an ordered set of face rules. For every grapheme, CJK resolves
the first matching rule and returns one tuple: native selector, category,
baseline, tracking, scale, and boundary class. The same tuple controls both
the rendered run and its optical adjustment; no later language-profile lookup
can replace the chosen font.

The removed CJK profile grid is not a fallback route. `cjk-language-layout`
requires direct `fontsets:` and an optional `common-fontset:`; language and
region are conditions on composite rules rather than another font table.

The compositor begins CJK runs at `1em`. The resolved face scale, or the
converted global `cjk-scale` fallback, is applied exactly once. A face scale
therefore replaces the fallback rather than multiplying it.

`fonts.common` is another composite consulted once after the active role. If
neither matches, Typst's ordinary fallback chooses a glyph without guessed
optics. `jsfont` carries an explicit role marker, so identical native stacks
in different roles remain distinguishable. An explicit nested `text(font:)`
is an intentional boundary and exits that marker.

For Typst-owned inline elements that are not ordinary text nodes, CJK builds a
locale-native signature from the same composite. Explicit rules matching the
active language and region lead generic fallback rules: English starts with
its Western face, Japanese with its Japanese face, and regional Chinese with
its matching Han face. The generic inline-element bridge then applies the
resolved category face and optics while leaving the element's own semantics
intact. `smartquote`, for example, still lets Typst decide opening versus
closing punctuation; CJK only supplies its configured face.

### Horizontal composition

`cjk-language-layout` installs contextual `show text` and `show par` rules.
It reads effective language and region, traverses graphemes once, resolves the
active role composite, joins compatible runs, and applies the returned optics
alongside linguistic normalization and paragraph policy.

Generated output carries inert private feature markers to prevent show-rule
recursion. `jsstyle-bypass` marks caller content that must retain its own exact
composition. Paragraph settings require one rebuilt paragraph because a Typst
paragraph has already captured ambient set rules before its show rule sees it.

### Inline boundaries are a separate walk

Font routing does not create spacing. The paragraph-boundary walk separately
classifies the first and last meaningful inline edges of styled text, links,
raw text, mathematics, and transparent sequences. It inserts the configured
weak CJK boundary gap only at direct CJK-to-Western, CJK-to-math, or
CJK-to-raw adjacency. Existing source whitespace and structural boundaries
already provide separation and receive no duplicate gap.

This must remain a bottom-up operation. Equations nested in a Theorion
problem, a link, emphasis, or a local box are visible only after the container
has yielded its inline children. Block math and block raw are excluded because
their vertical separation is block layout, not an inline boundary. The
Theorion adapter passes deferred solution/proof bodies through this same walk
when those bodies become available.

### Composite resolution in detail

For every complete grapheme cluster, CJK determines a semantic category
(`western`, `number`, `hangul`, `han`, `kana`, `punctuation`, or `symbol`) from
its meaningful base. Combining marks and variation selectors stay attached to
that grapheme. It then examines rules in source order. A rule must match its
coverage and, when supplied, its normalized language and region condition.
The first match returns one result:

```text
native selector + ordered native fallbacks + category + boundary class
              + baseline + tracking + scale
```

Each optical property resolves independently:

```text
rule-local value -> face category value -> face common value
                 -> global language/category fallback -> neutral value
```

`auto` means continue to the next source; explicit `0em` or scale `1` is a
real override. Adjacent graphemes are joined only when native selector,
fallbacks, effective optics, and boundary behaviour agree. The output is one
native Typst run per compatible sequence, rather than one box per character.

The common composite is consulted once after the active role. It gives common
symbols or an intentionally shared fallback a declared selector order. If it
does not match, Typst performs ordinary fallback and CJK applies no guessed
correction to that unobserved fallback glyph. A role marker—not native stack
comparison—keeps two roles with identical physical fonts but different optics
distinct. An inner native `text(font:)` intentionally exits the marker; an
inner `jsfont(...)` selects a new composite scope.

## Book body segmentation

`jsvert(flow: "inline" | "region")` immediately becomes local CJK content.
`jsvert(flow: auto | "page")` emits a descriptor. The top-level `segment-body`
pass is the only authority allowed to collect these descriptors.

It flattens transparent sequences and `text(lang:, region:)` wrappers while
carrying inherited language and region. It leaves figures, tables, boxes,
grids, and other opaque local containers intact. A page-flow descriptor trapped
there is rejected because it cannot safely own a physical page.

The group classifier compares resolved surface geometry:

```text
width, height, rows, columns, line/column/row gaps,
row-fit and overhang thresholds, runt/widow policy, stream gap, page-start
```

It flushes a group at visible horizontal content, explicit page/column breaks,
`page-start: true`, or incompatible geometry. Whitespace and empty paragraph
nodes do not split a group. Per-stream language, fonts, region, punctuation,
TCY, and heading behavior are intentionally not shared geometry.

## Physical pages and vertical surfaces

Horizontal content uses normal multi-column layout. A vertical group in a
multi-column document receives a one-column physical page with normal side
margins. `page.cols` therefore never changes vertical `rows`, `columns`, or
continuation margins.

In a single-column document, the first vertical fragment may use remaining
page height. CJK records this height with a surface-specific state key, then
creates a physical break before continuation content. A unique surface id
prevents independent groups from overwriting one another and causing page
counter convergence warnings.

In a multi-column document, a vertical surface begins on a fresh one-column
page and immediately uses full-height continuation geometry.

## CJK vertical flow

### Config assembly

`_cjk-flow-resolve` chooses language/region from explicit call values, ambient
text context, and book policy. It selects the body, strong, and heading
composites, lowers their native fallback lists, and builds one stream
configuration containing those native selectors; vertical OpenType features;
TCY/orientation; language spacing; grid geometry; runt policy; and
justification.

`_cjk-prepare-vertical` translates local-flow values into Basho fields, then
attaches only resolved native selectors to prepared ordinary, TCY, heading,
strong, ruby-base, and ruby-reading tokens. Basho receives neither faces nor
roles, so its pagination and source cursors remain template-independent. In
particular, `paragraph-indent` and `paragraph-spacing` are Basho local-layout
fields. Typst's `set par(first-line-indent: ...)` does not alter a vertical
paragraph after Basho tokenizes it.

### Local flow

`_cjk-local-vertical` receives the real height made available by a figure,
block, grid cell, or page remainder. With `region-height: auto` it uses the
smaller of intrinsic and available height; longer text wraps left. It plans a
region, validates that the resulting width fits the container, and never emits
a page break.

Very short unbroken inline labels use an intrinsic Basho strip. This avoids the
local paragraph-indent artifact where a compact label would split into a runt
and a second line.

### Page flow and semantic headings

`_cjk-render-vertical-payloads` captures semantic heading anchors before actual
stream headings are rendered visually. A semantic vertical heading is visible
once while still participating in outlines and running heads. Visual mode emits
no anchor.

`_cjk-vertical-flow-multi` prepares all streams, calculates their natural
height and width, then chooses intrinsic or paginated output. `auto` selects an
intrinsic surface only when both dimensions fit; `page` skips that compact path.

## Basho pipeline

### Configuration and preparation

`basho-config` calls `prepare-config`. It validates keys, fills language
defaults, chooses a kinsoku resolver, sets normal space width, assembles
rendering/TCY modules, precomputes first-match node renderers, validates the
resolved record, and sets `_basho-resolved: true`.

`prepare-tate` is:

```text
flatten -> transforms -> classifiers -> (tokens:, resolved config:)
```

Passing an already-resolved config is intentional. Prepared streams can be
reused for intrinsic measurement, a first page, and continuation pages without
revalidating or reclassifying source content.

### Tokens, transforms, and metrics

`flatten` creates tokens for grapheme clusters, spaces, newlines, paragraph
breaks, headings, ruby, TCY, lists, equations, and opaque nodes. Printable
tokens keep `source-index`; synthetic spacing does not claim source identity.

Rendering transforms run first. TCY classifiers run next. Explicit helpers
(`tcy`, `vert`, `char`, `turn`, `vblock`, `hblock`, and `ruby`) emit metadata
tokens so their intended behavior remains unambiguous during packing.

`prepare-layout` resolves character-box, ruby-size, ruby-offset, tracking,
paragraph-indent, paragraph-spacing, and the ruby-overhang cap once. For ruby,
it records immutable base/reading spans before pagination. `"reserve"` gives
an overlong reading its natural span; `"overhang"` limits an isolated
unsegmented reading to symmetric paint beyond that span. Segment pairs and
adjacent ruby always reserve space. The renderer consumes those stored spans
without changing token count, source endpoints, or continuation cursors.
Lateral inter-line clearance remains a separate ruby-lane metric. Ordinary
glyphs have analytic cell metrics.
Opaque/arbitrary Typst content is measured once in a local no-op text scope, so
document-level CJK show rules cannot make measurements page-dependent.

### Kinsoku-aware lines

`paginate` fills one top-to-bottom vertical line until the next token would
overflow. It precomputes forward CJK-run lengths, remaining paragraph lengths,
and list flags, avoiding suffix rescans at every possible line break.

Its decisions are ordered:

1. Regular spaces are discarded at a line start and are legal break points.
2. Newline/parbreak creates a forced boundary; repeated breaks retain empty
   structural lines.
3. `vblock` and `hblock` occupy isolated lines.
4. `min-fragment-chars` rebalances short CJK fragments before generic kinsoku
   can lock in a one-character split.
5. Attached closing punctuation is handled with preceding text where possible.
6. Kinsoku chooses hanging punctuation, compression/oikomi, or legal
   push-back without creating a forbidden start when an alternative exists.
7. `min-final-line-chars` may shorten the preceding automatic line.
8. Justification applies only to automatically wrapped, non-final lines.

These are priorities, not an absolute word-boundary rule. An intra-run break
can remain legal when it is the only kinsoku-safe and spatially balanced option.

### Shared grids and continuation

`layout-tate-regions` prepares a queue for each stream at each needed cell
height. A queue contains prepared columns, widths, paragraph metadata, line
gap, and cumulative `source-ends`. The grid fills right-to-left; same-stream
lines use `line-gap` and stream transitions use the effective `stream-gap`.

Rows, columns, and gutters partition a surface into cells. A partial first page
uses a fitted row count. Continuation pages use the configured full grid.

The continuation invariant is:

```text
cursor == queue.columns.len() means that stream is complete.
source-ends[n] is the greatest consumed source index through line n.
```

This handles blank trailing paragraphs. An empty structural line has no local
source endpoint, but it cannot reset a cumulative endpoint to zero or restart a
completed Japanese stream while a later Korean stream continues. A no-progress
guard panics if a page returns unchanged cursors.

## Running heads and convergence

The book header queries semantic headings. It uses special page-number treatment
on an H1 page. Otherwise it accepts a section only when that section belongs to
the active chapter; an older chapter section is replaced by the active chapter
title. This prevents a vertical continuation page from showing a stale header.

Do not put page-number-dependent state/query feedback into Basho hot loops.
Any state that depends on a measured first-page remainder must be surface
specific and separated from continuation by a physical break, or Typst page
numbers can fail to converge.

## Safe change checklist

1. Change the layer that owns the behavior: page, CJK/font, or token layout.
2. Preserve public names unless making an explicit documented V2 break.
3. Keep horizontal `page.cols` independent from vertical grid fields.
4. Keep page-flow grouping declarative: no overlays, coordinate moves, sibling
   queries, or global mutable collectors.
5. Preserve source indices, cumulative endpoints, atomic completed lines,
   semantic heading anchors, kinsoku, ruby, TCY, equations, and fixed-layout
   guards when changing Basho.
6. Add a focused fixture, compile the full document twice, inspect warnings,
   and render affected page boundaries to images.
