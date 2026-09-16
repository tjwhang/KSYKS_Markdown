# jsarticle documentation

This root-level file is a compatibility entry point. The maintained
documentation lives in [`docs/`](docs/README.md).

Start with the [framework guide](docs/framework.md) for document authoring,
the [vertical-writing guide](docs/vertical-writing.md) for `jsvert`, the [API
reference](docs/api-reference.md) for public signatures, and the [internal
architecture](docs/internals.md) for the composition pipeline.

## Current font model

Fonts use one direct path:

```text
document role -> ordered composite rules -> physical face -> effective optics
```

`jsface` describes a physical family and its optical values. `jsfontset`
provides ordered coverage and locale rules. `fonts.composites` replaces only
the roles a document names; `js-default-composites` remains the fallback base.
Document-specific faces belong in `fonts.typ`, while CJK owns the reusable
language/region and punctuation-routing helpers.

The retired script-stack options (`font-western`, `font-hangul`, and related
tables), language-profile builders, and `cjk-role-adjustments` are not part of
the current API. See [the migration guide](docs/migration-v2.md) for the
replacement pattern.

## Vertical writing

`jsvert` is the sole vertical-writing wrapper. Use `flow: "inline"` or
`flow: "region"` for local containers and top-level `auto`/`"page"` flow for
page surfaces. The maintained guide is
[docs/vertical-writing.md](docs/vertical-writing.md).

See the [refactor and migration guide](docs/refactor.md) for the current module map, aliases and consumer synchronization.
