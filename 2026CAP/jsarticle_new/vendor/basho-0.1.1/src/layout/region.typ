// Intrinsic-width vertical region for composing independent streams.

#import "paginate.typ": paginate
#import "page.typ": render-page, column-ruby-overhang
#import "metrics.typ": prepare-layout, column-width

#let plan-tate-region-prepared(prepared, height) = {
  if prepared.tokens.len() == 0 {
    return (empty: true, width: 0pt)
  }
  let layout = prepare-layout(
    prepared.tokens, prepared.config, usable-height: height,
  )
  let cfg = layout.config
  let cols = paginate(layout.tokens, height, cfg)
  let widths = cols.map(col => column-width(col, cfg))
  let gap = measure(h(cfg.layout.gap)).width
  let rendered-width = widths.sum(default: 0pt)
  for (index, col) in cols.enumerate() {
    if index > 0 {
      rendered-width += calc.max(gap, column-ruby-overhang(col))
    }
  }
  (
    empty: false,
    width: rendered-width,
    cols: cols,
    config: cfg,
  )
}

#let plan-tate-region(tokens, height, config) = plan-tate-region-prepared(
  (tokens: tokens, config: config), height,
)

#let measure-tate-region-width(tokens, height, config) = {
  plan-tate-region(tokens, height, config).width
}

#let render-tate-region-plan(plan, height) = context {
  if plan.empty { return box() }
  let region = box(
    width: plan.width,
    height: height,
    align(right + top, render-page(plan.cols, plan.config.layout.gap, plan.config)),
  )
  [‏#region‏]
}

// Fit an intrinsically sized vertical stream into the row bands available at
// its call site. Columns are balanced across the fitted rows so the result can
// remain beside a following independent vertical stream instead of reserving
// the unused width of a physical page.
#let layout-tate-region-rows(
  tokens,
  available-height,
  full-height,
  width,
  rows,
  row-gap,
  row-fit-threshold,
  config,
) = context {
  if tokens.len() == 0 { return box() }
  let row-gap = measure(v(row-gap)).height
  let nominal-cell = (full-height - (rows - 1) * row-gap) / rows
  let nominal = (available-height + row-gap) / (nominal-cell + row-gap)
  let fitted = if available-height >= full-height {
    rows
  } else {
    calc.min(rows, calc.max(1, calc.ceil(nominal / row-fit-threshold)))
  }
  let cell-height = (available-height - (fitted - 1) * row-gap) / fitted
  let prepared = prepare-layout(tokens, config, usable-height: cell-height)
  let cfg = prepared.config
  let cols = paginate(prepared.tokens, cell-height, cfg)
  let widths = cols.map(col => column-width(col, cfg))
  let gap = measure(h(cfg.layout.gap)).width
  let per-row = calc.max(1, calc.ceil(cols.len() / fitted))
  let plans = ()
  for row in range(fitted) {
    let start = row * per-row
    if start < cols.len() {
      let end = calc.min(cols.len(), start + per-row)
      let row-cols = cols.slice(start, end)
      let row-widths = widths.slice(start, end)
      plans.push((
        cols: row-cols,
        width: {
          let result = row-widths.sum(default: 0pt)
          for (index, col) in row-cols.enumerate() {
            if index > 0 { result += calc.max(gap, column-ruby-overhang(col)) }
          }
          result
        },
      ))
    }
  }
  let used-rows = plans.len()
  let content-width = calc.min(width, calc.max(..plans.map(plan => plan.width)))
  let region-width = content-width
  let cells = plans.map(plan => box(
    width: content-width,
    height: cell-height,
    align(right + top, render-page(plan.cols, cfg.layout.gap, cfg)),
  ))
  let region = box(
    width: region-width,
    height: used-rows * cell-height + calc.max(0, used-rows - 1) * row-gap,
    grid(
      columns: (content-width,),
      rows: range(used-rows).map(_ => cell-height),
      row-gutter: row-gap,
      ..cells,
    ),
  )
  [‏#region‏]
}

#let layout-tate-region(tokens, height, config) = context {
  render-tate-region-plan(plan-tate-region(tokens, height, config), height)
}
