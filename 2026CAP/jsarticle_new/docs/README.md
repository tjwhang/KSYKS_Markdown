# jsarticle documentation

This directory documents V2 as both a document framework and a vertical CJK
composition system.

| Guide | Use it for |
| --- | --- |
| [V2 overview](jsarticle-v2.md) | A concise starting point, the grouped configuration model, and the primary vertical-writing contract. |
| [Framework guide](framework.md) | Building a document: title matter, pages, columns, language-aware horizontal type, fonts, components, notes, math, and vertical examples. |
| [Vertical writing](vertical-writing.md) | The `jsvert` flow contract, page-surface grouping, CJK preparation, Basho breaking, ruby, TCY, continuation, and safe tuning. |
| [API reference](api-reference.md) | Every supported jsarticle, CJK, and Basho entry point, argument, result, and intended scope. |
| [Internal architecture](internals.md) | How the book pass, CJK layer, and Basho pipeline cooperate; continuation and performance invariants. |
| [V2 migration](migration-v2.md) | The breaking flat-option to grouped-option mapping. |

## Which layer should I use?

Use `jsarticle-book` and `jsvert` for an ordinary document. They are the
stable document-facing API.

Use `cjk-profile` and direct CJK vertical functions only when writing a
reusable local component that needs vertical text but not document page flow.

Use Basho directly only when building another template or a specialized
vertical renderer. Basho deliberately has no knowledge of jsarticle pages,
headers, title matter, or horizontal columns.

```text
document author:       jsarticle-book -> jsvert
component author:      cjk-profile -> cjk-vertical-* 
template/engine author: basho-config -> prepare-tate -> tate-*-prepared
```

## Source and test map

| Area | Main source | Regression coverage |
| --- | --- | --- |
| Public book, components, and default composites | `jsarticle.typ` | `tests/default-composite-book.typ`, `tests/document-fontsets.typ` |
| CJK language adaptation and composite routing | `cjk.typ`, `src/cjk/fonts.typ` | `tests/composite-font-routing.typ`, `tests/composite-dispatcher.typ` |
| Theorion/Antique bridge | `src/integrations/theorion.typ` | full-document Theorion specimens |
| Vertical engine | `vendor/basho-0.1.1/` | `tests/mixed-vertical-continuation*.typ`, `tests/v2-invalid-basho.typ` |
| V2 option validation | `src/jsarticle/options.typ` | `tests/v2-invalid-options.typ` |

Compile a fixture from the repository root with:

```text
typst compile --root . tests/name.typ output.pdf
```

For a typography or pagination change, compile is necessary but not enough:
render representative PDF pages and inspect margins, page boundaries, stream
order, and missing/duplicated text.

See the [refactor and migration guide](refactor.md) for the current module map, aliases and consumer synchronization.
