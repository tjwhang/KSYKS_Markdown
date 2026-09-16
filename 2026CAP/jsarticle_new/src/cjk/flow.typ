#import "../../vendor/basho-0.1.1/lib.typ" as basho
#import "fonts.typ": *
#import "profile.typ": *
#import "prepare.typ": *
#let cjk-vertical-defaults = (
    punctuation-font: none,
    ambient-language: "ja",
    page-margin: auto,
    page-start: false,
    heading-mode: "semantic",
    unicode-vertical-fallbacks: false,
    collapse-space-after-punctuation: auto,
    korean-fullwidth-cjk-spaces: false,
    boundary-spacing: 0.15em,
    inline-atom-particles: (ko: (), ja: ()),
    latin-orientation: "rotate",
    tcy-max-digits: 2,
    tracking: 0pt,
    ruby-size: 0.5em,
    ruby-gap: 0em,
    ruby-overflow: "reserve",
    ruby-overhang: 0.5em,
    width: auto,
    height: auto,
    columns: 1,
    rows: 1,
    line-gap: 0.6em,
    column-gap: 2em,
    row-gap: 2em,
    row-fit-threshold: 1.5,
    line-overhang-threshold: 0.5em,
    min-final-line-chars: 2,
    min-fragment-chars: 2,
    min-fragment-languages: ("ko",),
    justify-languages: ("ko",),
    justify: true,
    orphan-lines: 2,
    widow-lines: 2,
    stream-gap: 0.6em,
    font-family: "body",
    strong-family: "gothic",
    heading-family: "gothic",
    ruby-family: "body",
    fontsets: none,
)

// Fragment balancing and full-line expansion are language policies, not
// universal vertical-writing rules.  Korean benefits from both when ordinary
// spaces remain ordinary break spaces; Japanese and Chinese instead rely on
// their kinsoku profiles unless explicitly selected by the caller.
#let _cjk-language-policy-enabled(languages, language) = {
    if type(languages) != array { return false }
    languages.contains(language)
}

#let _cjk-effective-vertical-prose-layout(
    language, min-fragment, justify, min-fragment-languages, justify-languages,
) = (
    min-fragment-chars: if _cjk-language-policy-enabled(
        min-fragment-languages, language,
    ) { min-fragment } else { 1 },
    justify: if _cjk-language-policy-enabled(justify-languages, language) {
        justify
    } else { false },
)

#let cjk-normalize-vertical-defaults(values) = {
    let result = cjk-vertical-defaults
    for (key, value) in values {
        // `auto` means "use the declared default" for policy values.
        // Width and height remain intrinsically automatic because their
        // declared defaults are themselves `auto`.
        if value != auto or result.at(key, default: auto) == auto {
            result.insert(key, value)
        }
    }
    result
}

#let _cjk-heading-data(body) = {
    let walk(node) = if type(node) == array {
        node.map(walk).flatten()
    } else if type(node) == content {
        let name = repr(node.func())
        if name == "heading" {
            ((
                level: node.at("depth", default: node.at("level", default: 1)),
                body: node.body,
            ),)
        } else if node.has("children") {
            walk(node.children)
        } else if node.has("body") {
            walk(node.body)
        } else {
            ()
        }
    } else {
        ()
    }
    walk(body)
}

#let _cjk-semantic-heading-anchors(body, language, region, mode) = {
    if mode == "semantic" {
        for item in _cjk-heading-data(body) {
            text(lang: language, region: region, box(
                width: 0pt,
                height: 0pt,
                clip: true,
                heading(
                    level: item.level,
                    outlined: true,
                    bookmarked: true,
                    item.body,
                ),
            ))
        }
    }
}

#let _cjk-flow-resolve(body, policy, inline: false, flow: auto,
    page-renderer: none,
    region-height: auto, region-height-cap: none,
    language: auto, region: auto, font: auto,
    strong-font: auto, heading-font: auto, ruby-font: auto, font-family: auto,
    strong-family: auto, heading-family: auto, ruby-family: auto,
    page-start: auto, heading-mode: auto,
    unicode-vertical-fallbacks: auto, collapse-space-after-punctuation: auto,
    korean-fullwidth-cjk-spaces: auto, boundary-spacing: auto,
    inline-atom-particles: auto,
    latin-orientation: auto, tcy-max-digits: auto, tracking: auto,
    ruby-size: auto, ruby-gap: auto, ruby-overflow: auto, ruby-overhang: auto,
    width: auto, height: auto, columns: auto, rows: auto, gap: auto,
    column-gap: auto, row-gap: auto, row-fit-threshold: auto,
    line-overhang-threshold: auto, min-final-line-chars: auto,
    min-fragment-chars: auto,
    min-fragment-languages: auto,
    justify-languages: auto,
    justify: auto,
    orphan-lines: auto, widow-lines: auto,
    ..options) = context {
    let candidate = if language == auto { text.lang } else { language }
    let resolved-language = if ("ja", "ko", "zh").contains(candidate) {
        candidate
    } else { policy.at("ambient-language") }
    if not ("ja", "ko", "zh").contains(resolved-language) {
        resolved-language = "ja"
    }
    let resolved-region = if region == auto { text.region } else { region }
    let fontsets = policy.at("fontsets", default: none)
    if type(fontsets) != dictionary {
        panic("cjk vertical flow requires direct composite fontsets")
    }
    let resolved-font-family = if font-family == auto { policy.at("font-family") } else { font-family }
    let resolved-strong-family = if strong-family == auto { policy.at("strong-family") } else { strong-family }
    let resolved-heading-family = if heading-family == auto { policy.at("heading-family") } else { heading-family }
    let resolved-ruby-family = if ruby-family == auto { policy.at("ruby-family") } else { ruby-family }
    let named = options.named()
    named.insert("ruby-auto-pair", policy.at("ruby-auto-pair", default: true))
    if "punctuation-font" not in named and policy.at("punctuation-font", default: none) != none {
        named.insert("punctuation-font", policy.at("punctuation-font"))
    }
    if "features" not in named { named.insert("features", ("vert", "vrt2", "jsly")) }
    named.insert("language", resolved-language)
    named.insert("region", resolved-region)
    let direct-fontset = if font == auto {
        fontsets.at(resolved-font-family, default: none)
    } else { none }
    let direct-strong-fontset = if strong-font == auto {
        fontsets.at(resolved-strong-family, default: none)
    } else { none }
    let direct-heading-fontset = if heading-font == auto {
        fontsets.at(resolved-heading-family, default: none)
    } else { none }
    let direct-ruby-fontset = if ruby-font == auto {
        fontsets.at(resolved-ruby-family, default: none)
    } else { none }
    let common-fontset = fontsets.at("common", default: none)
    if direct-fontset != none {
        named.insert("font", cjk-fontset-native(direct-fontset, common: common-fontset))
        if "punctuation-font" not in named {
            named.insert("punctuation-font", cjk-fontset-native(
                direct-fontset, common: common-fontset,
            ))
        }
        named.insert("fontset", direct-fontset)
        named.insert("strong-fontset", direct-strong-fontset)
        named.insert("heading-fontset", direct-heading-fontset)
        named.insert("ruby-fontset", direct-ruby-fontset)
        named.insert("common-fontset", common-fontset)
        named.insert("strong-font", if strong-font == auto and direct-strong-fontset != none {
            cjk-fontset-native(direct-strong-fontset, common: common-fontset)
        } else { strong-font })
        named.insert("heading-font", if heading-font == auto and direct-heading-fontset != none {
            cjk-fontset-native(direct-heading-fontset, common: common-fontset)
        } else { heading-font })
        named.insert("ruby-font", if ruby-font == auto and direct-ruby-fontset != none {
            cjk-fontset-native(direct-ruby-fontset, common: common-fontset)
        } else { ruby-font })
    } else {
        // An explicit native body override exits the composite scope by
        // design. It remains valid in a direct-composite book; strong and
        // heading tokens can still use their configured document roles.
        named.insert("font", font)
        if "punctuation-font" not in named { named.insert("punctuation-font", font) }
        named.insert("strong-font", if direct-strong-fontset != none {
            cjk-fontset-native(direct-strong-fontset, common: common-fontset)
        } else { strong-font })
        named.insert("heading-font", if direct-heading-fontset != none {
            cjk-fontset-native(direct-heading-fontset, common: common-fontset)
        } else { heading-font })
        named.insert("strong-fontset", direct-strong-fontset)
        named.insert("heading-fontset", direct-heading-fontset)
        named.insert("ruby-fontset", direct-ruby-fontset)
        named.insert("common-fontset", common-fontset)
        named.insert("ruby-font", if ruby-font == auto and direct-ruby-fontset != none {
            cjk-fontset-native(direct-ruby-fontset, common: common-fontset)
        } else { ruby-font })
    }
    for (key, value) in (
        heading-mode: if heading-mode == auto { policy.at("heading-mode") } else { heading-mode },
        unicode-vertical-fallbacks: if unicode-vertical-fallbacks == auto { policy.at("unicode-vertical-fallbacks") } else { unicode-vertical-fallbacks },
        collapse-space-after-punctuation: if collapse-space-after-punctuation == auto { policy.at("collapse-space-after-punctuation") } else { collapse-space-after-punctuation },
        korean-fullwidth-cjk-spaces: if korean-fullwidth-cjk-spaces == auto { policy.at("korean-fullwidth-cjk-spaces") } else { korean-fullwidth-cjk-spaces },
        inline-atom-particles: if inline-atom-particles == auto { policy.at("inline-atom-particles") } else { inline-atom-particles },
        boundary-spacing: if boundary-spacing == auto { policy.at("boundary-spacing") } else { boundary-spacing },
        latin-orientation: if latin-orientation == auto { policy.at("latin-orientation") } else { latin-orientation },
        tcy-max-digits: if tcy-max-digits == auto { policy.at("tcy-max-digits") } else { tcy-max-digits },
        tracking: if tracking == auto { policy.at("tracking") } else { tracking },
        ruby-size: if ruby-size == auto { policy.at("ruby-size") } else { ruby-size },
        ruby-gap: if ruby-gap == auto { policy.at("ruby-gap") } else { ruby-gap },
        ruby-overflow: if ruby-overflow == auto { policy.at("ruby-overflow") } else { ruby-overflow },
        ruby-overhang: if ruby-overhang == auto { policy.at("ruby-overhang") } else { ruby-overhang },
        orphan-lines: if orphan-lines == auto { policy.at("orphan-lines") } else { orphan-lines },
        widow-lines: if widow-lines == auto { policy.at("widow-lines") } else { widow-lines },
    ) { named.insert(key, value) }
    let prose-layout = _cjk-effective-vertical-prose-layout(
        resolved-language,
        if min-fragment-chars == auto { policy.at("min-fragment-chars") } else { min-fragment-chars },
        if justify == auto { policy.at("justify") } else { justify },
        if min-fragment-languages == auto { policy.at("min-fragment-languages") } else { min-fragment-languages },
        if justify-languages == auto { policy.at("justify-languages") } else { justify-languages },
    )
    let grid = (
        width: if width == auto { policy.at("width") } else { width },
        height: if height == auto { policy.at("height") } else { height },
        columns: if columns == auto { policy.at("columns") } else { columns },
        rows: if rows == auto { policy.at("rows") } else { rows },
        gap: if gap == auto { policy.at("line-gap") } else { gap },
        column-gap: if column-gap == auto { policy.at("column-gap") } else { column-gap },
        row-gap: if row-gap == auto { policy.at("row-gap") } else { row-gap },
        row-fit-threshold: if row-fit-threshold == auto { policy.at("row-fit-threshold") } else { row-fit-threshold },
        line-overhang-threshold: if line-overhang-threshold == auto { policy.at("line-overhang-threshold") } else { line-overhang-threshold },
        min-final-line-chars: if min-final-line-chars == auto { policy.at("min-final-line-chars") } else { min-final-line-chars },
        min-fragment-chars: prose-layout.at("min-fragment-chars"),
        justify: prose-layout.at("justify"),
    )
    // All local and page primitives receive the same resolved layout options.
    // This fixes the former split where inline/region flow quietly missed some
    // per-book grid and final-line settings.
    for (key, value) in grid { named.insert(key, value) }
    // `auto` selects an intrinsic inline/region primitive when the stream fits
    // and promotes only genuinely long material to page flow.
    let resolved-flow = if inline { "inline" } else { flow }
    if not (resolved-flow in (auto, "inline", "page", "region")) {
        panic("vertical flow must be auto, \"inline\", \"page\", or \"region\"")
    }
    if resolved-flow == "region" {
        _cjk-local-vertical(
            body,
            region-height: region-height,
            region-height-cap: region-height-cap,
            _local-flow: "region",
            ..named,
        )
    } else if resolved-flow == "inline" {
        _cjk-local-vertical(
            body,
            region-height: region-height,
            region-height-cap: region-height-cap,
            _local-flow: "inline",
            ..named,
        )
    } else if resolved-flow == "page" {
        if page-renderer == none { panic("vertical page flow requires a page renderer") }
        let force-start = if page-start == auto { policy.at("page-start") } else { page-start }
        if force-start { colbreak(weak: true) }
        _cjk-vertical-flow-multi(((body: body),), policy, ..named)
    } else {
        let top = if type(page.margin) == dictionary { page.margin.at("top", default: page.margin.at("y", default: 0pt)) } else { page.margin }
        let bottom = if type(page.margin) == dictionary { page.margin.at("bottom", default: page.margin.at("y", default: 0pt)) } else { page.margin }
        let left = if type(page.margin) == dictionary { page.margin.at("left", default: page.margin.at("inside", default: page.margin.at("x", default: 0pt))) } else { page.margin }
        let right = if type(page.margin) == dictionary { page.margin.at("right", default: page.margin.at("outside", default: page.margin.at("x", default: 0pt))) } else { page.margin }
        let body-height = measure(box(height: page.height)).height - measure(box(height: top)).height - measure(box(height: bottom)).height
        let body-width = measure(box(width: page.width)).width - measure(box(width: left)).width - measure(box(width: right)).width
        let rows = grid.rows
        let row-gap-abs = measure(v(grid.at("row-gap"))).height
        let region-height = (
            body-height - calc.max(0, rows - 1) * row-gap-abs
        ) / rows
        let force-start = if page-start == auto { policy.at("page-start") } else { page-start }
        // Prepare first, then atomize only the compact result. Long material
        // never enters a box, so its page breaks remain legal and breakable.
        let prepared = _cjk-prepare-vertical(body, ..named)
        if basho.tate-inline-height(prepared) <= region-height {
            box(basho.tate-inline-prepared(prepared))
        } else if basho.tate-region-width(prepared, region-height) <= body-width {
            box(basho.tate-region-prepared(prepared, region-height))
        } else {
            if page-renderer == none { panic("vertical page flow requires a page renderer") }
            if force-start { colbreak(weak: true) }
            _cjk-vertical-flow-multi(((body: body),), policy, ..named)
        }
    }
}

// Render one phase of a shared multi-stream plan in a physical page body.
#let _cjk-vertical-flow-multi(
    bodies, policy, ..named-options,
) = context {
        let named = named-options.named()
        let page-ready = named.at("_page-ready", default: false)
        if "_page-ready" in named { let _ = named.remove("_page-ready") }
        // The first-page remainder is layout-dependent, so a paginating
        // one-column surface has to hand its cursor to the following flow on
        // the next typst pass. PLEASE keep that hand-off private to this *surface*:
        // a single global state made independent vertical groups overwrite one
        // another, which is what caused both lost streams and non-convergence.
        let surface-id = named.at("_surface-id", default: repr(bodies))
        if "_surface-id" in named { let _ = named.remove("_surface-id") }
        let requested-stream-gap = named.at("stream-gap", default: policy.at("stream-gap"))
        if "stream-gap" in named { let _ = named.remove("stream-gap") }
        // A wrapper boundary cannot be tighter than normal line leading.
        let stream-gap = if requested-stream-gap == auto { 0em } else {
            requested-stream-gap
        }
        let inter-stream-gap = calc.max(
            named.at("gap", default: policy.at("line-gap")), stream-gap,
        )
            let top = if type(page.margin) == dictionary { page.margin.at("top", default: page.margin.at("y", default: 0pt)) } else { page.margin }
            let bottom = if type(page.margin) == dictionary { page.margin.at("bottom", default: page.margin.at("y", default: 0pt)) } else { page.margin }
            let left = if type(page.margin) == dictionary { page.margin.at("left", default: page.margin.at("inside", default: page.margin.at("x", default: 0pt))) } else { page.margin }
            let right = if type(page.margin) == dictionary { page.margin.at("right", default: page.margin.at("outside", default: page.margin.at("x", default: 0pt))) } else { page.margin }
            let top-abs = measure(box(height: top)).height
            let full-height = measure(box(height: page.height)).height - top-abs - measure(box(height: bottom)).height
            let page-body-width = measure(box(width: page.width)).width - measure(box(width: left)).width - measure(box(width: right)).width
            let body-width = page-body-width
            let requested-height = named.at("height", default: policy.at("height"))
            let requested-width = named.at("width", default: policy.at("width"))
            let continuation-height = if requested-height == auto { full-height } else if type(requested-height) == ratio { full-height * requested-height } else { calc.min(full-height, measure(v(requested-height)).height) }
            let target-width = if requested-width == auto { body-width } else if type(requested-width) == ratio { body-width * requested-width } else { calc.min(body-width, measure(h(requested-width)).width) }
            let fontsets = policy.at("fontsets", default: none)
            if type(fontsets) != dictionary {
                panic("cjk vertical flow requires direct composite fontsets")
            }
            let streams = ()
            for item in bodies {
                let stream-body = if type(item) == dictionary { item.at("body") } else { item }
                let opts = named
                if type(item) == dictionary {
                    for (key, value) in item { if key != "body" { opts.insert(key, value) } }
                }
                let language = opts.at("language", default: text.lang)
                if not ("ja", "ko", "zh").contains(language) { language = policy.at("ambient-language") }
                let region = opts.at("region", default: text.region)
                let font-family = opts.at("font-family", default: policy.at("font-family"))
                let strong-family = opts.at("strong-family", default: policy.at("strong-family"))
                let heading-family = opts.at("heading-family", default: policy.at("heading-family"))
                let ruby-family = opts.at("ruby-family", default: policy.at("ruby-family"))
                // A descriptor resolved by `_cjk-flow-resolve` already carries
                // its composite identity alongside the native fallback stack.
                // Prefer that identity: the fallback stack is implementation
                // detail, not an explicit `font:` override from the author.
                let direct-fontset = opts.at("fontset", default: if opts.at("font", default: auto) == auto and fontsets != none {
                    fontsets.at(font-family, default: none)
                } else { none })
                let direct-strong-fontset = opts.at("strong-fontset", default: if opts.at("strong-font", default: auto) == auto and fontsets != none {
                    fontsets.at(strong-family, default: none)
                } else { none })
                let direct-heading-fontset = opts.at("heading-fontset", default: if opts.at("heading-font", default: auto) == auto and fontsets != none {
                    fontsets.at(heading-family, default: none)
                } else { none })
                let direct-ruby-fontset = opts.at("ruby-fontset", default: if opts.at("ruby-font", default: auto) == auto and fontsets != none {
                    fontsets.at(ruby-family, default: none)
                } else { none })
                let common-fontset = opts.at("common-fontset", default: fontsets.at("common", default: none))
                let prose-layout = _cjk-effective-vertical-prose-layout(
                    language,
                    opts.at("min-fragment-chars", default: policy.at("min-fragment-chars")),
                    opts.at("justify", default: policy.at("justify")),
                    opts.at("min-fragment-languages", default: policy.at("min-fragment-languages")),
                    opts.at("justify-languages", default: policy.at("justify-languages")),
                )
                streams.push((
                    ruby-auto-pair: policy.at("ruby-auto-pair", default: true),
                    body: stream-body,
                    language: language,
                    region: region,
                    font: if direct-fontset != none {
                        cjk-fontset-native(direct-fontset, common: common-fontset)
                    } else { opts.at("font", default: none) },
                    punctuation-font: opts.at(
                        "punctuation-font", default: if policy.at("punctuation-font", default: none) != none {
                            policy.at("punctuation-font")
                        } else if direct-fontset != none {
                            cjk-fontset-native(direct-fontset, common: common-fontset)
                        } else { opts.at("font", default: none) },
                    ),
                    strong-font: if direct-strong-fontset != none {
                        cjk-fontset-native(direct-strong-fontset, common: common-fontset)
                    } else { opts.at("strong-font", default: none) },
                    heading-font: if direct-heading-fontset != none {
                        cjk-fontset-native(direct-heading-fontset, common: common-fontset)
                    } else { opts.at("heading-font", default: none) },
                    ruby-font: if direct-ruby-fontset != none {
                        cjk-fontset-native(direct-ruby-fontset, common: common-fontset)
                    } else { opts.at("ruby-font", default: none) },
                    fontset: direct-fontset,
                    strong-fontset: direct-strong-fontset,
                    heading-fontset: direct-heading-fontset,
                    ruby-fontset: direct-ruby-fontset,
                    common-fontset: common-fontset,
                    heading-mode: opts.at("heading-mode", default: policy.at("heading-mode")),
                    unicode-vertical-fallbacks: opts.at("unicode-vertical-fallbacks", default: policy.at("unicode-vertical-fallbacks")),
                    collapse-space-after-punctuation: opts.at("collapse-space-after-punctuation", default: policy.at("collapse-space-after-punctuation")),
                    korean-fullwidth-cjk-spaces: opts.at("korean-fullwidth-cjk-spaces", default: policy.at("korean-fullwidth-cjk-spaces")),
                    inline-atom-particles: opts.at("inline-atom-particles", default: policy.at("inline-atom-particles")),
                    boundary-spacing: opts.at("boundary-spacing", default: policy.at("boundary-spacing")),
                    latin-orientation: opts.at("latin-orientation", default: policy.at("latin-orientation")),
                    tcy-max-digits: opts.at("tcy-max-digits", default: policy.at("tcy-max-digits")),
                    tracking: opts.at("tracking", default: policy.at("tracking")),
                    ruby-size: opts.at("ruby-size", default: policy.at("ruby-size")),
                    ruby-gap: opts.at("ruby-gap", default: policy.at("ruby-gap")),
                    ruby-overflow: opts.at("ruby-overflow", default: policy.at("ruby-overflow")),
                    ruby-overhang: opts.at("ruby-overhang", default: policy.at("ruby-overhang")),
                    min-final-line-chars: opts.at("min-final-line-chars", default: policy.at("min-final-line-chars")),
                    min-fragment-chars: prose-layout.at("min-fragment-chars"),
                    justify: prose-layout.at("justify"),
                    orphan-lines: opts.at("orphan-lines", default: policy.at("orphan-lines")),
                    widow-lines: opts.at("widow-lines", default: policy.at("widow-lines")),
                    features: opts.at("features", default: ("vert", "vrt2", "jsly")),
                ))
            }
            let row-count = named.at("rows", default: policy.at("rows"))
            if row-count == auto { row-count = 1 }
            let row-gap = named.at("row-gap", default: policy.at("row-gap"))
            let threshold = named.at(
                "row-fit-threshold", default: policy.at("row-fit-threshold"),
            )
            let min-final = named.at(
                "min-final-line-chars", default: policy.at("min-final-line-chars"),
            )
            let min-fragment = named.at(
                "min-fragment-chars", default: policy.at("min-fragment-chars"),
            )
            let justify = named.at("justify", default: policy.at("justify"))
            let orphan-lines = named.at("orphan-lines", default: policy.at("orphan-lines"))
            let widow-lines = named.at("widow-lines", default: policy.at("widow-lines"))
            let prepared = _cjk-prepare-vertical-streams(
                streams, text.lang, text.region, min-final, min-fragment,
                justify,
                orphan-lines, widow-lines,
            )
            let requested-flow = named.at("flow", default: auto)
            let natural-height = basho.tate-regions-natural-height(prepared)
            let natural-width = basho.tate-regions-natural-width(
                prepared, natural-height, gap: inter-stream-gap,
            )
            let intrinsic = (
                requested-flow != "page"
                    and natural-height <= continuation-height
                    and natural-width <= target-width
            )
            if intrinsic {
                basho.tate-regions-intrinsic-prepared(
                    prepared, natural-height,
                    gap: inter-stream-gap, width: target-width,
                )
            } else {
                let render-pages(first-height, part) = basho.tate-regions-prepared(
                    prepared,
                    first-height,
                    continuation-height,
                    target-width,
                    gap: inter-stream-gap,
                    columns: named.at("columns", default: policy.at("columns")),
                    rows: row-count,
                    column-gap: named.at("column-gap", default: policy.at("column-gap")),
                    row-gap: row-gap,
                    row-fit-threshold: threshold,
                    line-overhang-threshold: named.at(
                        "line-overhang-threshold",
                        default: policy.at("line-overhang-threshold"),
                    ),
                    part: part,
                )
                if page-ready {
                    // Multi-column documents have already switched to a fresh
                    // one-column physical page with normal side margins.
                    render-pages(continuation-height, "all")
                } else {
                    // Keep the first fragment in the current physical page.
                    // The continuation is rendered in normal surrounding flow
                    // from the stable, surface-specific cursor captured above.
                    let first-height = state(
                        "__cjk-vertical-first-height:" + surface-id, none,
                    )
                    block(width: 100%, height: 1fr, layout(size => {
                        first-height.update(size.height)
                        render-pages(size.height, "first")
                    }))
                    // A physical boundary separates the measured first
                    // fragment from its continuation. Keeping the break ahead
                    // of the state-dependent content prevents a short final
                    // continuation from feeding back into the preceding page
                    // remainder on the next typst pass.
                    pagebreak(weak: true)
                    context {
                        let captured = first-height.get()
                        if captured != none {
                            render-pages(captured, "rest")
                        }
                    }
                }
            }
}

#let _cjk-render-vertical-payloads(payloads) = context {
    let first = payloads.first()
    let policy = cjk-normalize-vertical-defaults(first.defaults)
    let common = first.options
    let streams = ()
    let anchors = []
    for payload in payloads {
        for source in payload.bodies {
            let item = if type(source) == dictionary { source } else { (body: source) }
            for (key, value) in payload.options {
                if key not in item { item.insert(key, value) }
            }
            if "language" not in item { item.insert("language", payload.language) }
            if "region" not in item { item.insert("region", payload.region) }
            let mode = item.at(
                "heading-mode", default: policy.at("heading-mode"),
            )
            anchors += _cjk-semantic-heading-anchors(
                item.body, item.language, item.region, mode,
            )
            item.insert("heading-mode", "visual")
            streams.push(item)
        }
    }
    let force-start = common.at("page-start", default: policy.at("page-start"))
    let page-ready = common.at("_page-ready", default: false)
    if force-start and not page-ready { colbreak(weak: true) }
    anchors
    _cjk-vertical-flow-multi(streams, policy, ..common)
}

#let cjk-vertical-flow(body, defaults: (:), ..options) = context {
    let payload = (
        bodies: (body,) + options.pos(),
        defaults: defaults,
        options: options.named(),
        language: text.lang,
        region: text.region,
    )
    if payload.bodies.len() == 1 {
        let policy = cjk-normalize-vertical-defaults(defaults)
        _cjk-flow-resolve(
            body, policy, page-renderer: _cjk-vertical-flow-multi,
            ..options.named(),
        )
    } else {
        _cjk-render-vertical-payloads((payload,))
    }
}

// Deterministic stream-array companion used by document templates that collect
// adjacent page-flow wrappers before layout. Each stream is `(body:, ..opts)`.
#let cjk-vertical-flow-streams(streams, defaults: (:), ..options) = context {
    if type(streams) != array or streams.len() == 0 {
        panic("cjk vertical flow streams must be a non-empty array")
    }
    _cjk-render-vertical-payloads(((
        bodies: streams,
        defaults: defaults,
        options: options.named(),
        language: text.lang,
        region: text.region,
    ),))
}
