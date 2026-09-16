#import "../../vendor/basho-0.1.1/lib.typ" as basho
#import "fonts.typ": *
#import "profile.typ": *
#let _cjk-apply-ruby-sizing(base) = {
    let ruby-size = base.at("ruby-size", default: auto)
    let ruby-gap = base.at("ruby-gap", default: auto)
    let ruby-overflow = base.at("ruby-overflow", default: auto)
    let ruby-overhang = base.at("ruby-overhang", default: auto)
    if "ruby-size" in base { let _ = base.remove("ruby-size") }
    if "ruby-gap" in base { let _ = base.remove("ruby-gap") }
    if "ruby-overflow" in base { let _ = base.remove("ruby-overflow") }
    if "ruby-overhang" in base { let _ = base.remove("ruby-overhang") }
    if ruby-size == auto and ruby-gap == auto and ruby-overflow == auto and ruby-overhang == auto {
        return base
    }

    let sizing = base.at("sizing", default: (:))
    if ruby-size != auto { sizing.insert("ruby-size", ruby-size) }
    if ruby-gap != auto {
        if ruby-gap < 0pt { panic("vertical ruby-gap must not be negative") }
        if "ruby-offset" in sizing {
            panic("vertical ruby-gap cannot be combined with sizing.ruby-offset")
        }
        sizing.insert("ruby-offset", sizing.at("char-box", default: 1em) + ruby-gap)
    }
    base.insert("sizing", sizing)
    let layout = base.at("layout", default: (:))
    if ruby-overflow != auto { layout.insert("ruby-overflow", ruby-overflow) }
    if ruby-overhang != auto {
        if ruby-overhang < 0pt { panic("vertical ruby-overhang must not be negative") }
        layout.insert("ruby-overhang", ruby-overhang)
    }
    if layout.len() > 0 { base.insert("layout", layout) }
    base
}

// Resolve vertical token selectors at the CJK/Basho boundary.  The returned
// tokens carry only native font lists, so Basho stays reusable outside
// jsarticle and does not know about faces, composites, or horizontal optics.
// Ruby base and reading selectors travel separately; ordinary, hanging, TCY,
// strong, and heading tokens are already immutable by the time pagination
// begins.
#let _cjk-attach-vertical-token-fonts(
    prepared,
    fontset: none,
    strong-fontset: none,
    heading-fontset: none,
    ruby-fontset: none,
    ruby-font: none,
    common-fontset: none,
    language: "ja",
    region: none,
) = {
    if fontset == none { return prepared }
    let fallback = if common-fontset == none { () } else {
        cjk-fontset-native(common-fontset)
    }
    let tokens = ()
    for token in prepared.tokens {
        let selected = if token.at("heading", default: none) != none {
            heading-fontset
        } else if token.at("bold", default: false) {
            strong-fontset
        } else {
            fontset
        }
        if selected != none and "text" in token and type(token.text) == str {
            let clusters = token.text.clusters()
            if clusters.len() > 0 {
                let resolved = cjk-resolve-font(
                    selected,
                    clusters.first(),
                    language: language,
                    region: region,
                    common: common-fontset,
                )
                if resolved != none {
                    token.insert("font", (resolved.selector,) + resolved.fallbacks + fallback)
                }
            }
        }
        let reading-fontset = if ruby-fontset != none { ruby-fontset } else { selected }
        if reading-fontset != none and token.type == "ruby" and "ruby" in token and type(token.ruby) == str {
            let clusters = token.ruby.clusters()
            if clusters.len() > 0 {
                let resolved = cjk-resolve-font(
                    reading-fontset,
                    clusters.first(),
                    language: language,
                    region: region,
                    common: common-fontset,
                )
                if resolved != none {
                    token.insert("ruby-font", (resolved.selector,) + resolved.fallbacks + fallback)
                }
            }
        } else if ruby-font != none and token.type == "ruby" {
            token.insert("ruby-font", ruby-font)
        }
        tokens.push(token)
    }
    let output = prepared
    output.insert("tokens", tokens)
    output
}

#let _cjk-prepare-vertical(body, language: "ja", region: none,
    font: none, strong-font: none, heading-font: none, ruby-font: none,
    fontset: none, strong-fontset: none, heading-fontset: none, ruby-fontset: none,
    common-fontset: none,
    page-start: false, heading-mode: "semantic",
    unicode-vertical-fallbacks: false,
    collapse-space-after-punctuation: auto,
    korean-fullwidth-cjk-spaces: false,
    boundary-spacing: auto, latin-orientation: "rotate",
    tcy-max-digits: 2, tracking: auto,
    width: auto, height: auto, columns: auto, rows: auto, gap: auto,
    column-gap: auto, row-gap: auto, row-fit-threshold: auto,
    line-overhang-threshold: auto, min-final-line-chars: auto,
    min-fragment-chars: auto,
    min-fragment-languages: auto,
    justify-languages: auto,
    justify: auto,
    orphan-lines: auto, widow-lines: auto,
    paragraph-indent: auto, paragraph-spacing: auto,
    features: auto, ..options) = {
    let base = options.named()
    let requested-justify = base.at("justify", default: justify)
    if "justify" in base { let _ = base.remove("justify") }
    base.insert("language", language)
    base.insert("region", region)
    base.insert("page-start", page-start)
    base.insert("heading-mode", heading-mode)
    base.insert("unicode-vertical-fallbacks", unicode-vertical-fallbacks)
    base.insert("collapse-space-after-punctuation", collapse-space-after-punctuation)
    base.insert("korean-fullwidth-cjk-spaces", korean-fullwidth-cjk-spaces)
    if boundary-spacing != auto {
        base.insert("cjk-western-gap", boundary-spacing)
        base.insert("western-cjk-gap", boundary-spacing)
    }
    base.insert("latin-orientation", latin-orientation)
    base.insert("tcy-max-digits", tcy-max-digits)
    if font != none { base.insert("font", font) }
    if strong-font != none { base.insert("strong-font", strong-font) }
    if heading-font != none { base.insert("heading-font", heading-font) }
    if features != auto { base.insert("features", features) }

    let sizing = base.at("sizing", default: (:))
    if tracking != auto { sizing.insert("tracking", tracking) }
    if sizing.len() > 0 { base.insert("sizing", sizing) }

    let layout = base.at("layout", default: (:))
    for (key, value) in (
        width: width, height: height, columns-per-row: columns, rows: rows,
        gap: gap, column-gap: column-gap, row-gap: row-gap,
        row-fit-threshold: row-fit-threshold,
        line-overhang-threshold: line-overhang-threshold,
        min-final-line-chars: min-final-line-chars,
        min-fragment-chars: min-fragment-chars,
        justify: requested-justify,
        orphan-lines: orphan-lines, widow-lines: widow-lines,
        paragraph-indent: paragraph-indent,
        paragraph-spacing: paragraph-spacing,
    ) { if value != auto { layout.insert(key, value) } }
    if layout.len() > 0 { base.insert("layout", layout) }
    let prepared = basho.prepare-tate(body, config: _cjk-apply-ruby-sizing(base))
    _cjk-attach-vertical-token-fonts(
        prepared,
        fontset: fontset,
        strong-fontset: strong-fontset,
        heading-fontset: heading-fontset,
        ruby-fontset: ruby-fontset,
        ruby-font: ruby-font,
        common-fontset: common-fontset,
        language: language,
        region: region,
    )
}

// Reusable, requirements-aware vertical CJK wrapper. The surrounding
// `text.lang`/`text.region` selects the langs unless explicitly provided in options.
#let _cjk-vertical-render(
    body,
    language: auto,
    region: auto,
    font: none,
    strong-font: none,
    heading-font: none,
    ruby-font: none,
    page-start: false,
    unicode-vertical-fallbacks: false,
    collapse-space-after-punctuation: auto,
    korean-fullwidth-cjk-spaces: false,
    boundary-spacing: auto,
    latin-orientation: "rotate",
    tcy-max-digits: 2,
    tracking: auto,
    width: auto,
    height: auto,
    columns: auto,
    rows: auto,
    gap: auto,
    column-gap: auto,
    row-gap: auto,
    row-fit-threshold: auto,
    line-overhang-threshold: auto,
    min-final-line-chars: auto,
    min-fragment-chars: auto,
    justify: auto,
    orphan-lines: auto,
    widow-lines: auto,
    paragraph-indent: auto,
    paragraph-spacing: auto,
    heading-mode: "semantic",
    features: auto,
    part: "all",
    initial-height: auto,
    _prepared-renderer: none,
    ..options,
) = context {
    let surrounding-language = text.lang
    let resolved-language = if language != auto {
        language
    } else if ("ja", "ko", "zh").contains(surrounding-language) {
        surrounding-language
    } else {
        "ja"
    }
    let resolved-region = if region == auto { text.region } else { region }
    let prepared = _cjk-prepare-vertical(
        body, language: resolved-language, region: resolved-region,
        font: font, strong-font: strong-font, heading-font: heading-font,
        ruby-font: ruby-font,
        page-start: page-start, heading-mode: heading-mode,
        unicode-vertical-fallbacks: unicode-vertical-fallbacks,
        collapse-space-after-punctuation: collapse-space-after-punctuation,
        korean-fullwidth-cjk-spaces: korean-fullwidth-cjk-spaces,
        boundary-spacing: boundary-spacing,
        latin-orientation: latin-orientation, tcy-max-digits: tcy-max-digits,
        tracking: tracking, width: width, height: height, columns: columns,
        rows: rows, gap: gap, column-gap: column-gap, row-gap: row-gap,
        row-fit-threshold: row-fit-threshold,
        line-overhang-threshold: line-overhang-threshold,
        min-final-line-chars: min-final-line-chars,
        min-fragment-chars: min-fragment-chars,
        justify: justify,
        orphan-lines: orphan-lines, widow-lines: widow-lines,
        paragraph-indent: paragraph-indent,
        paragraph-spacing: paragraph-spacing,
        features: features, ..options,
    )
    if _prepared-renderer != none {
        _prepared-renderer(prepared)
    } else {
        basho.tate-prepared(prepared, part: part, initial-height: initial-height)
    }
}

#let _cjk-vertical-inline-render(
    body,
    language: auto,
    region: auto,
    font: none,
    strong-font: none,
    heading-font: none,
    ruby-font: none,
    unicode-vertical-fallbacks: false,
    collapse-space-after-punctuation: auto,
    korean-fullwidth-cjk-spaces: false,
    boundary-spacing: auto,
    latin-orientation: "rotate",
    tcy-max-digits: 2,
    tracking: auto,
    min-final-line-chars: auto,
    min-fragment-chars: auto,
    justify: auto,
    orphan-lines: auto,
    widow-lines: auto,
    features: auto,
    heading-mode: "semantic",
    ..options,
) = context {
    let surrounding-language = text.lang
    let resolved-language = if language != auto {
        language
    } else if ("ja", "ko", "zh").contains(surrounding-language) {
        surrounding-language
    } else { "ja" }
    let base = options.named()
    let requested-justify = base.at("justify", default: justify)
    if "justify" in base { let _ = base.remove("justify") }
    base.insert("language", resolved-language)
    base.insert("region", if region == auto { text.region } else { region })
    base.insert("heading-mode", heading-mode)
    base.insert("unicode-vertical-fallbacks", unicode-vertical-fallbacks)
    base.insert("collapse-space-after-punctuation", collapse-space-after-punctuation)
    base.insert("korean-fullwidth-cjk-spaces", korean-fullwidth-cjk-spaces)
    if boundary-spacing != auto {
        base.insert("cjk-western-gap", boundary-spacing)
        base.insert("western-cjk-gap", boundary-spacing)
    }
    base.insert("latin-orientation", latin-orientation)
    base.insert("tcy-max-digits", tcy-max-digits)
    if font != none { base.insert("font", font) }
    if strong-font != none { base.insert("strong-font", strong-font) }
    if heading-font != none { base.insert("heading-font", heading-font) }
    if features != auto { base.insert("features", features) }
    if tracking != auto {
        let sizing = base.at("sizing", default: (:))
        sizing.insert("tracking", tracking)
        base.insert("sizing", sizing)
    }
    if min-final-line-chars != auto or min-fragment-chars != auto or requested-justify != auto or orphan-lines != auto or widow-lines != auto {
        let layout = base.at("layout", default: (:))
        if min-final-line-chars != auto { layout.insert("min-final-line-chars", min-final-line-chars) }
        if min-fragment-chars != auto { layout.insert("min-fragment-chars", min-fragment-chars) }
        if requested-justify != auto { layout.insert("justify", requested-justify) }
        if orphan-lines != auto { layout.insert("orphan-lines", orphan-lines) }
        if widow-lines != auto { layout.insert("widow-lines", widow-lines) }
        base.insert("layout", layout)
    }
    basho.tate-inline(body, config: _cjk-apply-ruby-sizing(base))
}

// Fixed-height, intrinsic-width primitive used by shared vertical streams.
#let _cjk-vertical-region-render(
    body,
    height,
    language: auto,
    region: auto,
    font: none,
    strong-font: none,
    heading-font: none,
    ruby-font: none,
    unicode-vertical-fallbacks: false,
    collapse-space-after-punctuation: auto,
    korean-fullwidth-cjk-spaces: false,
    boundary-spacing: auto,
    latin-orientation: "rotate",
    tcy-max-digits: 2,
    tracking: auto,
    min-final-line-chars: auto,
    min-fragment-chars: auto,
    justify: auto,
    orphan-lines: auto,
    widow-lines: auto,
    features: auto,
    heading-mode: "semantic",
    ..options,
) = context {
    let surrounding-language = text.lang
    let resolved-language = if language != auto { language } else if (
        ("ja", "ko", "zh").contains(surrounding-language)
    ) { surrounding-language } else { "ja" }
    let base = options.named()
    let requested-justify = base.at("justify", default: justify)
    if "justify" in base { let _ = base.remove("justify") }
    base.insert("language", resolved-language)
    base.insert("region", if region == auto { text.region } else { region })
    base.insert("heading-mode", heading-mode)
    base.insert("unicode-vertical-fallbacks", unicode-vertical-fallbacks)
    base.insert("collapse-space-after-punctuation", collapse-space-after-punctuation)
    base.insert("korean-fullwidth-cjk-spaces", korean-fullwidth-cjk-spaces)
    if boundary-spacing != auto {
        base.insert("cjk-western-gap", boundary-spacing)
        base.insert("western-cjk-gap", boundary-spacing)
    }
    base.insert("latin-orientation", latin-orientation)
    base.insert("tcy-max-digits", tcy-max-digits)
    if font != none { base.insert("font", font) }
    if strong-font != none { base.insert("strong-font", strong-font) }
    if heading-font != none { base.insert("heading-font", heading-font) }
    if features != auto { base.insert("features", features) }
    if tracking != auto {
        let sizing = base.at("sizing", default: (:))
        sizing.insert("tracking", tracking)
        base.insert("sizing", sizing)
    }
    if min-final-line-chars != auto or min-fragment-chars != auto or requested-justify != auto or orphan-lines != auto or widow-lines != auto {
        let layout = base.at("layout", default: (:))
        if min-final-line-chars != auto { layout.insert("min-final-line-chars", min-final-line-chars) }
        if min-fragment-chars != auto { layout.insert("min-fragment-chars", min-fragment-chars) }
        if requested-justify != auto { layout.insert("justify", requested-justify) }
        if orphan-lines != auto { layout.insert("orphan-lines", orphan-lines) }
        if widow-lines != auto { layout.insert("widow-lines", widow-lines) }
        base.insert("layout", layout)
    }
    basho.tate-region(body, height, config: _cjk-apply-ruby-sizing(base))
}

// Resolve a local vertical line length from the container typst is currently
// filling. `auto` is shrink-to-content: short labels stay compact
// while longer text occupies the available height and wraps left.
#let _cjk-local-height-value(value, available, option) = {
    if type(value) == ratio {
        if value <= 0% {
            panic(option + " ratios must be greater than zero")
        }
        return available * value
    }
    if type(value) == length { return measure(v(value)).height }
    panic(option + " must be a length or ratio")
}

// `region-height: auto` is shrink-to-content. A cap keeps a display gesture
// compact without imposing empty space on a shorter stream.
#let _cjk-local-region-height(requested, natural, available, cap: none) = {
    let height = if requested == auto or requested == none {
        calc.min(natural, available)
    } else {
        _cjk-local-height-value(requested, available, "vertical region height")
    }
    if cap == auto or cap == none { return height }
    calc.min(height, _cjk-local-height-value(
        cap, available, "vertical region height cap",
    ))
}

// Local vertical text is normal box. It never emits a page break;
// instead it uses the actual height exposed by the surrounding figure, block,
// box, grid cell, or remaining page region as its line length. The rendered
// box reports that exact geometry back to typst, so ordinary block/paragraph
// spacing remains intact.
#let _cjk-local-vertical(
    body, region-height: auto, region-height-cap: none, ..named-options,
) = context {
    let named = named-options.named()
    let local-flow = named.at("_local-flow", default: "region")
    if "_local-flow" in named { let _ = named.remove("_local-flow") }
    // The cover uses one intentionally unbounded display strip per source
    // line. It bypasses local container height while keeping explicit typst
    // line breaks as distinct rtl vertical lines
    let atomic-lines = named.at("_atomic-lines", default: false)
    if "_atomic-lines" in named { let _ = named.remove("_atomic-lines") }
    let prepared = _cjk-prepare-vertical(body, ..named)
    if atomic-lines {
        let lines = ()
        let current = ()
        for token in prepared.tokens {
            if token.type in ("newline", "parbreak") {
                lines.push(current)
                current = ()
            } else if token.type != "heading-anchor" {
                current.push(token)
            }
        }
        if current.len() > 0 { lines.push(current) }
        let strips = lines.map(tokens => basho.tate-inline-prepared((
            tokens: tokens, config: prepared.config,
        )))
        return stack(
            dir: rtl,
            spacing: prepared.config.layout.at("gap", default: 0.6em),
            ..strips,
        )
    }
    let forced-break = prepared.tokens.any(token => token.type in (
        "newline", "parbreak", "heading-anchor", "hblock", "vblock",
    ))
    let visible = prepared.tokens.filter(token => not (token.type in (
        "newline", "parbreak", "heading-anchor",
    )))
    let min-final = prepared.config.layout.at(
        "min-final-line-chars", default: 2,
    )
    // A short unbroken inline label inside an auto-sized figure or grid must
    // establish the height it needs. The region paginator adds a paragraph
    // indent after the intrinsic height is measured, which formerly made a
    // five-cell label split into a one-cell runt and a second line. Explicit
    // region heights and ordinary prose still flow against the container.
    let intrinsic-label = (
        local-flow == "inline"
          and (region-height == auto or region-height == none)
          and not forced-break
          and visible.len() <= calc.max(4, 2 * min-final + 1)
    )
    if intrinsic-label { return basho.tate-inline-prepared(prepared) }
    layout(size => {
        // Explicit vertical line breaks create side-by-side lines. Their
        // local region needs the tallest line.
        let natural = if forced-break {
            basho.tate-region-natural-height(prepared)
        } else {
            basho.tate-inline-height(prepared)
        }
        if natural <= 0pt { return box() }
        let height = _cjk-local-region-height(
            region-height, natural, size.height, cap: region-height-cap,
        )
        if height <= 0pt {
            panic("vertical text has no usable local height")
        }
        let plan = basho.tate-region-plan-prepared(prepared, height)
        if not plan.empty and plan.width > size.width {
            panic(
                "vertical text does not fit in the local container; "
                  + "use a taller region, a wider container, or page flow "
                  + "(needs " + repr(plan.width) + ", has " + repr(size.width) + ")",
            )
        }
        basho.tate-region-from-plan(plan, height)
    })
}

// Paginated companion to cjk-vertical-region. Each stream is a dictionary
// containing `body` plus the same language/font/rendering options accepted by
// the single-region wrapper. This keeps profile construction outside Basho
// while letting Basho retain source-token continuity across pages.
#let _cjk-prepare-vertical-streams(
    streams, surrounding-language, surrounding-region, min-final-line-chars,
    min-fragment-chars,
    justify,
    orphan-lines, widow-lines,
) = {
    let sources = ()
    for stream in streams {
        let language = stream.at("language", default: auto)
        let resolved-language = if language != auto { language } else if (
            ("ja", "ko", "zh").contains(surrounding-language)
        ) { surrounding-language } else { "ja" }
        let base = stream.at("config", default: (:))
        base.insert("language", resolved-language)
        base.insert("region", stream.at("region", default: surrounding-region))
        base.insert("heading-mode", stream.at("heading-mode", default: "semantic"))
        base.insert("unicode-vertical-fallbacks", stream.at(
            "unicode-vertical-fallbacks", default: false,
        ))
        base.insert("collapse-space-after-punctuation", stream.at(
            "collapse-space-after-punctuation", default: auto,
        ))
        base.insert("korean-fullwidth-cjk-spaces", stream.at(
            "korean-fullwidth-cjk-spaces", default: false,
        ))
        base.insert("inline-atom-particles", stream.at(
            "inline-atom-particles", default: (ko: (), ja: ()),
        ))
        let boundary = stream.at("boundary-spacing", default: auto)
        if boundary != auto {
            base.insert("cjk-western-gap", boundary)
            base.insert("western-cjk-gap", boundary)
        }
        base.insert("latin-orientation", stream.at(
            "latin-orientation", default: "rotate",
        ))
        base.insert("tcy-max-digits", stream.at("tcy-max-digits", default: 2))
        for key in ("font", "punctuation-font", "strong-font", "heading-font", "features") {
            let value = stream.at(key, default: none)
            if value != none and value != auto { base.insert(key, value) }
        }
        let tracking = stream.at("tracking", default: auto)
        if tracking != auto {
            let sizing = base.at("sizing", default: (:))
            sizing.insert("tracking", tracking)
            base.insert("sizing", sizing)
        }
        for key in ("ruby-auto-pair", "ruby-size", "ruby-gap", "ruby-overflow", "ruby-overhang") {
            let value = stream.at(key, default: auto)
            if value != auto { base.insert(key, value) }
        }
        let layout = base.at("layout", default: (:))
        layout.insert("min-final-line-chars", stream.at(
            "min-final-line-chars", default: min-final-line-chars,
        ))
        layout.insert("min-fragment-chars", stream.at(
            "min-fragment-chars", default: min-fragment-chars,
        ))
        layout.insert("justify", stream.at("justify", default: justify))
        layout.insert("orphan-lines", stream.at(
            "orphan-lines", default: orphan-lines,
        ))
        layout.insert("widow-lines", stream.at(
            "widow-lines", default: widow-lines,
        ))
        base.insert("layout", layout)
        sources.push((body: stream.body, config: _cjk-apply-ruby-sizing(base)))
    }
    let prepared = basho.prepare-tate-streams(sources)
    let output = ()
    for (index, source) in prepared.enumerate() {
        let stream = streams.at(index)
        output.push(_cjk-attach-vertical-token-fonts(
            source,
            fontset: stream.at("fontset", default: none),
            strong-fontset: stream.at("strong-fontset", default: none),
            heading-fontset: stream.at("heading-fontset", default: none),
            ruby-fontset: stream.at("ruby-fontset", default: none),
            ruby-font: stream.at("ruby-font", default: none),
            common-fontset: stream.at("common-fontset", default: none),
            language: stream.at("language", default: surrounding-language),
            region: stream.at("region", default: surrounding-region),
        ))
    }
    output
}

#let cjk-vertical-regions(
    streams,
    height,
    full-height,
    width,
    gap: 1em,
    columns: 1,
    rows: 1,
    column-gap: 2em,
    row-gap: 2em,
    row-fit-threshold: 1.5,
    line-overhang-threshold: 0.5em,
    min-final-line-chars: 2,
    min-fragment-chars: 2,
    justify: true,
    orphan-lines: 2,
    widow-lines: 2,
    intrinsic: false,
    part: "all",
) = context {
    let streams = _cjk-prepare-vertical-streams(
        streams, text.lang, text.region, min-final-line-chars,
        min-fragment-chars,
        justify,
        orphan-lines, widow-lines,
    )
    if intrinsic {
        basho.tate-regions-intrinsic-prepared(
            streams, height, gap: gap, width: width,
        )
    } else {
        basho.tate-regions-prepared(
            streams,
            height,
            full-height,
            width,
            gap: gap,
            columns: columns,
            rows: rows,
            column-gap: column-gap,
            row-gap: row-gap,
            row-fit-threshold: row-fit-threshold,
            line-overhang-threshold: line-overhang-threshold,
            part: part,
        )
    }
}
#let cjkvert = cjk-vertical
#let cjk-tcy = basho.tcy
#let cjk-upright = basho.vert
#let cjk-turn = basho.turn
#let cjk-ruby = basho.ruby
#let cjk-vblock = basho.vblock
#let cjk-hblock = basho.hblock
