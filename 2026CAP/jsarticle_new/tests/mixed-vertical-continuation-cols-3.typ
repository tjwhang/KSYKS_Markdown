#import "../jsarticle.typ": jsarticle-book, jsarticle-options, jsvert

// Reverse stream order and omit trailing breaks. Visual headings stay out of
// the outline; the running head must still belong to the active chapter.
#show: jsarticle-book.with(
  options: jsarticle-options(
    document: (title: [Three-column vertical continuation], title-page: "inline"),
    page: (paper-size: "a5", cols: 3, h1-break: "continuous"),
    vertical: (
      rows: 1, columns: 1, heading-mode: "visual", stream-gap: 0.6em,
    ),
  ),
)

= Three-column boundary

#jsvert(
  (language: "ko", region: "KR", body: [
    == 한글 선행 스트림

    이 짧은 한글 스트림은 한 번만 나타나야 한다.
  ]),
  (language: "ja", region: "JP", body: [
    == 日本語継続ストリーム

    #for _ in range(20) [
      この日本語ストリームは三段の水平ページ設定とは独立した縦組の面で続き、完了した韓国語ストリームを再び出力してはならない。

    ]
  ]),
)
