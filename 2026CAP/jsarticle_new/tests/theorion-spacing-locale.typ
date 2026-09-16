#import "../preamble.typ": *
#show: show-theorion
#let gap = if sys.inputs.at("gap", default: "large") == "zero" { 0em } else { 1em }
#show: jsarticle-book.with(options: jsarticle-options(
  page: (h1-break: "continuous"),
  typography: (font-size: 11pt, cjk-spacing: gap, inline-atom-particles: none,
    inline-math-display-style: true, inline-math-bounds: true),
))
#set par(justify: false, first-line-indent: 0pt)
#set text(lang: "ko", region: none)
#problem(title: [한$x$글], difficulty: 1)[한$x$글]
#tip-box[한$x$글]
#solution[한$x$글]
#proof[한$x$글]
#theorem(floating: false)[한$x$글]

#pagebreak()
#set text(lang: "ko", region: "hj")
#solution[한$x$글]
#proof[한$x$글]
#problem[한$x$글]

#pagebreak()
#set text(lang: "ko", region: none)
#example[한$x$글]
#note-box[한$x$글]
#warning-box[한$x$글]
#exercise[한$x$글]<exercise-check>
#remark[한$x$글]
#conclusion[한$x$글]
@exercise-check
#solution(title: "CUSTOM")[Visible custom solution]
#proof(qed: sym.square.stroked)[Visible custom proof]
#set-result("noanswer")
#solution[HIDDEN-SOLUTION]
#proof[HIDDEN-PROOF]
#set-result("answer")

#pagebreak()
#set text(lang: "en", region: "US")
#solution[한$x$글]
#proof[한$x$글]
#problem[한$x$글]

#pagebreak()
#set text(lang: "ja", region: "JP")
#solution[한$x$글]
#proof[한$x$글]
#problem[한$x$글]
