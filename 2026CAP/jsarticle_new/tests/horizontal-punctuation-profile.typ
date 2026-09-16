#import "../jsarticle.typ": jsarticle-book, jsarticle-options

#show: jsarticle-book.with(
  options: jsarticle-options(
    document: (title: [Horizontal punctuation profile], title-page: "inline"),
    typography: (
      ambient-language: "ko",
      optical-profiles: (
        ko: (
          punctuation: (baseline: -1em, tracking: 0em),
        ),
      ),
    ),
  ),
)

한글 (ASCII parentheses), [brackets], and 「CJK quotation marks」 all use the
configured punctuation baseline profile.
