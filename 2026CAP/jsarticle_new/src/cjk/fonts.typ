// Composite font routing for jsarticle.
//
// Faces describe physical fonts and their optical corrections. Fontsets decide
// when a face is used. This module deliberately knows nothing about document
// roles, page layout, paragraph policies, or Basho.

#let cjk-font-categories = (
  "western", "number", "hangul", "han", "kana", "punctuation", "symbol",
)

// A role marker identifies a document-owned composite scope.  It is deliberately
// independent of native selector names: two roles may use the same physical
// fonts while retaining different rule optics.
#let cjk-font-roles = (
  "body", "serif", "serif-bold", "gothic", "gothic-bold", "maru",
  "strong", "heading", "footnote", "ruby", "title",
)

#let cjk-ipa-pattern = regex("\\[[\\p{sc:Latn}\\p{M}ˈˌːˑ.‿ -]+\\]|/[\\p{sc:Latn}\\p{M}ˈˌːˑ.‿ -]+/")
#let cjk-ipa-special = regex("[\u{0250}-\u{02ff}]")
#let cjk-ipa(body, font: auto) = {
  // Preserve the active composite. Physical font repairs belong to its rules.
  if font == auto { text(lang: "en", script: "latn", body) }
  else { text(font: font, lang: "en", script: "latn", body) }
}

#let cjk-font-role-features(role, features: (:)) = {
  if role not in cjk-font-roles {
    panic("cjk font: unknown composite role " + repr(role))
  }
  let output = features
  let code = 0
  for (index, candidate) in cjk-font-roles.enumerate() {
    if candidate == role { code = index + 1 }
  }
  output.insert("jsfr", code)
  output
}

#let cjk-font-role(features) = {
  let code = features.at("jsfr", default: 0)
  if type(code) != int or code < 1 or code > cjk-font-roles.len() {
    none
  } else {
    cjk-font-roles.at(code - 1)
  }
}

#let _cjk-font-category-patterns = (
  western: regex("^[\\p{sc:Latn}\\p{sc:Cyrl}\\p{sc:Grek}ˈˌːˑ][\\p{M}]*$"),
  number: regex("^[0-9]$"),
  hangul: regex("^[\\p{sc:Hangul}]$"),
  han: regex("^[\\p{sc:Han}]$"),
  kana: regex("^[\\p{sc:Hiragana}\\p{sc:Katakana}ー]$"),
  punctuation: regex("^[\\p{Ps}\\p{Pe}<>。、，．！？；：.,?!~:;‘’“”﹁﹂﹃﹄]$"),
)

#let _cjk-font-face-key = "jsarticle-cjk-face"
#let _cjk-fontset-key = "jsarticle-cjk-fontset"

#let _cjk-font-record(value, path) = {
  if type(value) != dictionary { panic("cjk font: " + path + " must be a dictionary") }
}

#let _cjk-font-optics(value, path) = {
  _cjk-font-record(value, path)
  let output = (baseline: auto, tracking: auto, scale: auto)
  for (key, item) in value {
    if key not in output { panic("cjk font: unknown optical property " + path + "." + key) }
    if key == "scale" and item != auto and (type(item) != float and type(item) != int or item <= 0) {
      panic("cjk font: " + path + ".scale must be a positive number or auto")
    }
    output.insert(key, item)
  }
  output
}

// A physical face. `name` is passed directly to Typst when the face wins a
// routing rule; coverage remains exclusively on the rule.
#let cjk-face(name, baseline: auto, tracking: auto, scale: auto, optics: (:)) = {
  if type(name) != str or name == "" { panic("cjk-face: name must be a non-empty string") }
  let common = _cjk-font-optics((baseline: baseline, tracking: tracking, scale: scale), "face")
  _cjk-font-record(optics, "face.optics")
  let categorized = (:)
  for (category, values) in optics {
    if category not in cjk-font-categories {
      panic("cjk-face: unknown optics category " + repr(category))
    }
    categorized.insert(category, _cjk-font-optics(values, "face.optics." + category))
  }
  let face = (name: name, optics: common, category-optics: categorized)
  face.insert(_cjk-font-face-key, true)
  face
}

#let _cjk-is-face(value) = type(value) == dictionary and value.at(_cjk-font-face-key, default: false)

#let _cjk-font-list(value, path) = if type(value) == str { (value,) } else if type(value) == array and value.all(item => type(item) == str) {
  value
} else { panic("cjk font: " + path + " must be a string or array of strings") }

#let _cjk-font-covers(value, path) = {
  if type(value) == str {
    if value not in cjk-font-categories and value != "any" {
      panic("cjk font: " + path + " must be a category, any, or regex")
    }
    return value
  }
  if type(value) != regex { panic("cjk font: " + path + " must be a category, any, or regex") }
  value
}

#let _cjk-font-rule(value, path) = {
  _cjk-font-record(value, path)
  let allowed = ("face", "covers", "lang", "region", "fallbacks", "optics")
  for key in value.keys() {
    if key not in allowed { panic("cjk font: unknown rule field " + path + "." + key) }
  }
  if "face" not in value or not _cjk-is-face(value.face) { panic("cjk font: " + path + ".face must be a cjk-face") }
  if "covers" not in value { panic("cjk font: " + path + " requires covers") }
  let output = (face: value.face, covers: _cjk-font-covers(value.covers, path + ".covers"), lang: auto, region: auto, fallbacks: (), optics: (baseline: auto, tracking: auto, scale: auto))
  // Resolved rules may be fed back through `jsfontset-extend`. Preserve
  // their explicit `auto` sentinel instead of treating it as a malformed
  // language or region list.
  if "lang" in value and value.lang != auto { output.insert("lang", _cjk-font-list(value.lang, path + ".lang").map(lower)) }
  if "region" in value and value.region != auto { output.insert("region", _cjk-font-list(value.region, path + ".region").map(upper)) }
  if "fallbacks" in value and value.fallbacks != auto { output.insert("fallbacks", _cjk-font-list(value.fallbacks, path + ".fallbacks")) }
  if "optics" in value { output.insert("optics", _cjk-font-optics(value.optics, path + ".optics")) }
  output
}

#let cjk-fontset(..rules) = {
  if rules.pos().len() == 0 { panic("cjk-fontset requires at least one rule") }
  let output = ()
  for (index, rule) in rules.pos().enumerate() {
    let resolved = _cjk-font-rule(rule, "fontset.rules." + str(index + 1))
    if index + 1 < rules.pos().len() and resolved.covers == "any" and resolved.lang == auto and resolved.region == auto {
      panic("cjk-fontset: an unconditional any rule must be last")
    }
    output.push(resolved)
  }
  let fontset = (rules: output)
  fontset.insert(_cjk-fontset-key, true)
  fontset
}

#let _cjk-is-fontset(value) = type(value) == dictionary and value.at(_cjk-fontset-key, default: false)

#let cjk-fontset-rules(fontset) = {
  if not _cjk-is-fontset(fontset) { panic("cjk font: expected cjk-fontset") }
  fontset.rules
}

#let _cjk-font-western-space = regex("^[ \t]$")

// In a Western-language run, ordinary spaces must remain with neighbouring
// Western text instead of falling through to a CJK catch-all face.
#let cjk-font-category(grapheme, language: none) = {
  let western-locale = language != none and not (
    lower(language) in ("ko", "ja", "zh", "sc", "tc")
  )
  if western-locale and grapheme.match(_cjk-font-western-space) != none { return "western" }
  for category in ("hangul", "han", "kana", "western", "number", "punctuation") {
    if grapheme.match(_cjk-font-category-patterns.at(category)) != none { return category }
  }
  "symbol"
}

#let cjk-font-locale-key(language, region: none) = if lower(language) == "ko" {
  "ko"
} else if lower(language) == "ja" {
  "ja"
} else if lower(language) == "tc" {
  "tc"
} else if lower(language) == "sc" {
  "sc"
} else if lower(language) == "zh" and region != none and ("TW", "HK", "MO").contains(upper(region)) {
  "tc"
} else if lower(language) == "zh" {
  "sc"
} else { "western" }

#let _cjk-font-rule-matches(rule, grapheme, language, region) = {
  let coverage = rule.covers
  let covered = if coverage == "any" { true } else if type(coverage) == str {
    cjk-font-category(grapheme, language: language) == coverage
  } else { grapheme.match(coverage) != none }
  let locale = cjk-font-locale-key(language, region: region)
  let language-matches = rule.lang == auto or rule.lang.contains(lower(language)) or rule.lang.contains(locale)
  let region-matches = rule.region == auto or (region != none and rule.region.contains(upper(region)))
  covered and language-matches and region-matches
}

#let _cjk-font-global(global, language, category, region: none) = {
  if type(global) != dictionary { return (baseline: auto, tracking: auto, scale: auto) }
  let language-values = global.at(cjk-font-locale-key(language, region: region), default: global.at(lower(language), default: (:)))
  if type(language-values) != dictionary { return (baseline: auto, tracking: auto, scale: auto) }
  _cjk-font-optics(language-values.at(category, default: (:)), "global optics")
}

#let _cjk-font-effective(rule, category, global, language, region: none) = {
  let face = rule.face
  let category-values = face.category-optics.at(category, default: (baseline: auto, tracking: auto, scale: auto))
  let fallback = _cjk-font-global(global, language, category, region: region)
  let output = (:)
  for (property, neutral) in (("baseline", 0em), ("tracking", 0em), ("scale", 1.0)) {
    let value = rule.optics.at(property)
    if value == auto { value = category-values.at(property) }
    if value == auto { value = face.optics.at(property) }
    if value == auto { value = fallback.at(property) }
    output.insert(property, if value == auto { neutral } else { value })
  }
  output
}

// Resolve one composite only. The public resolver below tries the active
// composite once, then the optional common composite once; it never walks
// language-specific fallback tables.
#let _cjk-resolve-fontset(fontset, grapheme, language, region, global-optics, source) = {
  for (index, rule) in cjk-fontset-rules(fontset).enumerate() {
    if _cjk-font-rule-matches(rule, grapheme, language, region) {
      let category = cjk-font-category(grapheme, language: language)
      return (
        face: rule.face,
        selector: rule.face.name,
        fallbacks: rule.fallbacks,
        category: category,
        rule-index: index,
        source: source,
        .._cjk-font-effective(rule, category, global-optics, language, region: region),
      )
    }
  }
  none
}

// The single routing operation used by composition and test traces.
#let cjk-resolve-font(
  fontset,
  grapheme,
  language: "ko",
  region: none,
  common: none,
  global-optics: (:),
) = {
  let active = _cjk-resolve-fontset(
    fontset,
    grapheme,
    language,
    region,
    global-optics,
    "active",
  )
  if active != none or common == none { return active }
  _cjk-resolve-fontset(common, grapheme, language, region, global-optics, "common")
}

// A native selector list is used only as an ambient scope signature and native
// fallback. With a locale, explicit matching rules lead the generic rules so
// Typst-owned inline elements inherit the same primary face as text routing.
#let _cjk-font-rule-locale-matches(rule, language, region) = {
  if language == none { return true }
  let locale = cjk-font-locale-key(language, region: region)
  let language-matches = rule.lang == auto or rule.lang.contains(lower(language)) or rule.lang.contains(locale)
  let region-matches = rule.region == auto or (region != none and rule.region.contains(upper(region)))
  language-matches and region-matches
}

#let cjk-fontset-native(fontset, common: none, language: none, region: none) = {
  let output = ()
  let rules = cjk-fontset-rules(fontset)
  let ordered-rules = if language == none {
    rules
  } else {
    // Locale-specific rules decide the primary face. Generic rules retain
    // their declaration order as the ordinary fallback layer.
    let selected = ()
    for specific in (true, false) {
      for rule in rules {
        let conditioned = rule.lang != auto or rule.region != auto
        if conditioned == specific and _cjk-font-rule-locale-matches(rule, language, region) {
          selected.push(rule)
        }
      }
    }
    selected
  }
  for rule in ordered-rules {
    if not output.contains(rule.face.name) { output.push(rule.face.name) }
    for fallback in rule.fallbacks { if not output.contains(fallback) { output.push(fallback) } }
  }
  if common != none {
    let common-rules = cjk-fontset-rules(common)
    let ordered-common = if language == none {
      common-rules
    } else {
      let selected = ()
      for specific in (true, false) {
        for rule in common-rules {
          let conditioned = rule.lang != auto or rule.region != auto
          if conditioned == specific and _cjk-font-rule-locale-matches(rule, language, region) {
            selected.push(rule)
          }
        }
      }
      selected
    }
    for rule in ordered-common {
      if not output.contains(rule.face.name) { output.push(rule.face.name) }
    }
  }
  output
}

// Generic composite extension. The caller supplies faces; CJK supplies the
// native fallback chain so an override cannot discard its base composite.
#let cjk-fontset-extend(base, ..rules) = {
  let fallback = cjk-fontset-native(base)
  let overrides = ()
  for candidate in rules.pos() {
    if type(candidate) == dictionary and "fallbacks" not in candidate {
      candidate.insert("fallbacks", fallback)
    }
    overrides.push(candidate)
  }
  cjk-fontset(..overrides, ..cjk-fontset-rules(base))
}

// Face-only multilingual override. It contains no physical font choices and
// is usable by any template that supplies its own faces and base composite.
#let cjk-fontset-override(
  base,
  western: auto, number: auto, hangul: auto, kana: auto,
  han-ko: auto, han-ja: auto, han-sc: auto, han-tc: auto,
  punct-western: auto, punct-ko: auto, punct-ja: auto, punct-sc: auto, punct-tc: auto,
) = {
  let rules = ()
  if western != auto { rules.push((face: western, covers: "western")) }
  if number != auto { rules.push((face: number, covers: "number")) }
  if hangul != auto { rules.push((face: hangul, covers: "hangul")) }
  if kana != auto { rules.push((face: kana, covers: "kana")) }
  if han-ko != auto { rules.push((face: han-ko, covers: "han", lang: "ko")) }
  if han-ja != auto { rules.push((face: han-ja, covers: "han", lang: "ja")) }
  if han-tc != auto { rules.push((face: han-tc, covers: "han", lang: "zh", region: ("TW", "HK", "MO"))) }
  if han-sc != auto { rules.push((face: han-sc, covers: "han", lang: ("zh", "sc"))) }
  if punct-western != auto { rules.push((face: punct-western, covers: "punctuation", lang: "western")) }
  if punct-ko != auto { rules.push((face: punct-ko, covers: "punctuation", lang: "ko")) }
  if punct-ja != auto { rules.push((face: punct-ja, covers: "punctuation", lang: "ja")) }
  if punct-tc != auto { rules.push((face: punct-tc, covers: "punctuation", lang: "zh", region: ("TW", "HK", "MO"))) }
  if punct-sc != auto { rules.push((face: punct-sc, covers: "punctuation", lang: ("zh", "sc"))) }
  cjk-fontset-extend(base, ..rules)
}

#let cjk-fontset-trace(fontset, source, language: "ko", region: none, common: none, global-optics: (:)) = source.clusters().map(cluster => (
  cluster: cluster,
  resolved: cjk-resolve-font(fontset, cluster, language: language, region: region, common: common, global-optics: global-optics),
))

// Resolve a source string once and retain adjacent graphemes only when the
// selected physical face and effective optics are identical. Composition owns
// spacing and paragraph policy; this helper is deliberately pure so it can be
// used inside an existing compositor without adding a document-wide show rule.
#let cjk-fontset-runs(fontset, source, language: "ko", region: none, common: none, global-optics: (:)) = {
  let output = ()
  let active = none
  let clusters = ()
  for cluster in source.clusters() {
    let resolved = cjk-resolve-font(
      fontset,
      cluster,
      language: language,
      region: region,
      common: common,
      global-optics: global-optics,
    )
    if resolved == none {
      if active != none and clusters.len() > 0 {
        output.push((text: clusters.join(""), ..active))
      }
      active = none
      clusters = ()
      output.push((text: cluster, resolved: none))
    } else if active == none or (
      active.selector != resolved.selector
        or active.fallbacks != resolved.fallbacks
        or active.baseline != resolved.baseline
        or active.tracking != resolved.tracking
        or active.scale != resolved.scale
        or active.category != resolved.category
    ) {
      if active != none and clusters.len() > 0 {
        output.push((text: clusters.join(""), ..active))
      }
      active = resolved
      clusters = (cluster,)
    } else {
      clusters.push(cluster)
    }
  }
  if active != none and clusters.len() > 0 {
    output.push((text: clusters.join(""), ..active))
  }
  output
}

// Render already-classified source through one composite. Callers provide the
// surrounding text styles; the resolver replaces only font and face optics.
// This is intentionally an ordinary content function, not a show rule.
#let cjk-fontset-render(
  fontset,
  source,
  language: "ko",
  region: none,
  common: none,
  global-optics: (:),
  styles: (:),
) = {
  _cjk-font-record(styles, "fontset render styles")
  let output = ()
  for run in cjk-fontset-runs(
    fontset,
    source,
    language: language,
    region: region,
    common: common,
    global-optics: global-optics,
  ) {
    let args = styles
    if run.at("resolved", default: run) == none {
      output.push(text(run.text, ..args))
    } else {
      if "font" in args { let _ = args.remove("font") }
      let common-fallbacks = if common == none { () } else { cjk-fontset-native(common) }
      args.insert("font", (run.selector,) + run.fallbacks + common-fallbacks)
      args.insert("size", args.at("size", default: 1em) * run.scale)
      args.insert("baseline", args.at("baseline", default: 0em) + run.baseline)
      args.insert("tracking", args.at("tracking", default: 0em) + run.tracking)
      output.push(text(run.text, ..args))
    }
  }
  output.sum(default: [])
}

// Generated inline elements (smart quotes today) are not text nodes, so the
// grapheme compositor cannot see them. Resolve their category through the
// same composite path and let Typst retain control of their semantics.
#let _cjk-font-category-probes = (
  punctuation: "“",
  symbol: "§",
)

#let cjk-fontset-render-inline-element(
  fontset,
  body,
  category: "punctuation",
  language: "ko",
  region: none,
  common: none,
  global-optics: (:),
  styles: (:),
) = {
  _cjk-font-record(styles, "fontset inline element styles")
  if category not in _cjk-font-category-probes {
    panic("cjk font: unsupported inline element category " + repr(category))
  }
  let resolved = cjk-resolve-font(
    fontset,
    _cjk-font-category-probes.at(category),
    language: language,
    region: region,
    common: common,
    global-optics: global-optics,
  )
  if resolved == none { return body }
  let args = styles
  if "font" in args { let _ = args.remove("font") }
  let locale-fallbacks = cjk-fontset-native(
    fontset,
    common: common,
    language: language,
    region: region,
  ).filter(name => name != resolved.selector)
  args.insert("font", (resolved.selector,) + resolved.fallbacks + locale-fallbacks)
  args.insert("size", args.at("size", default: 1em) * resolved.scale)
  args.insert("baseline", args.at("baseline", default: 0em) + resolved.baseline)
  args.insert("tracking", args.at("tracking", default: 0em) + resolved.tracking)
  text(..args)[#body]
}

#let _cjk-font-selector-entry-matches(expected, actual) = {
  if type(expected) == str and type(actual) == str { return lower(expected) == lower(actual) }
  if type(expected) != dictionary or type(actual) != dictionary { return false }
  if "name" not in expected or "name" not in actual { return false }
  lower(expected.name) == lower(actual.name) and expected.at("covers", default: none) == actual.at("covers", default: none)
}

#let _cjk-font-selector-matches(expected, actual) = {
  let left = if type(expected) == array { expected } else { (expected,) }
  let right = if type(actual) == array { actual } else { (actual,) }
  left.len() == right.len() and left.zip(right).all(pair => _cjk-font-selector-entry-matches(pair.at(0), pair.at(1)))
}

#let cjk-fontset-native-matches(fontset, actual, common: none) = {
  _cjk-font-selector-matches(cjk-fontset-native(fontset, common: common), actual)
}

// Applies a fontset without consulting role tables. The scope's native list is
// only an override boundary; emitted runs use the selected physical face.
#let cjk-fontset-apply(fontset, common: none, global-optics: (:), signature: auto, body) = {
  let signature = if signature == auto { cjk-fontset-native(fontset, common: common) } else { signature }
  set text(font: signature)
  show smartquote: it => context {
    let features = text.features
    if features.at("jscq", default: 0) == 1 or not _cjk-font-selector-matches(signature, text.font) {
      it
    } else {
      let emitted = features
      emitted.insert("jscf", 1)
      emitted.insert("jscq", 1)
      cjk-fontset-render-inline-element(
        fontset,
        it,
        category: "punctuation",
        language: text.lang,
        region: text.region,
        common: common,
        global-optics: global-optics,
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
  show text: it => context {
    let features = text.features
    if features.at("jscf", default: 0) == 1 or not _cjk-font-selector-matches(signature, text.font) {
      it
    } else {
      let language = text.lang
      let region = text.region
      let emitted = features
      emitted.insert("jscf", 1)
      cjk-fontset-render(
        fontset,
        it.text,
        language: language,
        region: region,
        common: common,
        global-optics: global-optics,
        styles: (
          size: text.size,
          baseline: text.baseline,
          tracking: text.tracking,
          features: emitted,
        ),
      )
    }
  }
  body
}
