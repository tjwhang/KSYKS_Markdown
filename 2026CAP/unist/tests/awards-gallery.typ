#import "../portfolio.typ": pf-document, pf-appendix, pf-afterword
#import "../sections/appendix.typ": appendix
#pf-document[
    #pf-appendix(title: appendix.title, body-width: appendix.body-width, inset: appendix.inset, appendix.body)
    #pf-afterword[AFTERWORD-CHECK]
]
