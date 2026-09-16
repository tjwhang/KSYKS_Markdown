// Use the same advances for ruby preparation and painting. U+3000 remains
// a full cell; only ordinary U+0020 uses the configured word-space advance.
#let ruby-text-height(value, cell, space) = {
  if value == none { return 0pt }
  if type(value) != str { return cell }
  value.clusters().map(ch => if ch == " " { space } else { cell }).sum(default: 0pt)
}
