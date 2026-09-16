#import "../jsarticle.typ": jsarticle-options

// This document must fail with `options.page.colz`; it protects strict public
// validation from silently accepting a misspelled layout setting.
#jsarticle-options(page: (colz: 2))
