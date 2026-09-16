#import "../jsarticle.typ": *
#import "../src/jsarticle/options.typ": *

#assert(jsnnh1 == js-heading-unnumbered)
#assert(jsnnoh1 == js-heading-unlisted)
#assert(jsnneq == js-equation-unnumbered)
#assert(jspnum == js-problem-number)
#assert(jsans == js-answer-box)
#assert(resolve-option-record == resolve-options)
#assert(project-book-options == flatten-book-options)
#assert(flatten-book-options(jsarticle-options()) == project-book-options(jsarticle-options()))

#show: jsarticle-book.with(options: jsarticle-options(page: (h1-break: "continuous")))
#js-heading-unnumbered[Unnumbered heading]
#js-heading-unlisted[Unlisted heading]
#js-equation-unnumbered[$a^2 + b^2 = c^2$]
#js-problem-number(1) #js-answer-box[A]
