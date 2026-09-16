// ==========================================
// 1. FONTS & CONFIGURATIONS
// ==========================================

#import "cjk.typ": cjk-inline-math-spacing, cjk-language-layout, cjk-latin-space, cjk-latin-spacing

// Shared with block renderers that need to decide whether an element can fit
// on one otherwise empty text page.  The template updates this state after
// resolving paper size, margins, binding allowance, and automatic type size.
#let js-body-height = state("jsarticle-body-height", none)
#let js-column-width = state("jsarticle-column-width", none)
#let js-marginal-outset = state("jsarticle-marginal-outset", none)
#let js-baseline = state("jsarticle-baseline", none)

#let font-common = (
  body: (
    (name: "New Computer Modern Math", covers: regex("[0-9]")),
    (name: "STIX Two Math", covers: regex("[*†‡§¶‖]")),
  ),
  gothic: (
    (name: "Arial", covers: regex("[0-9]")),
    (name: "Arial", covers: regex("[*†‡§¶‖]")),
  ),
)

// `western` means the shared book-typography profile for Latin, Greek, and
// Cyrillic writing systems. It is more accurate here than naming the whole
// group `latin`, while remaining understandable as a public configuration.
#let font-western = (
  body: (
    (name: "Minion Pro", covers: regex("[\u{2060}\p{sc:Latn}\p{sc:Cyrl}\p{sc:Grek}‘’“”()\[\]\{\}.,?!~:;«»„‚—–-]")),
  ),
  gothic: (
    (name: "Arial", covers: regex("[ \u{2060}\p{sc:Latn}\p{sc:Cyrl}\p{sc:Grek}‘’“”()\[\]\{\}.,?!~:;«»„‚—–-]")),
  ),
)

#let font-hangul = (
  body: (
    (name: "KoPubWorldBatang_Pro", covers: regex("[‘’“”()\[\]\{\}.,?!~:;]")),
    (name: "applemyungjo", covers: regex("[\p{sc:Hang}]")),
  ),
  gothic: (
    (name: "KoPubWorldDotum_Pro", covers: regex("[()\[\]\{\}〔〕〈〉《》【】「」『』.,?!]")),
    (name: "Bookk Gothic", covers: regex("[\p{sc:Hang}]")),
  ),
)

#let font-han-kr = (
  body: (
    (name: "Source Han Serif K", covers: regex("[\p{sc:Han}]")),
  ),
  gothic: (
    (name: "Hiragino Kaku Gothic ProN", covers: regex("[\p{sc:Han}]")),
  ),
)

#let font-han-ja = (
  body: (
    (name: "Hiragino Mincho ProN", covers: regex("[\p{sc:Han}。｡︒、､︑〔〕〈〉《》【】「」『』Ⅰ-Ⅹ]")),
  ),
  gothic: (
    (name: "Hiragino Kaku Gothic ProN", covers: regex("[\p{sc:Han}。｡︒、､︑〔〕〈〉《》【】「」『』Ⅰ-Ⅹ]")),
  ),
)

#let font-kana = (
  body: (
    (name: "Hiragino Mincho ProN", covers: regex("[\p{sc:Hiragana}\p{sc:Katakana}]")),
  ),
  gothic: (
    (name: "Hiragino Kaku Gothic ProN", covers: regex("[\p{sc:Hiragana}\p{sc:Katakana}]")),
  ),
)

#let font-han-sc = (
  body: (
    (name: "Source Han Serif SC", covers: regex("[\p{sc:Han}，。！？、；：（）《》〈〉「」『』【】]")),
  ),
  gothic: (
    (name: "Source Han Sans SC", covers: regex("[\p{sc:Han}，。！？、；：（）《》〈〉「」『』【】]")),
  ),
)

#let font-han-tc = (
  body: (
    (name: "Source Han Serif HC", covers: regex("[\p{sc:Han}，。！？、；：（）《》〈〉「」『』【】]")),
  ),
  gothic: (
    (name: "Source Han Sans", covers: regex("[\p{sc:Han}，。！？、；：（）《》〈〉「」『』【】]")),
  ),
)

// Language profiles are complete stacks, composed from the script atoms
// above. Consequently a Korean paragraph can still set kana and Hanja, and a
// Japanese or Chinese paragraph can contain Hangul and Western words without
// falling through to a platform-dependent font.
#let compose-font-profile(groups, body-fallbacks: (), gothic-fallbacks: ()) = (
  body: groups.map(group => group.body).sum(default: ()) + body-fallbacks,
  gothic: groups.map(group => group.gothic).sum(default: ()) + gothic-fallbacks,
)

#let font-kr = compose-font-profile(
  (font-hangul, font-han-kr, font-kana, font-han-ja, font-common, font-western),
  body-fallbacks: (
    "applemyungjo", "Source Han Serif K", "Hiragino Mincho ProN", "Minion Pro",
  ),
  gothic-fallbacks: (
    "Bookk Gothic", "Source Han Sans K", "Hiragino Kaku Gothic ProN", "Arial",
  ),
)

#let font-ja = compose-font-profile(
  (font-han-ja, font-kana, font-hangul, font-western, font-common),
  body-fallbacks: (
    "Hiragino Mincho ProN", "applemyungjo", "Minion Pro",
  ),
  gothic-fallbacks: (
    "Hiragino Kaku Gothic ProN", "Bookk Gothic", "Arial",
  ),
)

#let font-sc = compose-font-profile(
  (font-han-sc, font-kana, font-hangul, font-western, font-common),
  body-fallbacks: (
    "Source Han Serif SC", "Hiragino Mincho ProN", "applemyungjo", "Minion Pro",
  ),
  gothic-fallbacks: (
    "Source Han Sans SC", "Hiragino Kaku Gothic ProN", "Bookk Gothic", "Arial",
  ),
)

#let font-tc = compose-font-profile(
  (font-han-tc, font-kana, font-hangul, font-western, font-common),
  body-fallbacks: (
    "Source Han Serif", "Hiragino Mincho ProN", "applemyungjo", "Minion Pro",
  ),
  gothic-fallbacks: (
    "Source Han Sans", "Hiragino Kaku Gothic ProN", "Bookk Gothic", "Arial",
  ),
)

#let font-western-profile = compose-font-profile(
  (font-western, font-common, font-hangul, font-han-kr, font-kana),
  body-fallbacks: (
    "Minion Pro", "applemyungjo", "Source Han Serif K", "Hiragino Mincho ProN",
  ),
  gothic-fallbacks: (
    "Arial", "Bookk Gothic", "Source Han Sans K", "Hiragino Kaku Gothic ProN",
  ),
)
#let font-body = font-kr.body
#let font-italic = font-body

#let font-maru = (
  (name: "KoPubWorldDotum_Pro", covers: regex("[()\[\]\{\}〔〕〈〉《》【】「」『』.,?!]")),
  (name: "Hiragino Kaku Gothic ProN", covers: regex("[。｡︒、､︑Ⅰ-Ⅹ]")),
  (name: "Montserrat", covers: regex("[0-9]")),
  (name: "Montserrat", covers: regex("[\u{2060}\p{sc:Latn}\p{sc:Cyrl}\p{sc:Grek}+]")),
  (name: "M PLUS 2", covers: regex("[\p{scx:Han}\p{scx:Hira}\p{scx:Kana}]")),
  (name: "Gmarket Sans TTF", covers: regex("[\p{scx:Hang}]")),
  "Gmarket Sans TTF",
  "M PLUS 2",
  "Source Han Sans",
)

#let font-gothic = font-kr.gothic // 굵기에 따른 변화가 약하거나 없는 것으로 구성하기

#let font-math = (
  (name: "STIX Two Math", covers: regex("[*†‡§¶‖]")),
  (name: "STIX Two Math", covers: regex("[∑∏∐∫∬∭∮∯∰⋂⋃⋀⋁]")),
  // (name: "Century Old Math"),
  (name: "New Computer Modern Math"),
  (name: "Hiragino Mincho ProN", covers: regex("[\p{scx:Han}\p{scx:Hira}\p{scx:Kana}]")),
  (name: "Hakgyoansim Bareonbatang", covers: regex("[\p{scx:Hang}]")),
)

#let font-raw = (
  (name: "Jetbrains Mono", covers: regex("[ 0-9 \u{2060}\p{sc:Latn}\p{sc:Cyrl}\p{sc:Grek}+]")),
  // (name: "Hiragino Kaku Gothic ProN", covers: regex("[\p{scx:Han}\p{scx:Hira}\p{scx:Kana}]")),
  // (name: "bookk gothic", covers: regex("[\p{scx:Hangul}]")),
  // "KoPubWorldDotum_Pro",
  // "Hiragino Kaku Gothic ProN",
  "Source Han Sans",
)
#let js-raw-features = (jsrw: 1,)

// Keep inline identifiers copyable while giving the line breaker legal,
// zero-width opportunities after conventional code separators. Without
// these points, one long raw element is atomic and the preceding justified
// Korean line must absorb the entire unused width into a handful of spaces.
#let js-breakable-inline-raw(source) = {
  let pieces = ()
  let run = ""
  for cluster in source.clusters() {
    run += cluster
    if ("_", "-", ".", "/", "\\", ":").contains(cluster) {
      pieces.push(text(run))
      pieces.push(h(0pt, weak: true))
      run = ""
    }
  }
  if run != "" { pieces.push(text(run)) }
  pieces.sum(default: [])
}

#let js-paper-size(name) = {
  if name == "a3" { (297mm, 420mm) } else if name == "a4" { (210mm, 297mm) } else if name == "a5" {
    (148mm, 210mm)
  } else if name == "a6" { (105mm, 148mm) } else if name == "b4" { (257mm, 364mm) } else if (
    name == "b5" or name == "jis-b5"
  ) { (182mm, 257mm) } else if name == "b6" { (128mm, 182mm) } else if type(name) == array { name } else {
    panic("Unknown paper size: " + repr(name))
  }
}

#let jsnumbering(format, ..args) = {
  if args.pos().len() == 0 { return "" }
  let result = numbering(format, ..args)
  let n = args.pos().first()
  if format == "가" {
    let consonants = (0, 2, 3, 5, 6, 7, 9, 11, 12, 14, 15, 16, 17, 18)
    let vowels = (0, 4, 8, 13, 18, 20)
    let c = calc.rem(n - 1, consonants.len())
    let v = calc.floor((n - 1) / consonants.len())
    if v < vowels.len() {
      result = str.from-unicode(0xAC00 + consonants.at(c) * 21 * 28 + vowels.at(v) * 28)
    }
  }
  result.replace("贰", "貳").replace("叁", "參").replace("陆", "陸").replace("亿", "億")
}

// ==========================================
// 2. TYPOGRAPHY & OPTICAL ENGINE
// ==========================================

#let calculate-typography(
  paper-size,
  font-size,
  baseline-ratio,
  lines-per-page,
  text-width,
  cjk-height,
  cjk-scale,
  type,
) = {
  let (page-width, page-height) = js-paper-size(paper-size)
  // Geometric linear scale relative to A4. ISO A/B sizes then vary smoothly
  // instead of jumping at an arbitrary "small paper" threshold.
  let paper-scale = calc.sqrt((page-width / 210mm) * (page-height / 297mm))

  // `font-size` is the nominal outer/Latin size. CJK is an optical correction
  // within it; changing cjk-scale must not silently redefine the public size.
  let size = if font-size == auto {
    // The 0.38 exponent reproduces the established A4 -> A5 transition
    // (12 pt -> 10.5 pt in novel mode) without shrinking type linearly with
    // paper. Quarter-point rounding keeps the result typographically usable.
    let reference = if type == "novel" { 12pt } else { 11.5pt }
    let scaled = reference * calc.pow(paper-scale, 0.38)
    calc.max(8.5pt, calc.min(14pt, calc.round(scaled / 0.25pt) * 0.25pt))
  } else { font-size }
  let cjk-factor = cjk-scale / 1em
  if cjk-factor <= 0 { panic("cjk-scale must be greater than zero.") }
  let cjk-size = size * cjk-factor

  let ratio = if baseline-ratio == auto {
    if type == "novel" { 1.8 } else { 1.6 }
  } else { baseline-ratio }

  let baseline = size * ratio
  // top-edge - bottom-edge is intentionally one full outer em. Typst's
  // `par.leading` is the gap between those line boxes, so subtract the whole
  // line box rather than only its ascent (`cjk-height * cjk-size`).
  let leading = baseline - size
  if leading < 0pt { panic("baseline-ratio is too small for the selected cjk-scale.") }

  let width = if text-width == auto {
    // A4 is the reference: 32 full-width CJK characters for prose and 37 for
    // academic text. Paper width uses a slightly sub-linear exponent: a fully
    // linear reduction made the A5 prose measure (about 25.8 characters) look
    // needlessly narrow. 0.87 yields about 27 on A5 and 23 on A6 while keeping
    // the resolved type size and physical margins in the calculation.
    let reference-size = if type == "novel" { 12pt } else { 11.5pt }
    let reference-characters = if type == "novel" { 32 } else { 37 }
    let proportional-characters = (
      reference-characters
      * calc.pow(page-width / 210mm, 0.87)
      * (reference-size / size)
    )
    let target-characters = if type == "novel" {
      calc.max(20, calc.min(35, proportional-characters))
    } else {
      // Academic copy tolerates a somewhat wider measure, but remains bounded
      // on unusually small and large custom sheets.
      calc.max(24, calc.min(45, proportional-characters))
    }
    let desired = target-characters * cjk-size
    let minimum-side-margin = calc.max(8mm, 12mm * paper-scale)
    calc.min(desired, page-width - 2 * minimum-side-margin)
  } else { text-width }

  let line-count = if lines-per-page == auto {
    // Vertical measure follows page height rather than text width. Using
    // 1.618 * width made A5 and narrower sheets needlessly short, even though
    // their page aspect can comfortably hold more baseline rows.
    // A low fixed margin ratio only suits unusually tall book formats. Correct
    // it by page aspect: squarer sheets receive more vertical air, while a
    // genuinely elongated custom sheet can use more baseline rows.
    let page-aspect = page-height / page-width
    let iso-aspect = 297 / 210
    let aspect-correction = calc.sqrt(iso-aspect / page-aspect)
    let base-margin-ratio = if type == "novel" { 12% } else { 10.5% }
    let margin-ratio = if type == "novel" {
      calc.max(9%, calc.min(15%, base-margin-ratio * aspect-correction))
    } else {
      calc.max(8%, calc.min(14%, base-margin-ratio * aspect-correction))
    }
    let physical-floor = calc.max(9mm, 13mm * paper-scale)
    let target-margin = calc.max(physical-floor, margin-ratio * page-height)
    let available-height = page-height - 2 * target-margin
    calc.max(8, calc.floor((available-height - size) / baseline) + 1)
  } else { lines-per-page }

  let side-margin = (page-width - width) / 2
  let body-height = size + baseline * (line-count - 1)
  let vertical-margin = (page-height - body-height) / 2

  (
    page-width: page-width,
    page-height: page-height,
    paper-scale: paper-scale,
    size: size,
    cjk-size: cjk-size,
    baseline: baseline,
    leading: leading,
    line-count: line-count,
    width: width,
    side-margin: side-margin,
    vertical-margin: vertical-margin,
  )
}

// ==========================================
// 3. HEADING RENDERER
// ==========================================

#let render-heading(it, typo, type, chapter-format, fonts) = {
  let number = if it.numbering == none { none } else { counter(heading).display(it.numbering) }
  let heading-font = fonts.gothic
  set par(first-line-indent: 0em)

  if it.level == 1 {
    if it.has("label") and it.label == <__jspart__> {
      it.body
    } else {
      let top-space = if type == "novel" {
        4 * typo.baseline
      } else {
        5 * typo.baseline
      }
      block(
        // `above` is inter-block spacing and is unreliable at a page start.
        // An internal top inset preserves the H1 offset after a page break.
        above: 0pt,
        below: 2 * typo.baseline,
        breakable: false,
        inset: (top: top-space),
        width: 100%,
      )[
        #align(if type == "novel" { center } else { left })[
          #if number != none {
            text(font: fonts.maru, size: 1.15em, weight: "medium")[#number]
            v(1.2em)
          }
          #text(
            font: heading-font,
            size: if type == "novel" { 1.7em } else { 1.8em },
            weight: "semibold",
          )[#it.body]
        ]
      ]
    }
  } else {
    let factor = if it.level == 2 { 1.22 } else if it.level == 3 { 1.08 } else { 1 }
    let above = if it.level == 2 {
      2 * typo.baseline
    } else if it.level == 3 {
      1.3 * typo.baseline
    } else {
      typo.baseline
    }
    let below = if it.level == 2 { 0.7 * typo.baseline } else { 0.6 * typo.baseline }
    block(
      above: above,
      below: below,
      breakable: false,
      // The heading itself sticks to the following block. Text widow/orphan
      // costs then keep a usable opening of the following paragraph without a
      // synthetic spacer that can survive between consecutive headings.
      sticky: true,
      width: 100%,
    )[
      #set text(font: heading-font, size: factor * typo.size, weight: "semibold")
      #if number != none {
        text(font: fonts.gothic, weight: "medium")[#number]
        h(0.8em)
      }
      #it.body
    ]
  }
}

// ==========================================
// 4. OUTLINE ENGINE
// ==========================================

#let render-outline-entry(it, typo, fonts, type) = {
  let part = "label" in it.element.fields() and it.element.label == <__jspart__>
  if part {
    v(1.5 * typo.baseline, weak: true)
    align(center)[
      #text(font: fonts.gothic, weight: "semibold", size: 1.15em)[
        #link(it.element.location())[#it.body()]
      ]
    ]
  } else {
    let indent = if it.level == 1 { 0em } else { (it.level - 1) * 1.2em }
    let width = if it.level == 1 { 4.5em } else { 3.6em }
    v(if it.level == 1 { typo.baseline } else { 0.55 * typo.baseline }, weak: true)
    link(it.element.location())[
      #grid(
        columns: (indent, width, 1fr, auto),
        column-gutter: 0pt,
        [],
        it.prefix(),
        [
          #it.body()
          #if it.fill != none {
            h(0.45em)
            box(width: 1fr, align(right, it.fill))
          }
        ],
        [#h(0.5em)#it.page()],
      )
    ]
  }
}

// ==========================================
// 5. FOOTNOTE ENGINE
// ==========================================

#let render-footnote-entry(it, typo) = context {
  let is-trans = it.note.has("label") and it.note.label == <trans>
  let n = if is-trans {
    counter("trans-note").at(here()).first()
  } else {
    counter(footnote).at(here()).first()
  }
  let mark = if is-trans { "*" + numbering("i", n) } else { "*" + str(n) }

  set text(size: 0.88em)
  set par(leading: typo.leading * 0.78, spacing: typo.leading * 0.78, first-line-indent: 0em)
  grid(
    columns: (1.4em, 1fr),
    super(mark, typographic: true, size: 0.8em), it.note.body,
  )
}

// ==========================================
// 6. COVER / TITLE / PART ENGINE
// ==========================================

#let render-cover(title, subtitle, date, author-line, other, logo, fonts) = {
  align(center)[
    #v(22%)
    #text(size: 1.9em, font: fonts.body)[#title]
    #if subtitle != [] and subtitle != none [#v(1.2em) #text(size: 1em)[— #subtitle —]]
    #v(3em)
    #text(size: 0.95em)[#date]
    #v(5%)
    #text(size: 1.15em)[#author-line]
    #if other != [] [#v(0.4em) #text(size: 0.9em)[#other]]
    #v(1fr)
    #if logo != [] [#text(size: 1.05em, font: fonts.gothic, weight: "semibold")[#logo]]
    #v(15%)
  ]
}

#let render-inline-title(title, subtitle, author-line, other, date, abstract, keywords, fonts) = {
  place(top + center, scope: "parent", float: true)[
    #set align(center)
    #v(1.2em)
    #text(size: 1.7em, font: fonts.body)[#title]
    #if subtitle != [] and subtitle != none [#v(0.6em) #text(size: 0.95em)[#subtitle]]
    #v(1em)
    #text(size: 0.95em)[#author-line]
    #if other != [] [#v(0.35em) #text(size: 0.85em)[#other]]
    #if date != "" [#v(0.6em) #text(size: 0.82em)[#date]]
    #if abstract != [] [
      #v(1.2em)
      #block(width: 90%, text(size: 0.9em)[#align(left)[*초록*#h(0.7em)#abstract]])
    ]
    #if keywords != () [#v(0.5em) #text(size: 0.82em)[*주제어*#h(0.7em)#keywords.join(", ")]]
    #v(1.4em)
  ]
}

#let render-part(title, num, fonts) = {
  v(30%)
  align(center)[
    #if num != none [#text(size: 1.1em, font: fonts.body, tracking: 0.25em, fill: luma(80))[#num] #v(0.6em)]
    #text(size: 2.15em, font: fonts.body, weight: "semibold", tracking: 0.06em)[#title]
    #v(2.5em)
    #line(length: 1.8em, stroke: 0.6pt + luma(160))
  ]
  v(1fr)
}


// ==========================================
// MAIN TEMPLATE FUNCTION
// ==========================================

#let jsarticle-book(
  title: [],
  subtitle: [],
  author: [],
  other: [],
  date: "",
  logo: [],
  authors: none,
  abstract: [],
  keywords: (),
  title-page: "cover",
  author-layout: "inline",
  bind: "none",
  margin-ratio: "optical",
  paper-size: "a4",
  doc-type: "article",
  cols: 1,
  column-gutter: 2em,
  chapter-format: ("第", "章"),
  font-size: auto,
  text-width: auto,
  marginal-outset: auto,
  lines-per-page: auto,
  baseline-ratio: auto,
  cjk-height: 0.88,
  cjk-scale: 0.925em,
  latin-scale: 1em,
  latin-baseline: 0em,
  latin-tracking: 0em,
  language-aware: true,
  japanese-scale: auto,
  chinese-scale: auto,
  western-leading-ratio: auto,
  japanese-leading-ratio: auto,
  chinese-leading-ratio: auto,
  strong-latin-scale: auto,
  strong-latin-baseline: 0em,
  strong-tracking: 0em,
  optical-adjustments: true,
  cjk-spacing: none,
  body,
) = {
  // 1. Typography Engine Initialization
  let typo = calculate-typography(
    paper-size,
    font-size,
    baseline-ratio,
    lines-per-page,
    text-width,
    cjk-height,
    cjk-scale,
    doc-type,
  )
  let western-line-ratio = if western-leading-ratio == auto {
    if doc-type == "novel" { 1.52 } else { 1.48 }
  } else { western-leading-ratio }
  let japanese-line-ratio = if japanese-leading-ratio == auto {
    if doc-type == "novel" { 1.68 } else { 1.60 }
  } else { japanese-leading-ratio }
  let chinese-line-ratio = if chinese-leading-ratio == auto {
    if doc-type == "novel" { 1.66 } else { 1.58 }
  } else { chinese-leading-ratio }
  let wide-outset = if marginal-outset == auto { typo.cjk-size } else { marginal-outset }

  let fonts = (
    body: font-body,
    italic: font-italic,
    maru: font-maru,
    gothic: font-gothic,
    math: font-math,
    western-body: font-western-profile.body,
    western-gothic: font-western-profile.gothic,
    japanese-body: font-ja.body,
    chinese-simplified-body: font-sc.body,
    chinese-traditional-body: font-tc.body,
    japanese-gothic: font-ja.gothic,
    chinese-simplified-gothic: font-sc.gothic,
    chinese-traditional-gothic: font-tc.gothic,
  )
  let language-fonts = (
    ko: (body: fonts.body, gothic: fonts.gothic),
    ja: (body: fonts.japanese-body, gothic: fonts.japanese-gothic),
    sc: (body: fonts.chinese-simplified-body, gothic: fonts.chinese-simplified-gothic),
    tc: (body: fonts.chinese-traditional-body, gothic: fonts.chinese-traditional-gothic),
    western: (body: fonts.western-body, gothic: fonts.western-gothic),
  )
  // Optical values remain template choices; the application engine lives in
  // cjk.typ so the same mechanism can be reused by other templates.
  let optical-profiles = (
    ko: (
      hangul: (baseline: -0.07em, tracking: -0.1em, strong-baseline: -0.06em),
      han: (baseline: 0em, tracking: -0.01em, strong-baseline: 0em),
      kana: (baseline: 0.02em, tracking: -0.02em, strong-baseline: 0.02em),
    ),
  )

  let (cjk-text-sp, raw-sp) = {
    if cjk-spacing == none { (none, none) } else if cjk-spacing == auto { (0.15em, none) } else if (
      type(cjk-spacing) == length
    ) { (cjk-spacing, none) } else if type(cjk-spacing) == dictionary {
      (
        cjk-spacing.at("cjk-latin", default: 0.15em),
        cjk-spacing.at("raw", default: none),
      )
    } else { panic("Invalid cjk-spacing: " + repr(cjk-spacing)) }
  }

  let binding-factor = calc.sqrt((typo.page-width / 210mm) * (typo.page-height / 297mm))

  let (margin-top, margin-bottom) = {
    if margin-ratio == "optical" {
      let offset = if doc-type == "article" { typo.baseline / 2 } else { typo.baseline / 4 }
      (typo.vertical-margin + offset, typo.vertical-margin - offset)
    } else if margin-ratio == "lichtenberg" {
      let total = 2 * typo.vertical-margin
      let top = total / (1 + 1.414)
      (top, total - top)
    } else {
      panic("Unknown margin-ratio: \"" + margin-ratio + "\". Expected \"optical\" or \"lichtenberg\".")
    }
  }

  if bind == "top" {
    margin-top += 15mm * binding-factor
  } else if bind == "center" {
    // additional inner margin calculated below
  } else if bind != "none" {
    panic("Unknown bind: \"" + bind + "\". Expected \"none\", \"top\", or \"center\".")
  }

  let inside = typo.side-margin
  let outside = typo.side-margin
  if bind == "center" {
    // Shift the type area away from the spine without shrinking it. Adding a
    // gutter only to the inside margin silently reduced the calculated CJK
    // character count, most noticeably on A5 and smaller sheets.
    let binding-shift = 2.5mm * binding-factor
    inside += binding-shift
    outside -= binding-shift
  }

  let author-items = if authors == none {
    if author == [] or author == none { () } else { (author,) }
  } else { authors }
  let author-separator = if author-layout == "stack" { linebreak() } else { h(2em) }
  let author-line = author-items.join(author-separator)

  // 2. Global Document & Page Setup
  set document(title: title, author: "")
  set page(
    width: typo.page-width,
    height: typo.page-height,
    margin: (inside: inside, outside: outside, top: margin-top, bottom: margin-bottom),
    header-ascent: 28%,
    footer-descent: 30%,
    columns: cols,
    header: if doc-type == "novel" { none } else {
      context {
        let physical = here().page()
        if title-page == "cover" and physical == 1 { none } else {
          let odd = calc.odd(physical)
          let number = counter(page).display()
          // A heading's own location can remain on the page before the
          // pagebreak injected by its show rule.  Use a marker emitted after
          // that break so the running head follows the rendered H1 page.
          let has-h1 = query(metadata.where(value: "js-h1-page")).any(
            marker => marker.location().page() == physical,
          )

          let header-content = if has-h1 {
            // Page containing h1: Display page number only in small bold font, no line
            align(if odd { right } else { left })[
              #text(size: 0.85em, font: fonts.body, weight: "bold")[#number]
            ]
          } else {
            // Standard page header: Section/Chapter title + Number + Horizontal Line
            let h1 = heading.where(level: 1)
            let h2 = heading.where(level: 2)
            let chapter = query(h1.before(here())).last(default: none)
            let section = query(h2.before(here())).last(default: none)
            let section-text = if section == none { [] } else {
              let c = counter(heading).at(section.location())
              if section.numbering == none { section.body } else {
                [#c.at(0).#c.at(1)#h(0.8em)#section.body]
              }
            }
            let chapter-text = if chapter == none { [] } else if chapter.numbering == none {
              chapter.body
            } else {
              let c = counter(heading).at(chapter.location()).first()
              let value = chapter-format.at(0) + str(c) + chapter-format.at(1)
              let number = if cjk-text-sp == none { value } else {
                cjk-latin-space(value, cjk-text-sp)
              }
              [#number #h(1em) #chapter.body]
            }
            stack(
              spacing: 0.2em,
              text(size: 0.86em, font: fonts.body)[
                #if odd [#section-text #h(1fr) #number] else [#number #h(1fr) #chapter-text]
              ],
              line(length: 100%, stroke: 0.4pt),
            )
          }
          move(
            dx: -wide-outset,
            block(width: 100% + 2 * wide-outset, header-content),
          )
        }
      }
    },
    footer: if doc-type == "article" { none } else {
      context {
        let physical = here().page()
        if title-page == "cover" and physical == 1 { none } else {
          let odd = calc.odd(physical)
          align(if odd { right } else { left })[#text(size: 0.85em, fill: luma(65))[#counter(page).display()]]
        }
      }
    },
  )

  // Publish the actual usable vertical extent, including any top-binding
  // allowance, and the resolved width of one column. Consumers read these
  // values contextually at the block's location.
  js-body-height.update(typo.page-height - margin-top - margin-bottom)
  js-column-width.update((typo.width - (cols - 1) * column-gutter) / cols)
  js-marginal-outset.update(wide-outset)
  js-baseline.update(typo.baseline)

  set columns(gutter: column-gutter)

  let cjk-top-edge = cjk-height * typo.cjk-size
  set text(
    font: fonts.body,
    size: typo.size,
    lang: "ko",
    number-type: "lining",
    weight: 400,
    fill: rgb("1a1a1a"),
    // The custom outer rule supplies the controlled Latin spacing.
    cjk-latin-spacing: none,
    // Keep the line box exactly one outer em while anchoring its ascent to
    // the requested (post-scale) CJK size.
    top-edge: cjk-top-edge,
    bottom-edge: cjk-top-edge - typo.size,
    costs: (widow: 100%, orphan: 100%),
  )

  set par(
    first-line-indent: (amount: 1em),
    leading: typo.leading,
    spacing: typo.leading,
    justify: true,
    justification-limits: (
      // Keep word spaces at or below their designed width. Residual stretch
      // is shared by the far more numerous character boundaries; on the
      // worst Korean lines the upper bound only cancels the -0.1em optical
      // tracking instead of opening conspicuous holes between words.
      spacing: (min: 88%, max: 100%),
      tracking: (min: -0.015em, max: 0.10em),
    ),
    linebreaks: "optimized",
  )

  // 3. Core Show Rules (Without Self-Recursion Loops)
  show strong: set text(font: fonts.gothic, weight: "medium")
  show emph: set text(font: fonts.italic, style: "italic")

  // Place the raw rules before the generic text dispatcher. Typst applies the
  // later show rule first, so the raw element gets the final monospace face
  // after its contained text has passed through language dispatch.
  show raw: set text(font: font-raw, features: js-raw-features)
  show raw.where(block: true): set block(width: 100%, fill: luma(242), inset: 0.8em, spacing: typo.baseline)
  show raw.where(block: true): set par(justify: false, leading: typo.leading * 0.8)
  show raw.where(block: false): it => {
    set text(font: font-raw, features: js-raw-features)
    let code = js-breakable-inline-raw(it.text)
    if raw-sp != none {
      h(raw-sp + 0.25em, weak: true) + code + h(raw-sp, weak: true)
    } else {
      code
    }
  }

  // A reference normally receives a localized kind such as "Equation" or
  // "Figure". Keep only its number; a manually supplied @label[supplement]
  // still takes precedence when prose needs one.
  set ref(supplement: none)

  // Math Engine - Numbering and style rules. Do not add spacing around all
  // inline equations: this rule cannot inspect neighbours, so it cannot tell
  // `한글$B$` from `($B$)` without producing asymmetric bracket spacing.
  set math.equation(numbering: n => context {
    let numbers = counter(heading).get()
    let chapter = numbers.at(0, default: 0)
    let section = numbers.at(1, default: 0)
    if chapter == 0 { numbering("(1.1)", section, n) } else { numbering("(1.1.1)", chapter, section, n) }
  })
  show math.equation: set text(font: fonts.math, weight: "regular")
  show math.equation.where(block: true): set block(spacing: typo.baseline)
  show math.equation.where(block: true): set par(leading: typo.leading)
  show math.equation.where(block: false): it => it
  set math.cases(gap: 0.8em)

  set quote(block: true)
  show quote.where(block: true): set pad(left: 2em)
  show quote.where(block: true): set block(spacing: typo.baseline)

  set list(indent: 1.2em)
  set enum(indent: 1.2em)
  set terms(indent: 2em, separator: h(0.8em, weak: true))
  show list: set block(spacing: typo.baseline)
  show enum: set block(spacing: typo.baseline)
  show terms: set block(spacing: typo.baseline)

  set table(stroke: 0.04em)
  show table: set text(top-edge: (2 * cjk-height - 1) * typo.size)

  // Footnote Engine - Target `<trans>` with specific where-selector to avoid recursive loops
  set footnote(numbering: (..v) => super(size: 0.7em, baseline: -0.25em, typographic: true, numbering(
    n => [\*#n],
    ..v,
  )))
  set footnote.entry(indent: 1.5em, gap: 0.5em, clearance: typo.leading, separator: line(
    length: 30%,
    stroke: 0.45pt + luma(30),
  ))

  show footnote.where(label: <trans>): it => context {
    let n = counter("trans-note").at(here()).first()
    super(size: 0.7em, baseline: -0.25em)[\*#numbering("i", n)]
  }
  show footnote.entry: it => render-footnote-entry(it, typo)

  // Heading & Numbering
  set heading(numbering: (..nums) => {
    let values = nums.pos()
    if values.len() == 1 {
      let value = chapter-format.at(0) + str(values.at(0)) + chapter-format.at(1)
      if cjk-text-sp == none { value } else { cjk-latin-space(value, cjk-text-sp) }
    } else if (
      values.at(0) == 0
    ) { values.slice(1).map(str).join(".") } else { values.map(str).join(".") }
  })

  // Heading Counter Manipulation & Render Delegation
  show heading: it => {
    place.flush()
    if it.level == 1 and not (it.has("label") and it.label == <__jspart__>) {
      if doc-type == "novel" { pagebreak(to: "odd", weak: true) } else { pagebreak(weak: true) }
      metadata("js-h1-page")
      counter(footnote).update(0)
      counter(math.equation).update(0)
    }
    render-heading(it, typo, doc-type, chapter-format, fonts)
  }

  // Outline Engine
  set outline.entry(fill: if doc-type == "novel" { none } else { repeat(gap: 0.45em, justify: false)[.] })
  show outline.entry: it => render-outline-entry(it, typo, fonts, doc-type)

  // 4. Layout Presentation Order Control
  let layout-content = {
    if title-page == "cover" and title != [] and title != "" {
      render-cover(title, subtitle, date, author-line, other, logo, fonts)
      pagebreak()
    }

    if title-page == "inline" and title != [] and title != "" {
      render-inline-title(title, subtitle, author-line, other, date, abstract, keywords, fonts)
    }

    if cjk-text-sp == none {
      body
    } else {
      cjk-latin-spacing(cjk-text-sp, cjk-inline-math-spacing(cjk-text-sp, body))
    }
  }

  cjk-language-layout(
    layout-content,
    language-fonts,
    typo.size,
    language-aware: language-aware,
    cjk-scale: cjk-scale,
    latin-scale: latin-scale,
    latin-baseline: latin-baseline,
    latin-tracking: latin-tracking,
    japanese-scale: japanese-scale,
    chinese-scale: chinese-scale,
    strong-latin-scale: strong-latin-scale,
    strong-latin-baseline: strong-latin-baseline,
    strong-tracking: strong-tracking,
    optical-adjustments: optical-adjustments,
    optical-profiles: optical-profiles,
    western-leading-ratio: western-line-ratio,
    japanese-leading-ratio: japanese-line-ratio,
    chinese-leading-ratio: chinese-line-ratio,
    skip-features: js-raw-features,
  )
}

// ==========================================
// UTILITIES & USER EXTENSIONS
// ==========================================

#let transnote(body) = {
  counter("trans-note").step()
  [#footnote(body)<trans>]
  counter(footnote).update(x => x - 1)
}

#let jspart(title, num: none) = [
  #[
    #set page(header: none, footer: none)
    #pagebreak(to: "odd", weak: true)
    #let outline-title = if num != none { [— #num　#title —] } else { [— #title —] }
    #hide[#heading(level: 1, numbering: none, outlined: true)[#outline-title]<__jspart__>]
    #render-part(title, num, (body: font-body, gothic: font-gothic))
  ]
  #pagebreak(weak: true)
]

#let jsicover(title, subtitle: none, author: none, size: 2.7em) = [
  #context [
    #let rsize = if calc.min(page.width, page.height) <= 148mm { size * 0.82 } else { size }
    #pagebreak(to: "odd", weak: true)
    #set page(header: none, footer: none)
    #v(20%)
    #align(center)[
      #text(size: rsize, font: font-body, weight: "semibold", tracking: 0.06em)[#title]
      #if subtitle != none [#v(0.4em) #text(size: rsize * 0.45, font: font-gothic, weight: "semibold")[#subtitle]]
      #if author != none [#v(4em) #text(size: rsize * 0.42, font: font-gothic)[#author]]
    ]
    #v(1fr)
  ]
  #pagebreak(to: "odd")
]

#let jsdinkus(sym: "*　*　*") = {
  v(2 * 1.65em, weak: true)
  align(center)[#text(size: 1.25em, font: font-body, weight: "bold")[#sym]]
  v(2 * 1.65em, weak: true)
}

#let jsquote(indent: false, body) = pad(left: 2em, top: 0.7em, bottom: 0.7em, {
  if indent { set par(first-line-indent: (amount: 1em, all: true)) } else { set par(first-line-indent: 0em) }
  body
})

#let jsbox(body) = block(width: 100%, stroke: 0.5pt, inset: (x: 1.5em, y: 1em), {
  set par(first-line-indent: 0em)
  body
})

#let jstopic(title: [], body) = {
  v(1.2em, weak: true)
  block(breakable: false)[
    #set par(first-line-indent: 0em)
    #text(font: font-gothic, weight: "semibold")[■#h(0.35em)#title]
    #h(0.5em)#body
  ]
}

#let jsans(it) = box(baseline: 25%, stroke: 0.5pt, inset: 1pt, rect(
  stroke: 0.5pt,
  inset: (x: 3pt, y: 2pt),
  radius: 0pt,
  text(size: 0.85em, weight: "semibold")[#it],
))

#let jsnnh1(title) = heading(level: 1, numbering: none)[#title]
#let jsnnoh1(title) = heading(level: 1, numbering: none, outlined: false)[#title]
