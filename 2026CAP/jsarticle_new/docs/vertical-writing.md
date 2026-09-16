# Vertical writing: authoring model and renderer mechanics

`jsvert` is the only public vertical-writing wrapper. It describes intended
flow; it is neither a positioned box nor a second page template. jsarticle
places page-flow material, CJK prepares it, and Basho packs and draws it.

```text
#jsvert(...) [source]
        -> jsarticle: local content or a page-flow descriptor
        -> CJK: language policy, native fonts, prepared tokens
        -> Basho: vertical lines, grid cells, pages, glyphs
```

That separation is intentional. `jsvert` never moves content by coordinates,
queries later siblings, or keeps global collection state. A page surface comes
from the book-flow pass in ordinary source order.

## Choosing a flow

```typst
#jsvert(flow: "inline")[短い縦書き]
#jsvert(flow: "region", region-height: 45mm)[箱の中で折り返す縦書き]
#jsvert(language: "ja")[本文の縦書き]
#jsvert(flow: "page", language: "ko")[긴 세로쓰기]
```

| Flow | Valid scope | Behaviour |
| --- | --- | --- |
| `"inline"` | Any local container | An intrinsic, atomic vertical strip. Best for short labels and figure elements. Typst controls surrounding horizontal spacing. |
| `"region"` | Any local container | Uses the real local height, wraps left through that region, and never creates a page break. Supply `region-height:` for a fixed region; `auto` uses the smaller of intrinsic need and enclosing height. |
| `auto` | Top-level book flow | Emits a descriptor. The book pass uses a compact fitting surface when possible, otherwise the remaining page height and continuation pages. |
| `"page"` | Top-level book flow | Emits the same descriptor but always plans a page surface instead of selecting the compact intrinsic path. |

`auto` and `"page"` are rejected inside figures, tables, boxes, grids, and
other opaque local containers. Such a container cannot safely give the book
pass ownership of a physical page. Use `inline` or `region` there.

## Defaults, local overrides, and locale

The `vertical` group of `jsarticle-options` supplies defaults. Arguments on
a call override just that stream.

```typst
#show: jsarticle-book.with(
  options: jsarticle-options(
    vertical: (
      rows: 2,
      columns: 1,
      line-gap: .55em,
      column-gap: 2em,
      row-gap: 2em,
      min-final-line-chars: 2,
      min-fragment-chars: 2,
      orphan-lines: 2,
      widow-lines: 2,
      justify: auto,
      stream-gap: .6em,
    ),
  ),
)

#jsvert(language: "ja", rows: 3)[この呼び出しだけ三行の行列]
```

The horizontal page `cols` setting is not a vertical setting. Vertical
`rows`, `columns`, and their gaps define Basho's grid. A page-flow vertical
surface always uses normal one-column side margins, even in a two- or
three-column book.

Language resolves in this order:

1. Explicit `language:` and `region:` on `jsvert`.
2. Transparent surrounding `text(lang:, region:)` context.
3. The book's ambient language and region.

Language governs normalization, punctuation, full-width-space handling,
particles, kinsoku, and break defaults. It does not choose a separate font
table. Ordered composites choose fonts; see [internal architecture](internals.md#faces-and-composites).

Ruby readings use `fonts.ruby-family`, which defaults to the resolved body
family. Set `fonts: (ruby-family: "footnote")` to use the footnote composite
for ruby across horizontal and vertical text. `vertical.ruby-family` or a
specific `jsvert(ruby-family: "footnote")` changes only that vertical stream.

## From calls to a shared surface

Top-level `jsvert(flow: auto | "page")` emits an internal descriptor. The
book classifier walks source order and emits horizontal events or vertical
descriptors. It flattens transparent sequences and transparent language/region
contexts, but preserves figures, tables, boxes, and other opaque boundaries.

Consecutive descriptors share one surface only when resolved surface geometry
matches. Language, region, fonts, headings, punctuation, ruby, and TCY may
differ by stream. The signature includes:

```text
width and height; rows and columns; line, column, and row gaps;
fitting thresholds; runt/orphan/widow policy; stream gap; page-start policy
```

Whitespace and empty paragraphs do not split a group. Visible horizontal
content, an explicit page or column break, `page-start: true`, or changed
geometry flushes it.

```typst
#jsvert(language: "ja")[第一の流れ]

#jsvert(language: "ko")[둘째 흐름]
```

The Japanese stream is consumed first. The Korean stream begins at the top of
the next vertical line to its left. Line gap separates lines in one stream;
`stream-gap` separates streams.

## Physical placement and horizontal resumption

The book pass produces horizontal segments and full-width vertical surfaces.
In a single-column book, a short surface can occupy only the remaining height,
allowing horizontal prose to continue below it on the same physical page. If it
overflows, continuations own the following one-column pages and following
horizontal material resumes after the surface.

In a multi-column book, a page-flow surface starts on a fresh one-column page.
This preserves full width and normal side margins rather than mixing a
full-width surface into a fragmented column page. Its continuation uses the
same one-column geometry. `page-start: true` always begins a fresh page.

The initial available height is recorded with a surface-specific key.
Continuation content begins after a physical break and uses full-page geometry.
Surface-specific identity prevents independent groups from overwriting each
other's measured remainder and causing page-counter convergence warnings.

## CJK preparation and native font attachment

CJK resolves a call through `_cjk-flow-resolve` and
`_cjk-prepare-vertical`. It builds a Basho configuration and resolves body,
strong, heading, and common composites. Prepared tokens carry only native font
selector data. Basho never sees faces, composites, or document roles.

```text
ordinary text     -> body composite -> native selector on token
strong text       -> strong composite -> native selector on token
heading text      -> heading composite -> native selector on token
ruby base/reading -> independently selected native selectors
explicit font:    -> caller selector remains authoritative
```

The first matching composite rule wins. If none matches, CJK consults the
common composite once, then Typst's own native fallback. Face optical metadata
is horizontal composition data: it does not alter Basho character-cell geometry
or pagination.

## Basho preparation pipeline

`prepare-tate` is reusable preparation, not rendering:

```text
source content
  -> flatten
  -> rendering transforms
  -> classifiers
  -> immutable prepared tokens + resolved Basho configuration
```

Flattening makes tokens for grapheme clusters, spaces, soft and hard breaks,
paragraph breaks, headings, ruby, TCY, lists, equations, and opaque Typst
content. Printable tokens keep a `source-index`; synthetic spacing never
claims source identity.

Transforms apply explicit vertical helpers and rendering policy. Classifiers
identify TCY, punctuation, blocks, ruby, and roles. Layout preparation resolves
character box, tracking, ruby size and offset, paragraph indent, and paragraph
spacing once for a geometry. Ordinary glyph placement is analytic; arbitrary
opaque content is locally measured only when analytic metrics are impossible.

## Lines, grids, and breaks

A vertical line fills top to bottom; lines progress right to left. Basho tracks
occupied height, visible-token count, trailing CJK-run length, paragraph
metadata, and cumulative source endpoints while packing.

Its break policy is ordered:

1. Ordinary spaces are discarded at a line start and are legal break points.
2. Newline and paragraph break create forced boundaries, including empty
   structural lines.
3. `vblock` and `hblock` consume isolated line space.
4. `min-fragment-chars` may rebalance a short CJK fragment.
5. Closing punctuation stays with preceding text when possible; forbidden
   starters are rejected by kinsoku.
6. Basho tries hanging punctuation, compression, or legal push-back before
   accepting a forbidden break.
7. `min-final-line-chars` may shorten the preceding automatic line.
8. Justification applies only to automatic non-final body lines.

Fragment prevention is a cost-based repair, not a universal word-boundary rule.
It may allow `문자/문자` or `시키/고자` when geometry demands it, while
resisting `보존한다/면,`. Footnote markers are not fragment characters and
cannot start a line. Korean particle constraints work when Korean vertical
justification is enabled; Japanese particle lists provide the equivalent
agglutinative constraint without relying on spaces.

Kinsoku, particles, runt prevention, orphan/widow handling, and justification
are independent tests in the same choice. A break that avoids a runt but starts
with forbidden punctuation is not acceptable.

## Ruby, TCY, blocks, notes, and punctuation

### Ruby

`#rb[base][reading]` routes through CJK: horizontally it uses vendored Rubby;
inside `jsvert` it becomes Basho ruby. Parallel `|` separators align
segments, so `#rb[신|체][身|體]` places readings per base segment.

Ruby readings retain `ruby-size`; Basho never compresses a long reading to fit
its base. Its prepared layout span is shared by the paginator and renderer, so
a page break cannot recalculate the reading differently from its first page.

`vertical.ruby-overflow` chooses the policy when a reading exceeds its base:

```typst
vertical: (
  ruby-overflow: "reserve", // default
  ruby-overhang: .5em,
)
```

- `"reserve"` gives every overlong base/reading pair the reading's natural
  vertical span. The base and reading remain centered, and the added advance is
  split before and after the base.
- `"overhang"` may paint up to `ruby-overhang` beyond both ends of one
  isolated, unsegmented ruby annotation. Any remaining excess is reserved.
  Consecutive ruby annotations and `|`-aligned segments always reserve space,
  because an overhang there could collide with another reading.

This vertical reserve is distinct from lateral ruby clearance: Basho still
widens the gap to the next right-to-left line only when the reading lane itself
needs it. Ruby remains annotation rather than source prose: no extra source
token, cursor, kinsoku decision, or fragment count is created.

The ruby composite styles the reading only. A footnote ruby family therefore
does not alter the base text's active role, font, or break identity.

### TCY and Western text

TCY keeps short digit groups upright according to `tcy-max-digits`. Ordinary
Latin uses `latin-orientation: "rotate"` or `"upright"`. These are rendering
modes, not source changes, so they do not affect continuation identity.

### Equations and opaque blocks

Block equations and other `vblock`/ `hblock` content occupy isolated line
space and are not justified. Inline equations remain inline tokens and use
CJK boundary spacing when adjacent to CJK text. Opaque content is measured only
when needed; document CJK show rules are disabled during that measurement.

### Footnotes and punctuation

Vertical footnote and `transnote` markers attach to text. They do not consume
an ordinary character cell for fragment calculation, cannot start a line, and
use the selected footnote native font.

Unicode vertical substitution and punctuation-space collapse are separate.
Substitution selects vertical glyph forms when the face needs help; collapse
removes an inappropriate source space after CJK punctuation. Neither should be
replaced with manual movement.

## Continuation integrity

Each stream queue contains prepared columns, cumulative `source-ends`, and a
cursor:

```text
cursor == queue.columns.len()  => stream complete
source-ends[n]                 => greatest source index consumed through n
```

Cumulative endpoints matter when a stream ends with blank paragraphs. An empty
structural line has no local source endpoint, but cannot reset a previous
endpoint to zero. Completion remains authoritative even when structural tokens
remain. A no-progress guard stops a continuation from queuing identical content
again.

This prevents a completed Japanese stream from being rebuilt while a later
Korean stream continues.

## Semantic headings and running heads

`heading-mode: "semantic"` emits one zero-sized final-render anchor alongside
the visible vertical heading. It can participate in counters, outlines,
references, and running heads without appearing during measurement. `"visual"`
draws only the heading.

Running-head selection verifies that a section belongs to the active chapter,
so a vertical continuation cannot display a stale section from an earlier
chapter.

## Safe tuning order

1. Select the correct role/composite and physical faces first.
2. Tune character box, grid geometry, and gaps.
3. Tune language policy: spaces, TCY, orientation, and punctuation collapse.
4. Tune fragment, final-line, orphan/widow, justification, and kinsoku policy.
5. Add a focused fixture, compile the full document twice, then inspect start,
   continuation, and horizontal-resumption pages as images.

Do not add stateful sibling collectors, absolute overlays, coordinate moves, or
page-number-dependent feedback to solve flow. They break the separation between
source order, prepared-token cursors, and physical-page decisions.
