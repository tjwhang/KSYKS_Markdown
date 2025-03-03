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

작년 (2024년)에 정보올림피아드에 출전하기 위해 저번 기출문제를 살펴보다가 경우의 수로 풀 법 한데 뭔가 안되서 몹시 많이 짜증나는 문제를 발견하고야 말았다. 시험지를 재배치하는것은 분명히 교란순열의 일종 같은데 청강생 때문에 뭔가 많이 꼬여서 케이스를 분류하여 푸는데도 순탄하게 되지 않고 뭔가 많이 거지같은 상황들이 많이 연출되어서 푸는데에 골머리를 썩게 되었다. 궁금하면 직접 해보아라. **과연 당신도 이딴 생각을 안 하고 배길 수 있겠는가??** 

정올은 이와 같이 가끔씩 당연히 컴퓨터가 해야 할 일들을 사람 새끼에게 시키고는 한다. 이것은 분명 KOI가 수험생들을 사람이 아니라 일개 계산 노예로 취급한다는 방증이다. 하지만, 그러한 문제들은 수학적 사고력이나 지식으로 풀 수 있는 경우가 많다. 이 경우도 그러하다. 이 문제를 풀기 위하여 우리는 완전순열(또는 교란순열)이라고 불리는 derangement의 개념을 확장할 생각을 하였다.

## 2. 시작

이 문제 뿐 아니라, 2015 개정 교육과정 수학(하)에서 좆 같은 교란순열 문제들로 피똥을 질질 싼 우리는 오기가 생겨 새로운 개념을 정립하기 시작했다. 어차피 1학년 끝나면 나오지도 않을 문제를 왜 중요시하며 쳐 내는지 모르겠지만 마지막을 즐기라는 의도인 것 같기도 하다. 어쨌든 간에 우리는 일반적인 개념을 정립하기 위해 정의부터 시작했다. 

처음에는 문제풀이 과정 중 하나로 시작했기 때문에, 일반화를 하기 어려웠다. 

## 3. 새로운 수열 δ

$X = \{A,B\} \quad Y=\{\overbrace{A,B,\cdots X}^n\}$ 이고 

$f:X\rightarrow Y$ 인 함수 $f(x)$에 대해서 

A와 B를 A,B가 포함된 총 n개의 것들에 대응시킬 때 모든 x에 대하여 $f(x)\neq x$인 함수의 개수가 몇개일까?  

## 4. 일반화와 정의

결국 일반화를 계속 거친 끝에 두 매개변수로 입력을 받는 표현식을 완성했고, 아래와 같이 정의했다.

$f:X \to Y$ 에서 $|X| = d, |Y| = a$이고 $X \subset Y$일 때, 모든 $x \in X$에 대해 $f(x)\neq x$인 경우의 수를 다음과 같이 표현한다.

$$
{}_{d}{\rm U}_{a} \quad \text{where }d>a \implies {}_{d}\mathrm{U}_{a}=0
$$

$f:X \to Y$가 함수이므로 $0 < d \leq a$ 일 때만 생각한다. 이때, $d=a$이면 ${}_{a}\mathrm{U}_{a}$는 교란 순열의 값인 $D_{a}$와 같다. $d>a$일 때는 함수가 아니므로 방법이 없다고 생각하여 값을 0으로 고정했다. 다만 이는 이후 발상에서, 함수에서의 정의를 관계(relation)으로 확장하여 정의했기 때문에 달라지게 된다.

$d=2$일 때가 상술한 수열의 표현을 빌려 $\delta_a$이 된다. 

### 4.1. 표기에 대하여

이는 모두 임의로 지정한 기호로 정식 표기는 문서 하단에서 정할 예정이다. 일단, 임시 표기는 엉터리인 부분이 있기는 하지만, $\delta_n$의 델타는 derangement의 d에서 따왔고, ${}_{d}{\rm U}_{a}$의 U는 Unique, d는 departure, a는 arrival에서 따왔다. 여기서 d를 domain, r를 range로 하지 않는 이유는 함수가 아닐 때의 경우를 염두에 두고 정한 것이라고 할 수 있다. 

또, 굳이 표기를 $U(n, r)$ 과 같이 하지 않고, ${}_{n}{\rm X}_{r}$ 꼴로 한 이유는 이 새로운 수열이자 순열이 기존의 순열, 조합 등 ${}_{n}{\rm X}_{r}$ 꼴로 표기되는 수들과 관계가 있다고 판단했기 때문이다. 가만히 생각해보면, ${}_{4}{\rm C}_{n}$에서 $n \in \mathbb{N},~n\leq4$이라고 정하면 이 또한 수열이기 때문이다. 우리의 새로운 순열과 유사한 점이 있는 부분이다.

