// Compact public CJK profile records for direct vertical rendering.

#import "../../vendor/basho-0.1.1/lib.typ" as basho

#let cjk-profile(locale: (:), fonts: (:), vertical: (:)) = {
  let resolved-locale = (language: auto, region: auto)
  let resolved-fonts = (body: none, punctuation: none, strong: none, heading: none)
  if type(locale) != dictionary or type(fonts) != dictionary or type(vertical) != dictionary {
    panic("cjk-profile: locale, fonts, and vertical must be dictionaries")
  }
  for (key, value) in locale {
    if key not in resolved-locale { panic("cjk-profile: unknown locale." + key) }
    resolved-locale.insert(key, value)
  }
  for (key, value) in fonts {
    if key not in resolved-fonts { panic("cjk-profile: unknown fonts." + key) }
    resolved-fonts.insert(key, value)
  }
  (locale: resolved-locale, fonts: resolved-fonts, vertical: vertical)
}

#let _cjk-resolve-profile(profile, surrounding-language, surrounding-region) = {
  if type(profile) != dictionary or not (
    "locale" in profile and "fonts" in profile and "vertical" in profile
  ) {
    panic("cjk vertical: profile must be created by cjk-profile")
  }
  let candidate = profile.locale.language
  let language = if candidate == auto {
    if surrounding-language in ("ja", "ko", "zh") { surrounding-language } else { "ja" }
  } else { candidate }
  let region = if profile.locale.region == auto { surrounding-region } else { profile.locale.region }
  let config = profile.vertical
  config.insert("language", language)
  config.insert("region", region)
  for (profile-key, config-key) in (
    body: "font", punctuation: "punctuation-font", strong: "strong-font", heading: "heading-font",
  ) {
    let value = profile.fonts.at(profile-key)
    if value != none { config.insert(config-key, value) }
  }
  basho.basho-config(config)
}

#let cjk-vertical(body, profile: cjk-profile(), part: "all", initial-height: auto) = context {
  let config = _cjk-resolve-profile(profile, text.lang, text.region)
  basho.tate-prepared(
    basho.prepare-tate(body, config: config),
    part: part,
    initial-height: initial-height,
  )
}

#let cjk-vertical-inline(body, profile: cjk-profile()) = context {
  let config = _cjk-resolve-profile(profile, text.lang, text.region)
  basho.tate-inline-prepared(basho.prepare-tate(body, config: config))
}

#let cjk-vertical-region(body, height, profile: cjk-profile()) = context {
  let config = _cjk-resolve-profile(profile, text.lang, text.region)
  basho.tate-region-prepared(
    basho.prepare-tate(body, config: config),
    height,
  )
}
