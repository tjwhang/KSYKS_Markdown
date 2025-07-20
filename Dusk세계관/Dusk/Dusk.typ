#import "@preview/wonderous-book_custom:0.1.1": book

// #set par(
//   first-line-indent: 1em
// )

#set page(paper: "a5")

#show: book.with(
  title: [Dusk (임시 제목)],
  author: "",
  dedication: [장 이름은 임시이고, 앞에 붙는 말들은 부 이름임.],
  publishing-info: [
    Dusk 2025, Second Parallel \
  ],
)

// 각주 (#footnote)는 최종 원고 붙여넣은 후 읽으면서 하나씩 넣을것.

#include "chapters/1-1.typ"
#include "chapters/1-2.typ"
#include "chapters/1-3.typ"
#include "chapters/2-1.typ"
#include "chapters/2-2.typ"
#include "chapters/2-3.typ"
#include "chapters/2-4.typ"