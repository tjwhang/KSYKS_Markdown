// Experimental: applies the document serif italic face to text-shaped glyphs
// inside math. Keep this opt-in: a text font cannot replace a full math font
// for every operator, delimiter, and extensible construction.
#let pf-text-italic-math(body, font: "Minion Pro") = {
    show math.equation: set text(font: font, style: "italic")
    body
}
