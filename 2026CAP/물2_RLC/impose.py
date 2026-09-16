import os
from pypdf import PdfReader, PdfWriter, PageObject


def reorder_for_booklet(input_pdf, output_pdf):
    print(f"📖 [{input_pdf}] 파일을 소책자용으로 변환합니다...")

    reader = PdfReader(input_pdf)
    writer = PdfWriter()

    total_pages = len(reader.pages)

    # 중철 제본은 4의 배수여야 하므로, 모자란 만큼 빈 페이지 수를 계산합니다.
    target_pages = ((total_pages + 3) // 4) * 4
    blank_pages_needed = target_pages - total_pages

    # 첫 페이지의 크기(A5)를 기준으로 빈 페이지를 만듭니다.
    first_page = reader.pages[0]
    width = first_page.mediabox.width
    height = first_page.mediabox.height

    pages = []
    # 원본 페이지 추가
    for i in range(total_pages):
        pages.append(reader.pages[i])

    # 4의 배수를 맞추기 위해 빈 페이지 추가
    for i in range(blank_pages_needed):
        pages.append(PageObject.create_blank_page(width=width, height=height))

    print(f"   - 원본 페이지: {total_pages}쪽")
    print(f"   - 추가된 빈 페이지: {blank_pages_needed}쪽")
    print(f"   - 총 재배열 페이지: {target_pages}쪽")

    # 소책자(Booklet) 순서로 배열 알고리즘 적용
    left = 0
    right = target_pages - 1

    while left < right:
        # 1. 종이 앞면 (A4 왼쪽: 마지막 쪽, A4 오른쪽: 1쪽)
        writer.add_page(pages[right])
        writer.add_page(pages[left])
        left += 1
        right -= 1

        if left >= right:
            break

        # 2. 종이 뒷면 (A4 왼쪽: 2쪽, A4 오른쪽: 마지막에서 두 번째 쪽)
        writer.add_page(pages[left])
        writer.add_page(pages[right])
        left += 1
        right -= 1

    # 결과물 저장
    with open(output_pdf, "wb") as f:
        writer.write(f)

    print(f"✅ 완료! [{output_pdf}] 파일이 생성되었습니다.")


if __name__ == "__main__":
    # 변환할 파일명과 출력될 파일명을 지정하세요.
    INPUT_FILE = "main.pdf"  # Typst로 뽑은 A5 원본 PDF
    OUTPUT_FILE = "main_booklet.pdf"  # 인쇄소/프린터에 넘길 PDF

    if os.path.exists(INPUT_FILE):
        reorder_for_booklet(INPUT_FILE, OUTPUT_FILE)
    else:
        print(f"❌ 에러: {INPUT_FILE} 파일을 찾을 수 없습니다. 같은 폴더에 넣어주세요.")
