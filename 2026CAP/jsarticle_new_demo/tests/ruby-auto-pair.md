# Automatic ruby pairing (demo only)

Enabled by default, horizontally and in inline, region, and page vertical flow:

```typst
#ruby[신체발부 수지부모][身體髮膚 受之父母]
#ruby(auto-pair: false)[신체발부 수지부모][身體髮膚 受之父母]

#show: jsarticle-book.with(options: jsarticle-options(
  typography: (ruby-auto-pair: false),
))
// Per-call true overrides the book default; auto inherits it.
#ruby(auto-pair: true)[신체][身體]
```

Inference requires equal Unicode grapheme counts and matching whitespace
positions. Hangul (including decomposed/archaic clusters), Han, Hiragana,
Katakana, and Bopomofo characters qualify. Whitespace remains in the base with
an empty annotation. Explicit `|` on either side always takes precedence.
Mismatches, mixed non-CJK text, leading/trailing whitespace, and styled content
are left grouped. Styles are not stripped to force pairing.

This is not pronunciation analysis: equal-count Japanese readings can still
need manual grouping. Multi-symbol Bopomofo syllables/tone marks require
explicit delimiters, e.g. `#ruby[ㄕㄣ|ㄊㄧˇ][身|體]`.

Run from the demo root:

```powershell
typst compile --root . tests/ruby-auto-pair.typ "$env:TEMP/ruby-auto-pair.pdf"
typst compile --root . --input pair=false tests/ruby-auto-pair.typ "$env:TEMP/ruby-auto-pair-off.pdf"
typst compile --root . tests/old-hangul.typ "$env:TEMP/ruby-old-hangul.pdf"
typst compile --root . tests/vertical-font-defaults.typ "$env:TEMP/ruby-font-defaults.pdf"
typst compile --root . main.typ "$env:TEMP/demo-ruby-main.pdf"
```

The fixture asserts segmentation and override behavior, and renders inferred,
explicit, grouped, and forced-pairing comparisons. The horizontal adapter also
normalizes plain space-containing sequences for Rubby and uses stable local
text edges to prevent annotations overlapping the base.
