#import "../../cjk.typ": *
#import "fonts.typ": *
#import "state.typ": *
#import "../../vendor/rubby-0.10.2/rubby.typ": get-ruby
#import "../../vendor/basho-0.1.1/src/utils/ruby-pair.typ": ruby-auto-pair, ruby-pair-plain
#let jscjk-inline-boundaries(body) = context {
  let config = js-inline-boundary-config.get()
  cjk-inline-boundary-spacing(
    body,
    config.at("gaps"),
    inline-atom-particles: config.at("inline-atom-particles"),
  )
}

// `#rb[reading][base]` retains Rubby's familiar reading-first syntax.  The
// marker is already a valid Basho ruby token, so vertical renderers consume it
// directly. Horizontal segments lower it to the vendored Rubby implementation
// immediately before ordinary document layout.
#let _js-ruby-marker = "jsarticle-ruby"
#let _js-horizontal-ruby(reading, base, alignment: auto, dy: 0em, auto-pair: auto) = context {
  let pair = ruby-auto-pair(reading, base, enabled: if auto-pair == auto {
    js-vertical-config.get().at("ruby-auto-pair", default: true)
  } else { auto-pair })
  // Rubby cannot extract a plain sequence containing spaces on its own.
  // Normalize only plain content; retain styled content unchanged.
  let plain-reading = ruby-pair-plain(pair.reading)
  let plain-base = ruby-pair-plain(pair.base)
  let reading = if plain-reading == none { pair.reading } else { plain-reading }
  let base = if plain-base == none { pair.base } else { plain-base }
  let fontsets = js-current-fontsets.get()
  if fontsets == none { panic("ruby must be used inside an active jsarticle-book") }
  let common = fontsets.at("common", default: none)
  let ruby-fontset = fontsets.at("ruby", default: fontsets.at("body"))
  let em = text.size
  let reading-size = 0.55 * em
  let offset = dy.to-absolute()
  // Rubby owns base/ruby positioning. This callback styles only the reading,
  // so changing fonts.ruby-family never changes the annotated base text.
  let style-reading = body => cjk-fontset-apply(
    ruby-fontset,
    common: common,
  )[#text(top-edge: 0.8 * reading-size, bottom-edge: 0.2 * reading-size)[#body]]
  let render = get-ruby(
    size: reading-size,
    // Rubby places the reading at -1.5 * its height - dy. Convert that
    // coordinate to a small base-to-reading gap plus the caller's offset.
    dy: 0.12 * em - 0.5 * reading-size - offset,
    pos: top,
    alignment: "center",
    delimiter: "|",
    auto-spacing: true,
    ruby-style: style-reading,
  )
  box({
    // Paragraph edge/leading settings (notably footnotes) must not move the
    // annotation's origin. Both layers use local, explicit vertical bounds.
    set par(leading: 0pt)
    set text(top-edge: 0.8 * em, bottom-edge: 0.2 * em)
    if alignment == auto { render(reading, base) } else {
      render(reading, base, alignment: alignment)
    }
  })
}
#let ruby(reading, base, alignment: auto, dy: 0em, auto-pair: auto) = {
  assert(auto-pair in (auto, true, false), message: "ruby auto-pair must be auto, true, or false")
  metadata((
  type: "ruby",
  text: base,
  ruby: reading,
  (_js-ruby-marker): true,
  alignment: alignment,
  dy: dy,
  auto-pair: auto-pair,
))
}
// Short public spelling, matching Rubby's familiar `#rb[reading][base]`.
#let rb = ruby

// `jsvert` is the only public vertical-writing wrapper. Inline and fixed-region
// calls render locally. Automatic and page calls remain inert descriptors until
// jsarticle-book can group adjacent streams and place them on a page-wide
// surface without inheriting the horizontal column count.
// `justify: false` keeps automatic vertical line ends ragged; the default is
// true and distributes only eligible CJK inter-character slots.
#let _js-vertical-marker = "jsarticle-vertical-flow"
#let jsvert(body, ..options) = {
  let named = options.named()
  let flow = named.at("flow", default: auto)
  if not (flow in (auto, "inline", "region", "page")) {
    panic("jsvert: flow must be auto, \"inline\", \"region\", or \"page\"")
  }
  if flow in ("inline", "region") {
    context cjk-vertical-flow(
      body,
      defaults: js-vertical-config.get(),
      ..options,
    )
  } else {
    metadata((
      kind: _js-vertical-marker,
      bodies: (body,) + options.pos(),
      options: named,
    ))
  }
}
#let jscjk-normalize(
  body,
  language: auto,
  punctuation: auto,
  spaces: auto,
  collapse-punctuation-space: auto,
  skip-features: ((jscb: 1),),
) = context {
  let defaults = js-horizontal-normalization-config.get()
  cjk-normalize-horizontal(
    body,
    language: if language == auto { defaults.language } else { language },
    punctuation: if punctuation == auto { defaults.punctuation } else { punctuation },
    spaces: if spaces == auto { defaults.spaces } else { spaces },
    collapse-punctuation-space: if collapse-punctuation-space == auto {
      defaults.at("collapse-punctuation-space")
    } else { collapse-punctuation-space },
    skip-features: skip-features,
  )
}
// Compatibility alias. The operation is normalization, not a layout grid.
#let jsgrid = jscjk-normalize
#let jsstyle-bypass(body) = cjk-style-bypass(body)
#let jsipa = cjk-ipa
#let jsface = cjk-face
#let jsfontset = cjk-fontset
// Complete framework defaults. A document only supplies the composite roles it
// wants to replace through `options.fonts.composites`.
#let js-default-composites = js-default-fontsets
#let jsfontset-extend = cjk-fontset-extend
#let jsfontset-override = cjk-fontset-override
#let jsfont(target, ..options, body) = context {
  let fontsets = js-current-fontsets.get()
  if fontsets == none {
    panic("jsfont must be used inside an active jsarticle-book")
  }
  let fontset = if type(target) == str {
    if target not in fontsets { panic("Unknown jsarticle font role " + repr(target)) }
    fontsets.at(target)
  } else { target }
  let common = fontsets.at("common", default: none)
  let styles = options.named()
  if type(target) == str {
    // Named document roles use the book compositor directly.  This preserves
    // category-specific face optics (for example Hangul versus digits in a
    // Gothic-bold label) and gives an explicit nested native font precedence.
    let features = styles.at("features", default: (:))
    if "features" in styles { let _ = styles.remove("features") }
    set text(
      font: cjk-fontset-native(fontset, common: common),
      features: cjk-font-role-features(target, features: features),
    )
    text(..styles)[#body]
  } else {
    // A local, unregistered composite has no document role marker.  Its own
    // scoped renderer remains the deliberate escape hatch for that case.
    cjk-fontset-apply(fontset, common: common)[
      #text(..styles)[#body]
    ]
  }
}
// Register an outline destination for presentation-layer components without
// borrowing article-heading geometry, counters, or page-start policy.
#let jsheading-anchor(title, level: 1, outlined: true, destination: none) = {
  let marker = metadata((kind: "js-heading-anchor", level: level, title: title))
  place(top + left)[
    #hide[#heading(level: level, numbering: none, outlined: outlined)[#title]<__jsheading_anchor__>]
  ]
  if destination == none { marker } else { [#marker #destination] }
}
#let default-optical-profiles = (
  ko: (
hangul: (baseline: 0em, tracking: -0.06em),
    han: (baseline: 0em, tracking: 0em),
kana: (baseline: 0em, tracking: -0.01em),
    punctuation: (baseline: 0.0em, tracking: 0em),
  ),
)
// Public access to the families resolved by the active `jsarticle-book`.
// There is deliberately no module-level `font-kr` shortcut: a family is
// composed from the document's ambient language and its per-script stacks.
#let js-font-families() = {
  let families = js-current-fonts.get()
  if families == none {
    panic("js-font-families must be used inside an active jsarticle-book")
  }
  families
}
#let js-font-family(family) = {
  let families = js-font-families()
  if family not in families {
    panic("Unknown jsarticle font family " + repr(family))
  }
  families.at(family)
}

#let font-math = (
  // Keep the mathematical families first and unrestricted. Upright text,
  // operators, ordinary symbols, and variants such as hbar must all come from
  // the same OpenType MATH family.

  (name: "STIX Two Math", covers: regex("[*†‡§¶‖]")),
  (name: "STIX Two Math", covers: regex("[∑∏∐∫∬∭∮∯∰⋂⋃⋀⋁]")),
  "New Computer Modern Math",
  "STIX Two Math",

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
#let js-raw-features = (jsrw: 1)
#let js-fixed-layout-features = (jsly: 1)
#let js-math-features = (jsmt: 1)


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
