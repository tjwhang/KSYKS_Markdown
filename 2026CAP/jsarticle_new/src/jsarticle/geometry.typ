#let calculate-typography(
  paper-size,
  font-size,
  baseline-ratio,
  lines-per-page,
  text-width,
  cjk-height,
  cjk-scale,
  document-type,
  cols,
) = {
  let dimensions = (
    a3: (297mm, 420mm),
    a4: (210mm, 297mm),
    a5: (148mm, 210mm),
    a6: (105mm, 148mm),
    b4: (257mm, 364mm),
    b5: (182mm, 257mm),
    b6: (128mm, 182mm),
  )
  let (page-width, page-height) = if type(paper-size) == array {
    paper-size
  } else {
    let key = if paper-size == "jis-b5" { "b5" } else { paper-size }
    if key in dimensions {
      dimensions.at(key)
    } else {
      panic("Unknown paper size: " + repr(paper-size))
    }
  }

  let paper-scale = calc.sqrt((page-width / 210mm) * (page-height / 297mm))

  let size = if font-size == auto {
    let reference = if document-type == "novel" { 12pt } else { 11.5pt }
    let scaled = reference * calc.pow(paper-scale, 0.38)
    calc.max(8.5pt, calc.min(14pt, calc.round(scaled / 0.25pt) * 0.25pt))
  } else { font-size }
  let cjk-factor = cjk-scale / 1em
  if cjk-factor <= 0 { panic("cjk-scale must be greater than zero.") }
  let cjk-size = size * cjk-factor

  let ratio = if baseline-ratio == auto {
    if document-type == "novel" { 1.8 } else { 1.6 }
  } else { baseline-ratio }

  let baseline = size * ratio
  let leading = baseline - size
  if leading < 0pt { panic("baseline-ratio is too small for the selected cjk-scale.") }

  let width = if text-width == auto {
    let reference-size = if document-type == "novel" { 12pt } else { 11.5pt }
    let reference-characters = if document-type == "novel" { 32 } else { 38 }
    // Multi-column pages need a wider total type area, but not a nearly
    // edge-to-edge one. Scale the reference measure close to the reciprocal
    // square-root of the column count: on A4 this gives about 22 CJK cells
    // per column for a two-column article, versus about 38 in one column.
    let column-reference = reference-characters * calc.pow(cols, -0.78)
    let proportional-characters = (
      column-reference * calc.pow(page-width / 210mm, 0.87) * (reference-size / size)
    )
    let target-characters = if document-type == "novel" {
      calc.max(
        if cols == 1 { 20 } else if cols == 2 { 16 } else { 13 },
        calc.min(35, proportional-characters),
      )
    } else {
      calc.max(
        if cols == 1 { 24 } else if cols == 2 { 18 } else { 14 },
        calc.min(45, proportional-characters),
      )
    }
    // Automatic geometry is resolved before contextual em lengths can be
    // converted. Use the template's 2em nominal gutter for the target; the
    // actual `column-gutter` is still used by page layout below.
    let gutter-width = 2 * size
    let desired = cols * target-characters * cjk-size + (cols - 1) * gutter-width
    let minimum-side-margin = if cols == 1 {
      calc.max(8mm, 12mm * paper-scale)
    } else {
      // More columns may use a slightly smaller frame, but the reduction is
      // deliberately shallow: A4 keeps about 18 mm at two columns and 16 mm
      // at three, instead of collapsing toward a technical handout margin.
      calc.max(10mm, 22mm * paper-scale / calc.pow(cols, 0.30))
    }
    calc.min(desired, page-width - 2 * minimum-side-margin)
  } else { text-width }

  let line-count = if lines-per-page == auto {
    let page-aspect = page-height / page-width
    let iso-aspect = 297 / 210
    let aspect-correction = calc.sqrt(iso-aspect / page-aspect)
    let base-margin-ratio = if document-type == "novel" { 12% } else { 10.5% }
    let margin-ratio = if document-type == "novel" {
      calc.max(9%, calc.min(15%, base-margin-ratio * aspect-correction))
    } else {
      calc.max(8%, calc.min(14%, base-margin-ratio * aspect-correction))
    }
    let physical-floor = calc.max(9mm, 13mm * paper-scale)
    let target-margin = calc.max(physical-floor, margin-ratio * page-height)
    let available-height = page-height - 2 * target-margin
    calc.max(8, calc.floor((available-height - size) / baseline) + 1)
  } else { lines-per-page }

  let side-margin = (page-width - width) / 2
  let body-height = size + baseline * (line-count - 1)
  let vertical-margin = (page-height - body-height) / 2

  (
    page-width: page-width,
    page-height: page-height,
    paper-scale: paper-scale,
    size: size,
    cjk-size: cjk-size,
    baseline: baseline,
    leading: leading,
    line-count: line-count,
    width: width,
    side-margin: side-margin,
    vertical-margin: vertical-margin,
  )
}
