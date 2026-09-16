#import "../jsarticle.typ": jsarticle-book, jsarticle-options

// A book with no font overrides must use the direct composite defaults rather
// than construct the retired language-profile hierarchy.
#show: jsarticle-book.with(options: jsarticle-options())

English 한국어 日本語 中文 123 「」
