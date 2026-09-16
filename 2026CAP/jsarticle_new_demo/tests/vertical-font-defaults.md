# Demo-only vertical defaults (not propagated)

Comparison: `jsarticle_new` and this demo had identical `src/cjk/flow.typ`.
Their default composite routing was functionally identical as well. The original
main explicitly imports/passes `document-composites`, selects different heading
and ruby families, and supplies 0.2em vertical boundary spacing. The demo does
not load its document-level `fonts.typ`; editing that file alone has no effect.

Repairs in the demo engine:
- `vertical.punctuation-font` defaults to the existing Hiragino Mincho face.
  This is a vertical renderer override, after composite selection, and leaves
  horizontal punctuation untouched. `none` disables the override. A per-call
  `punctuation-font` still wins. Region, inline, page, headings and ruby share it.
- Combining Jamo have an explicit supported face rule in each default composite:
  Source Han Serif K for serif families, Source Han Sans K for sans families.
  Previously multi-codepoint Jamo missed the single-codepoint Hangul category
  and reached the generic Han/any rule (Hiragino in the sans composites).
  Modern precomposed Hangul retains the selected Hangul face. This is deliberate
  script routing, not an assertion that Typst can detect shaping support.
- Vertical boundary spacing defaults to 0.2em independently of horizontal text;
  explicit `auto` still inherits horizontal spacing. Combining Jamo clusters
  now count as CJK for boundary spacing.

Run `python tests/check-vertical-font-defaults.py` and
`python tests/check-old-hangul.py` (pdfplumber/Poppler/Typst required).
The first verifies fonts embedded in the PDF, including an explicit override;
the second protects the earlier Jamo shaping fix with exact render comparisons.

No changes have been propagated to `jsarticle_new`, UNIST, or other projects.
