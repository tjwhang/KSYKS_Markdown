# Refactor verification - 2026-09-05

All comparisons used Typst 0.15.1, the same system fonts, and a fixed PDF
creation timestamp. Document dates were evaluated on the same day.

## Preservation

- Source specimen: 26 pages; final PDF byte-for-byte identical to baseline.
- Mathematics document: 13 pages; final PDF byte-for-byte identical to baseline.
- All 20 initially passing engine fixtures: final PDFs byte-for-byte identical
  to baseline. This includes CJK component spacing, font routing, ruby,
  vertical prose policies and two-/three-column continuation.
- Two invalid-option fixtures retain their expected diagnostics.
- The previously broken `face-theme-regression` fixture was migrated from the
  removed face/theme API to current composite rules, with assertions for face
  coverage and baseline precedence. No removed runtime feature was restored.
- The added public-alias fixture passes. The suite now contains 24 fixtures:
  22 successful builds and two expected failures.
- Source vendor files and all three document font files were left unchanged.
- Both consumer engine trees match the explicit manifest and source hashes.

## Portfolio behavior

The final portfolio remains seven pages. Every page was rendered and reviewed,
with a larger profile-page inspection for text and margin clearance.

The engine migration changes vertical glyph selection because the consumer
had an older vendor renderer. That difference affects the cover, margin markers
and vertical evidence. It is the authoritative source's existing token-font
fix, not a new vendor modification.

Compared with the migrated engine alone, portfolio cleanup changes only pages
3 and 7: empty metadata separators are removed, and the typography part strap
now appears above its first implemented project. Current prose, font optics,
0.12 em CJK spacing, figures and manual figure IDs are preserved.

Targeted navigation fixtures pass with and without an inserted page. Checks
include actual PDF link targets, profile page 1, incrementing overflow folios,
continuation headers, a TOC-only first project, the visible part strap, missing
destination em dashes, and a manual page override fixed at 99.

The old/new API compatibility fixture produces identical PDFs. It also asserts
new-key precedence and omission of absent metadata. An accidental `page` module
export was removed from the portfolio facade to avoid shadowing Typst's builtin.

## Timings

Five-run wall-clock medians, in seconds:

| Document | Before | Final |
| --- | ---: | ---: |
| Source specimen | 6.554 | 6.572 |
| Portfolio | 2.201 | 2.374 |
| Mathematics | 3.002 | 3.092 |

These results do not demonstrate a compilation speedup. The source specimen is
effectively unchanged; the portfolio measurement also includes the migrated
font-selection fix and corrected part heading. Structural cleanup was retained
for readability and maintenance, not presented as a performance improvement.

A separate portfolio timing trace found approximately 969 ms in system-font
discovery, 758 ms exclusive in preparation, and 540 ms exclusive in document
layout. The inline-spacing visitor was the largest named source-level call
group (166 ms exclusive). Timed builds include profiling overhead and these
figures must not be added to unprofiled benchmark medians.

Existing single-pass traversal and font memoization were preserved. No
speculative global caches, font exclusions or altered show-rule order were
introduced. Repeated portfolio-wide metadata filtering was replaced with a
dedicated selector; no independent speedup claim is made for that small change.

## Repeating the checks

- `tools/check.ps1`: all engine fixtures, including expected failures.
- `tools/benchmark.ps1`: five-run document timings.
- `tools/sync-engine.ps1 -Mode check`: consumer/source equality.
- Portfolio `tests/compatibility.typ`: compile with `api=old` and default inputs.
- Portfolio `tests/navigation.typ`: compile with `extra=yes` and default inputs.

The module map and compatibility table are in `refactor.md`. Portfolio authoring
instructions are in the consumer's `README.md`.
