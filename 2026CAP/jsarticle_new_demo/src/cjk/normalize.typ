#import "spacing.typ": *
#let cjk-style-bypass(body) = context {
    let features = text.features
    features.insert("jscb", 1)
    set text(features: features)
    body
}

// horizontal cjk normalization. old name 'grid'
#let cjk-normalize-horizontal-text(
    source,
    language: "ko",
    punctuation: true,
    spaces: true,
    collapse-punctuation-space: true,
) = {
    let clusters = source.clusters()
    let output = ""
    let previous-script = none
    let suppress-space = false
    let cjkish(cluster) = cjk-boundary-kind(cluster) == "cjk"
    let converted(cluster) = if cluster == "." {
        "。"
    } else if cluster == "," {
        if language == "zh" { "，" } else { "、" }
    } else if cluster == "!" {
        "！"
    } else if cluster == "?" {
        "？"
    } else if cluster == ":" {
        "："
    } else if cluster == ";" {
        "；"
    } else if cluster == "(" {
        "（"
    } else if cluster == ")" {
        "）"
    } else if cluster == "[" {
        "［"
    } else if cluster == "]" {
        "］"
    } else if cluster == "{" {
        "｛"
    } else if cluster == "}" {
        "｝"
    } else {
        cluster
    }
    let half-punctuation = ".,!?;:()[]{}‘’“”"

    // One reverse pass supplies look-ahead without rescanning the suffix for
    // every space or punctuation mark
    let reverse-next = ()
    let following-script = none
    for cluster in clusters.rev() {
        reverse-next.push(following-script)
        let kind = cjk-boundary-kind(cluster)
        if kind == "cjk" { following-script = "cjk" } else if kind == "western" {
            following-script = "western"
        }
    }
    let next-scripts = reverse-next.rev()

    for (index, cluster) in clusters.enumerate() {
        let next-script = next-scripts.at(index)

        if cluster == " " {
            if suppress-space and collapse-punctuation-space {
                suppress-space = false
            } else if spaces and previous-script == "cjk" and next-script == "cjk" {
                output += "　"
            } else {
                output += cluster
            }
            continue
        }

        suppress-space = false
        let touches-cjk = previous-script == "cjk" or next-script == "cjk"
        if punctuation and half-punctuation.contains(cluster) and touches-cjk and previous-script != "western" {
            output += converted(cluster)
            suppress-space = true
        } else {
            output += cluster
        }

        if cjkish(cluster) {
            previous-script = "cjk"
        } else if cjk-boundary-kind(cluster) == "western" {
            previous-script = "western"
        }
    }
    output
}

#let cjk-normalize-horizontal(
    body,
    language: auto,
    punctuation: true,
    spaces: true,
    collapse-punctuation-space: true,
    skip-features: ((jscb: 1),),
) = context {
    let configured-language = if language == auto { text.lang } else { language }
    show text: it => context {
        let skipped = skip-features.any(marker => {
            let matches = true
            for (key, value) in marker {
                if text.features.at(key, default: none) != value { matches = false }
            }
            matches
        })
        if skipped or text.features.at("jscg", default: 0) == 1 {
            it
        } else {
            let features = text.features
            features.insert("jscg", 1)
            text(
                cjk-normalize-horizontal-text(
                    it.text,
                    language: if language == auto { text.lang } else { configured-language },
                    punctuation: punctuation,
                    spaces: spaces,
                    collapse-punctuation-space: collapse-punctuation-space,
                ),
                font: text.font,
                lang: text.lang,
                region: text.region,
                script: text.script,
                dir: text.dir,
                features: features,
            )
        }
    }
    body
}

// Compatibility aliases retained for existing templates.
#let cjk-grid-normalize-text = cjk-normalize-horizontal-text
#let cjk-grid-normalize = cjk-normalize-horizontal
