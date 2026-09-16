// Canonical option-record utilities shared by the jsarticle V2 facade.
//
// Records are deliberately plain Typst dictionaries: they are easy to inspect,
// compose with `(..record)`, and do not require contextual state to validate.

#let _option-path(prefix, key) = prefix + "." + key

#let _assert-record(value, path) = {
  if type(value) != dictionary {
    panic("jsarticle: " + path + " must be a dictionary")
  }
}

// Recursively merge only declared keys. This is intentionally stricter than a
// generic dictionary merge: misspelled settings must fail at the public edge,
// not alter a later page-layout pass unpredictably.
#let resolve-options(defaults, overrides, path: "options", opaque: ()) = {
  _assert-record(defaults, path + " defaults")
  _assert-record(overrides, path)
  let result = defaults
  for (key, value) in overrides {
    if key not in defaults {
      panic("jsarticle: unknown option " + _option-path(path, key))
    }
    let base = defaults.at(key)
    if type(base) == dictionary and _option-path(path, key) not in opaque {
      _assert-record(value, _option-path(path, key))
      result.insert(key, resolve-options(
        base, value, path: _option-path(path, key), opaque: opaque,
      ))
    } else {
      result.insert(key, value)
    }
  }
  result
}

// Flattens a resolved book record for the private renderer. The mapping stays
// at one boundary while the public API remains grouped and stable.
#let flatten-book-options(options) = {
  let flat = (:)
  for (group-name, group) in options {
    if group-name == "vertical" {
      flat.insert("vertical", group)
      continue
    }
    for (key, value) in group {
      let projected = if group-name == "fonts" {
        if key == "composites" { "font-composites" } else { key }
      } else if group-name == "horizontal" and key == "normalization" {
        "horizontal-normalization"
      } else if group-name == "page" and key in ("margin", "header", "footer") {
        "page-" + key
      } else { key }
      flat.insert(projected, value)
    }
  }
  flat
}

#let resolve-option-record = resolve-options
#let project-book-options = flatten-book-options
