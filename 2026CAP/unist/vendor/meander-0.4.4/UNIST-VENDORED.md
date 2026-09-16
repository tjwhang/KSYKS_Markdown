# Meander 0.4.4 experiment

Source: the pinned `@preview/meander:0.4.4` package, MIT licensed.
The original LICENSE is retained. No global package-cache files are modified.

The only upstream source change is the initial search bound in
`src/bisect.typ` / `has-children`: exponentially bracket the overflowing
prefix before running the original binary refinement and boundary splitting.
The existing monotonic-fit assumption remains; negative spacing and contextual
content require differential layout checks.

Five package-root imports in internals.typ and opt/{debug,placement,overflow}.typ
are made relative so the package can be imported from a local vendor directory.
These are path-only adaptations; the fitting change is the only behavior edit.

This copy is experimental until the acceptance report says otherwise.
Production `components/flow.typ` must keep its upstream import unless both
layout and performance gates pass.
