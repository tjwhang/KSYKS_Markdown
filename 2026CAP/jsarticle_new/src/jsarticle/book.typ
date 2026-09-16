#import "headings.typ": make-heading-renderers
#import "../../cjk.typ": *
#import "fonts.typ": *
#import "state.typ": *
#import "inline.typ": *
#import "options.typ": *
#import "defaults.typ": *
#import "geometry.typ": *
#import "flow.typ": *
#import "title.typ": *
#let _jsarticle-book-render = {

  (
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
    page-margin: auto,
    page-header: auto,
    page-footer: auto,
    paper-size: "a4",
    doc-type: "article",
    cols: 1,
    // H1 flow policy: remain in flow, advance to the next column/page, or
    // unconditionally begin a new physical page.
    h1-break: "adaptive", // "continuous", "adaptive", "page"
    column-gutter: 2em,
    chapter-format: ("第", "章"),
    font-size: auto,
    ruby-auto-pair: true,
    text-width: auto,
    marginal-outset: auto,
    lines-per-page: auto,
    baseline-ratio: auto,
    cjk-height: 0.88,
    cjk-scale: 0.925em,
    latin-scale: 1em,
    latin-baseline: 0em,
    latin-tracking: 0em,
    latin-light-weight: false,
    language-aware: true,
    ambient-language: "ko",
    vertical: (
      punctuation-font: js-default-faces.hiragino-mincho.name,
      page-start: false,
      heading-mode: "semantic", // "semantic", "visual"
      unicode-fallbacks: true,
      collapse-punctuation-space: true,
      korean-fullwidth-spaces: false,
      boundary-spacing: 0.2em,
      latin-orientation: "rotate", // "rotate", "upright"
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
      line-overhang-threshold: 0.5em, // value should be lower than 1em
      min-final-line-chars: 2,
      min-fragment-chars: 2,
      min-fragment-languages: ("ko",),
      justify-languages: ("ko",),
      justify: true,
      orphan-lines: 2,
      widow-lines: 2,
      stream-gap: 0.6em,
      font-family: auto,
      strong-family: auto,
      heading-family: auto,
      ruby-family: auto,
    ),
    japanese-scale: auto,
    chinese-scale: auto,
    korean-leading-ratio: auto,
    western-leading-ratio: auto,
    japanese-leading-ratio: auto,
    chinese-leading-ratio: auto,
    strong-latin-scale: auto,
    strong-latin-baseline: 0em,
    font-composites: js-default-fontsets,
    body-family: "serif",
    strong-family: "gothic-bold",
    heading-family: "gothic",
    footnote-family: "footnote",
    ruby-family: auto,
    strong-weight: "medium",
    horizontal-normalization: (
      enabled: false,
      punctuation: true,
      spaces: true,
      collapse-punctuation-space: true,
    ),
    optical-adjustments: true,
    optical-profiles: default-optical-profiles,
    inline-math-display-style: false,
    inline-math-bounds: false,
    math-font: font-math,
    cjk-spacing: none,
    inline-atom-particles: auto,
    body,
  ) => {
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
      cols,
    )
    let single-typo = calculate-typography(
      paper-size,
      font-size,
      baseline-ratio,
      lines-per-page,
      text-width,
      cjk-height,
      cjk-scale,
      doc-type,
      1,
    )
    if not (h1-break in ("continuous", "adaptive", "page")) {
      panic("jsarticle-book: h1-break must be \"continuous\", \"adaptive\", or \"page\"")
    }
    // The V2 facade has already merged and validated this record.
    // Keep the private renderer a consumer, not a second source of defaults.
    let vertical-options = vertical
    if vertical-options.line-overhang-threshold >= 1em {
      panic("jsarticle-book: line overhang threshold should be lower than 1em")
    }
    // As with vertical options, horizontal normalization is resolved once at
    // the public boundary and passed through unchanged.
    let horizontal-normalization-options = horizontal-normalization
    let korean-line-ratio = if korean-leading-ratio == auto {
      typo.baseline / typo.size
    } else { korean-leading-ratio }
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

    // Physical type is always selected through an ordered composite. The
    // public V2 schema rejects the former language profile grid.
    if type(font-composites) != dictionary {
      panic("jsarticle: options.fonts.composites must be a dictionary")
    }
    let composite-fontsets = js-default-fontsets
    let roles = (
      "common",
      "body",
      "serif",
      "serif-bold",
      "gothic",
      "gothic-bold",
      "maru",
      "strong",
      "heading",
      "footnote",
      "ruby",
      "title",
    )
    for (role, fontset) in font-composites {
      if role not in roles {
        panic("jsarticle: unknown option options.fonts.composites." + role)
      }
      composite-fontsets.insert(role, fontset)
    }
    let selected-role = (role, family) => if role in font-composites {
      composite-fontsets.at(role)
    } else {
      composite-fontsets.at(family)
    }
    composite-fontsets.insert("body", selected-role("body", body-family))
    composite-fontsets.insert("strong", selected-role("strong", strong-family))
    composite-fontsets.insert("heading", selected-role("heading", heading-family))
    composite-fontsets.insert("footnote", selected-role("footnote", footnote-family))
    composite-fontsets.insert("ruby", selected-role(
      "ruby", if ruby-family == auto { body-family } else { ruby-family },
    ))
    composite-fontsets.insert("title", selected-role("title", "heading"))
    js-current-fontsets.update(composite-fontsets)

    let fonts = (
      body: cjk-fontset-native(composite-fontsets.at("body"), common: composite-fontsets.at("common")),
      serif: cjk-fontset-native(composite-fontsets.at("serif"), common: composite-fontsets.at("common")),
      serif-bold: cjk-fontset-native(composite-fontsets.at("serif-bold"), common: composite-fontsets.at("common")),
      italic: cjk-fontset-native(composite-fontsets.at("serif"), common: composite-fontsets.at("common")),
      maru: cjk-fontset-native(composite-fontsets.at("maru"), common: composite-fontsets.at("common")),
      gothic: cjk-fontset-native(composite-fontsets.at("gothic"), common: composite-fontsets.at("common")),
      gothic-bold: cjk-fontset-native(composite-fontsets.at("gothic-bold"), common: composite-fontsets.at("common")),
      footnote: cjk-fontset-native(composite-fontsets.at("footnote"), common: composite-fontsets.at("common")),
      ruby: cjk-fontset-native(composite-fontsets.at("ruby"), common: composite-fontsets.at("common")),
      strong: cjk-fontset-native(composite-fontsets.at("strong"), common: composite-fontsets.at("common")),
      heading: cjk-fontset-native(composite-fontsets.at("heading"), common: composite-fontsets.at("common")),
      math: math-font,
    )
    js-current-fonts.update(fonts)

    // Composite scopes carry both an explicit semantic role and its canonical
    // native signature.  CJK uses the signature only to honour an intentional
    // nested native font override; it never infers a role by scanning stacks.
    let role-font(role) = cjk-fontset-native(
      composite-fontsets.at(role),
      common: composite-fontsets.at("common"),
    )
    let role-features(role, base: (:)) = cjk-font-role-features(
      role,
      features: base,
    )

    let renderers = make-heading-renderers(typo, doc-type, role-font, role-features)

    // One scalar intentionally means one spacing policy for all inline CJK
    // boundaries. A record can tune Latin, math, and raw independently.
    let cjk-boundary-gaps = if cjk-spacing == none {
      (cjk-latin: none, math: none, raw: none)
    } else if cjk-spacing == auto {
      (cjk-latin: 0.15em, math: 0.15em, raw: 0.15em)
    } else if type(cjk-spacing) == length {
      (cjk-latin: cjk-spacing, math: cjk-spacing, raw: cjk-spacing)
    } else if type(cjk-spacing) == dictionary {
      for (key, value) in cjk-spacing {
        if key not in ("cjk-latin", "math", "raw") {
          panic("options.typography.cjk-spacing has unknown key " + repr(key))
        }
        if value != none and type(value) != length {
          panic("options.typography.cjk-spacing." + key + " must be a length or none")
        }
      }
      let cjk-latin = cjk-spacing.at("cjk-latin", default: 0.15em)
      (
        cjk-latin: cjk-latin,
        math: cjk-spacing.at("math", default: cjk-latin),
        raw: cjk-spacing.at("raw", default: cjk-latin),
      )
    } else {
      panic("options.typography.cjk-spacing must be none, auto, a length, or a dictionary")
    }
    let cjk-text-sp = cjk-boundary-gaps.at("cjk-latin")
    // Keep a CJK particle with a directly preceding inline atom. `auto` uses
    // the built-in Korean/Japanese lists; callers may supply one or both lists
    // or `none` to disable the constraint altogether.
    let default-inline-atom-particles = (
      ko: (
        "으로",
        "에서",
        "에게",
        "까지",
        "부터",
        "보다",
        "처럼",
        "같이",
        "마다",
        "조차",
        "마저",
        "밖에",
        "은",
        "는",
        "이",
        "가",
        "을",
        "를",
        "와",
        "과",
        "도",
        "만",
        "의",
        "에",
        "로",
        "랑",
        "하고",
        "인",
        "이며",
        "이고",
        "이라",
        "라고",
        "인데",
      ),
      ja: (
        "から",
        "まで",
        "より",
        "ので",
        "のに",
        "けど",
        "たら",
        "なら",
        "って",
        "では",
        "には",
        "とは",
        "は",
        "が",
        "を",
        "に",
        "へ",
        "と",
        "で",
        "の",
        "も",
        "や",
        "か",
        "ね",
        "よ",
        "ぞ",
        "さ",
        "わ",
        "な",
        "し",
        "て",
        "ば",
      ),
    )
    let inline-atom-particle-lists = if inline-atom-particles == auto {
      default-inline-atom-particles
    } else if inline-atom-particles == none {
      (ko: (), ja: ())
    } else if type(inline-atom-particles) == dictionary {
      let result = default-inline-atom-particles
      for (language, particles) in inline-atom-particles {
        if language not in ("ko", "ja") {
          panic("options.typography.inline-atom-particles has unknown language " + repr(language))
        }
        if type(particles) != array or not particles.all(particle => type(particle) == str) {
          panic("options.typography.inline-atom-particles." + language + " must be an array of strings")
        }
        result.insert(language, particles)
      }
      result
    } else {
      panic("options.typography.inline-atom-particles must be auto, none, or a dictionary")
    }
    let cjk-options = (
      language-aware: language-aware,
      ambient-language: ambient-language,
      cjk-scale: cjk-scale,
      latin-scale: latin-scale,
      latin-baseline: latin-baseline,
      latin-tracking: latin-tracking,
      latin-light-weight: latin-light-weight,
      japanese-scale: japanese-scale,
      chinese-scale: chinese-scale,
      strong-latin-scale: strong-latin-scale,
      strong-latin-baseline: strong-latin-baseline,
      korean-leading-ratio: korean-line-ratio,
      western-leading-ratio: western-line-ratio,
      japanese-leading-ratio: japanese-line-ratio,
      chinese-leading-ratio: chinese-line-ratio,
      skip-features: (js-raw-features, js-math-features),
      skip-paragraph-features: (js-fixed-layout-features,),
      boundary-spacing: cjk-text-sp,
      math-boundary-spacing: cjk-boundary-gaps.math,
      raw-boundary-spacing: cjk-boundary-gaps.raw,
      inline-atom-particles: inline-atom-particle-lists,
    )

    let resolve-page-margins(t) = {
      if page-margin != auto {
        if type(page-margin) != dictionary {
          panic("jsarticle-book: page margin must be auto or a dictionary")
        }
        let physical = "left" in page-margin or "right" in page-margin
        let sides = if physical { ("left", "right") } else { ("inside", "outside") }
        for key in sides + ("top", "bottom") {
          if key not in page-margin {
            panic("jsarticle-book: explicit page margin requires " + repr(key))
          }
        }
        // A complete physical pair takes precedence over legacy binding keys.
        // Retain the chosen keys so Typst does not mirror fixed margins.
        let resolved = (
          top: page-margin.top,
          bottom: page-margin.bottom,
        )
        for key in sides { resolved.insert(key, page-margin.at(key)) }
        return resolved
      }
      let binding-factor = calc.sqrt((t.page-width / 210mm) * (t.page-height / 297mm))
      let (top, bottom) = {
        if margin-ratio == "optical" {
          let offset = if doc-type == "article" { t.baseline / 2 } else { t.baseline / 4 }
          (t.vertical-margin + offset, t.vertical-margin - offset)
        } else if margin-ratio == "lichtenberg" {
          let total = 2 * t.vertical-margin
          let upper = total / (1 + 1.414)
          (upper, total - upper)
        } else {
          panic("Unknown margin-ratio: \"" + margin-ratio + "\". Expected \"optical\" or \"lichtenberg\".")
        }
      }
      if bind == "top" {
        top += 15mm * binding-factor
      } else if bind != "center" and bind != "none" {
        panic("Unknown bind: \"" + bind + "\". Expected \"none\", \"top\", or \"center\".")
      }
      let inside = t.side-margin
      let outside = t.side-margin
      if bind == "center" {
        // Shift the type area away from the spine without shrinking it.
        let binding-shift = 2.5mm * binding-factor
        inside += binding-shift
        outside -= binding-shift
      }
      (inside: inside, outside: outside, top: top, bottom: bottom)
    }
    let page-margins = resolve-page-margins(typo)
    let single-page-margins = resolve-page-margins(single-typo)
    let side-total(margins) = if "left" in margins {
      margins.left + margins.right
    } else { margins.inside + margins.outside }
    let page-body-width = typo.page-width - side-total(page-margins)
    let margin-top = page-margins.top
    let margin-bottom = page-margins.bottom

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
      // Keep native page columns for horizontal material. Page-flow vertical
      // surfaces switch to a scoped one-column page below; this is the safe
      // fallback required because explicit columns cannot contain pagebreaks.
      margin: page-margins,
      header-ascent: 28%,
      footer-descent: 30%,
      columns: cols,
      header: if page-header != auto { page-header } else if doc-type == "novel" { none } else {
        context {
          let physical = here().page()
          let h1 = heading.where(level: 1)
          let has-h1 = query(metadata.where(value: "js-h1-page")).any(
            marker => marker.location().page() == physical,
          )
          if here().page-numbering() == none or (not js-running-heads.get() and not has-h1) {
            none
          } else {
            let odd = calc.odd(physical)
            let number = counter(page).display()
            let header-content = if has-h1 {
              // Page containing h1: Display page number only in small bold font, no line
              align(if odd { right } else { left })[
                #text(
                  font: role-font("serif-bold"),
                  weight: "bold",
                  features: role-features("serif-bold", base: js-fixed-layout-features),
                )[#number]
              ]
            } else {
              // Standard page header: Section/Chapter title + Number + Horizontal Line
              let h2 = heading.where(level: 2)
              let chapter = query(h1.before(here())).last(default: none)
              // A running header lives above the body, so `before(here())`
              // cannot see a section that starts later on the same page. Prefer
              // the last h2 actually placed on this page, including anchors from
              // shared vertical regions, then fall back to the preceding one.
              let page-section = query(h2)
                .filter(
                  item => item.location().page() == physical,
                )
                .last(default: none)
              let candidate-section = if page-section != none {
                page-section
              } else { query(h2.before(here())).last(default: none) }
              // A visual vertical heading intentionally does not enter the
              // outline. Its continuation page must therefore never inherit a
              // section heading from the preceding chapter.
              let section = if candidate-section == none or chapter == none {
                candidate-section
              } else {
                let chapter-number = counter(heading).at(chapter.location()).first()
                let section-number = counter(heading).at(candidate-section.location()).first()
                if section-number == chapter-number { candidate-section } else { none }
              }
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
              let odd-header-text = if section == none { chapter-text } else { section-text }
              stack(
                spacing: 0.2em,
                text(
                  font: role-font("body"),
                  features: role-features("body", base: js-fixed-layout-features),
                )[
                  #if odd [#odd-header-text #h(1fr) #number] else [#number #h(1fr) #chapter-text]
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
      footer: if page-footer != auto { page-footer } else if doc-type == "article" { none } else {
        context {
          if here().page-numbering() == none or not js-running-heads.get() {
            none
          } else {
            let odd = calc.odd(here().page())
            align(if odd { right } else { left })[#text(size: 0.9em, fill: luma(65))[#counter(
              page,
            ).display()]]
          }
        }
      },
    )

    // Publish the actual usable vertical extent, including any top-binding
    // allowance, and the resolved width of one column. Consumers read these
    // values contextually at the block's location.
    js-body-height.update(typo.page-height - margin-top - margin-bottom)
    js-column-width.update((page-body-width - (cols - 1) * column-gutter) / cols)
    js-marginal-outset.update(wide-outset)
    js-baseline.update(typo.baseline)
    js-single-page-margin.update(single-page-margins)
    let published-horizontal-normalization = horizontal-normalization-options
    published-horizontal-normalization.insert("language", ambient-language)
    js-horizontal-normalization-config.update(published-horizontal-normalization)
    js-inline-boundary-config.update((
      gaps: cjk-boundary-gaps,
      inline-atom-particles: inline-atom-particle-lists,
    ))

    js-vertical-config.update((
      punctuation-font: vertical-options.at("punctuation-font"),
      ambient-language: ambient-language,
      page-margin: single-page-margins,
      page-start: vertical-options.at("page-start"),
      heading-mode: vertical-options.at("heading-mode"),
      unicode-vertical-fallbacks: vertical-options.at("unicode-fallbacks"),
      collapse-space-after-punctuation: vertical-options.at("collapse-punctuation-space"),
      korean-fullwidth-cjk-spaces: vertical-options.at("korean-fullwidth-spaces"),
      inline-atom-particles: inline-atom-particle-lists,
      boundary-spacing: if vertical-options.at("boundary-spacing") == auto {
        if cjk-text-sp == none { 0pt } else { cjk-text-sp }
      } else { vertical-options.at("boundary-spacing") },
      latin-orientation: vertical-options.at("latin-orientation"),
      tcy-max-digits: vertical-options.at("tcy-max-digits"),
      tracking: vertical-options.tracking,
      ruby-auto-pair: ruby-auto-pair,
      ruby-size: vertical-options.at("ruby-size"),
      ruby-gap: vertical-options.at("ruby-gap"),
      ruby-overflow: vertical-options.at("ruby-overflow"),
      ruby-overhang: vertical-options.at("ruby-overhang"),
      width: vertical-options.width,
      height: vertical-options.height,
      columns: vertical-options.columns,
      rows: vertical-options.rows,
      line-gap: vertical-options.at("line-gap"),
      column-gap: vertical-options.at("column-gap"),
      row-gap: vertical-options.at("row-gap"),
      row-fit-threshold: vertical-options.at("row-fit-threshold"),
      line-overhang-threshold: vertical-options.at("line-overhang-threshold"),
      min-final-line-chars: vertical-options.at("min-final-line-chars"),
      min-fragment-chars: vertical-options.at("min-fragment-chars"),
      min-fragment-languages: vertical-options.at("min-fragment-languages"),
      justify-languages: vertical-options.at("justify-languages"),
      justify: vertical-options.at("justify"),
      orphan-lines: vertical-options.at("orphan-lines"),
      widow-lines: vertical-options.at("widow-lines"),
      stream-gap: vertical-options.at("stream-gap"),
      font-family: if vertical-options.at("font-family") == auto { body-family } else {
        vertical-options.at("font-family")
      },
      strong-family: if vertical-options.at("strong-family") == auto { strong-family } else {
        vertical-options.at("strong-family")
      },
      heading-family: if vertical-options.at("heading-family") == auto { heading-family } else {
        vertical-options.at("heading-family")
      },
      ruby-family: if vertical-options.at("ruby-family") == auto {
        if ruby-family == auto { body-family } else { ruby-family }
      } else { vertical-options.at("ruby-family") },
      fontsets: composite-fontsets,
    ))

    set columns(gutter: column-gutter)

    // Page-flow jsvert calls are represented as metadata until this top-level
    // body pass. That gives the template one deterministic place to group
    // adjacent streams and alternate native horizontal columns with page-wide
    // vertical surfaces. Grouping itself uses no location queries or sibling
    // state; the renderer only hands the measured first-region height to its
    // continuation so both phases calculate the same source cursor.
    let segment-body = make-body-flow(cols, vertical-options, single-page-margins)

    let cjk-top-edge = cjk-height * typo.cjk-size
    let ambient-profile-key = if ambient-language == "ko" {
      "ko"
    } else if ambient-language == "ja" {
      "ja"
    } else if ambient-language == "zh" {
      "zh"
    } else {
      "western"
    }
    let ambient-paragraph = cjk-paragraph-profiles.at(ambient-profile-key)
    let ambient-indent = ambient-paragraph.at("first-line-indent")
    if ambient-indent == auto {
      // Preserve the established jsarticle measure: its public `font-size` is
      // the outer em, while the Korean glyph remains optically scaled inside it.
      ambient-indent = 1em
    }
    set text(
      font: role-font("body"),
      size: typo.size,
      lang: ambient-language,
      number-type: "lining",
      weight: 400,
      fill: rgb("1D1E23"),
      // The custom show rule supplies better controlled Latin spacing.
      cjk-latin-spacing: none,
      // Keep the line box exactly one outer em while anchoring its ascent to
      // the requested (post-scale) CJK size. -> top - bottom = 1em
      top-edge: (cjk-top-edge / typo.size) * 1em,
      bottom-edge: (cjk-top-edge / typo.size - 1) * 1em,
      costs: ambient-paragraph.at("costs"),
      features: role-features("body"),
    )

    set par(
      first-line-indent: ambient-indent,
      leading: (typo.leading / typo.size) * 1em,
      spacing: if ambient-paragraph.at("spacing") == auto {
        (typo.leading / typo.size) * 1em
      } else { ambient-paragraph.at("spacing") },
      justify: ambient-paragraph.at("justify"),
      justification-limits: ambient-paragraph.at("justification-limits"),
      linebreaks: ambient-paragraph.at("linebreaks"),
    )

    // 3. Core Show Rules (Without Self-Recursion Loops)
    // A semantic marker, rather than the resulting numeric weight, drives CJK
    // strong optics. Nested explicit `text(font: ...)` remains authoritative.
    show strong: set text(
      font: role-font("strong"),
      weight: strong-weight,
      features: role-features("strong", base: cjk-semantic-strong-marker),
    )
    // show emph: set text(font: fonts.italic, style: "italic")

    // Place the raw rules before the generic text dispatcher.
    show raw: set text(font: font-raw, features: js-raw-features)
    show raw.where(block: true): set block(width: 100%, fill: luma(242), inset: 0.8em, spacing: typo.baseline)
    show raw.where(block: true): set par(justify: false, leading: typo.leading * 0.8)
    show raw.where(block: false): it => {
      set text(font: font-raw, features: js-raw-features)
      let pieces = ()
      let run = ""
      for cluster in it.text.clusters() {
        run += cluster
        if ("_", "-", ".", "/", "\\", ":").contains(cluster) {
          pieces.push(text(run))
          pieces.push(h(0pt, weak: true))
          run = ""
        }
      }
      if run != "" { pieces.push(text(run)) }
      let code = pieces.sum(default: [])
      // Keep the semantic raw-boundary markers adjacent to the code content.
      // A markup block here would preserve its line-feed indentation as two
      // ordinary spaces: the trailing one then sat between a raw atom and a
      // following CJK particle *before* the configured boundary gap.  Build
      // the sequence directly so `cjk-spacing.raw` is the only physical
      // spacing at either raw/CJK seam.
      metadata((js-cjk-raw-boundary: "start")) + code + metadata((js-cjk-raw-boundary: "end"))
    }

    set ref(supplement: none)

    // Math Engine
    set math.equation(numbering: n => context {
      let numbers = counter(heading).get()
      let chapter = numbers.at(0, default: 0)
      let section = numbers.at(1, default: 0)
      if chapter == 0 { numbering("(1.1)", section, n) } else { numbering("(1.1.1)", chapter, section, n) }
    })
    // The private feature is an inert shaping tag and a boundary marker for the
    // multilingual compositor. Without it, quoted/upright math text is seen as
    // ordinary prose and rebuilt with the ambient body font.
    show math.equation: set text(
      font: fonts.math,
      weight: "regular",
      features: js-math-features,
    )
    show math.equation.where(block: true): set block(spacing: typo.baseline)
    show math.equation.where(block: true): set par(leading: typo.leading)
    show math.equation.where(block: false): it => context {
      // `math.display` changes the mathematical style while preserving the
      // equation's inline placement.
      let rendered = if inline-math-display-style { math.display(it) } else { it }

      // Korean textbook InDesign MathMagic style line spacing adjustments for eqs
      if inline-math-bounds {
        let normal-inline-height = typo.leading / 2 + typo.cjk-size - 0.02em.to-absolute()
        if measure(rendered).height >= normal-inline-height {
          set text(top-edge: "bounds", bottom-edge: "bounds")
          rendered
        } else {
          rendered
        }
      } else {
        rendered
      }
    }
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

    // target `<trans>` with specific where-selector to avoid recursion
    show footnote: it => [#sym.wj#it]
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
      [#sym.wj#super(size: 0.7em, baseline: -0.25em)[\*#numbering("i", n)]]
    }
    show footnote.entry: renderers.footnote

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
      let regular-h1 = it.level == 1 and not (it.has("label") and it.label == <__jspart__>)
      if regular-h1 {
        if h1-break == "adaptive" {
          if cols > 1 { colbreak(weak: true) } else { pagebreak(weak: true) }
        } else if h1-break == "page" {
          pagebreak(weak: true)
        }
        js-running-heads.update(true)
        metadata("js-h1-page")
        counter(footnote).update(0)
        counter(math.equation).update(0)
      }
      (renderers.heading)(it)
    }

    // Outline Engine
    set outline.entry(fill: if doc-type == "novel" { none } else { repeat(gap: 0.45em, justify: false)[.] })
    show outline.entry: renderers.outline
    show outline: it => {
      if h1-break != "continuous" {
        set page(columns: 1, margin: single-page-margins)
      }
      it
    }

    let render-vertical-cover = make-vertical-cover(title, subtitle, other, date, logo, role-font, role-features, author-line)

    // 4. Layout Presentation Order Control
    let layout-content = {
      if title-page == "cover" and title != [] and title != "" {
        js-running-heads.update(false)
        {
          set page(columns: 1, margin: single-page-margins)
          [
            #align(center)[
              #v(22%)
              #text(
                size: 1.9em,
                font: role-font("title"),
                features: role-features("title", base: js-fixed-layout-features),
              )[#title]
              #if subtitle != [] and subtitle != none [#v(1.2em) #text(size: 1em)[— #subtitle —]]
              #v(3em)
              #text(size: 0.95em)[#date]
              #v(5%)
              #text(size: 1.15em)[#author-line]
              #if other != [] [#v(0.4em) #text(size: 0.9em)[#other]]
              #v(1fr)
              #if logo != [] [#text(
                size: 1.05em,
                font: role-font("gothic"),
                weight: "semibold",
                features: role-features("gothic", base: js-fixed-layout-features),
              )[#logo]]
              #v(15%)
            ]
          ]
        }
      }

      if title-page == "inline" and title != [] and title != "" {
        place(top + center, scope: "parent", float: true, block(width: 100%)[
          #set align(center)
          #v(1.2em)
          #text(
            size: 1.7em,
            font: role-font("title"),
            features: role-features("title", base: js-fixed-layout-features),
          )[#title]
          #if subtitle != [] and subtitle != none [#v(0.6em) #text(size: 0.95em)[#subtitle]]
          #v(1em)
          #text(size: 0.95em)[#author-line]
          #if other != [] [#v(0.35em) #text(size: 0.85em)[#other]]
          #if date != "" [#v(0.6em) #text(size: 0.82em)[#date]]
          #if abstract != [] [
            #v(1.2em)
            #block(width: 90%, text(size: 0.9em)[#align(left)[*초록*#h(0.7em)#abstract]])
          ]
          #if keywords != () [#v(0.5em) #text(size: 0.82em)[*키워드*#h(0.7em)#keywords.join(", ")]]
          #v(1.4em)
        ])
      }

      if title-page == "cover-vert" and title != [] and title != "" {
        js-running-heads.update(false)
        set page(columns: 1, margin: single-page-margins)
        render-vertical-cover
      }

      segment-body(body)
    }

    // Normalize the source inside the language compositor. A separate generic
    // `show text` normalizer would rebuild a local jp or cn span
    // outside that compositor, silently leaving it on the ambient Korean
    // font stack.
    let cjk-layout-options = cjk-options
    cjk-layout-options.insert("horizontal-normalization", if horizontal-normalization-options.at("enabled") {
      (
        punctuation: horizontal-normalization-options.at("punctuation"),
        spaces: horizontal-normalization-options.at("spaces"),
        collapse-punctuation-space: horizontal-normalization-options.at("collapse-punctuation-space"),
      )
    } else { none })
    // Language optics are the final composite fallback. Convert the legacy
    // contextual CJK length into one dimensionless face scale here, so a face
    // scale replaces it rather than multiplying it in the compositor.
    let fontset-optics = (:)
    let cjk-scale-factor = cjk-scale / 1em
    for language in ("ko", "ja", "sc", "tc") {
      let categories = (:)
      for category in ("hangul", "han", "kana", "punctuation", "symbol") {
        categories.insert(category, (scale: cjk-scale-factor))
      }
      fontset-optics.insert(language, categories)
    }
    if optical-adjustments {
      for (language, categories) in optical-profiles {
        let resolved-categories = fontset-optics.at(language, default: (:))
        for (category, values) in categories {
          if type(values) == dictionary {
            let resolved-values = resolved-categories.at(category, default: (:))
            for property in ("baseline", "tracking", "scale") {
              if property in values {
                let value = values.at(property)
                resolved-values.insert(property, if property == "scale" { value / 1em } else { value })
              }
            }
            resolved-categories.insert(category, resolved-values)
          }
        }
        fontset-optics.insert(language, resolved-categories)
      }
    }
    cjk-layout-options.insert("fontset-optics", fontset-optics)
    cjk-inline-boundary-spacing(
      cjk-language-layout(
        layout-content,
        typo.size,
        fontsets: composite-fontsets,
        common-fontset: composite-fontsets.at("common"),
        config: cjk-layout-options,
      ),
      cjk-boundary-gaps,
      inline-atom-particles: inline-atom-particle-lists,
    )
  }
}

// Public V2 facade. The renderer intentionally keeps its flat private
// signature for now, so this is the only boundary that projects grouped,
// validated options into legacy layout variables.
#let jsarticle-book(options: jsarticle-options(), body) = {
  let flat = flatten-book-options(options)
  _jsarticle-book-render.with(..flat)(body)
}
