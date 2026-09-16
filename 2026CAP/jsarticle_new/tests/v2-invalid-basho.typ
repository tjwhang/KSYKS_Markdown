#import "../vendor/basho-0.1.1/lib.typ": basho-config

// This document must fail with `config.layout.colums`.
#basho-config((layout: (colums: 2)))
