#import "portfolio.typ": *
#import "sections/profile.typ": profile
#import "sections/appendix.typ": appendix
#import "sections/afterword.typ": afterword
#import "sections/project-artwork.typ": project-artwork
#import "sections/projects/top.typ": project as project_top
#import "sections/projects/protein.typ": project as project_protein
#import "sections/projects/roof.typ": project as project_roof
#import "sections/projects/phil.typ": project as project_phil
#import "sections/projects/wci.typ": project as project_wci
#import "sections/projects/cjk-density.typ": project as project_cjk_density
#import "sections/projects/typst-system.typ": project as project_typst_system

#pf-book(
    title: [문리현상 정초],
    subtitle: [【文理現象定礎】\ #h(1em)「현상、형태、가치에 대한 질문과 탐구」],
    author: [포트폴리오 본문], 
    school: [UNIST 2027학년도 그릿인재전형],
    application: "수험번호 111050021",
    date: "",
    profile: profile,
    appendix: appendix,
    afterword: afterword,
    artworks: project-artwork,
    parts: ((
        number: 1,
        title: "현상과 모형",
        premise: "수학과 물리에는 특히 지속적인 애정을 가져 왔습니다. 본 포트폴리오에서는 두 건만 소개합니다.",
        projects: (project_top, project_protein),
    ), (
        number: 2,
        title: "인간과 언어",
        premise: "비슷한 방법을 더 넓은 분야로 확장해 본 건들을 소개합니다.",
        projects: (project_roof, project_phil, project_wci),
    ), (
        number: 3,
        title: "문자와 조판",
        premise: "",
        projects: (project_cjk_density, project_typst_system),
    ),),
)
