#import "../jsarticle.typ": jsarticle-book, jsarticle-options, jsvert, rb

// Regression: an earlier stream ending in structural paragraph breaks must
// never restart when a later stream continues on a following page.
#show: jsarticle-book.with(
  options: jsarticle-options(
    document: (title: [Mixed vertical continuation], title-page: "inline"),
    page: (paper-size: "a5", cols: 1, h1-break: "continuous"),
    vertical: (rows: 2, columns: 1, stream-gap: 0.6em),
  ),
)

= Cursor regression

#jsvert(
  (
    language: "ja",
    region: "JP",
    body: [
      == 日本語カーソル検証

      この短い日本語ストリームは最初の面で完了する。末尾の空段落は構造上のトークンであり、次の面で本文を再開させてはならない。



    ],
  ),
  (
    language: "ko",
    region: "KR",
    body: [
      == 한글 연속성 검증

      #for _ in range(24) [
        #rb[とうきょうとうきょう][東京] 뒤따르는 한글 스트림은 여러 세로 면으로 이어져야 하며, 앞선 일본어 제목이나 본문을 다시 출력해서는 안 된다. 문단 경계와 금칙 처리, 줄의 순서도 계속 유지되어야 한다.

      ]
    ],
  ),
)
