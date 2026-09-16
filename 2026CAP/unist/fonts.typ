// Portfolio-specific faces. The framework supplies omitted locale routes and
// its shared footnote composite unchanged.
#import "jsarticle.typ": js-default-composites, jsface, jsfontset-override

#let minion = jsface("crimson text")
#let inter = jsface("Inter")
#let body-myung = jsface("batang", optics: (hangul: (scale: 0.925, baseline: -0.00em, tracking: -0.07em)))
#let midashi-myung = jsface("munhwa myungjo std", optics: (hangul: (scale: 0.925, baseline: -0.0em, tracking: -0.08em)))
#let kopub-punctuation = jsface("bookk myungjo", optics: (punctuation: (baseline: -0.07em)))
#let pretendard-gothic = jsface("Pretendard", optics: (hangul: (scale: 0.925, baseline: -0.04em, tracking: 0em), han: (tracking: -0.01em), punctuation: (baseline: -0.07em)))
#let pretendard-gothic-bold = jsface("Pretendard", optics: (hangul: (scale: 0.925, baseline: -0.02em, tracking: 0em), han: (tracking: -0.01em), punctuation: (baseline: -0.07em)))
#let pretendard-maru = jsface("Pretendard", optics: (hangul: (scale: 0.925, baseline: 0em, tracking: -0.08em), han: (tracking: -0.01em)))
#let source-han-serif-k = jsface("Source Han Serif K", optics: (han: (tracking: -0.01em)))

#let document-composites = (
    serif: jsfontset-override(
        js-default-composites.serif,
        western: minion,
        number: minion,
        hangul: body-myung,
        han-ko: source-han-serif-k,
        punct-ko: kopub-punctuation,
    ),
    serif-bold: jsfontset-override(
        js-default-composites.at("serif-bold"),
        western: minion,
        number: minion,
        hangul: midashi-myung,
        han-ko: source-han-serif-k,
        punct-ko: kopub-punctuation,
    ),
    gothic: jsfontset-override(
        js-default-composites.gothic,
        western: inter,
        number: inter,
        hangul: pretendard-gothic,
        han-ko: pretendard-gothic,
        punct-ko: pretendard-gothic,
    ),
    gothic-bold: jsfontset-override(
        js-default-composites.at("gothic-bold"),
        western: inter,
        number: inter,
        hangul: pretendard-gothic-bold,
        han-ko: pretendard-gothic-bold,
        punct-ko: pretendard-gothic-bold,
    ),
    footnote: jsfontset-override(js-default-composites.at("footnote"), western: jsface("Minion 3 caption"), number: jsface("Minion 3 caption"), punct-ko: kopub-punctuation),
    maru: jsfontset-override(js-default-composites.maru, western: inter, number: inter, hangul: pretendard-maru, han-ko: pretendard-maru),
)
