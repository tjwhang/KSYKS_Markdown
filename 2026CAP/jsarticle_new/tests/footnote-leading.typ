#import "../preamble.typ": *
#import "../jsarticle.typ": jsarticle-book, jsarticle-options

#show: jsarticle-book.with(
  options: jsarticle-options(
    typography: (ambient-language: "ko"),
    // Resolve the entry through a non-default named role: this confirms that
    // `fonts.footnote` is independent of the ordinary body font.
    fonts: (footnote-family: "gothic"),
  ),
)

This paragraph carries an ordinary footnote#footnote[
  The reduced footnote face must retain a compact, proportional line rhythm
  when the note wraps across multiple lines rather than inheriting the
  body-sized leading.
] and a translation note#transnote[
  Translation notes use the same entry renderer and must therefore have the
  same responsive leading as ordinary footnotes.
].
