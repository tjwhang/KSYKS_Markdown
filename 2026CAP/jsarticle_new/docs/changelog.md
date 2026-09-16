# jsarticle change log

## Unreleased

- Added vertical ruby overflow policy. `vertical.ruby-overflow: "reserve"`
  (the default) reserves an overlong reading's natural span before Basho
  paginates. `"overhang"` permits a capped symmetric paint overhang for an
  isolated unsegmented ruby; segmented and consecutive annotations reserve
  space to avoid collisions. `vertical.ruby-overhang` defaults to `0.5em`.

- Documented the V3 migration boundary: document-owned `fonts.typ` replaces
  selected direct composites while jsarticle retains locale routing and its
  footnote fallback composite.

- Consolidated vertical-writing documentation under
  `docs/vertical-writing.md`. It records the actual descriptor, grouping, CJK
  preparation, Basho packing, ruby, and continuation invariants; the stale
  root-level guide was removed instead of retaining profile-era instructions.

- Added `fonts.ruby-family`. `auto` follows body typography; `"footnote"`
  routes both horizontal Rubby readings and vertical Basho readings through the
  footnote composite. `vertical.ruby-family` and local `jsvert(ruby-family:)`
  provide a vertical-only override.

### Changed

- Corrected composite CJK scale ownership. An explicit face scale now replaces
  the legacy/global CJK scale fallback instead of being applied a second time.

- Restored V2 `page.margin`, `page.header`, and `page.footer` support. Explicit
  page margins now also publish the correct local component column width.

- Completed the CJK V3 cleanup: the inactive profile renderer, stack-based role
  inference, and font-name-based Latin adjustment tables are gone. Direct
  composites are now mandatory at the CJK layout boundary.

- Extracted the local Theorion/Antique renderers from the broad preamble into
  `src/integrations/theorion.typ`. The preamble remains source-compatible while
  labels, badges, theorem frames, problems, solutions, and proofs now have one
  role-aware implementation.

- Locale-aware native signatures now lead matching language/region rules before
  generic fallbacks. Typst-owned inline elements use that shared CJK boundary,
  so smart quotes preserve Typst's opening/closing behavior while receiving
  the configured Western, Korean, Japanese, or regional Chinese punctuation
  face rather than an unrelated first fallback font.

- Rewrote the public font documentation around the current face/composite
  model. It now distinguishes physical face categories such as `punctuation`
  from locale-specific override slots such as `punct-ko`, and removes the
  obsolete script-stack and role-adjustment examples.

- Replaced the live language-profile font path with direct composite routing:
  `role -> ordered rules -> physical face -> effective optics`. New books use
  direct composite defaults; a document-owned font file may override them.
- Kept jsarticle's NCM/Arial/Montserrat/KoPub-based catalogue as the framework
  default. Document-specific AppleMyungjo, SM, Bookk, Minion, and other faces
  remain in `fonts.typ`, where they extend those defaults without reproducing
  locale routing or losing the framework fallback stack.
- Moved multilingual composite extension into CJK. Other templates can now use
  the same language/region, punctuation, Han, and fallback mechanics while
  supplying their own physical faces.
- Added `jsfontset` and extended `jsface` with common and per-category optics.
  Face values own font-specific baseline, tracking, and scale; composite rules
  own coverage, locale conditions, and exceptional local optics.
- Routed body, strong text, headings, footnotes, title matter, built-in
  components, Theorion labels, and vertical prepared tokens through the same
  named role system. Ruby base and reading tokens now carry native selectors
  independently into Basho.
- Retired public language-stack options, `cjk-role-adjustments`, and
  font-name-based CJK-Latin adjustment lists. Use face or rule optics instead.
- The vertical renderer now preserves an explicit native `font:` override as a
  deliberate local escape hatch while continuing to use document composites
  for normal body, strong, heading, and ruby content.

- Added CJK-owned `cjk-face` and the jsarticle alias `jsface`.
- Added `jsfont(role, body, ..text-options)` for reusable components whose
  role must remain known even when native role stacks are identical.
- Added the `theme` option group and contextual `js-theme`/`js-theme-color`
  accessors. Body ink, heading number/text/outline fills, title matter, and
  part dividers now consume resolved abstract theme colors.
- The local Theorion/Antique adaptive frame adapter now carries abstract color
  roles until render time, mapping theorem-family frames to the active theme's
  `accent-1` through `accent-3` values without changing counters or references.
- Updated the UNIST portfolio components to consume `ink`, `muted`, and
  `rule` from the active book theme. `수능수학` now uses the same engine version
  and can opt into faces and themes without changing its selected fonts.
- Kept the V2 public surface unchanged while aligning the private
  `strong-family` fallback with `fonts.strong-family`.
- Documented the supported V2 configuration and the three-layer layout model
  as the authoritative source. The old root guide now points readers there.
- Simplified the ordinary Basho overflow path by reusing its tracked occupied
  height instead of scanning the same line a second time.

### Compatibility

- `jsarticle-book`, `jsarticle-options`, `jsvert`, `jsface`, `jsfontset`,
  `jsfont`, and native stack accessors remain supported.
- Per-language font tables, role-wide CJK adjustments, and font-name optical
  exception lists are intentionally breaking removals.
- Flat pre-V2 book options and the removed `jsvert-page` and `jsvert-inline`
  wrappers remain unsupported.

### Verification

- `main.typ` compiled to temporary PDFs for jsarticle, UNIST, and 수능수학;
  the focused `face-theme-regression.typ` fixture also compiled successfully.
- The current full document compiled without warnings before this cleanup.
- `tools/benchmark.ps1` measures separate Typst processes and reports a median
  without retaining a large timing trace. The current five-run median for
  `main.typ` is 6.084 seconds in the current font environment.

### Maintenance backlog

- The private renderer still accepts a flat projection of the public option
  record. Moving it to a fully record-based renderer requires a separate
  output-equivalence change because Typst lexical show-rule scope is sensitive
  to where the renderer is defined.
- `main.typ` imports Antique after `preamble.typ`. That can shadow preamble
  integration helpers and must be characterized with a focused fixture before
  changing import order.
