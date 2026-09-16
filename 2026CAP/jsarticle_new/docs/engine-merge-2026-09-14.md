# Reviewed engine merge, 2026-09-14

Source checkout: 3d7a966. Sources: jsarticle_new_demo and unist.
Destinations: jsarticle_new and 수능수학 only. Source projects, document content,
assets, main PDFs, and document-level fonts were left untouched.

## Accepted

- Demo ruby auto-pairing, book/per-call switches, plain spaced horizontal ruby,
  stable annotation bounds, and matching vertical ruby space metrics/painting.
- Demo Source Han Serif/Sans K Jamo fallback, Jamo vertical-feature correction,
  multi-Jamo CJK classification, Hiragino vertical punctuation routing,
  and 0.2em vertical boundary default.
- UNIST math/raw boundary and inline-atom particle propagation into the
  contextual paragraph compositor.
- UNIST preservation of empty authored horizontal ruby segments. Added matching
  vertical handling and an assertion for [い||かえ|][行|き|帰|り].
- Registered both new Basho helpers in engine-files.json; refreshed only merged
  entries in the math project's engine-lock.json.

## Retained locally

UNIST portfolio flow, Meander, artwork, appendix, specimen, math face/weight,
font choices, and footnote-marker styling are application-specific.
Demo zero tracking was not propagated: targets retain Hangul -0.06em and
Kana -0.01em. 수능수학 retains its 0.12 footnote-leading factor; jsarticle_new
retains 0.5. Formatting-only vendor changes were excluded.

## Verification

- Both baseline main builds succeeded without diagnostics.
- All 33 jsarticle_new Typst fixtures passed, including expected failures for
  the two deliberately invalid-option fixtures.
- Both targets passed ruby-auto-pair, pairing disabled, old-hangul, and
  vertical-font-defaults compiles.
- After the final trailing-empty change, both ruby settings and both main
  documents were recompiled successfully.
- Main page counts unchanged: jsarticle_new 26; 수능수학 13.
- PDF-rendered ruby fixture visually checked. Typst direct PNG output showed
  missing Han outlines; Poppler rendering of the PDF did not. No font changes
  were made to conceal this backend difference.
- Git whitespace check passes with cr-at-eol.
- Full-document pixel equality and performance benchmarking were not claimed.

Reproduce from IntroToQC using ../jsarticle_new/tools/check.ps1 with
-OutputDirectory pointing to a temporary directory. Compile each main.typ
with typst compile --root set to its project directory. Compile
tests/ruby-auto-pair.typ normally and with --input pair=false in both targets.
The old-hangul.typ and vertical-font-defaults.typ fixtures use the same command.

Do not blanket-sync the source projects: their local typography is intentional.
