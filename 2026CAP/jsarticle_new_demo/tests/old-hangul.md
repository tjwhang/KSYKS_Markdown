# Old Hangul in upright vertical cells

Basho stacks horizontally shaped clusters; it does not request true top-to-bottom
font shaping. Source Han Serif's `vert` GPOS positioning assumes true vertical
shaping and can displace combining Jamo (e.g. U+1147 U+1167, ᅇᅧ).
This is not missing glyph coverage or broken grapheme segmentation.

`upright-features` disables `vert`/`vrt2` only for cells containing conjoining
Jamo in U+1100-11FF, U+A960-A97F, or U+D7B0-D7FF. Hangul composition remains
enabled; other features, fonts, cell dimensions and pagination are unchanged.
Punctuation and non-Jamo cells retain their original feature settings.
The helper covers ordinary cells, heading cells, ruby readings and list markers.
This is a workaround for the horizontal-cell renderer, not a recommendation to
disable `vert` in a genuine vertical shaping engine.

Run `python tests/check-old-hangul.py` (Typst, Poppler, pdfplumber required).
It compares normal rendering with horizontal-feature reference rendering at
0.001 pt and pixel-for-pixel at 144 dpi, across region/inline/page modes and ruby.

Reference: https://ccjktype.fonts.adobe.com/2017/02/to-gpos-or-not-to-gpos.html
