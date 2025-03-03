---
title: "Deranged Injection"
subtitle: "An extension of derangement sequences"
author: ""
date: "2025년 03월 03일"

papersize: a4
mainfont: "STIX Two Text"
CJKmainfont: "SourceHanSerifK-Regular"

margin-right: 1.5in
margin-bottom: 1.5in
margin-top: 1.5in
margin-left: 1.5in
fontsize: 12pt
documentclass: article
output:
  pdf_document:
    latex_engine: xelatex

header-includes:
  - \usepackage{fontspec}
  #- \usepackage{xecjk}
  - \usepackage{unicode-math}
  - \setmathfont{STIX Two Math}
---
\begin{center}
\vspace{5cm}
Your school, lecture, class, organization, etc...
\vspace{2cm}

요 약

//TODO

\end{center}

\pagebreak

## 1. 발상

한국 정보 올림피아드 2023년 고등부 1교시 10번 문제
![KOI_2023_HS_1_10](KOI_2023_HS_1_10.png)
작년 (2024년)에 정보올림피아드에 출전하기 위해 저번 기출문제를 살펴보다가 경우의 수로 풀 법 한데 뭔가 안되서 몹시 많이 짜증나는 문제를 발견하고야 말았다. 시험지를 재배치하는것은 분명히 교란순열의 일종 같은데 청강생 때문에 뭔가 많이 꼬여서 케이스를 분류하여 푸는데도 순탄하게 되지 않고 뭔가 거지가

정올은 이와 같이 가끔씩 당연히 컴퓨터가 해야 할 일들을 사람 새끼에게 시키고는 한다. 이것은 분명 KOI가 수험생들을 사람이 아니라 일개 계산 노예로 취급한다는 반증이다. 하지만, 그러한 문제들은 수학적 사고력이나 지식으로 풀 수 있는 경우가 많다. 이 경우도 그러하다. 이 문제를 풀기 위하여 우리는 완전순열(또는 교란순열)이라고 불리는 derangement의 개념을 확장할 생각을 하였다.

## 2. 정의  

이 문제 뿐 아니라, 2015 개정 교육과정 수학(하)에서 좆 같은 교란순열 문제들로 피똥을 질질 싼 우리는 오기가 생겨 새로운 개념을 정립하기 시작했다. 어차피 1학년 끝나면 나오지도 않을 문제를 왜 중요시하며 쳐 내는지 모르겠지만 마지막을 즐기라는 의도인 것 같기도 하다.
