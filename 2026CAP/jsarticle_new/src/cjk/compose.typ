#import "fonts.typ": *
#import "spacing.typ": *
#import "language.typ": *
#import "normalize.typ": *
#let cjk-language-layout(
    body,
    text-size,
    fontsets: none,
    common-fontset: none,
    config: (:),
) = {
    let options = (
        language-aware: true,
        ambient-language: none,
        cjk-scale: 0.925em,
        latin-scale: 1em,
        latin-baseline: 0em,
        latin-tracking: 0em,
        latin-light-weight: false,
        japanese-scale: auto,
        chinese-scale: auto,
        strong-latin-scale: auto,
        strong-latin-baseline: 0em,
        korean-leading-ratio: 1.60,
        western-leading-ratio: 1.48,
        japanese-leading-ratio: 1.60,
        chinese-leading-ratio: 1.58,
        paragraph-profiles: (:),
        skip-features: none,
        skip-paragraph-features: none,
        boundary-spacing: none,
        inline-atom-particles: (ko: (), ja: ()),
        math-boundary-spacing: none,
        raw-boundary-spacing: none,
        western-languages: cjk-western-languages,
        markers: cjk-horizontal-profile-features,
        strong-marker: cjk-semantic-strong-marker,
        bypass-marker: (jscb: 1),
        horizontal-normalization: none,
        fontset-optics: (:),
    )
    let merge(base, source) = {
        for (key, value) in source {
            if key not in base {
                panic("Unknown CJK layout option: " + repr(key))
            }
            base.insert(key, value)
        }
        base
    }
    options = merge(options, config)

    let language-aware = options.at("language-aware")
    let ambient-language = options.at("ambient-language")
    let cjk-scale = options.at("cjk-scale")
    let latin-scale = options.at("latin-scale")
    let latin-baseline = options.at("latin-baseline")
    let latin-tracking = options.at("latin-tracking")
    let latin-light-weight = options.at("latin-light-weight")
    if not (
        type(latin-light-weight) == bool
          or (
            type(latin-light-weight) == int
              and latin-light-weight >= 1
              and latin-light-weight <= 1000
          )
    ) {
        panic("latin-light-weight must be false, true, or an integer from 1 to 1000")
    }
    let latin-body-weight = if latin-light-weight == false { none } else if (
        latin-light-weight == true
    ) { "light" } else { latin-light-weight }
    let japanese-scale = options.at("japanese-scale")
    let chinese-scale = options.at("chinese-scale")
    let strong-latin-scale = options.at("strong-latin-scale")
    let strong-latin-baseline = options.at("strong-latin-baseline")
    let korean-leading-ratio = options.at("korean-leading-ratio")
    let western-leading-ratio = options.at("western-leading-ratio")
    let japanese-leading-ratio = options.at("japanese-leading-ratio")
    let chinese-leading-ratio = options.at("chinese-leading-ratio")
    let skip-features = options.at("skip-features")
    let skip-paragraph-features = options.at("skip-paragraph-features")
    let boundary-spacing = options.at("boundary-spacing")
    let inline-atom-particles = options.at("inline-atom-particles")
    if type(inline-atom-particles) != dictionary {
        panic("inline-atom-particles must be a language dictionary")
    }
    for (language, particles) in inline-atom-particles {
        if language not in ("ko", "ja") {
            panic("inline-atom-particles has unknown language " + repr(language))
        }
        if type(particles) != array or not particles.all(particle => type(particle) == str) {
            panic("inline-atom-particles." + language + " must be an array of strings")
        }
    }
    let math-boundary-spacing = options.at("math-boundary-spacing")
    let raw-boundary-spacing = options.at("raw-boundary-spacing")
    let western-languages = options.at("western-languages")
    let markers = options.at("markers")
    let strong-marker = options.at("strong-marker")
    let bypass-marker = options.at("bypass-marker")
    let horizontal-normalization = options.at("horizontal-normalization")
    if horizontal-normalization != none and type(horizontal-normalization) != dictionary {
        panic("Horizontal normalization options must be a dictionary or none.")
    }
    let fontset-optics = options.at("fontset-optics")
    if type(fontsets) != dictionary or "body" not in fontsets {
        panic("fontsets must provide a body composite")
    }
    if fontset-optics != none and type(fontset-optics) != dictionary {
        panic("fontset-optics must be a dictionary or none")
    }
    let includes-features(features, required) = {
        let matches = true
        for (key, value) in required {
            if features.at(key, default: none) != value { matches = false }
        }
        matches
    }
    let matches-feature-option(features, option) = if option == none {
        false
    } else if type(option) == dictionary {
        includes-features(features, option)
    } else {
        option.any(marker => includes-features(features, marker))
    }
    let skips-layout(features) = matches-feature-option(features, skip-features) or includes-features(
        features, bypass-marker,
    )
    let skips-paragraph-layout(features) = skips-layout(features) or matches-feature-option(
        features, skip-paragraph-features,
    )

    // Language profiles own paragraph behaviour as well as font selection.
    // KLREQ makes Korean an explicit peer of Japanese, Chinese, and Western
    // composition instead of relying on a template's ambient paragraph rule.
    let paragraph-profiles = cjk-paragraph-profiles
    for (key, ratio) in (
        ko: korean-leading-ratio,
        western: western-leading-ratio,
        ja: japanese-leading-ratio,
        zh: chinese-leading-ratio,
    ) {
        let profile = paragraph-profiles.at(key)
        profile.insert("leading-ratio", ratio)
        paragraph-profiles.insert(key, profile)
    }
    for (key, overrides) in options.at("paragraph-profiles") {
        if key not in paragraph-profiles {
            panic("Unknown paragraph profile: " + repr(key))
        }
        let profile = paragraph-profiles.at(key)
        for (field, value) in overrides {
            if field not in profile {
                panic("Unknown paragraph profile field: " + repr(field))
            }
            profile.insert(field, value)
        }
        paragraph-profiles.insert(key, profile)
    }

    let strong-latin-size = if strong-latin-scale == auto { cjk-scale } else { strong-latin-scale }
    let japanese-size = if japanese-scale == auto { cjk-scale } else { japanese-scale }
    let chinese-size = if chinese-scale == auto { cjk-scale } else { chinese-scale }
    let script-patterns = (
        hangul: regex("^[\p{sc:Hangul}]$"),
        han: regex("^[\p{sc:Han}]$"),
        kana: regex("^[\p{sc:Hiragana}\p{sc:Katakana}]$"),
        latin: regex("^[\p{sc:Latn}ˈˌːˑ]\p{M}*$"),
        number: regex("^[0-9]$"),
        cyrillic: regex("^\p{sc:Cyrl}\p{M}*$"),
        greek: regex("^\p{sc:Grek}\p{M}*$"),
        western-content: regex("[\p{sc:Latn}\p{sc:Cyrl}\p{sc:Grek}]"),
        punctuation: regex("^[。、，．！？；：.,?!~:;‘’“”(){}\[\]（）［］｛｝〔〕〈〉《》【】「」『』]$"),
        open: regex("^[(\[\{]$"),
        close: regex("^[)\]\}]$"),
    )

    // typst memoizes this pure classifier. Keeping it as a small function is
    // faster than repeating the regular-expression chain for every occurrence
    // of the same cluster in long prose, while run construction stays linear.
    let script-info(cluster) = if cjk-is-open(cjk-boundary-kind(cluster)) or cjk-is-close(cjk-boundary-kind(cluster)) {
        (kind: "punctuation", tag: "hani", boundary: cjk-boundary-kind(cluster))
    } else if cluster.match(script-patterns.hangul) != none {
        (kind: "hangul", tag: "hang", boundary: "cjk")
    } else if cluster.match(script-patterns.han) != none {
        (kind: "han", tag: "hani", boundary: "cjk")
    } else if cluster.match(script-patterns.kana) != none {
        (kind: "kana", tag: "kana", boundary: "cjk")
    } else if cluster.match(script-patterns.punctuation) != none {
        let boundary = if cluster.match(script-patterns.open) != none {
            "open"
        } else if cluster.match(script-patterns.close) != none {
            "close"
        } else { none }
        (kind: "punctuation", tag: "hani", boundary: boundary)
    } else if cluster.match(script-patterns.latin) != none {
        (kind: "western", tag: "latn", boundary: "western")
    } else if cluster.match(script-patterns.number) != none {
        // Numbers retain the Western font role while using their own boundary
        // class. CJK/number pairs receive the same shared CJK/Latin measure,
        // but the class prevents a digit from being mistaken for a letter by
        // particle and script-specific optical rules.
        (kind: "number", tag: "latn", boundary: "number")
    } else if cluster.match(script-patterns.cyrillic) != none {
        (kind: "western", tag: "cyrl", boundary: "western")
    } else if cluster.match(script-patterns.greek) != none {
        (kind: "western", tag: "grek", boundary: "western")
    } else {
        (kind: "other", tag: "hani", boundary: none)
    }

    let script-runs(source) = {
        let runs = ()
        let current = none
        // Cluster arrays avoid repeatedly copying an increasingly long
        // string while a long Korean, Han, or Latin run is assembled.
        // Joining once per final run preserves the exact source text.
        let clusters-in-run = ()
        for cluster in source.clusters() {
            let info = script-info(cluster)
            if current != none and info != current {
                runs.push((..current, text: clusters-in-run.join("")))
                clusters-in-run = ()
            }
            current = info
            clusters-in-run.push(cluster)
        }
        if clusters-in-run.len() > 0 {
            runs.push((..current, text: clusters-in-run.join("")))
        }
        runs
    }

    // Called within the text show rule's context. Another context here would
    // create deferred layout work for every run during text-fit measurements.
    let compose(it, key, scale, western: false, fixed-layout: false) = {
        let language = text.lang
        let region = text.region
        let marker = markers.at(key)
        // Preserve the paragraph-pass marker across script-run rebuilding.
        // The generated-profile test below accepts this superset.
        let output-features = text.features
        for (tag, value) in marker { output-features.insert(tag, value) }
        // Strong is a semantic state supplied by a `strong` show-set rule
        let strong = includes-features(text.features, strong-marker)
        // A direct role is the only route into composite typography. Its native
        // signature is an override boundary: nested `text(font: ...)` content
        // remains native instead of inheriting an unrelated face's optics.
        // The native signature is an override boundary: a nested native
        // `text(font: ...)` exits the composite scope instead of inheriting an
        // unrelated role's face optics.
        let direct-role = cjk-font-role(text.features)
        let requested-fontset = if direct-role == none { none } else {
            fontsets.at(direct-role, default: none)
        }
        let active-fontset = if requested-fontset != none and cjk-fontset-native-matches(
            requested-fontset,
            text.font,
            common: common-fontset,
        ) {
            requested-fontset
        } else {
            none
        }
        let active-role = direct-role
        let source = if fixed-layout or horizontal-normalization == none {
            it.text
        } else {
            cjk-normalize-horizontal-text(
                it.text,
                language: if key == "sc" or key == "tc" { "zh" } else { key },
                punctuation: horizontal-normalization.at("punctuation", default: true),
                spaces: horizontal-normalization.at("spaces", default: true),
                collapse-punctuation-space: horizontal-normalization.at(
                    "collapse-punctuation-space", default: true,
                ),
            )
        }
        let source-has-western = source.match(script-patterns.western-content) != none
        let emit(value, args) = {
            // Resolve relative line-box edges before the face's optical scale
            // changes glyph size. Local caption/footnote sizes still apply.
            if type(text.top-edge) == length { args.insert("top-edge", text.top-edge.to-absolute()) }
            if type(text.bottom-edge) == length { args.insert("bottom-edge", text.bottom-edge.to-absolute()) }
            if active-fontset != none {
                cjk-fontset-render(
                    active-fontset,
                    value,
                    language: language,
                    region: region,
                    common: common-fontset,
                    global-optics: fontset-optics,
                    styles: args,
                )
            } else { text(value, ..args) }
        }
        if western {
            let args = (
                size: if strong { strong-latin-size } else { latin-scale },
                baseline: if strong {
                    strong-latin-baseline
                } else { latin-baseline },
                tracking: latin-tracking,
                lang: language,
                region: region,
                script: auto,
                dir: ltr,
                hyphenate: true,
                cjk-latin-spacing: none,
                features: output-features,
            )
            if latin-body-weight != none and not strong and active-role == "body" {
                args.insert("weight", latin-body-weight)
            }
            emit(source, args)
        } else {
            let node-boundary-spacing = if fixed-layout or key != "ko" {
                none
            } else { boundary-spacing }
            let particle-joining = not fixed-layout and key in ("ko", "ja") and source-has-western and (
                inline-atom-particles.at(key, default: ()).len() != 0
            )
            let latin-needs-adjustment = source-has-western and (
                latin-scale != scale
                    or latin-baseline != 0em
                    or latin-tracking != 0em
                    or (strong and (
                        strong-latin-size != scale
                            or strong-latin-baseline != 0em
                    ))
                    // A configured body weight also requires script-run
                    // composition. Otherwise a CJK-context paragraph can
                    // bypass the Latin run that owns the variable-weight
                    // request while an explicit Western paragraph cannot.
                    or (
                        latin-body-weight != none
                          and not strong
                          and active-role == "body"
                    )
            )
            let needs-adjustment = (
                node-boundary-spacing != none
                  or particle-joining
                  or latin-needs-adjustment
            )
            if not needs-adjustment {
                emit(source, (
                    // Composite optics own CJK scaling. Starting at 1em keeps
                    // an explicit face scale from multiplying the legacy
                    // contextual `cjk-scale` a second time.
                    size: 1em,
                    lang: language,
                    region: region,
                    script: auto,
                    dir: ltr,
                    cjk-latin-spacing: auto,
                    features: output-features,
                ))
            } else {
                let output = ()
                let previous = none
                for run in script-runs(source) {
                    let particle = if previous == "western" and run.boundary == "cjk" {
                        cjk-leading-inline-particle(
                            run.text,
                            inline-atom-particles,
                            language: key,
                        )
                    } else { none }
                    let join-particle = particle != none
                    if previous != none {
                        let script-boundary = (
                            (previous == "cjk" and run.boundary == "western")
                                or (previous == "western" and run.boundary == "cjk")
                                or (previous == "cjk" and run.boundary == "number")
                                or (previous == "number" and run.boundary == "cjk")
                        )
                        let word-before = previous == "cjk" or previous == "western" or previous == "number"
                        let word-after = run.boundary == "cjk" or run.boundary == "western" or run.boundary == "number"
                        let bracket-boundary = (
                            (word-before and cjk-is-open(run.boundary))
                                or (cjk-is-close(previous) and word-after)
                        )
                        if script-boundary and node-boundary-spacing != none and not join-particle {
                            output.push(sym.wj)
                            output.push(h(node-boundary-spacing, weak: true))
                            output.push(sym.wj)
                        } else if bracket-boundary and node-boundary-spacing != none {
                            output.push(cjk-boundary-gap("bracket", node-boundary-spacing, previous: previous, current: run.boundary))
                        }
                    }
                    let run-is-western = run.kind == "western" or run.kind == "number"
                    let default-baseline = if run-is-western {
                        if strong {
                            strong-latin-baseline
                        } else { latin-baseline }
                    } else { 0em }
                    let default-tracking = if run-is-western {
                        latin-tracking
                    } else { 0em }
                    let default-size = if run-is-western {
                        if strong { strong-latin-size } else { latin-scale }
                    } else { 1em }
                    let baseline = default-baseline
                    let tracking = default-tracking
                    let run-size = default-size
                    let run-args = (
                        size: run-size,
                        baseline: baseline,
                        tracking: tracking,
                        lang: language,
                        region: region,
                        script: run.tag,
                        dir: ltr,
                        // The compositor owns every CJK/Latin and CJK/number
                        // boundary explicitly. Leaving Typst's
                        // automatic spacing enabled on the CJK side adds a
                        // second, invisible gap and forces users to offset it
                        // with negative `cjk-spacing` values.
                        cjk-latin-spacing: none,
                        features: output-features,
                    )
                    if (
                        run-is-western
                          and latin-body-weight != none
                          and not strong
                          and active-role == "body"
                    ) {
                        run-args.insert("weight", latin-body-weight)
                    }
                    if join-particle {
                        let tail = run.text.slice(particle.len())
                        if node-boundary-spacing != none {
                            output.push(sym.wj)
                            output.push(h(node-boundary-spacing, weak: true))
                            output.push(sym.wj)
                        } else {
                            output.push(sym.wj)
                        }
                        output.push(emit(particle, run-args))
                        if tail != "" { output.push(emit(tail, run-args)) }
                    } else {
                        output.push(emit(run.text, run-args))
                    }
                    previous = run.boundary
                }
                output.sum(default: [])
            }
        }
    }

    let apply-language(it, language, scale, western: false) = {
        // Every generated profile carries the common inert `jscm` tag. Check it
        // first so the thousands of second-pass text nodes avoid rescanning all
        // language marker dictionaries and hard-skip markers.
        let generated = text.features.at("jscm", default: 0) == 1
        let fixed-layout = skips-layout(text.features)
        if generated {
            it
        } else {
            compose(it, language, scale, western: western, fixed-layout: fixed-layout)
        }
    }

    // Typst parses source `'` and `"` as language-aware `smartquote` elements
    // before the text compositor sees them. The generic inline-element bridge
    // gives them the same locale-resolved punctuation face as ordinary text.
    show smartquote: it => context {
        let features = text.features
        let direct-role = cjk-font-role(features)
        let requested-fontset = if direct-role == none {
            none
        } else { fontsets.at(direct-role, default: none) }
        let active-fontset = if requested-fontset != none and cjk-fontset-native-matches(
            requested-fontset,
            text.font,
            common: common-fontset,
        ) { requested-fontset } else { none }
        if features.at("jscq", default: 0) == 1 or active-fontset == none {
            it
        } else {
            let emitted = features
            emitted.insert("jscf", 1)
            emitted.insert("jscq", 1)
            cjk-fontset-render-inline-element(
                active-fontset,
                it,
                category: "punctuation",
                language: text.lang,
                region: text.region,
                common: common-fontset,
                global-optics: fontset-optics,
                styles: (
                    size: text.size,
                    baseline: text.baseline,
                    tracking: text.tracking,
                    lang: text.lang,
                    region: text.region,
                    script: auto,
                    dir: text.dir,
                    cjk-latin-spacing: none,
                    features: emitted,
                ),
            )
        }
    }

    // `lang` is a style property rather than a text-element field, so
    // `text.where(lang: ...)` cannot dispatch on it.
    show text: it => context {
        let language = text.lang
        if language == "ko" {
            apply-language(it, "ko", cjk-scale)
        } else if language-aware and language == "ja" {
            apply-language(it, "ja", japanese-size)
        } else if language-aware and language == "zh" {
            let traditional = text.region != none and (
                "TW", "HK", "MO"
            ).contains(upper(text.region))
            apply-language(it, if traditional { "tc" } else { "sc" }, chinese-size)
        } else if language-aware and western-languages.contains(language) {
            apply-language(it, "western", latin-scale, western: true)
        } else {
            it
        }
    }

    show par: it => context {
        // Paragraph profiles need one fresh layout pass: a `par` element has
        // already captured its ambient set rules by the time this show rule
        // sees it. Mark that pass in the text style so the implicit paragraph
        // created from `it.body` is accepted on its second visit. This keeps
        // the mechanism inline and breakable—no box, region, or block wrapper.
        let paragraph-pass = text.features.at("jspg", default: 0) == 1
        let key = if text.lang == ambient-language {
            none
        } else if text.lang == "ko" {
            "ko"
        } else if not language-aware {
            none
        } else if text.lang == "ja" {
            "ja"
        } else if text.lang == "zh" {
            "zh"
        } else if western-languages.contains(text.lang) {
            "western"
        } else {
            none
        }
        let hard-skip = skips-layout(text.features)
        let apply-profile = key != none and not skips-paragraph-layout(text.features)
        let boundary-gaps = (
            cjk-latin: boundary-spacing,
            math: math-boundary-spacing,
            raw: raw-boundary-spacing,
        )
        let fragment-spacing = if (
            boundary-spacing == none
              and math-boundary-spacing == none
              and raw-boundary-spacing == none
        ) or hard-skip or paragraph-pass {
            (body: it.body, changed: false)
        } else {
cjk-inline-fragment-spacing(boundary-gaps, it.body, inline-atom-particles: inline-atom-particles)
        }
        if not paragraph-pass and not hard-skip and (apply-profile or fragment-spacing.changed) {
            let features = text.features
            features.insert("jspg", 1)
            set text(features: features)
            if apply-profile {
                let profile = paragraph-profiles.at(key)
                let leading = (profile.at("leading-ratio") - 1) * 1em
                let spacing = profile.at("spacing")
                if spacing == auto { spacing = leading }
                let first-line-indent = profile.at("first-line-indent")
                if first-line-indent == auto { first-line-indent = cjk-scale }
                let costs = profile.at("costs")
                if costs != none { set text(costs: costs) }
                set par(
                    first-line-indent: first-line-indent,
                    leading: leading,
                    spacing: spacing,
                    justify: profile.at("justify"),
                    justification-limits: profile.at("justification-limits"),
                    linebreaks: profile.at("linebreaks"),
                )
            }
            fragment-spacing.body
        } else {
            it
        }
    }

    body
}

#let cjk-math(body, before: false, after: false, gap: 0.1em) = {
    if before { h(gap, weak: true) }
    body
    if after { h(gap, weak: true) }
}

#let cjk-raw = cjk-math
