// Reusable horizontal CJK and multilingual typography utilities.
//
// This module owns script/language dispatch, horizontal OpenType controls,
// optical adjustment, CJK/Western boundary spacing, and language-specific
// paragraph conventions. It contains no fixed font or page-geometry choices:
// templates supply composed font stacks and visual profile values.

// Classify one grapheme cluster at a time. Latin uses Script rather than
// Script_Extensions, so shared punctuation never becomes a false Latin match.
#let cjk-script = regex("^[\p{scx:Hangul}\p{scx:Han}\p{scx:Hira}\p{scx:Kana}]$")
#let cjk-latin-or-digit = regex("^[\p{sc:Latn}\p{sc:Grek}\p{sc:Cyrl}0-9]$")
#let cjk-open-bracket = regex("^[(\[\{]$")
#let cjk-close-bracket = regex("^[)\]\}]$")

#let cjk-kind(cluster) = {
    if cluster.match(cjk-script) != none { "cjk" } else if cluster.match(cjk-latin-or-digit) != none {
        "latin"
    } else if cluster.match(cjk-open-bracket) != none {
        "open-bracket"
    } else if cluster.match(cjk-close-bracket) != none {
        "close-bracket"
    } else {
        none
    }
}

#let cjk-word-kind(kind) = kind == "cjk" or kind == "latin"

#let cjk-boundary-kind(previous, current) = {
    let script-boundary = (
        (previous == "cjk" and current == "latin") or (previous == "latin" and current == "cjk")
    )
    let bracket-boundary = (
        (cjk-word-kind(previous) and current == "open-bracket")
            or (previous == "close-bracket" and cjk-word-kind(current))
    )
    if script-boundary { "script" } else if bracket-boundary { "bracket" } else { none }
}

// Insert boundary spacing within one text node. Word Joiners are used only for
// source-adjacent CJK/Latin-digit pairs: they prevent a break at the newly
// inserted gap without affecting the baseline. Bracket gaps stay breakable.
#let cjk-latin-space(source, amount) = {
    let parts = ()
    let run = ""
    let clusters = source.clusters()
    let previous = none
    for cluster in clusters {
        let current = cjk-kind(cluster)
        let boundary = cjk-boundary-kind(previous, current)
        if boundary != none {
            if run != "" {
                parts.push(run)
                run = ""
            }
            if boundary == "script" { parts.push(sym.wj) }
            parts.push(h(amount, weak: true))
            if boundary == "script" { parts.push(sym.wj) }
        }
        run += cluster
        previous = current
    }
    if run != "" {
        parts.push(run)
    }
    parts.sum(default: [])
}

// Apply CJK/Latin spacing to one language/region pair. `marker-region` is an
// internal recursion marker: it retains language shaping while excluding the
// generated text from the two selectors below. Defaults preserve Korean use,
// while another template can choose, for example, lang: "ja", region: "JP".
#let cjk-latin-spacing(
    amount,
    body,
    lang: "ko",
    region: "KR",
    marker-region: "KP",
) = {
    let transform = it => text(cjk-latin-space(it.text, amount), lang: lang, region: marker-region)
    show text.where(lang: lang, region: none): transform
    show text.where(lang: lang, region: region): transform
    body
}

// Apply a caller-supplied gap only where an inline equation is directly
// adjacent to CJK text. Walk nested sequences as well because `include`
// preserves its returned document content as a nested sequence. The equation
// itself is never rewritten, so math-internal operator and script spacing stay
// untouched.
#let content-sequence-element = ([A] + [B]).func()
#let content-styled-element = math.bold([E]).func()

#let cjk-text-edge(it, first: true) = {
    if it.func() != text or it.text == "" {
        false
    } else {
        let clusters = it.text.clusters()
        let cluster = if first { clusters.first() } else { clusters.last() }
        cluster.match(cjk-script) != none
    }
}

#let cjk-inline-math-spacing(amount, body) = {
    if body.func() == content-sequence-element {
        let children = body.children
        let output = ()
        for (index, child) in children.enumerate() {
            let inline-math = child.func() == math.equation and not child.block
            let before = inline-math and index > 0 and cjk-text-edge(children.at(index - 1), first: false)
            let after = inline-math and index + 1 < children.len() and cjk-text-edge(children.at(index + 1))
            if before { output.push(h(amount, weak: true)) }
            output.push(cjk-inline-math-spacing(amount, child))
            if after { output.push(h(amount, weak: true)) }
        }
        output.sum(default: [])
    } else if body.func() == content-styled-element {
        let fields = body.fields()
        let child = cjk-inline-math-spacing(amount, fields.remove("child"))
        let styles = fields.remove("styles")
        body.func()(child, styles)
    } else {
        body
    }
}

// Shared implementation for script-specific optical profiles.
#let cjk-optical-adjust(
    body,
    scale,
    regular-baseline,
    regular-tracking,
    strong-baseline,
    strong-tracking: 0em,
    kind: none,
    language-profiles: (:),
) = context {
    // A template may refine the optical values by `text.lang` without
    // duplicating the script matcher.  This is deliberately independent of
    // writing direction so the same language profiles can later be reused by
    // horizontal and vertical composition engines.
    let language = text.lang
    let language-profile = language-profiles.at(language, default: none)
    let script-profile = if language-profile == none or kind == none {
        none
    } else {
        language-profile.at(kind, default: none)
    }
    let resolved-scale = if script-profile == none { scale } else { script-profile.at("scale", default: scale) }
    let resolved-baseline = if script-profile == none {
        regular-baseline
    } else { script-profile.at("baseline", default: regular-baseline) }
    let resolved-tracking = if script-profile == none {
        regular-tracking
    } else { script-profile.at("tracking", default: regular-tracking) }
    let resolved-strong-baseline = if script-profile == none {
        strong-baseline
    } else { script-profile.at("strong-baseline", default: strong-baseline) }
    let resolved-strong-tracking = if script-profile == none {
        strong-tracking
    } else { script-profile.at("strong-tracking", default: strong-tracking) }
    let strong = (
        text.weight == "medium"
            or text.weight == "semibold"
            or text.weight == "bold"
    )
    set text(
        size: resolved-scale,
        baseline: if strong { resolved-strong-baseline } else { resolved-baseline },
        tracking: if strong { resolved-strong-tracking } else { resolved-tracking },
    )
    body
}

// Apply caller-supplied (baseline, tracking, strong-baseline) profiles to
// Hangul, Han, and Kana. The caller keeps ownership of all visual values.
#let cjk-optical-adjustments(
    body,
    scale,
    hangul,
    han,
    kana,
    strong-tracking: 0em,
    language-profiles: (:),
) = {
    // Horizontal CJK punctuation is deliberately excluded from the script
    // runs below. Script_Extensions would otherwise classify some marks as
    // Han, Hiragana, and Katakana at once. Scale each mark exactly once along
    // with its surrounding CJK text; leaving punctuation at the outer Latin
    // em makes an ordinary horizontal comma/full stop resemble a raised
    // vertical-writing alternate next to 0.925-em glyphs.
    show regex("[。、，．！？；：（）〔〕〈〉《》【】「」『』]+"): it => cjk-optical-adjust(
        it,
        scale,
        han.at(0),
        0em,
        han.at(2),
        kind: "punctuation",
        language-profiles: language-profiles,
    )

    // Use Script, not Script_Extensions. CJK punctuation such as 「」 has
    // Han/Hiragana/Katakana in Script_Extensions and would otherwise match
    // more than one rule, receiving the scale repeatedly.
    show regex("[\p{sc:Hangul}]+"): it => cjk-optical-adjust(
        it,
        scale,
        ..hangul,
        strong-tracking: strong-tracking,
        kind: "hangul",
        language-profiles: language-profiles,
    )
    show regex("[\p{sc:Han}]+"): it => cjk-optical-adjust(
        it,
        scale,
        ..han,
        strong-tracking: strong-tracking,
        kind: "han",
        language-profiles: language-profiles,
    )
    show regex("[\p{sc:Hiragana}\p{sc:Katakana}]+"): it => cjk-optical-adjust(
        it,
        scale,
        ..kana,
        strong-tracking: strong-tracking,
        kind: "kana",
        language-profiles: language-profiles,
    )
    body
}

// --------------------------------------------------------------------------
// Reusable horizontal multilingual composition engine
// --------------------------------------------------------------------------

// Languages normally composed with the shared Western profile. Templates may
// pass a different list to `cjk-language-layout` when needed.
#let cjk-western-languages = (
    "af", "az", "be", "bg", "br", "bs", "ca", "cs", "cy", "da", "de", "el", "en", "eo", "es",
    "et", "eu", "fi", "fo", "fr", "ga", "gl", "hr", "hu", "id", "is", "it", "kk", "ky", "la",
    "lb", "lt", "lv", "mk", "mn", "ms", "mt", "nb", "nl", "nn", "no", "oc", "pl", "pt", "rm",
    "ro", "ru", "sk", "sl", "sq", "sr", "sv", "sw", "tg", "tr", "uk", "uz", "vi",
)

#let cjk-language-class(language, western-languages: cjk-western-languages) = {
    if language == "ja" {
        "japanese"
    } else if language == "zh" {
        "chinese"
    } else if western-languages.contains(language) {
        "western"
    } else {
        "default"
    }
}

// Horizontal composition must never request vertical alternates. The private
// feature tags are inert per-profile markers: the configured fonts do not
// implement them, but their values survive normalization and prevent the
// dispatcher from matching its own output.
#let cjk-horizontal-profile-features = (
    ko: (vert: 0, vrt2: 0, vhal: 0, vpal: 0, vkrn: 0, jskr: 1),
    ja: (vert: 0, vrt2: 0, vhal: 0, vpal: 0, vkrn: 0, jsja: 1),
    sc: (vert: 0, vrt2: 0, vhal: 0, vpal: 0, vkrn: 0, jssc: 1),
    tc: (vert: 0, vrt2: 0, vhal: 0, vpal: 0, vkrn: 0, jstc: 1),
    western: (vert: 0, vrt2: 0, vhal: 0, vpal: 0, vkrn: 0, jswe: 1),
)

#let cjk-hangul-char = regex("^[\p{sc:Hangul}]$")
#let cjk-han-char = regex("^[\p{sc:Han}]$")
#let cjk-kana-char = regex("^[\p{sc:Hiragana}\p{sc:Katakana}]$")
#let cjk-latin-char = regex("^[\p{sc:Latn}0-9]$")
#let cjk-cyrillic-char = regex("^[\p{sc:Cyrl}]$")
#let cjk-greek-char = regex("^[\p{sc:Grek}]$")
#let cjk-punctuation-char = regex("^[。、，．！？；：（）〔〕〈〉《》【】「」『』]$")

#let cjk-script-kind(cluster) = {
    if cluster.match(cjk-hangul-char) != none { "hangul" } else if cluster.match(cjk-han-char) != none {
        "han"
    } else if cluster.match(cjk-kana-char) != none {
        "kana"
    } else if cluster.match(cjk-latin-char) != none {
        "latin"
    } else if cluster.match(cjk-cyrillic-char) != none {
        "cyrillic"
    } else if cluster.match(cjk-greek-char) != none {
        "greek"
    } else if cluster.match(cjk-punctuation-char) != none {
        "punctuation"
    } else {
        "other"
    }
}

#let cjk-script-runs(source) = {
    let runs = ()
    let kind = none
    let value = ""
    for cluster in source.clusters() {
        let next = cjk-script-kind(cluster)
        if kind != none and next != kind {
            runs.push((kind: kind, text: value))
            value = ""
        }
        kind = next
        value += cluster
    }
    if value != "" { runs.push((kind: kind, text: value)) }
    runs
}

#let cjk-opentype-script(kind, fallback: "hani") = {
    if kind == "hangul" { "hang" } else if kind == "han" or kind == "punctuation" {
        "hani"
    } else if kind == "kana" {
        "kana"
    } else if kind == "latin" {
        "latn"
    } else if kind == "cyrillic" {
        "cyrl"
    } else if kind == "greek" {
        "grek"
    } else {
        fallback
    }
}

// Rebuild a source text node once with the regional font stack. Profiles that
// need no per-script override take a single-element fast path; all other nodes
// are split into contiguous script runs once.
#let cjk-render-profiled-text(
    it,
    language,
    region,
    font-profile,
    western-font-profile,
    marker,
    scale,
    latin-scale,
    latin-baseline,
    latin-tracking,
    strong-latin-scale,
    strong-latin-baseline,
    strong-tracking,
    optical-profile: none,
    optical-adjustments: true,
) = context {
    let strong = text.weight == "medium" or text.weight == "semibold" or text.weight == "bold"
    let regional-font = if strong { font-profile.gothic } else { font-profile.body }
    let western-font = if strong { western-font-profile.gothic } else { western-font-profile.body }
    let source = it.text
    // The common path needs neither script splitting nor new text elements.
    // Font cover rules choose Western/CJK faces inside the supplied composite
    // stack, so reconstruct only when an optical override actually differs.
    let needs-western-adjustment = (
        latin-scale != scale
            or latin-baseline != 0em
            or latin-tracking != 0em
            or (strong and (
                strong-latin-scale != scale
                    or strong-latin-baseline != 0em
                    or strong-tracking != 0em
            ))
    )
    let needs-optical-adjustment = optical-adjustments and optical-profile != none
    if not needs-western-adjustment and not needs-optical-adjustment {
        text(
            source,
            font: regional-font,
            size: scale,
            lang: language,
            region: region,
            script: auto,
            dir: ltr,
            cjk-latin-spacing: auto,
            features: marker,
        )
    } else {
        let hangul = if optical-profile == none { none } else { optical-profile.at("hangul", default: none) }
        let han = if optical-profile == none { none } else { optical-profile.at("han", default: none) }
        let kana = if optical-profile == none { none } else { optical-profile.at("kana", default: none) }

        cjk-script-runs(source).map(run => {
            let western = ("latin", "cyrillic", "greek").contains(run.kind)
            let script-profile = if not optical-adjustments {
                none
            } else if run.kind == "hangul" {
                hangul
            } else if run.kind == "han" {
                han
            } else if run.kind == "kana" {
                kana
            } else {
                none
            }
            let baseline = if western {
                if strong { strong-latin-baseline } else { latin-baseline }
            } else if strong {
                if script-profile == none {
                    0em
                } else {
                    script-profile.at(
                        "strong-baseline",
                        default: script-profile.at("baseline", default: 0em),
                    )
                }
            } else {
                if script-profile == none { 0em } else { script-profile.at("baseline", default: 0em) }
            }
            let tracking = if western {
                if strong { strong-tracking } else { latin-tracking }
            } else if strong and script-profile != none {
                strong-tracking
            } else {
                if script-profile == none { 0em } else { script-profile.at("tracking", default: 0em) }
            }
            text(
                run.text,
                font: if western { western-font } else { regional-font },
                size: if western {
                    if strong { strong-latin-scale } else { latin-scale }
                } else { scale },
                baseline: baseline,
                tracking: tracking,
                lang: language,
                region: region,
                script: cjk-opentype-script(run.kind),
                dir: ltr,
                cjk-latin-spacing: if western { none } else { auto },
                features: marker,
            )
        }).join()
    }
}

#let cjk-render-western-text(
    it,
    language,
    region,
    font-profile,
    marker,
    latin-scale,
    latin-baseline,
    latin-tracking,
    strong-latin-scale,
    strong-latin-baseline,
    strong-tracking,
) = context {
    let strong = text.weight == "medium" or text.weight == "semibold" or text.weight == "bold"
    text(
        it.text,
        font: if strong { font-profile.gothic } else { font-profile.body },
        size: if strong { strong-latin-scale } else { latin-scale },
        baseline: if strong { strong-latin-baseline } else { latin-baseline },
        tracking: if strong { strong-tracking } else { latin-tracking },
        lang: language,
        region: region,
        script: auto,
        dir: ltr,
        hyphenate: true,
        cjk-latin-spacing: none,
        features: marker,
    )
}

// Apply language-aware fonts, horizontal shaping, optical adjustments, and
// paragraph conventions to arbitrary template content. Required profile keys:
// `ko`, `ja`, `sc`, `tc`, and `western`, each with `body` and `gothic` stacks.
#let cjk-language-layout(
    body,
    profiles,
    text-size,
    language-aware: true,
    cjk-scale: 0.925em,
    latin-scale: 1em,
    latin-baseline: 0em,
    latin-tracking: 0em,
    japanese-scale: auto,
    chinese-scale: auto,
    strong-latin-scale: auto,
    strong-latin-baseline: 0em,
    strong-tracking: 0em,
    optical-adjustments: true,
    optical-profiles: (:),
    western-leading-ratio: 1.48,
    japanese-leading-ratio: 1.60,
    chinese-leading-ratio: 1.58,
    skip-features: none,
    western-languages: cjk-western-languages,
    markers: cjk-horizontal-profile-features,
) = {
    let strong-latin-size = if strong-latin-scale == auto { cjk-scale } else { strong-latin-scale }
    let japanese-size = if japanese-scale == auto { cjk-scale } else { japanese-scale }
    let chinese-size = if chinese-scale == auto { cjk-scale } else { chinese-scale }

    show text: it => context {
        let language = text.lang
        let region = text.region
        if skip-features != none and text.features == skip-features {
            it
        } else if language == "ko" {
            if text.features == markers.ko { it } else {
                cjk-render-profiled-text(
                    it, language, region, profiles.ko, profiles.western, markers.ko, cjk-scale,
                    latin-scale, latin-baseline, latin-tracking, strong-latin-size,
                    strong-latin-baseline, strong-tracking,
                    optical-profile: optical-profiles.at("ko", default: none),
                    optical-adjustments: optical-adjustments,
                )
            }
        } else if not language-aware {
            it
        } else if language == "ja" {
            if text.features == markers.ja { it } else {
                cjk-render-profiled-text(
                    it, language, region, profiles.ja, profiles.western, markers.ja, japanese-size,
                    latin-scale, latin-baseline, latin-tracking, strong-latin-size,
                    strong-latin-baseline, strong-tracking,
                    optical-profile: optical-profiles.at("ja", default: none),
                    optical-adjustments: optical-adjustments,
                )
            }
        } else if language == "zh" {
            let traditional = region != none and ("TW", "HK", "MO").contains(upper(region))
            let key = if traditional { "tc" } else { "sc" }
            let marker = markers.at(key)
            let profile = profiles.at(key)
            if text.features == marker { it } else {
                cjk-render-profiled-text(
                    it, language, region, profile, profiles.western, marker, chinese-size,
                    latin-scale, latin-baseline, latin-tracking, strong-latin-size,
                    strong-latin-baseline, strong-tracking,
                    optical-profile: optical-profiles.at(key, default: none),
                    optical-adjustments: optical-adjustments,
                )
            }
        } else if western-languages.contains(language) {
            if text.features == markers.western { it } else {
                cjk-render-western-text(
                    it, language, region, profiles.western, markers.western,
                    latin-scale, latin-baseline, latin-tracking, strong-latin-size,
                    strong-latin-baseline, strong-tracking,
                )
            }
        } else {
            it
        }
    }

    show par: it => context {
        if language-aware {
            let class = cjk-language-class(text.lang, western-languages: western-languages)
            if class == "western" {
                set par(
                    first-line-indent: 1.25em,
                    leading: text-size * (western-leading-ratio - 1),
                    spacing: 0pt,
                    justification-limits: (
                        spacing: (min: 80%, max: 125%),
                        tracking: (min: 0em, max: 0em),
                    ),
                )
            } else if class == "japanese" {
                set par(
                    first-line-indent: (amount: 1em, all: true),
                    leading: text-size * (japanese-leading-ratio - 1),
                    spacing: 0pt,
                    justification-limits: (
                        spacing: (min: 100%, max: 100%),
                        tracking: (min: -0.04em, max: 0.08em),
                    ),
                )
            } else if class == "chinese" {
                set par(
                    first-line-indent: (amount: 2em, all: true),
                    leading: text-size * (chinese-leading-ratio - 1),
                    spacing: 0pt,
                    justification-limits: (
                        spacing: (min: 100%, max: 100%),
                        tracking: (min: -0.04em, max: 0.10em),
                    ),
                )
            }
        }
        it
    }

    body
}

// Optional directional wrappers for contexts outside a paragraph. Keeping the
// math/raw names makes source intent clear without adding a global raw rule.
#let cjk-math(body, before: false, after: false, gap: 0.1em) = {
    if before { h(gap, weak: true) }
    body
    if after { h(gap, weak: true) }
}

#let cjk-raw(body, before: false, after: false, gap: 0.1em) = {
    if before { h(gap, weak: true) }
    body
    if after { h(gap, weak: true) }
}
