// lib.typ
// Public API for Basho — Vertical Japanese Typesetting

#import "src/main.typ": basho-config, char, hblock, prepare-tate, prepare-tate-streams, ruby, tate, tate-inline, tate-inline-height, tate-inline-prepared, tate-prepared, tate-region, tate-region-from-plan, tate-region-natural-height, tate-region-plan-prepared, tate-region-prepared, tate-region-rows-prepared, tate-region-width, tate-regions, tate-regions-intrinsic-prepared, tate-regions-natural-height, tate-regions-natural-width, tate-regions-prepared, tcy, turn, vblock, vert
#import "src/kinsoku/kinsoku.typ": default-resolver
#import "src/config.typ": default-categories, default-opts, default-rendering-params, merge-config
#import "src/kinsoku/spacing.typ": default-spacing
#import "src/components/turn.typ": default-turn
#import "src/components/vblock.typ": default-vblock
#import "src/components/hblock.typ": default-hblock

/// Standalone helpers are exported for building custom resolvers
#let kinsoku = {
  import "src/kinsoku/kinsoku.typ": *
  (
    "if-forbidden-start": is-forbidden-start,
    "is-forbidden-end": is-forbidden-end,
    "is-hanging": is-hanging,
    "is-unbreakable-pair": is-unbreakable-pair,
    "is-compressible-punctuation": is-compressible-punctuation,
    "calculate-shrinkable-space": calculate-shrinkable-space,
    "apply-spacing-compression": apply-spacing-compression,
    "get-compressible-amount": get-compressible-amount,
    "count-justification-points": count-justification-points,
    "justify-line": justify-line,
    "is-valid-line-end": is-valid-line-end,
    "default-resolver": default-resolver,
  )
}

/// Token utilities are exported for building custom transforms and classifiers
#let token-schema = {
  import "src/pipeline/token.typ": *
  ("token": token, "merge-token": merge-token, "is-token-type": is-token-type)
}
