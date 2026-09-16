#import "../preamble.typ": *
#import "../jsarticle.typ": jsarticle-book, jsarticle-options

#show: jsarticle-book.with(
  options: jsarticle-options(
    typography: (
      ambient-language: "ko",
      cjk-spacing: 1em,
    ),
  ),
)

#tip-box[$g(x)$로 놓아 본다.]

// Antique's answer environments defer their bodies through `context`; the
// preamble adapters must therefore prepare these boundaries before that step.
#solution[$s(x)$로 놓아 본다.]
#proof[$p(x)$로 놓아 본다.]

#figure(block(inset: 1em)[한글$x$좌표와 한글1좌표를 비교한다.])
