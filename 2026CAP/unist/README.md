# Editing the portfolio

Edit `portfolio-content.typ`. Its single `pf-book(...)` declaration supplies
both the cover contents and project pages. `main.typ` remains the build entrypoint.

Each part has `number`, `title`, `premise`, and `projects`. Each project has a
stable `id`, `number`, `title`, optional `short-title`, metadata (`field`,
`period`, `role`, `tools`), and a `pages` array. Keep a future project in the
contents with `pages: ()`; its page is shown as an em dash. The first project
with pages receives the part strap. Every later array item starts a continuation.

Use `displayed-page` only to override the printed contents-page value. Links
still target the real project. IDs and figure identifiers are never renumbered
automatically. Figure labels such as `1-A` remain yours to choose.

```typst
#pf-columns(
  left-width: 80mm,
  left: [#pf-heading[Question] Your explanation.],
  right: [#pf-figure("1-A", caption: [Caption])[Your evidence.]],
)
#pf-note(label: "한계")[State the limitation.]
```

Profile content accepts `pages` or legacy `overview`/`background`. Layout measures, shared type
sizes, colors and margin-marker positions live in `components/theme.typ`;
physical faces and their optical adjustments remain in `fonts.typ`.

Ruby is available directly through the portfolio import: `#rb[reading][base]`,
for example `#rb[かんじ][漢字]`. `ruby` is the long spelling of the same helper.
It renders above horizontal text and beside text inside `pf-vertical`.
Segment readings and bases with `|`: `#ruby[れん|よう|けい][連|用|形]`.
Horizontal ruby supports empty readings, including the final segment:
`#ruby[い||かえ|][行|き|帰|り]` leaves `き` and `り` unannotated.
Do not insert placeholder dots. Horizontal ruby uses local em bounds so Han-only
bases remain correctly annotated in measured evidence flow and footnotes.
Run `python tests/check-ruby-flow.py` to check native/evidence/overflow placement.

## Continuous prose with evidence

### Appendix and afterword

Add optional `appendix` and `afterword` fields to `pf-book`. They follow the
projects in that order and receive linked contents entries. Omit either field
to omit its pages entirely; the existing portfolio is unchanged by default.

```typst
#pf-book(
  // Existing title, profile, and parts fields...
  appendix: (title: "부록", pages: ([첫 번째 부록 내용], [다음 부록 내용])),
  afterword: [마치며의 본문],
)
```

Each uses the profile's margins, offset serif title, and spacious opening.
The default body is a breakable single column, inset by `3em`, with a width of
38 CJK ems capped to the available space. Text can overflow naturally; `pages`
adds deliberate page breaks. Page numbering continues, and project running
headers are cleared. The title and optional `artwork` appear only on the first
page. Artwork is decorative, bottom-right aligned, and does not reserve prose
space; keep it clear of the text, as in the profile's first-page illustration.

Standalone use inside `pf-document` is also supported:

```typst
#pf-appendix(title: "추가 자료", body-width: 100%, inset: 3em)[부록 본문]
#pf-afterword[마치며의 본문]
```

Dictionary fields support the same options (`title`, `body`, `pages`,
`body-width`, `inset`, `artwork`, `destination`). Use `body` or `pages`, not both.
Default destinations are `<pf-appendix>` and `<pf-afterword>`; supply unique
destinations when using a standalone component more than once. The standalone
forms do not add entries to a separately constructed cover automatically.
Run `python tests/check-endmatter.py` for navigation and overflow checks.

Project pages now use `pf-flow` when the text should continue automatically:

```typst
pages: ([
  #pf-flow(
    evidence: (
      [#pf-figure("1-A", caption: [Caption.])[#image("assets/example.png", width: 100%)]],
      [#pf-figure("1-B", caption: [A second item.])[Evidence.]],
    ),
  )[
    #pf-heading[Question]
    Write the prose continuously here, including equations and footnotes.
  ]
],),
```

Evidence fills the right column from the top, in array order. Prose fills the
left column and then the space below the evidence on the right. Items that do
not fit move intact to the next page; an item larger than the usable page
produces an error rather than being clipped. Remaining prose continues in
ordinary two-column flow. `#pf-flow[Text]` uses two columns without evidence.

Edit only the `evidence` array to add/reorder figures, and the trailing content
block to edit prose. Keep additional `pages` entries only for deliberate page
breaks. `pf-columns` remains available for independently composed columns;
the profile's overview/background layout still uses it.

`gutter` defaults to `pf-column-gutter`; `evidence-gap` defaults to `3mm`.
On evidence pages, automatic clearance conservatively reserves notes reachable
in the planned evidence regions, not all later notes in a long project. Its
source-based reservation only grows during fitting, avoiding a pagination
feedback loop. Repository-link and figure/caption/source wrappers expose their
note sources without changing their rendering. For footnotes hidden inside
other custom context-producing helpers, supply a sufficient explicit
`footnote-space: 25mm` (for example). Ordinary overflow pages use native
footnote layout. Avoid wrapping the entire prose in an unbreakable `box` or
`stack`; keep paragraphs directly in the flow body.

The flow implementation is in `components/flow.typ`, using bounded source
windows from `components/flow-stream.typ` with pinned `@preview/meander:0.4.4`
for evidence-region threading. Original paragraph/style scopes are restored
before fitting and before native overflow. `components/flow-clearance.typ`
handles the source-note preflight. This is project-scoped: covers, profiles,
independent columns, and the shared engine keep their existing mechanisms.
See `tests/flow-stream-performance.md` for measurements and limitations.
The shared CJK compositor
avoids nested contextual evaluation during repeated text-fit measurements;
keep that optimization when syncing the engine. No authoring options change.
Run `python tests/check-flow.py` to check text continuity, evidence order,
overflow, footnote clearance, short text and original-layout equivalence.
See `tests/flow-performance.md` for measured performance and verification.

UNIST's math font routing lives in `src/jsarticle/inline.typ`, in `font-math`.
Minion Math supplies Western letters, numbers, Unicode mathematical alphabets,
and letter-like symbols. New Computer Modern Math supplies general symbols and
stretchy delimiters; the explicit STIX entries retain large operators. There is
no separate portfolio math-font override. Write ordinary matching pairs such
as `$ [sum_(i=1)^n x_i] $` or `$ {sum_(i=1)^n x_i} $`; Typst scales them
automatically. Use `lr(...)` only for deliberately unmatched or custom pairs.

Keep this UNIST-local `font-math` selection when reviewing engine syncs. A glyph
missing from Minion still falls back normally; extending `covers` cannot add
glyphs to the font itself. The inactive text-italic experiment is not imported
by the portfolio and does not participate in this routing.

Equation boundary gaps use `pf-cjk-gap` in `components/theme.typ`. Both the
source and paragraph passes are needed: native nested containers are handled
before layout, and contextual content is handled when it becomes available.
`pf-flow` also resolves source boundaries before text is split across regions.

`pf-heading` in `components/layout.typ` reserves the following gap and two body
lines during fit measurement, cancelling that reservation in its trailing
spacing. This protects headings from Meander's cuts without changing the normal
visible gap. The reservation scales with body size and leading.

Run `python tests/check-math-boundaries.py`, `python tests/check-math-delimiters.py`,
and `python tests/check-pf-heading-flow.py` for the targeted regression checks.

## Names and compatibility

| Previous spelling | Preferred spelling |
| --- | --- |
| `pf-portfolio` | `pf-book` |
| `pf-split(left-body:, right-body:, left:)` | `pf-columns(left:, right:, left-width:)` |
| `pf-topic` | `pf-heading` |
| `pf-project-continuation` | `pf-next-page` |
| `pf-vertical-evidence` | `pf-vertical` |
| Profile `main`, `cap` | `overview`, `background` |
| Project `short_title` | `short-title` |
| Note `kind` | `label` |

Old functions and keys remain supported. New keys win when both are supplied.
`pf-figure`, `pf-note`, `pf-comparison`, and `pf-result` retain their roles.

## Where the implementation lives

The introduction accepts free-form pages, just like a project:

```typst
profile: (pages: (
  [Full-width introduction text.],
  [#pf-columns(left: [Left text.], right: [Right text.])],
)),
```

Each entry starts a new page; long content may also overflow naturally.
The title and outline anchor appear once. Continuation pages retain the
introduction marker and sequential folios, without a horizontal running title. Use `pf-columns`
for independent columns, or Typst's `columns(2)[...]` for newspaper-style
flow. Existing `overview`/`background` and `main`/`cap` inputs still work;
explicit `pages` takes precedence.

- `portfolio.typ`: document options and the part/project rendering sequence.
- `components/project.typ`: project opening and continuation pages.
- `components/layout.typ`: columns, headings, figures, notes and vertical evidence.
- `components/flow.typ`: continuous two-column prose with separately supplied evidence.
- `components/navigation.typ`: shared destinations and page metadata.
- `components/data.typ`: old-key normalization and optional metadata handling.
- `components/cover.typ`, `profile.typ`, `page.typ`: the three presentation surfaces.

Headers use project metadata plus elapsed physical pages, so overflow pages
advance their folio even without an explicit continuation call. The profile's
counter reset is read from its body location, not the earlier header location.

The shared engine comes from `../jsarticle_new`. Run its `tools/sync-engine.ps1`
in preview mode before updating the local engine. Do not copy its document
fonts, preamble, content, or assets over this project.

`tests/compatibility.typ` accepts `--input api=old`; its PDF should equal the
default new-API PDF. `tests/navigation.typ` accepts `--input extra=yes` to
exercise automatic page updates while a manual contents-page override stays 99.

Run `python tests/check.py` to compile both variants and check PDF equivalence,
folios, continuation headers, and actual link destinations. It requires Typst
on PATH plus the Python packages `pdfplumber` and `pypdf`.

IPA preserves the environment's Western family. The default ChosunilboNM
composite repairs only standalone stress/length marks with New Computer Modern.
IPA letters and their combining marks keep the Western face.
Use `#jsipa[ˈvaɪ̯nˌɡaʁ.tən]` for explicit Latin IPA context;
`font:` can override the typeface.
Captions and sources have their own paragraphs, with line spacing proportional
to their local size. `pf-caption` and `pf-source` accept a `size:` override;
their shared defaults live in `components/theme.typ`.
The single `typography.baseline-ratio` in `portfolio.typ` controls inherited
line spacing at every local text size; there is no absolute portfolio baseline.
# Awards gallery and final-page artwork

The main portfolio includes editable examples in `sections/appendix.typ` and
`sections/afterword.typ`. The awards are explicitly mock exhibits, not claims of
actual awards. Replace their bodies with scans or photographs. `pf-award(body,
title: [], detail: [], accession: "", height: 65mm)` keeps each exhibit and its
10-11 pt wall label together; `pf-award-gallery(..exhibits)` makes two columns.
Use a standalone `pf-award` for a full-width exhibit.

Project corner images are configured separately in `sections/project-artwork.typ`.
Pass its dictionary as `pf-book(artworks: project-artwork, ...)`; keys are project
IDs. Each entry accepts `path`, `width`, `height`, `dx`, and `dy`. Image paths are
relative to `components/artwork.typ`. Set width alone (or height alone) for natural
aspect-ratio scaling, without a hidden cap. Set both for a contain-fit box.
The default corner is the bottom right of the body area; positive offsets move
right/down; negative values move left/up. Sizes and offsets are unrestricted;
use mm for predictable physical adjustments. Percentages refer to the full page,
not a prose column. Anything outside the physical page is cropped by the PDF.

Artwork follows the final physical page, including explicit continuation pages.
It is painted in the page background, behind text, outside `pf-flow`, and reserves
no space, so it cannot reflow prose. Overlap is allowed; there is no automatic
collision avoidance. Large or dark artwork can still reduce text readability.
Changes to the separate artwork file avoid changing the flow's source input, but
a fresh full compilation still compiles the document. Check with
`python tests/check-artwork.py` (requires pdfplumber).
