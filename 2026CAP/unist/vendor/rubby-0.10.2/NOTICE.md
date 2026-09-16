# Rubby 0.10.2

This directory vendors the renderer from `@preview/rubby:0.10.2`. The only
local change is the short provenance header at the top of `rubby.typ`.

- Copyright (C) 2023 Andrew Voynov.
- License: AGPL-3.0-only.
- Upstream source: `https://typst.app/universe/package/rubby/0.10.2/`.

`jsarticle.typ` supplies the context-sensitive `#rb` facade. The vendored
renderer remains horizontal-only and must not gain jsarticle or Basho imports.
