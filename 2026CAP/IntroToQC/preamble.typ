#import "@preview/physica:0.9.5": *
#import "@preview/alchemist:0.1.4": *
#import "@preview/theorion:0.5.0": *
#import "@preview/rich-counters:0.2.1": *
#import "@preview/cetz:0.3.4"
#import "@preview/cetz-plot:0.1.1"
#import "@preview/mannot:0.3.0": *
#import "@preview/codly:1.3.0": *
#import "@preview/codly-languages:0.1.1": *
#import "@preview/tyipa:0.1.0" as ipa
#import "@preview/rubby:0.10.2": get-ruby
#import "@preview/wrap-it:0.1.1": *
#import "@preview/itemize:0.2.0" as el
#import "@preview/in-dexter:0.7.2": *
#import "@preview/metalogo:1.2.0": LaTeX, TeX

#import "@preview/basho:0.1.0": *

#import "jsarticle.typ"

#show: show-theorion
#import cosmos.antique: *

// Antique's slash-box defaults to `breakable: false`.  That is desirable for
// ordinary theorem-like blocks, but a block taller than a complete text page
// would then run through the bottom edge.  Measure the fully rendered block at
// the current column width: keep it whole when it fits on a blank text page,
// and permit page splitting only when keeping it whole is impossible. Larger
// short blocks float by default; their wider measure marks them as independent
// insertions when surrounding prose is reordered.
#let adaptive-slash-box(
    color: c-maroon,
    prefix: none,
    title: "",
    full-title: none,
    breakable: auto,
    floating: auto,
    float-placement: bottom,
    block-spacing: auto,
    float-clearance: auto,
    float-threshold: 18%,
    frame-outset: auto,
    ..args,
    body,
) = context {
    let available = jsarticle.js-body-height.get()
    let column-width = jsarticle.js-column-width.get()
    let template-outset = jsarticle.js-marginal-outset.get()
    let template-baseline = jsarticle.js-baseline.get()
    let resolved-outset = if frame-outset == auto {
        if template-outset == none { 1em.to-absolute() } else { template-outset }
    } else {
        frame-outset
    }
    let resolved-spacing = if block-spacing == auto {
        // One baseline leaves theorem frames visually fused with adjacent
        // prose and with one another. Two baselines preserve the rhythm while
        // still keeping a sequence of short definitions recognisably related.
        if template-baseline == none { 3.2em.to-absolute() } else { 2 * template-baseline }
    } else {
        block-spacing
    }
    let resolved-float-clearance = if float-clearance == auto {
        resolved-spacing
    } else {
        float-clearance
    }
    let slash-box(is-breakable) = move(
        dx: -resolved-outset,
        block(
            width: 100% + 2 * resolved-outset,
            spacing: resolved-spacing,
            render-slash-box(
                color: color,
                prefix: prefix,
                title: title,
                full-title: full-title,
                breakable: is-breakable,
                ..args,
                body,
            ),
        ),
    )
    let unbroken = slash-box(false)
    let measured = if column-width == none {
        measure(unbroken).height
    } else {
        measure(width: column-width, unbroken).height
    }
    let clearance-height = resolved-float-clearance.to-absolute()
    let too-tall-to-float = available != none and measured + clearance-height > available
    let resolved-breakable = if breakable == auto { too-tall-to-float } else { breakable }
    let resolved-floating = if floating == auto {
        available != none and measured >= float-threshold * available
    } else {
        floating
    }

    // A later numbered block must not overtake an earlier pending float.
    // Ordinary prose may still fill the intervening space as intended.
    place.flush()

    if resolved-floating and not resolved-breakable {
        // Only substantial short blocks float automatically. Their wider rule
        // and body distinguish them from the narrower sequential text stream.
        place(
            float-placement,
            scope: "column",
            float: true,
            clearance: resolved-float-clearance,
            align(start, unbroken),
        )
    } else {
        slash-box(resolved-breakable)
    }
}

// Reuse Antique's original counters and identifiers so references, outlines,
// explicit numbering, positional titles, and `show-theorion` all retain their
// existing behaviour.  Only the renderer and its automatic split policy vary.
#let adaptive-slash-frame(identifier, frame-counter, color) = make-frame(
    identifier,
    theorion-i18n-map.at(identifier),
    counter: frame-counter,
    render: adaptive-slash-box.with(color: color),
)

#let (_, theorem-box, theorem, _) = adaptive-slash-frame("theorem", theorem-counter, c-maroon)
#let (_, lemma-box, lemma, _) = adaptive-slash-frame("lemma", lemma-counter, c-maroon)
#let (_, corollary-box, corollary, _) = adaptive-slash-frame("corollary", corollary-counter, c-maroon)
#let (_, definition-box, definition, _) = adaptive-slash-frame("definition", definition-counter, c-forest)
#let (_, axiom-box, axiom, _) = adaptive-slash-frame("axiom", axiom-counter, c-forest)
#let (_, postulate-box, postulate, _) = adaptive-slash-frame("postulate", postulate-counter, c-forest)
#let (_, proposition-box, proposition, _) = adaptive-slash-frame("proposition", proposition-counter, c-navy)
#let (_, property-box, property, _) = adaptive-slash-frame("property", property-counter, luma(100))
#let (_, assumption-box, assumption, _) = adaptive-slash-frame("assumption", assumption-counter, c-forest)

#let notag(content) = {
    math.equation(
        block: true,
        numbering: none,
        content,
    )
}

#let cal(it) = math.class("normal", context {
    show math.equation: set text(font: "Garamond-Math", stylistic-set: 3)

    let scaling = 100% * (1em.to-absolute() / text.size)
    let wrapper = if scaling < 60% { math.sscript } else if scaling < 100% { math.script } else { it => it }

    box(text(top-edge: "bounds", bottom-edge: "bounds", $wrapper(math.cal(it))$))
})

#let scr(it) = math.class("normal", context {
    show math.equation: set text(font: "Garamond-Math", stylistic-set: 1)

    let scaling = 100% * (1em.to-absolute() / text.size)
    let wrapper = if scaling < 60% { math.sscript } else if scaling < 100% { math.script } else { it => it }

    box(text(top-edge: "bounds", bottom-edge: "bounds", $wrapper(math.cal(it))$))
})

#set math.equation(numbering: n => {
    numbering("(1.1)", counter(heading).get().first(), n)
    // if you want change the number of number of displayed
    // section numbers, modify it this way:
    /*
    let count = counter(heading).get()
    let h1 = count.first()
    let h2 = count.at(1, default: 0)
    numbering("(1.1.1)", h1, h2, n)
    */
})

#set figure(numbering: n => {
    numbering("1.1", counter(heading).get().first(), n)
    // if you want change the number of number of displayed
    // section numbers, modify it this way:
    /*
    let count = counter(heading).get()
    let h1 = count.first()
    let h2 = count.at(1, default: 0)
    numbering("(1.1.1)", h1, h2, n)
    */
})

#let rb = get-ruby(
    size: 0.55em, // Ruby font size
    dy: -0.25em, // Vertical offset of the ruby
    pos: top, // Ruby position (top or bottom)
    alignment: "center", // Ruby alignment ("center", "start", "between", "around")
    delimiter: "|", // The delimiter between words
    auto-spacing: true, // Automatically add necessary space around words
)

#let jspart = jsarticle.jspart
#let transnote = jsarticle.transnote
#let jsdinkus = jsarticle.jsdinkus
#let jsquote = jsarticle.jsquote
#let jsbox = jsarticle.jsbox
#let jstopic = jsarticle.jstopic
#let jsans = jsarticle.jsans
#let jicover = jsarticle.jsicover
#let nnh1 = jsarticle.jsnnh1
#let nnoh1 = jsarticle.jsnnoh1
#let tnumbering = jsarticle.jsnumbering
