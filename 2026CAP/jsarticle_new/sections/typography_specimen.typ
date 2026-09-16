#import "../preamble.typ": *
#import "../jsarticle.typ": jsvert

= 다국어 혼합 조판 표본

#set text(lang: "ko")

이 장은 여러 문자체계와 인라인 기능이 실제 한 글줄 안에서 연속적으로 전환될 때의 글꼴 선택, 기준선, 자간과 줄바꿈을 확인하기 위한 표본이다.

#jsquote[
    極 意
]

한국어 문장을 쓰다가 English도 한 번, 그리고 затем появляется русский текст를 CJK 간격 잘 되는지 보려고 넣고, 漢字와 かな도 잘 나오는지 봐주고 수식도 아무거나 하나 $x_i = alpha_i + beta_i$로 작성하기로 한다.

== 개별 문자체계 글줄

=== 한글

#text(
    lang: "ko",
    region: "KR",
)[
    좋은 「本文본문」 조판(組版, typesetting)은 낱글자의 모양만 고르는 일이 아니라 글줄 전체에 고른 밀도와 안정된 리듬을 부여하는 일이다. 글자 사이의 간격이 지나치게 벌어지거나 좁아지지 않아야 하고, 문장부호는 앞뒤 글자와 자연스럽게 어울리면서도 행의 흐름을 흐트러뜨리지 않아야 한다. 여러 줄을 이어 읽을 때 시선이 다음 줄의 시작을 쉽게 찾아가고, 문단의 덩어리가 지나치게 성기거나 답답해 보이지 않는다면 글자는 내용 뒤로 물러나 독서를 조용히 돕는다. 이 문단은 한글 음절과 한국어 문장부호만으로 충분한 길이를 채워, 한글 전용 글줄의 기준선과 자간과 양쪽 맞춤이 다른 문자체계의 도움 없이도 고르게 유지되는지 살피기 위한 것이다.

    #jsgrid[
        좋은 본문 조판은 낱글자의 모양만 고르는 일이 아니라 글줄 전체에 고른 밀도와 안정된 리듬을 부여하는 일이다. 글자 사이의 간격이 지나치게 벌어지거나 좁아지지 않아야 하고, 문장부호는 앞뒤 글자와 자연스럽게 어울리면서도 행의 흐름을 흐트러뜨리지 않아야 한다. 「여러 줄을 이어 읽을 때」 시선이 다음 줄의 시작을 쉽게 찾아가고, 문단의 덩어리가 지나치게 성기거나 답답해 보이지 않는다면 글자는 내용 뒤로 물러나 독서를 조용히 돕는다. 이 문단은 한글 음절과 한국어 문장부호만으로 충분한 길이를 채워, 한글 전용 글줄의 기준선과 자간과 양쪽 맞춤이 다른 문자체계의 도움 없이도 고르게 유지되는지 살피기 위한 것이다.

        좋은 本文 組版은 낱글자의 模樣만 고르는 일이 아니라 글줄 全體에 고른 密度와 安靜된 리듬을 扶餘하는 일이다. 글자 사이의 間隔이 지나치게 벌어지거나 좁아지지 않아야 하고, 文章符號는 앞뒤 글자와 자연스럽게 어울리면서도 行의 흐름을 흐트러뜨리지 않아야 한다. 「여러 줄을 이어 읽을 때」 視線이 다음 줄의 始作을 쉽게 찾아가고, 文段의 덩어리가 지나치게 성기거나 답답해 보이지 않는다면 글자는 內容 뒤로 물러나 讀書를 조용히 돕는다. 이 文段은 韓㐎 音節과 韓國語 文章符號만으로 充分한 길이를 채워, 한글 全用 글줄의 基準線과 字間과 양쪽 맞춤이 다른 文字體系의 도움 없이도 고르게 留止되는지 살피기 爲한 것이다.
    ]

    좋은 본문 조판은 낱글자의 모양만 고르는 일이 아니라 글줄 전체에 고른 밀도와 안정된 리듬을 부여하는 일이다. 글자 사이의 간격이 지나치게 벌어지거나 좁아지지 않아야 하고, 문장부호는 앞뒤 글자와 자연스럽게 어울리면서도 행의 흐름을 흐트러뜨리지 않아야 한다. 여러 줄을 이어 읽을 때 시선이 다음 줄의 시작을 쉽게 찾아가고, 문단의 덩어리가 지나치게 성기거나 답답해 보이지 않는다면 글자는 내용 뒤로 물러나 독서를 조용히 돕는다. 이 문단은 한글 음절과 한국어 문장부호만으로 충분한 길이를 채워, 한글 전용 글줄의 기준선과 자간과 양쪽 맞춤이 다른 문자체계의 도움 없이도 고르게 유지되는지 살피기 위한 것이다.

    좋은 본문 조판은 낱글자의 모양만 고르는 일이 아니라 글줄 전체에 고른 밀도와 안정된 리듬을 부여하는 일이다. 글자 사이의 간격이 지나치게 벌어지거나 좁아지지 않아야 하고, 문장부호는 앞뒤 글자와 자연스럽게 어울리면서도 행의 흐름을 흐트러뜨리지 않아야 한다. 여러 줄을 이어 읽을 때 시선이 다음 줄의 시작을 쉽게 찾아가고, 문단의 덩어리가 지나치게 성기거나 답답해 보이지 않는다면 글자는 내용 뒤로 물러나 독서를 조용히 돕는다. 이 문단은 한글 음절과 한국어 문장부호만으로 충분한 길이를 채워, 한글 전용 글줄의 기준선과 자간과 양쪽 맞춤이 다른 문자체계의 도움 없이도 고르게 유지되는지 살피기 위한 것이다.

    좋은 본문 조판은 낱글자의 모양만 고르는 일이 아니라 글줄 전체에 고른 밀도와 안정된 리듬을 부여하는 일이다. 글자 사이의 간격이 지나치게 벌어지거나 좁아지지 않아야 하고, 문장부호는 앞뒤 글자와 자연스럽게 어울리면서도 행의 흐름을 흐트러뜨리지 않아야 한다. 여러 줄을 이어 읽을 때 시선이 다음 줄의 시작을 쉽게 찾아가고, 문단의 덩어리가 지나치게 성기거나 답답해 보이지 않는다면 글자는 내용 뒤로 물러나 독서를 조용히 돕는다. 이 문단은 한글 음절과 한국어 문장부호만으로 충분한 길이를 채워, 한글 전용 글줄의 기준선과 자간과 양쪽 맞춤이 다른 문자체계의 도움 없이도 고르게 유지되는지 살피기 위한 것이다.

]

=== 라틴

#text(
    lang: "en",
    region: "US",
)[
    Typography becomes 'convincing' when letters form a steady field rather than a collection of isolated shapes. A readable page balances measure, leading, word spacing, and margins so that the eye can move forward without repeatedly searching for the next line. The color of a paragraph should remain even through ordinary changes in word length, punctuation, and emphasis, while the texture should be firm enough to hold the page together without becoming dark or cramped. This passage provides a sustained Latin-only sample for judging lowercase rhythm, capitals, ascenders, descenders, spacing, and justified line endings across several complete lines.

    Typography becomes convincing when letters form a steady field rather than a collection of isolated shapes. A readable page balances measure, leading, word spacing, and margins so that the eye can move forward without repeatedly searching for the next line. The color of a paragraph should remain even through ordinary changes in word length, punctuation, and emphasis, while the texture should be firm enough to hold the page together without becoming dark or cramped. This passage provides a sustained Latin-only sample for judging lowercase rhythm, capitals, ascenders, descenders, spacing, and justified line endings across several complete lines.

    Typography becomes convincing when letters form a steady field rather than a collection of isolated shapes. A readable page balances measure, leading, word spacing, and margins so that the eye can move forward without repeatedly searching for the next line. The color of a paragraph should remain even through ordinary changes in word length, punctuation, and emphasis, while the texture should be firm enough to hold the page together without becoming dark or cramped. This passage provides a sustained Latin-only sample for judging lowercase rhythm, capitals, ascenders, descenders, spacing, and justified line endings across several complete lines.

]

=== 키릴

#text(
    lang: "ru",
    region: "RU",
)[Хорошая книжная типографика создаёт спокойный и ровный ритм, в котором отдельные буквы не отвлекают внимание от смысла текста. Длина строки, межстрочный интервал, ширина пробелов и поля страницы должны поддерживать друг друга, чтобы взгляд уверенно переходил от одной строки к следующей. Если набор слишком плотный, абзац выглядит тяжёлым, а если расстояния чрезмерны, строка распадается на отдельные фрагменты. Этот продолжительный образец позволяет проверить форму кириллических букв, высоту строчных знаков, положение пунктуации и равномерность выключки по ширине на протяжении нескольких строк.]

=== 프랑스어·독일어·그리스어

#text(
    lang: "fr",
    region: "FR",
)[Une typographie de lecture devient convaincante lorsque les lettres, les espaces et les signes de ponctuation forment une texture régulière plutôt qu’une suite de formes isolées. La longueur de ligne, l’interligne et les marges doivent se soutenir mutuellement afin que le regard avance sans hésitation. Cet échantillon vérifie aussi les accents, les apostrophes, les guillemets et la césure française dans un paragraphe justifié suffisamment long.]

#text(
    lang: "de",
    region: "DE",
)[Gute Buchtypografie entsteht, wenn Schriftgrad, Zeilenlänge, Durchschuss und Wortabstände ein ruhiges Ganzes bilden. Auch bei langen zusammengesetzten Wörtern darf der Grauwert des Absatzes nicht auseinanderfallen, und die automatische Silbentrennung soll breite Lücken vermeiden. Dieser längere deutsche Absatz prüft Umlaute, ß, Satzzeichen und gleichmäßige Blocksatzzeilen unter denselben westlichen Grundeinstellungen.]

#text(
    lang: "el",
    region: "GR",
)[Η καλή τυπογραφία βιβλίου δημιουργεί έναν ήρεμο και σταθερό ρυθμό, ώστε τα μεμονωμένα γράμματα να μην αποσπούν την προσοχή από το νόημα. Το μήκος της αράδας, το διάστιχο, τα κενά και τα περιθώρια πρέπει να συνεργάζονται, ενώ οι τόνοι και τα ελληνικά σημεία στίξης παραμένουν καθαρά μέσα σε ένα πλήρες δικαιολογημένο κείμενο.]

=== 중국어 간체

#text(
    lang: "zh",
    region: "CN",
)[良好的正文排版不只是选择漂亮的字形，而是让整个段落形成安定而均匀的阅读节奏。字与字之间的距离、行与行之间的空间、每行的长度以及页面四周的留白必须彼此配合，读者的视线才能自然地从一行移到下一行。标点符号既要清楚地表达句子的层次，也不应破坏文字表面的灰度。当段落不显得拥挤，也不因过度疏朗而失去凝聚力时，版面便能安静地承载内容。这段文字用连续的简体中文检查字形、基线、标点压缩、禁则与两端对齐。

    良好的正文排版不只是选择漂亮的字形，而是让整个段落形成安定而均匀的阅读节奏。字与字之间的距离、行与行之间的空间、每行的长度以及页面四周的留白必须彼此配合，读者的视线才能自然地从一行移到下一行。标点符号既要清楚地表达句子的层次，也不应破坏文字表面的灰度。当段落不显得拥挤，也不因过度疏朗而失去凝聚力时，版面便能安静地承载内容。这段文字用连续的简体中文检查字形、基线、标点压缩、禁则与两端对齐。]

=== 중국어 번체

#text(
    lang: "zh",
    region: "TW",
)[良好的正文排版不只是選擇漂亮的字形，而是讓整個段落形成安定而均勻的閱讀節奏。字與字之間的距離、行與行之間的空間、每行的長度以及頁面四周的留白必須彼此配合，讀者的視線才能自然地從一行移到下一行。標點符號既要清楚地表達句子的層次，也不應破壞文字表面的灰度。當段落不顯得擁擠，也不因過度疏朗而失去凝聚力時，版面便能安靜地承載內容。這段文字用連續的漢字正文檢查字面大小、基線位置、標點配置與兩端對齊是否保持一致。

    『良好的正文排版不只是選擇漂亮的字形，』而是讓整個段落形成安定而均勻的閱讀節奏。字與字之間的距離、行與行之間的空間、每行的長度以及頁面四周的留白必須彼此配合，讀者的視線才能自然地從一行移到下一行。標點符號既要清楚地表達句子的層次，也不應破壞文字表面的灰度。當段落不顯得擁擠，也不因過度疏朗而失去凝聚力時，版面便能安靜地承載內容。這段文字用連續的漢字正文檢查字面大小、基線位置、標點配置與兩端對齊是否保持一致。]

=== 일본어

#text(
    lang: "ja",
    region: "JP",
)[
    読みやすい本文組版では、一つ一つの文字の美しさだけでなく、行全体と段落全体の調子が整っていることが大切である。漢字、ひらがな、カタカナ、「句読点」が自然につながり、行の長さと行間と余白が互いに支え合えば、読者の視線は迷わず次の行へ移ることができる。文字が詰まりすぎると紙面は重くなり、間隔が広すぎると文章のまとまりが失われる。この長い文章は、日本語だけが続く環境で字面の大きさ、仮名のリズム、約物の位置、禁則処理、両端揃えの安定性を数行にわたって確かめるための見本である。

    読みやすい本文組版では、一つ一つの文字の美しさだけでなく、行全体と段落全体の調子が整っていることが大切である。漢字、ひらがな、カタカナ、句読点が自然につながり、行の長さと行間と余白が互いに支え合えば、読者の視線は迷わず次の行へ移ることができる。文字が詰まりすぎると紙面は重くなり、間隔が広すぎると文章のまとまりが失われる。この長い文章は、日本語だけが続く環境で字面の大きさ、仮名のリズム、約物の位置、禁則処理、両端揃えの安定性を数行にわたって確かめるための見本である。

    読みやすい本文組版では、一つ一つの文字の美しさだけでなく、行全体と段落全体の調子が整っていることが大切である。漢字、ひらがな、カタカナ、句読点が自然につながり、行の長さと行間と余白が互いに支え合えば、読者の視線は迷わず次の行へ移ることができる。文字が詰まりすぎると紙面は重くなり、間隔が広すぎると文章のまとまりが失われる。この長い文章は、日本語だけが続く環境で字面の大きさ、仮名のリズム、約物の位置、禁則処理、両端揃えの安定性を数行にわたって確かめるための見本である。

    読みやすい本文組版では、一つ一つの文字の美しさだけでなく、行全体と段落全体の調子が整っていることが大切である。漢字、ひらがな、カタカナ、句読点が自然につながり、行の長さと行間と余白が互いに支え合えば、読者の視線は迷わず次の行へ移ることができる。文字が詰まりすぎると紙面は重くなり、間隔が広すぎると文章のまとまりが失われる。この長い文章は、日本語だけが続く環境で字面の大きさ、仮名のリズム、約物の位置、禁則処理、両端揃えの安定性を数行にわたって確かめるための見本である。

    読みやすい本文組版では、一つ一つの文字の美しさだけでなく、行全体と段落全体の調子が整っていることが大切である。漢字、ひらがな、カタカナ、句読点が自然につながり、行の長さと行間と余白が互いに支え合えば、読者の視線は迷わず次の行へ移ることができる。文字が詰まりすぎると紙面は重くなり、間隔が広すぎると文章のまとまりが失われる。この長い文章は、日本語だけが続く環境で字面の大きさ、仮名のリズム、約物の位置、禁則処理、両端揃えの安定性を数行にわたって確かめるための見本である。
]

=== 수학

$
    H psi                          & = E psi, \
    psi                            & = sum_(k=0)^(n-1) alpha_k e_k, \
    rho                            & = sum_i p_i ket(psi_i) bra(psi_i), \
    U(theta)                       & = mat(cos theta, -sin theta;sin theta, cos theta), \
    integral_0^1 x^m (1-x)^n dif x & = (m! n!) / (m+n+1)!.
$

== 혼합

#jsquote[
    안 예쁘지만 기능 테스트를 위해서는 필요하다.
]

한국어로 조판을 시작하면 문장의 회색도와 한글 기준선을 먼저 볼 수 있고, the English phrase “quiet typography supports sustained reading”가 공백 뒤에 이어질 때 라틴 글꼴의 x-height와 숫자 0123456789의 높이를 곧바로 비교할 수 있다. Далее русское предложение объясняет, что кириллица должна сохранять ровный ритм строки без чрезмерного разрежения, 然後中文說明漢字的字面大小與標點位置應保持穩定, そして日本語ではひらがな・カタカナ・漢字の切り替えが自然である必要がある. 같은 줄의 끝에는 상태 $psi = alpha e_0 + beta e_1$와 조건 $abs(alpha)^2 + abs(beta)^2 = 1$을 배치하여 본문과 인라인 수식의 기준선도 함께 확인한다.

두 번째 혼합 문단은 공백 없는 경계를 집중적으로 시험한다. 자기A자신, 상태Vector상태, модельQ2026система, 中文ABC漢字, 日本語Typeかな처럼 문자체계가 바로 맞닿아도 어느 한쪽 글꼴이 이웃 문자를 잘못 가져가서는 안 된다. The sequence selfAself continues into русский фрагмент без смены размера, 接著是「中文引號」與《書名號》, 이어서 일본어의 『二重かぎ括弧』와 〈山括弧〉가 나온다. 괄호 (Latin), скобки (Кириллица), 中文括號（全形）, 日本語の括弧（確認）가 한 문단에 섞여도 낫표와 괄호의 상하폭, 좌우 여백과 줄 끝 금칙 처리가 일관되어야 한다.

== 강조·기울임·raw 혼합행

#epigraph(
    attribution: [『孝經』],
    style: "vert",
)[
    #rb[신|체|발|부][身|體|髮|膚] #rb[수|지|부|모][受|之|父|母] \ #rb[불|감|훼|상][不|敢|毁|傷] #rb[효|지|시|야][孝|之|始|也]。 \ 立身行道 揚名於後世 \ 以顯父母 孝之終也。
]
#rb[일|반][一|般] 본문 normal text обычный текст 普通中文 通常の日本語가 먼저 나오고, *강조 구간은 한국어 Strong English усиленный русский 加重中文 強調された日本語와 수식 $A_i^dagger A_i = I$를 한꺼번에 포함한다.* 강조가 끝나면 다시 일반 굵기로 정확히 돌아와야 하며, strong 내부의 숫자 1623과 아래첨자 $lambda_(i,j)$도 Gothic 숫자나 잘못된 수학 글꼴로 교체되지 않아야 한다. 같은 문단의 _기울임 구간에는 한국어와 italic이탤릭 English, курсивный русский, 中文說明, 日本語の説明_을 함께 넣어 italic이 없는 CJK 글꼴에서 불필요한 합성 기울임이 생기는지, 라틴과 키릴의 실제 italic face가 올바르게 선택되는지 확인한다#footnote[각주 폰A트 テスト健康づくりАобычныйäάǎ текстД #lorem(30)].

인라인 raw도 별도 문단으로 떼지 않고 본문 안에 둔다. 한국어 설명 뒤의 `state_vector_01`, English code `apply_gate(q0)`, русский идентификатор `russian_state_2`, 中文標識 `zh_state_3`, 日本語識別子 `jp_state_4`가 한 줄 흐름에서 각각 고정폭 글꼴을 유지해야 한다. 그 다음 *strong text와 `raw_inside_strong_123` 및 수식 $sum_(k=0)^n a_k$가 함께 있는 구간*을 두어 strong 규칙이 raw와 수식 내부까지 침범하지 않는지도 점검하고, 끝에는 plain English, обычный русский, 普通中文, 通常の日本語로 돌아와 스타일 범위가 새지 않는지 확인한다.

== 수식·기호 혼합행

수식이 여러 문자체계 사이에 놓이는 상황을 길게 확인한다. 한국어에서 $a_n = sum_(k=0)^n binom(n, k) x^k$라고 쓰고 English says that the coefficients remain finite, русский текст называет это разложением, 中文稱它為二項式展開, 日本語では二項展開と呼ぶ. 이어서 행렬 $U(theta) = mat(1, 0;0, e^(i theta))$와 밀도연산자 $rho = sum_i p_i ket(psi_i) bra(psi_i)$를 같은 문단에 넣어 큰 괄호, 위첨자, 아래첨자와 그리스 문자의 기준선이 주변 한글·라틴·키릴·한자·가나에 영향을 주지 않는지 확인한다.

한국어 설명 $integral_0^1 x^2 dif x = 1/3$ English continuation затем русский переход 之後中文銜接 そして日本語の続き처럼 수식 양쪽의 언어가 계속 바뀌어도 강제 상자나 끊을 수 없는 긴 덩어리가 만들어지지 않아야 한다. 첨자가 많은 식 $A_(i,j) = (partial^2 F)/(partial x_i partial x_j)$, 극한 $lim_(n -> infinity) (1 + 1/n)^n = e$, 곱 $product_(j=1)^m (I + lambda_j P_j)$를 차례로 배치한 뒤, 문단 마지막을 한국어 마침표로 닫아 행의 높이와 문단 간격이 안정적인지 살핀다.

$
    psi(theta)                               & = 1 / sqrt(2) (e_0 + e^(i theta) e_1), \
    U(theta)                                 & = mat(1, 0;0, e^(i theta)), \
    sum_(k=0)^(n-1) integral_0^1 x_k^2 dif x & = n / 3.
$

블록 수식 위아래에도 혼합 문장을 둔다. Before the display 영어가 이어지고, перед формулой стоит русский текст, 公式之前有中文, 数式の前には日本語があり, 수식 뒤에는 다시 한국어가 나와 블록 간격을 비교한다. After the display the prose resumes, после формулы строка продолжается, 公式之後文字繼續, 数式の後も文章が続き며 $sigma_x sigma_y = i sigma_z$ 같은 짧은 인라인 식으로 끝난다.

$
    "A big equation is " i hbar pdv(, t) psi = (- hbar^2/(2m) nabla^2 + V(x))psi \ sin x
$

== 종합 스트레스 문단

마지막 문단은 모든 요소를 반복하여 페이지와 줄 경계에서의 전환을 시험한다. 한국어 2026 English typography Кириллическая типографика 中文排版 日本語組版 $H psi = E psi$가 이어지고, *한국어 Strong English сильный русский 加重漢字 強調かな $x_(i+1)^2$*, 다시 일반 본문, _italic English курсив русский 中文 日本語_, 그리고 `raw_mixed_CY_ZH_JP_01`이 한 흐름을 이룬다. 「낫표」 『겹낫표』 〈홑화살괄호〉 《겹화살괄호》, “English quotes”, «русские кавычки», 「中文引號」, 「日本語のかぎ括弧」까지 연속해 배치하고, 자기A자신·модельBсистема·中文C漢字·日本語Dかな의 무공백 경계를 반복한다. 이 긴 문장이 여러 줄로 나뉘더라도 오른쪽 여백을 침범하지 않고, 각 행의 기준선과 색이 크게 흔들리지 않으며, 마지막 문자까지 정상적으로 선택되면 다문자 본문 조판의 기본 기능이 유지되는 것으로 판단할 수 있다.

= 세로짜기 표본

이 절의 페이지 흐름 `jsvert`는 언어와 지역을 각 호출에 명시한다. 공통 설정은 `main.typ`의 `jsarticle-book`에 있는 `vertical` 설정 사전을 바꾸면 되며, 아래 호출에는 비교에 필요한 예외만 직접 적는다.

좋은 본문 조판은 낱글자의 모양만 고르는 일이 아니라 글줄 전체에 고른 밀도와 안정된 리듬을 부여하는 일이다. 글자 사이의 간격이 지나치게 벌어지거나 좁아지지 않아야 하고, 문장부호는 앞뒤 글자와 자연스럽게 어울리면서도 행의 흐름을 흐트러뜨리지 않아야 한다. 여러 줄을 이어 읽을 때 시선이 다음 줄의 시작을 쉽게 찾아가고, 문단의 덩어리가 지나치게 성기거나 답답해 보이지 않는다면 글자는 내용 뒤로 물러나 독서를 조용히 돕는다. 이 문단은 한글 음절과 한국어 문장부호만으로 충분한 길이를 채워, 한글 전용 글줄의 기준선과 자간과 양쪽 맞춤이 다른 문자체계의 도움 없이도 고르게 유지되는지 살피기 위한 것이다.


#jsvert(
    (
        language: "ja",
        region: "JP",
        body: [
            == 日本語自動プロファイル

            読みやすい縦組では、漢字、ひらがな、カタカナと句読点が一つのリズムを作る。数字24は自動的に縦中横となり、Latin text, punctuation. は欧文の流れを保つ。段落の途中で改ページしても、同じ縦の行が別のページへ分裂してはならない。

            次の段落は一字下げで始まり、行頭禁則と行末禁則、約物の位置、行送りの安定性を確認する。 次の段落は一字下げで始まり、行頭禁則と行末禁則、約物の位置、行送りの安定性を確認する。
            次の段落は一字下げで始まり、行頭禁則と行末禁則、 約物の位置、行送りの安定性を確認する。

        ],
    ),
    (
        language: "ko",
        region: "KR",
        body: [
            == 한글과 문맥 의존 문장부호

            한글 세로짜기에서는 한글 다음의 쉼표, 그리고 마침표. 를 세로 CJK 문장부호로 처리한다. 반면 Latin text, punctuation. 은 로마자 글줄의 일부이므로 쉼표와 마침$a$표a를 라틴 문자와 함께 회전시킨다. 숫자24와 한국 한자 漢字, 일본 가나 かな가 섞여도 글줄의 순서와 길이는 유지되어야 한다.
            $
                "A big equation is " i hbar pdv(, t) psi = (- hbar^2/(2m) nabla^2 + V(x))psi
            $

            다음 문단은 자간과 들여쓰기, 금칙 처리와 페이지 경계에서의 연속성을 확인한다. 좋은 본문 조판은 낱글자의 모양만 고르는 일이 아니라 글줄 전체에 고른 밀도와 안정된 리듬을 부여하는 일이다. 글자 사이의 간격이 지나치게 벌어지거나 좁아지지 않아야 하고, 문장부호는 앞뒤 글자와 자연스럽게 어울리면서도 행의 흐름을 흐트러뜨리지 않아야 한다. 여러 줄을 이어 읽을 때 시선이 다음 줄의 시작을 쉽게 찾아가고, 문단의 덩어리가 지나치게 성기거나 답답해 보이지 않는다면 글자는 내용 뒤로 물러나 독서를 조용히 돕는다. 이 문단은 한글 음절과 한국어 문장부호만으로 충분한 길이를 채워, 한글 전용 글줄의 기준선과 자간과 양쪽 맞춤이 다른 문자체계의 도움 없이도 고르게 유지되는지 살피기 위한 것이다.

        ],
    ),
)

#pagebreak(weak: true)
== 다단·다행 세로 흐름

아래 표본은 지정한 세로쓰기 직사각형을 2행 2열의 네 본문 영역으로 나눈다. `rows`와 `columns`는 낱개의 세로 글줄 수가 아니라 독립된 본문 영역 수이며, 각 영역 안에는 폭이 허용하는 만큼 여러 세로 글줄이 오른쪽에서 왼쪽으로 흐른다.

// #pagebreak()
#jsvert(
    language: "ja",
    region: "JP",
    width: auto,
    height: auto,
    rows: 2,
    columns: 1,
    column-gap: 2em,
    row-gap: 2em,
)[
    第一段は右上から始まり、四つの縦の行を満たした後で第二段の右端へ移る。行の途中でページが分裂せず、句読点、括弧、数字24、Latin text, punctuation. と数式$x+y$の境界も安定しなければならない。第一段は右上から始まり、四つの縦の行を満たした後で第二段の右端へ移る。行の途中でページが分裂せず、句読点、括弧、数字24、Latin text, punctuation. と数式$x+y$の境界も安定しなければならない。第一段は右上から始まり、四つの縦の行を満たした後で第二段の右端へ移る。行の途中でページが分裂せず、句読点、括弧、数字24、Latin text, punctuation. と数式$x+y$の境界も安定しなければならない。第一段は右上から始まり、四つの縦の行を満たした後で第二段の右端へ移る。行の途中でページが分裂せず、句読点、括弧、数字24、Latin text, punctuation. と数式$x+y$の境界も安定しなければならない。

    読みやすい本文組版では、一つ一つの文字の美しさだけでなく、行全体と段落全体の調子が整っていることが大切である。漢字、ひらがな、カタカナ、句読点が自然につながり、行の長さと行間と余白が互いに支え合えば、読者の視線は迷わず次の行へ移ることができる。文字が詰まりすぎると紙面は重くなり、間隔が広すぎると文章のまとまりが失われる。この長い文章は、日本語だけが続く環境で字面の大きさ、仮名のリズム、約物の位置、禁則処理、両端揃えの安定性を数行にわたって確かめるための見本である。

    第二段落でも字下げと送り順を確認する。第一段は右上から始まり、四つの縦の行を満たした後で第二段の右端へ移る。行頭禁則と行末禁則を保ち、複数ページに続いても列と段の順序を維持する。
]

#pagebreak(weak: true)
== 도판용 짧은 세로글과 tracking

#figure(rect(width: 100%, inset: 1em, stroke: 0.4pt + luma(75%), grid(
    columns: (1fr, 1fr, 1fr),
    align(center)[#text(lang: "ja")[#jsvert(flow: "inline", tracking: -0.1em)[縦組24]]],
    align(center)[#text(lang: "ko")[#jsvert(flow: "inline", tracking: 0em)[세로쓰기24]]],
    align(center)[#text(lang: "zh", region: "TW")[#jsvert(flow: "inline", tracking: 0.1em)[直排文字24]]],
)), caption: [왼쪽부터 tracking -0.1em, 0em, 0.1em])
