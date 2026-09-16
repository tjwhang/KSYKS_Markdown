#import "../../portfolio.typ": *
#import "../../components/specimen.typ": pf-specimen
#import "../specimens/typst-system.typ": specimen

#let project = (
    id: "typst-system",
    number: 7,
    title: "조화로운 다국어 조판",
    short-title: "typst 다국어 조판 시스템",
    field: "타이포그래피 · CJK 조판 · 소프트웨어 · 언어",
    period: "2026.02 ~ 현재",
    tools: ("typst"),
    pages: (
        [
        #pf-flow(
            evidence: (),
        )[
        #pf-repo(label: [GitHub 리포지토리 및 관련 링크])[
        #link(
            "https://github.com/tjwhang/KSYKS_Markdown/tree/main/2026CAP/jsarticle_new",
        )[`https://github.com/tjwhang/KSYKS_Markdown/tree/main/2026CAP/jsarticle_new`] \
        #link(
            "https://github.com/tjwhang/KSYKS_Markdown/tree/main/2026CAP/unist",
        )[`https://github.com/tjwhang/KSYKS_Markdown/tree/main/2026CAP/unist`]\
        ▶ *기능 설명 영상* #h(1em) #link("https://www.youtube.com/playlist?list=PLO0wCGntTQIc")[`https://youtube.com/playlist?list=PLO0wCGntTQIc&si=uOYS7UtqxCA7R0Qb`]
        ]
        #set par(first-line-indent: 1em)

        #pf-heading[문자체계의 조화 찾기]
        가장 먼저 해결한 것은 여러 문자체계의 글꼴을 일관되게 사용하는 문제였습니다. 글꼴 가족을 여러 글꼴을 묶은 합성글꼴로 정의한 뒤 문자를 라틴, 한글, 한자, 가나, 문장부호 등으로 구분하고, 언어와 지역을 함께 확인하여 적절한 실제 글꼴을 선택합니다. 같은 한자라도 한국어·일본어·중국어 맥락에 따라 서로 다른 글꼴을 사용할 수 있고, 중국어도 간체와 번체 지역을 구분하도록 했습니다#footnote[언어, 지역별로 표준자형이 조금씩 다르기 때문입니다.]. 각 글꼴에는 글자 크기, 기준선, 자간을 따로 보정할 수 있도록 했습니다. 예를 들어 특정 한글 글꼴이 같은 크기의 라틴 글꼴보다 커 보이거나 기준선이 낮다면 그 글꼴에만 보정값을 주고, 다른 문자체계에는 영향을 주지 않도록 하기 위함이었습니다. 

        또한, 서로 다른 문자체계는 외형적 특징이 상이합니다. 적절한 글꼴을 찾는 것 다음으로 할 수 있는 방법은 서로 다른 문자체계 간에는 아예 이것들이 같은 흐름 상에 놓이지 않았다는 것을 독자의 눈에게 어필하는 것입니다. 특히 라틴/수식/반각괄호 등과 한중일 문자 간 간격이 딱 붙어 보이는 문제가 대두되어 이를 해결했습니다. 

        #pf-heading[세로쓰기 구현하기]
        동양의 미를 지면에 구현하고, 고문헌을 인용할 때나 디자인 요소로 용이하게 사용하기 위해 세로쓰기[縱書]를 별도로 만들기로 했습니다. typst는 물론 여러 프로세서가 세로쓰기를 제대로 지원하고 있지 않기 때문에, 구현 목표를 정확히 알기 위해 세로쓰기 규칙이 명시된 W3C의 KLREQ, JLREQ 문서와 옛날 신문 사진들을 참고했습니다. 

        금칙(禁則), 종중횡(#ruby[たてちゅうよこ][縦中横]) 등의 규칙과, 행을 공간에 나누어 배치하는 pagination 등 기본적인 메커니즘은 오픈소스 엔진인 basho를 활용했습니다. 이를 제 요구치에 맞추기 위해 일본어에 맞춰져 있던 엔진에 한국어 조판 규칙을 추가하고, 이것이 주 문서의 언어와 합성글꼴 설정을 받을 수 있도록 연결했습니다. 세로쓰기는 짧은 표제처럼 한 줄로 사용하는 경우, 일정한 공간 안에서 행이 진행하는 경우, 여러 페이지에 걸쳐 이어지는 경우를 구분할 수 있도록 했습니다.

        #pf-heading[보고서 작성 도구에서 문서 체계로]
        처음에는 탐구보고서를 일정한 형식으로 빠르게 만들기 위한 도구에 가까웠지만, 기능을 추가하면서 판형과 여백, 글자 크기, 행간, 제목과 장, 각주, 합성글꼴, 가로쓰기와 세로쓰기를 하나의 설정에서 조절하는 문서 체계로 확장했습니다. 현재는 범주별로 설정을 서로 분리한 구조로 관리하고 있습니다. 또한 판형에 따라 글자 크기와 본문 폭, 줄 수, 여백도 일정한 기준으로 자동 계산할 수 있도록 했습니다.

        구현 과정에서 가장 크게 바뀐 것은 기능의 수보다 구조였습니다. 처음에는 언어별 글꼴 목록과 개별 보정값을 여러 곳에서 직접 관리했지만, 이후에는 실제 글꼴과 그 글꼴을 사용할 조건을 분리하고, 문서에서는 역할만 지정하도록 다시 설계했습니다. 이전의 언어별 글꼴표와 글꼴 이름에 의존한 보정방식도 제거했습니다.

        #pf-heading[적용 결과물]
        읽고 계신 이 포트폴리오 자체가 해당 문서 체계를 목적에 맞게 개조하여 조판한 문서입니다. 설명드린 기능은 본 문서 지면 곳곳에서 확인하실 수 있습니다. 따라서 이 포트폴리오는 앞에서 소개한 탐구들을 정리한 문서인 동시에, 그 탐구들을 작성하고 조판하면서 반복해서 겪었던 문제를 해결하기 위해 발전시킨 현재 결과물이기도 합니다. 

        다만 더 상세한 설명은 상단에 첨부된 '기능 설명 영상'을 참조해 주시면 감사하겠습니다. #h(1fr) #sym.wj #sym.qed#metadata(none)<pf-typst-system-specimen-start>
        ]
        #pf-specimen(specimen, anchor: <pf-typst-system-specimen-start>)
        ],
    ),
)
