#import "@preview/min-book_custom:1.1.0": *
#import "@preview/physica:0.9.5": *
#import "@preview/alchemist:0.1.4": *
#import "@preview/theorion:0.3.3": *
#import "@preview/rich-counters:0.2.1": *
#import "@preview/cetz:0.3.4"
#import "@preview/cetz-plot:0.1.1"
#import cosmos.rainbow: *

#import "template.typ": *

#let title = [제목 입력]

#show: book.with(
  title: "제목",
  subtitle: "부제목",
  edition: 0,
  volume: 0,
  authors: "저자",
  date: datetime.today(),
  cover: auto,
  titlepage: auto,
  catalog: (
    id: "제목(ID)",
    place: "출판장소",
    publisher: "출판사",
    isbn: "숫자",
    subjects: (),
    access: (),
    ddc: none,
    udc: none,
    before: none,
    after: none,
  ),
  dedication: "이 책을 누구누구에게 바침.",
  acknowledgements: [
    도움 주신 분들
  ],
  epigraph: "정서",
  toc: true,
  part: "",
  chapter: auto,
  cfg: (
    numbering-style: auto,
    page: "a5",
    lang: "dk",
    justify: false,
    first-line-indent: 1em,
    margin: (x: 15%, y: 14%),
    font: ("STIX Two Text", "KoPubBatang"),
    font-math: "Erewhon Math",
    font-mono: "Inconsolata",
    font-size: 11pt,
    heading-weight: "bold",
    cover-bgcolor: rgb("#ffffff"),
    cover-txtcolor: luma(0%),
    cover-fonts: ("KoPubBatang", "KoPubBatang"),
    cover-back: true,
    toc-indent: none,
    toc-bold:false,
    chapter-numrestart: false,
    two-sided: true,
    link-readable: true,
  ),
)

#show: show-theorion
#set math.mat(delim: "[")

= Prelude

#include "chapters/chapter1.typ"