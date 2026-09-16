#let cjk-semantic-strong-marker = (jssg: 1)

// Apply caller-supplied baseline/tracking profiles to Hangul, Han, and Kana.
// Semantic emphasis chooses a font role; it does not own separate optics.
#let cjk-optical-adjustments(
    body,
    scale,
    hangul,
    han,
    kana,
    language-profiles: (:),
) = {
    let adjust(body, values, kind) = context {
        let language-profile = language-profiles.at(text.lang, default: none)
        let script-profile = if language-profile == none {
            none
        } else {
            language-profile.at(kind, default: none)
        }
        let baseline = values.at(0)
        let regular-tracking = values.at(1)
        set text(
            size: if script-profile == none { scale } else { script-profile.at("scale", default: scale) },
            baseline: if script-profile == none {
                baseline
            } else { script-profile.at("baseline", default: baseline) },
            tracking: if script-profile == none {
                regular-tracking
            } else { script-profile.at("tracking", default: regular-tracking) },
        )
        body
    }

    // horizontal/latin puncts are excluded
    show regex("[。、，．！？；：（）〔〕〈〉《》【】「」『』]+"): it => adjust(
        it, (han.at(0), 0em, han.at(2)), "punctuation",
    )

    show regex("[\p{sc:Hangul}]+"): it => adjust(it, hangul, "hangul")
    show regex("[\p{sc:Han}]+"): it => adjust(it, han, "han")
    show regex("[\p{sc:Hiragana}\p{sc:Katakana}]+"): it => adjust(it, kana, "kana")
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

// Templates provide optical values; this module validates their vocabulary.
#let cjk-optical-profile-fields = (
    "scale", "baseline", "tracking",
    "strong-scale",
)

#let cjk-normalize-optical-profiles(profiles) = {
    if type(profiles) != dictionary {
        panic("CJK optical profiles must be a dictionary.")
    }
    let normalized = (:)
    for (language, scripts) in profiles {
        if type(scripts) != dictionary {
            panic("CJK optical language profile " + repr(language) + " must be a dictionary.")
        }
        let normalized-scripts = (:)
        for (script, values) in scripts {
            if type(values) != dictionary {
                panic("CJK optical script profile " + repr(script) + " must be a dictionary.")
            }
            let normalized-values = (:)
            for (field, value) in values {
                if field not in cjk-optical-profile-fields {
                    panic("Unknown CJK optical profile field: " + repr(field))
                }
                normalized-values.insert(field, value)
            }
            normalized-scripts.insert(script, normalized-values)
        }
        normalized.insert(language, normalized-scripts)
    }
    normalized
}


// Reusable horizontal paragraph profiles. `auto` on Korean indentation means
// one resolved CJK character width; `auto` spacing means one leading gap.
// Templates can consume these values for their ambient/default paragraph
// setup, while `cjk-language-layout` applies the same source of truth when a
// paragraph carries an explicit language.
#let cjk-paragraph-profiles = (
    ko: (
        first-line-indent: auto,
        spacing: auto,
        justify: true,
        justification-limits: (
            spacing: (min: 88%, max: 100%),
            tracking: (min: -0.04em, max: 0.01em),
        ),
        linebreaks: "optimized",
        costs: (widow: 100%, orphan: 100%),
    ),
    western: (
        first-line-indent: 1.25em,
        spacing: auto,
        justify: true,
        justification-limits: (
            spacing: (min: 80%, max: 125%),
            tracking: (min: 0em, max: 0em),
        ),
        linebreaks: "optimized",
        costs: (widow: 100%, orphan: 100%),
    ),
    ja: (
        first-line-indent: (amount: 1em, all: true),
        spacing: auto,
        justify: true,
        justification-limits: (
            spacing: (min: 100%, max: 100%),
            tracking: (min: -0.04em, max: 0.08em),
        ),
        linebreaks: "optimized",
        costs: (widow: 100%, orphan: 100%),
    ),
    zh: (
        first-line-indent: (amount: 2em, all: true),
        spacing: auto,
        justify: true,
        justification-limits: (
            spacing: (min: 100%, max: 100%),
            tracking: (min: -0.04em, max: 0.10em),
        ),
        linebreaks: "optimized",
        costs: (widow: 100%, orphan: 100%),
    ),
)

// Horizontal composition must never request vertical alternates. The private
// feature tags are inert per-profile markers: the configured fonts do not
// implement them, but their values survive normalization and prevent the
// dispatcher from matching its own output.
#let cjk-horizontal-profile-features = (
    ko: (vert: 0, vrt2: 0, vhal: 0, vpal: 0, vkrn: 0, jscm: 1, jskr: 1),
    ja: (vert: 0, vrt2: 0, vhal: 0, vpal: 0, vkrn: 0, jscm: 1, jsja: 1),
    sc: (vert: 0, vrt2: 0, vhal: 0, vpal: 0, vkrn: 0, jscm: 1, jssc: 1),
    tc: (vert: 0, vrt2: 0, vhal: 0, vpal: 0, vkrn: 0, jscm: 1, jstc: 1),
    western: (vert: 0, vrt2: 0, vhal: 0, vpal: 0, vkrn: 0, jscm: 1, jswe: 1),
)
