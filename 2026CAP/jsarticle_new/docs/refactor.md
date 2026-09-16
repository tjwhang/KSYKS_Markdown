# Engine source map and migration

The root `jsarticle.typ` and `cjk.typ` files are stable public import surfaces.
Implementation modules import their dependencies directly, never their own
root facade. Public signatures, state keys, feature markers, option defaults,
and vertical continuation cursors are preserved.

## Source map

`src/jsarticle/`:

| Module | Responsibility |
| --- | --- |
| `options` / `defaults` | Strict record merging, flattening, public defaults |
| `fonts` / `state` | Built-in faces and roles; document-local contextual state |
| `inline` | Font selection, ruby, local vertical entrypoints, inline helpers |
| `geometry` | Automatic page and typography measurements |
| `book` | Page setup and ordered show-rule installation |
| `headings` | Heading, outline and footnote renderers with captured book settings |
| `flow` | Horizontal/vertical body segmentation and continuation hand-off |
| `title` | Adaptive vertical title composition |
| `components` | Parts, epigraphs, quotations and document utilities |

`src/cjk/`:

| Module | Responsibility |
| --- | --- |
| `fonts` | Face/composite rules and effective font resolution |
| `profile` | Direct vertical profile API |
| `spacing` | Inline boundary classification and fragment traversal |
| `language` | Paragraph policies, optical profile validation and markers |
| `normalize` | Horizontal punctuation and space normalization |
| `compose` | Contextual horizontal text/paragraph composition |
| `prepare` | Vertical token fonts, ruby sizing, local regions and streams |
| `flow` | Vertical flow policy, geometry and multi-stream page handling |

Contextual rules remain ordered in the book orchestrator. Factory functions
capture only their required book settings. No new global layout cache is used.
Vendor code in the authoritative source is unchanged by this refactor.

## Clearer names

| Previous | Preferred |
| --- | --- |
| `resolve-option-record` | `resolve-options` |
| `project-book-options` | `flatten-book-options` |
| `jsnnh1` | `js-heading-unnumbered` |
| `jsnnoh1` | `js-heading-unlisted` |
| `jsnneq` | `js-equation-unnumbered` |
| `jspnum` | `js-problem-number` |
| `jsans` | `js-answer-box` |

Previous names remain aliases with their original signatures. Unlisted headings
are also unnumbered, as before. Existing `jsvert`, `jsfont` and book APIs keep
their established names. Retired pre-V2 interfaces are not reinstated.

## Synchronizing consumers

Run `tools/sync-engine.ps1 -Mode preview` from PowerShell to list differences;
use `-Mode check` for an exit-code check, or `-Mode apply` to synchronize.
`-Targets unist` or `-Targets 수능수학` limits the destination. The default updates
both. `engine-files.json` explicitly lists files; document content, fonts,
preambles, assets and PDFs are excluded.

Each consumer receives `engine-lock.json` containing installed hashes. A later
local engine edit stops synchronization; review it before deliberately using
`-AllowLocalChanges`. The tool copies only manifest files and does not delete
unlisted files. Add new implementation modules to the manifest before syncing.

Both consumers previously had an older vendored renderer which ignored
prepared token fonts. Migration includes the source's already-existing fix;
this can change vertical glyph selection. The mathematics char-box difference
was only line endings. These migration differences are separate from the
output-preserving engine extraction.

Preamble package imports were retained because they form the document's
author-facing integration surface, including deferred theorem/math helpers.
Only aliases identical to already imported exports can be omitted safely;
short document-specific aliases remain available.

## Deferred content and Theorion

Contextual renderers must apply `jscjk-inline-boundaries(body)` where they
render author content: an outer spacing pass cannot inspect content hidden
inside a `context`. The portfolio and local Theorion adapter do this for
bodies and content-valued titles. Display equations remain separate blocks.

Math clearance is additive: `한$x$글` gets the configured math gap, while
`한 $x$ 글` retains each typed word space in addition to that gap. The word
spaces remain breakable and participate in justification; the math clearance
is fixed and drops at a line edge. Latin and raw spacing policies are unchanged.

The Theorion adapter defaults `text(lang: "ko")` to Hangul labels (풀이,
증명, 정리, 물음). Use `text(lang: "ko", region: "hj")` for Hanja labels.
Explicit titles and other languages remain supported. Frame adapters wrap
the renderer, not the figure, so attached labels and counters still work.
The installed Theorion package is not modified.

## Horizontal ruby placement

`#rb[reading][base]` uses a reading size of 55% and a default clearance of
0.12em, relative to the local surrounding text size. Horizontal placement is
isolated from paragraph leading and text-edge settings, including footnotes.
`#rb(dy: -0.1em)[reading][base]` raises the reading by 10% of that local size;
positive `dy` lowers it. A point value such as `dy: -1pt` moves it by the same
absolute distance everywhere. `dy: 0em` retains the default clearance.
This option affects horizontal ruby only; vertical ruby still uses `ruby-gap`.

## IPA, brackets and local line metrics

Explicit `page.margin` accepts either `(left:, right:, top:, bottom:)` for
fixed physical margins or `(inside:, outside:, top:, bottom:)` for mirrored
binding-relative margins. A complete physical pair wins when both are present;
an incomplete pair is an error rather than an implicit mix of coordinate systems.
`auto` and legacy margin behavior are unchanged. `bind: "none"` does not force
mirroring: use physical margins for an unbound document with unequal sides.

IPA uses the active font family, not a CJK-engine-owned physical font.
`#jsipa[ˈvaɪ̯nˌɡaʁ.tən]` sets Latin-language/script context while retaining
that family; `font:` is an explicit native override. Combining marks stay in
their base character's category.

The default ChosunilboNM composite has a font-specific repair in
`src/jsarticle/fonts.typ`: only standalone stress/length marks use New
Computer Modern. All pronunciation letters, including IPA letters and their
combining marks, retain the Western face and are shaped together. A custom Western face override
takes precedence over these default repair rules.

ASCII brackets `() [] {} <>` receive the configured boundary clearance.
Other Unicode opening/closing brackets, including `｢｣`, `「」` and `『』`,
are measured using the active font and features. Glyphs below 0.8 local em
receive clearance; full-width glyphs do not. Neutral measurement guards avoid
Typst's line-edge punctuation compression. No font-name exceptions are needed.

Footnote calls remain attached to preceding text across automatic line breaks.
Explicit paragraph breaks before a footnote are still author-controlled.
Inherited line-box edges and leading scale with local text size, including
caption/source components; explicit local leading and footnote rules remain.

Use synchronization's `-Files` array for a verified subset of the engine
manifest when a consumer has unrelated local customizations. Other lock hashes
are retained, and a full sync still reports those local edits rather than
silently overwriting them.
