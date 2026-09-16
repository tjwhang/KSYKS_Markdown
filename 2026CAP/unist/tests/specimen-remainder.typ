#import "../portfolio.typ": pf-document, pf-flow
#import "../components/specimen.typ": pf-specimen
#pf-document[
    #pf-flow(evidence: ())[PROSE-END#metadata(none)<prose-end>]
    #pf-specimen(area => [
        #assert(area.height > 100mm)
        SPECIMEN-START
        #v(1fr)
        SPECIMEN-END
    ], anchor: <prose-end>)
    #pagebreak()
    NEXT-PAGE
]
#context {
    assert(query(<prose-end>).len() == 1)
    assert(query(<prose-end>).first().location().page() == 1)
}
