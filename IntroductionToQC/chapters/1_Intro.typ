#import "../template.typ": *

= Introduction to Quantum Computing



== 무어의 법칙
캘리포니아 공과대학(CalTech)의 고든 무어(Gordon Moore) 교수는 관찰을 통해 일정 시간동안 컴퓨터 반도체에 집적되는 트랜지스터 수가 2배 이상 증가한다는 "무어의 법칙(Moore's Law)"을 제시했다. 그가 처음 법칙을 제안했을 때 그 "일정 시간"은 1년 정도였다.

#quote-box()[
  The complexity for minimum component costs has increased at a rate of roughly a factor of two per year. Certainly over the short term this rate can be expected to continue, if not to increase. Over the longer term, the rate of increase is a bit more uncertain, although there is no reason to believe it will not remain nearly constant for at least 10 years.

  -- Gordon Moore, 1965, "Electronics" 紙
]#footnote[
  최소 구성 요소 비용에 대한 복잡성은 연간 약 두 배 비율로 증가했습니다. 단기적으로 이 경향은 비율이 증가하지 않더라도 확실히 계속될 것으로 예상할 수 있습니다. 장기적으로 보면 증가율이 다소 불확실하지만 적어도 10년 동안 거의 일정할 것이라고 못 할 이유는 없습니다.
]

10년 뒤인 1975년, 무어는 법칙을 2년 마다 두 배로 증가한다고 수정했다. 열역학 제 2법칙의 등 여러 한계 때문에 증가 속도는 앞으로도 줄어들 예정이다. 오늘날 트랜지스터는 대략 50개의 원자 내외의 두께로 되어 있는데, 이대로 간다면 우리는 곧 원자 크기의 한계에 직면할 것이고, 물리 법칙이 달라지게 된다(...). 한 개의 원자는 한 뭉탱이의 원자와 전혀 다르게 행동하는데(적어도 그렇게 보이는데), 원자 뭉탱이는 고전역학의 지배를 받는 반면 원자 한 개는 양자역학의 지배를 받는다. 원자가 뭉탱이로 있을 때는, 큰수의 법칙에 따라 양자역학에 의한 확률적 현상들이 평균으로 수렴하여 무시해도 될 정도가 된다.

양자역학은 이상하고, 인간적 직관에 부합하지 않는다. 우리는 현대 인간 이전까지 양자역학적 효과를 실감하지 못했다. 즉, 인간은 양자역학이 아닌 고전역학적 사고로 진화했으며, 양자역학을 이해하기에 적합하지 않다. 