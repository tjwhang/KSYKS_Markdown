#import "../jsarticle.typ": jsarticle-book, jsarticle-options, jsvert

// The physical page has horizontal columns, but page-flow jsvert remains a
// full-width one-column surface with the same independent stream cursors.
#show: jsarticle-book.with(
  options: jsarticle-options(
    document: (title: [Two-column vertical continuation], title-page: "inline"),
    page: (paper-size: "a5", cols: 2, h1-break: "continuous"),
    vertical: (rows: 1, columns: 1, stream-gap: 0.6em),
  ),
)

= Two-column boundary

#jsvert(
  (language: "ja", region: "JP", body: [
    == 日本語先行ストリーム

    この短いストリームは完了後に再開してはならない。


  ]),
  (language: "ko", region: "KR", body: [
    == 한글 계속 스트림

    #for _ in range(20) [
      이 한글 스트림은 두 칼럼의 수평 문서 안에서도 전체 폭의 세로 면으로 계속되어야 하며, 완료된 일본어 스트림을 다시 출력해서는 안 된다.

    ]
  ]),
)
