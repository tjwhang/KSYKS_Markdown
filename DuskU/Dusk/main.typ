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
    title: "Dusk",
    subtitle: "2026",
    edition: 0,
    volume: 0,
    authors: "Echae",
    date: datetime.today(),
    cover: auto,
    titlepage: auto,
    catalog: (
        id: "Dusk",
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
    dedication: "",
    acknowledgements: [
        알림
        - 본 소설의 내용은 모두 가상이며, 현실의 모든 사건, 인물, 단체, 장소 등과 관련이 없습니다.
        - 본 소설은 2024년 8월부터 집필하기 시작했으며, 이후 정세는 반영하지 않았습니다.

    ],
    epigraph: "나중에 넣을 가장 중요한 대사 한 줄.",
    toc: true,
    part: "",
    chapter: auto,
    cfg: (
        numbering-style: auto,
        page: "a5",
        lang: "dk",
        justify: false,
        first-line-indent: 1em,
        margin: (x: 13%, y: 13%),
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
        toc-bold: false,
        chapter-numrestart: false,
        two-sided: true,
        link-readable: true,
    ),
)

#show: show-theorion
#set math.mat(delim: "[")

#let pb = pagebreak(to: "even", weak: true)

#set par(
  justify: false,
  leading: 1.3em,
  spacing: 1.8em
)

= Prelude

#include "chapters/1-1.typ"
#pb
#include "chapters/1-2.typ"
#pb
#include "chapters/1-3.typ"
#pb
#include "chapters/1-a.typ"
#pb

= Elevation
#include "chapters/2-1.typ"
#pb
#include "chapters/2-2.typ"
#pb
#include "chapters/2-3.typ"
#pb
#include "chapters/2-4.typ"
#pb
#include "chapters/2-a.typ"

= Discovery
#include "chapters/3-1.typ"
#pb