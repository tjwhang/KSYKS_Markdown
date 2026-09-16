// src/kinsoku/kinsoku.typ
#import "kinsoku-utils.typ": *
#import "kinsoku-builtin.typ": builtin-resolve

// Default resolver factory
// Returns a complete kinsoku configuration dictionary.
// Users override any field by passing named arguments.
// The `resolve` function is the built-in algorithm; set `resolve` to replace
// it entirely while keeping helper access via imports.
// ---------------------------------------------------------------------------

#let default-resolver(
    language: "ja",
    region: none,
    forbidden-start: auto,
    forbidden-end: auto,
    hanging: auto,
    unbreakable-chars: "—―…‥︙︰︱︲︳︴",
    buntetsu-kinsoku: true,
    compressible-punctuation: "、。，．︐︑︒",
    mode: auto,
    compression-per-punct: 0.5,
    consecutive-compression: 0.25,
    max-stretch: 0.5,
    resolve-fn: none,
) = {
    // Keep kinsoku invariant under Unicode vertical-form substitution. This
    // includes the full Vertical Forms block used for punctuation, quotes and
    // brackets, rather than only the comma/full-stop forms.
    let vertical-trailing = "︐︑︒︓︔︕︖"
    let vertical-closing = "︶﹈︸︺︼︾﹀﹂﹄︘"
    let vertical-opening = "︵﹇︷︹︻︽︿﹁﹃︗"
    let japanese-start = (
        " ）〕］｝〉》」』】)]}〞\u{201d}\u{2019}。、，．・：；ー～ぁぃぅぇぉっゃゅょゎァィゥェォッャュョヮヵヶ！？"
            + vertical-trailing
            + vertical-closing
    )
    let korean-start = (
        " ）〕］｝〉》」』】)]}〞\u{201d}\u{2019}。、，．・：；！？％‰°℃" + vertical-trailing + vertical-closing
    )
    let chinese-start = (
        " ）〕］｝〉》」』】)]}〞\u{201d}\u{2019}。、，．：；！？％‰°℃" + vertical-trailing + vertical-closing
    )
    let common-end = "（〔［｛〈《「『【([{〝\u{201c}\u{2018}" + vertical-opening
    let resolved-start = if forbidden-start == auto {
        if language == "ko" { korean-start } else if language == "zh" {
            chinese-start
        } else { japanese-start }
    } else { forbidden-start }
    let resolved-end = if forbidden-end == auto { common-end } else { forbidden-end }
    let resolved-hanging = if hanging == auto {
        if language == "ja" or language == "zh" { "、。，．︐︑︒" } else { "" }
    } else { hanging }
    let resolved-mode = if mode == auto {
        if language == "ja" or language == "zh" { "burasagari" } else { "oikomi" }
    } else { mode }
    let rfn = if resolve-fn != none { resolve-fn } else { builtin-resolve }
    (
        language: language,
        region: region,
        forbidden-start: resolved-start,
        forbidden-end: resolved-end,
        hanging: resolved-hanging,
        unbreakable-chars: unbreakable-chars,
        buntetsu-kinsoku: buntetsu-kinsoku,
        compressible-punctuation: compressible-punctuation,
        mode: resolved-mode,
        compression-per-punct: compression-per-punct,
        consecutive-compression: consecutive-compression,
        max-stretch: max-stretch,
        resolve: rfn,
    )
}
