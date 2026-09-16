#import "../jsarticle.typ": *
#let mode = sys.inputs.at("margin", default: "physical")
#let sides = {
  if mode == "legacy" { (inside: 20mm, outside: 32mm) }
  else if mode == "mixed" { (inside: 1mm, outside: 2mm, left: 20mm, right: 32mm) }
  else if mode == "incomplete" { (left: 20mm) }
  else { (left: 20mm, right: 32mm) }
}
#show: jsarticle-book.with(options: jsarticle-options(
  page: (paper-size: "a4", bind: "none", margin: sides + (top: 24mm, bottom: 18mm)),
))
#set par(first-line-indent: 0pt)
#context {
  assert.eq(js-column-width.get(), 158mm)
  assert.eq(js-body-height.get(), 255mm)
  assert.eq(js-single-page-margin.get(), if mode == "legacy" {
    (inside: 20mm, outside: 32mm, top: 24mm, bottom: 18mm)
  } else { (left: 20mm, right: 32mm, top: 24mm, bottom: 18mm) })
}
PROBE
#pagebreak()
PROBE
#if sys.inputs.at("vertical", default: "no") == "yes" {
  jsvert(flow: "page", language: "ko")[세로쓰기 여백과 페이지 크기를 확인하는 문장입니다.]
}
