/// Validate a Basho configuration dictionary.
/// Panics with a descriptive message when required fields are missing or have invalid types.
///
/// - config (dictionary): The merged configuration to validate.
/// -> none
#let validate-config(config) = {
  assert(
    config.at("heading-mode", default: "semantic") in ("semantic", "visual"),
    message: "basho: heading-mode must be \"semantic\" or \"visual\"",
  )
  assert(
    type(config) == dictionary,
    message: "basho: config must be a dictionary",
  )

  assert(
    config.font == none or type(config.font) in (str, array),
    message: "basho: config.font must be a font name, font stack array, or none",
  )
  assert(
    config.at("punctuation-font") == none
      or type(config.at("punctuation-font")) in (str, array),
    message: "basho: config.punctuation-font must be a font name, font stack array, or none",
  )
  assert(
    config.at("heading-font") == none
      or type(config.at("heading-font")) in (str, array),
    message: "basho: config.heading-font must be a font name, font stack array, or none",
  )
  assert(
    config.language in ("ja", "ko", "zh"),
    message: "basho: config.language must be \"ja\", \"ko\", or \"zh\"",
  )
  assert(
    config.region == none or type(config.region) == str,
    message: "basho: config.region must be a region string or none",
  )
  assert(
    type(config.at("space-width")) == length,
    message: "basho: config.space-width must resolve to a length",
  )
  assert(
    type(config.at("cjk-western-gap")) == length
      and type(config.at("western-cjk-gap")) == length,
    message: "basho: CJK/Western boundary gaps must be lengths",
  )
  assert(
    type(config.at("unicode-vertical-fallbacks")) == bool,
    message: "basho: config.unicode-vertical-fallbacks must be true or false",
  )
  assert(
    type(config.at("collapse-space-after-punctuation")) == bool,
    message: "basho: config.collapse-space-after-punctuation must resolve to true or false",
  )
  assert(
    type(config.at("korean-fullwidth-cjk-spaces")) == bool,
    message: "basho: config.korean-fullwidth-cjk-spaces must be true or false",
  )
  assert(
    type(config.at("inline-atom-particles")) == dictionary,
    message: "basho: config.inline-atom-particles must be a language dictionary",
  )
  for (language, particles) in config.at("inline-atom-particles") {
    assert(
      language in ("ko", "ja") and type(particles) == array
        and particles.all(particle => type(particle) == str),
      message: "basho: config.inline-atom-particles must map ko/ja to arrays of strings",
    )
  }
  assert(
    type(config.at("page-start")) == bool,
    message: "basho: config.page-start must be true or false",
  )
  assert(
    config.at("latin-orientation") in ("rotate", "upright"),
    message: "basho: config.latin-orientation must be \"rotate\" or \"upright\"",
  )
  assert(
    type(config.at("tcy-max-digits")) == int and config.at("tcy-max-digits") >= 0,
    message: "basho: config.tcy-max-digits must be a non-negative integer",
  )
  assert(
    type(config.features) == array,
    message: "basho: config.features must be an array (e.g. (\"vert\", \"vrt2\"))",
  )

  if type(config.rendering) == array {
    for module in config.rendering {
      if "transform" in module {
        assert(
          type(module.transform) == function,
          message: "basho: each config.rendering entry with 'transform' must have a function value, got "
            + repr(type(module.transform)),
        )
      }
      if "node-renderers" in module {
        assert(
          type(module.node-renderers) == dictionary,
          message: "basho: each config.rendering entry with 'node-renderers' must have a dictionary value",
        )
      }
    }
  } else {
    assert(
      false,
      message: "basho: config.rendering must be an array of rendering modules",
    )
  }

  if type(config.tcy) == array {
    assert(
      config.tcy.len() > 0,
      message: "basho: config.tcy must contain at least one TCY module",
    )
    for tcy-mod in config.tcy {
      assert(
        "filter" in tcy-mod,
        message: "basho: each config.tcy entry must have a 'filter' function",
      )
      assert(
        type(tcy-mod.filter) == function,
        message: "basho: each config.tcy.filter must be a function",
      )
      assert(
        "pattern" in tcy-mod,
        message: "basho: each config.tcy entry must have a 'pattern' field (regex)",
      )
      assert(
        "sizes" in tcy-mod,
        message: "basho: each config.tcy entry must have a 'sizes' field (array of lengths)",
      )
    }
  } else {
    assert(false, message: "basho: config.tcy must be an array of TCY modules")
  }

  if type(config.kinsoku) == dictionary {
    assert(
      "resolve" in config.kinsoku,
      message: "basho: config.kinsoku must have a 'resolve' function",
    )
    assert(
      type(config.kinsoku.resolve) == function,
      message: "basho: config.kinsoku.resolve must be a function",
    )
  } else {
    assert(
      false,
      message: "basho: config.kinsoku must be a dictionary with resolver settings",
    )
  }

  if type(config.list) == dictionary {
    if "bullet" in config.list {
      assert(
        type(config.list.bullet) == dictionary,
        message: "basho: config.list.bullet must be a dictionary",
      )
      assert(
        "flatten" in config.list.bullet,
        message: "basho: config.list.bullet must have a 'flatten' function",
      )
      assert(
        type(config.list.bullet.flatten) == function,
        message: "basho: config.list.bullet.flatten must be a function",
      )
    }
    if "numbered" in config.list {
      assert(
        type(config.list.numbered) == dictionary,
        message: "basho: config.list.numbered must be a dictionary",
      )
      assert(
        "flatten" in config.list.numbered,
        message: "basho: config.list.numbered must have a 'flatten' function",
      )
      assert(
        type(config.list.numbered.flatten) == function,
        message: "basho: config.list.numbered.flatten must be a function",
      )
    }
  } else {
    assert(
      false,
      message: "basho: config.list must be a dictionary with 'bullet' and 'numbered' keys",
    )
  }

  if type(config.layout) == dictionary {
    assert(
      config.layout.at("width") == auto or (
        type(config.layout.at("width")) in (length, ratio)
      ),
      message: "basho: config.layout.width must be auto, a length, or a ratio",
    )
    assert(
      config.layout.at("height") == auto or (
        type(config.layout.at("height")) in (length, ratio)
      ),
      message: "basho: config.layout.height must be auto, a length, or a ratio",
    )
    assert(
      type(config.layout.columns) == int,
      message: "basho: config.layout.columns must be an integer >= 1",
    )
    assert(
      config.layout.columns >= 1,
      message: "basho: config.layout.columns must be >= 1",
    )
    assert(
      config.layout.rows == auto or (
        type(config.layout.rows) == int and config.layout.rows >= 1
      ),
      message: "basho: config.layout.rows must be auto or an integer >= 1",
    )
    assert(
      config.layout.at("columns-per-row") == auto or (
        type(config.layout.at("columns-per-row")) == int
          and config.layout.at("columns-per-row") >= 1
      ),
      message: "basho: config.layout.columns-per-row must be auto or an integer >= 1",
    )
    assert(
      type(config.layout.gap) == length,
      message: "basho: config.layout.gap must be a length (e.g. 1em)",
    )
    assert(
      type(config.layout.column-gap) == length,
      message: "basho: config.layout.column-gap must be a length (e.g. 2em)",
    )
    assert(
      type(config.layout.row-gap) == length,
      message: "basho: config.layout.row-gap must be a length (e.g. 2em)",
    )
    assert(
      type(config.layout.row-fit-threshold) in (int, float)
        and config.layout.row-fit-threshold >= 1
        and config.layout.row-fit-threshold <= 2,
      message: "basho: config.layout.row-fit-threshold must be between 1 and 2",
    )
    assert(
      type(config.layout.at("min-final-line-chars")) == int
        and config.layout.at("min-final-line-chars") >= 1,
      message: "basho: config.layout.min-final-line-chars must be an integer >= 1",
    )
    assert(
      type(config.layout.at("min-fragment-chars")) == int
        and config.layout.at("min-fragment-chars") >= 1,
      message: "basho: config.layout.min-fragment-chars must be an integer >= 1",
    )
    assert(
      type(config.layout.at("justify")) == bool,
      message: "basho: config.layout.justify must be true or false",
    )
    assert(
      config.layout.at("ruby-overflow", default: "reserve") in ("reserve", "overhang"),
      message: "basho: config.layout.ruby-overflow must be \"reserve\" or \"overhang\"",
    )
    assert(
      type(config.layout.at("ruby-overhang", default: 0.5em)) == length
        and config.layout.at("ruby-overhang", default: 0.5em) >= 0pt,
      message: "basho: config.layout.ruby-overhang must be a non-negative length",
    )
    assert(
      type(config.layout.at("orphan-lines")) == int
        and config.layout.at("orphan-lines") >= 1,
      message: "basho: config.layout.orphan-lines must be an integer >= 1",
    )
    assert(
      type(config.layout.at("widow-lines")) == int
        and config.layout.at("widow-lines") >= 1,
      message: "basho: config.layout.widow-lines must be an integer >= 1",
    )
    assert(
      type(config.layout.at("line-overhang-threshold")) == length
        and config.layout.at("line-overhang-threshold") >= 0pt,
      message: "basho: config.layout.line-overhang-threshold must be a non-negative length",
    )
    assert(
      type(config.layout.paragraph-indent) == length,
      message: "basho: config.layout.paragraph-indent must be a length",
    )
    assert(
      type(config.layout.paragraph-spacing) == length,
      message: "basho: config.layout.paragraph-spacing must be a length",
    )
    assert(
      type(config.layout.hooks) == array,
      message: "basho: config.layout.hooks must be an array of functions",
    )
  } else {
    assert(
      false,
      message: "basho: config.layout must be a dictionary with layout parameters",
    )
  }

  if type(config.sizing) == dictionary {
    assert(
      type(config.sizing.char-box) == length,
      message: "basho: config.sizing.char-box must be a length (e.g. 1em)",
    )
    assert(
      type(config.sizing.tracking) == length,
      message: "basho: config.sizing.tracking must be a length",
    )
  }

  if "categories" in config and type(config.categories) == dictionary {
    if "classify" in config.categories {
      assert(
        type(config.categories.classify) == function,
        message: "basho: config.categories.classify must be a function returning \"horizontal\", \"rotated\", or \"char\"",
      )
    }
  }
}
