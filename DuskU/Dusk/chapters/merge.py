#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""
디렉터리 내의 'n-m.typ' 패턴을 가진 파일들을 (n, m) 순서대로 정렬해
하나의 텍스트 파일(.txt)로 합치는 스크립트.

변경 사항:
- n-a.typ 같은 알파벳 부록 파일을 지원합니다.
- 정렬 규칙: 같은 n(챕터) 내에서 m이 숫자면 본문으로 간주하여 오름차순 정렬 후 먼저 배치,
  m이 알파벳이면 부록으로 간주하여 본문 뒤에 알파벳 순으로 배치합니다.
  예) 1-1.typ, 1-2.typ, ..., 1-a.typ, 1-b.typ, 그 다음 2-1.typ, ...

사용 예시:
    python typ_merge.py ./typ_chapters merged.txt
    python typ_merge.py . output.txt --encoding utf-8 --errors strict --verbose

기본 동작:
- 주어진 디렉터리의 최상위(재귀 아님)에서 파일명 패턴 '^(\d+)-([0-9]+|[A-Za-z]+)\\.typ$' 과 일치하는 파일만 대상으로 함.
- n은 정수로 파싱.
- m이 숫자면 본문, 알파벳이면 부록으로 분류하여 정렬.
- 각 파일의 내용을 순서대로 출력 파일에 기록.
- 파일 사이에는 최소 1개의 개행이 보장되도록 처리.

옵션:
- --encoding: 입력/출력 파일의 인코딩(기본: utf-8)
- --errors: 디코딩/인코딩 에러 처리 방식(기본: strict, 대안: replace, ignore 등)
- --quiet: 진행상황 출력 억제
- --verbose: 더 자세한 진행상황 출력(본문/부록 표기)

주의:
- 동일한 (n, m) 조합(대소문자/0채움 무시)이 2개 이상 발견되면 오류로 처리합니다.
  예) 1-01.typ 와 1-1.typ 는 중복, 1-A.typ 와 1-a.typ 도 중복.
"""

from __future__ import annotations

import argparse
import sys
import re
from pathlib import Path
from typing import List, Tuple


# n-m.typ 에서 m은 숫자(본문) 또는 알파벳(부록) 허용
FILENAME_RE = re.compile(r"^(\d+)-([0-9]+|[A-Za-z]+)\.typ$", re.IGNORECASE)


def parse_args() -> argparse.Namespace:
    p = argparse.ArgumentParser(description="n-m.typ 파일들을 챕터/부록 순서대로 합쳐 하나의 txt로 만듭니다.")
    p.add_argument(
        "directory",
        type=str,
        help="typ 파일들이 있는 디렉터리 경로 (재귀 검색하지 않음)",
    )
    p.add_argument(
        "output",
        type=str,
        help="결과를 저장할 출력 텍스트 파일 경로 (예: merged.txt)",
    )
    p.add_argument(
        "--encoding",
        default="utf-8",
        help="입출력 파일 인코딩 (기본: utf-8)",
    )
    p.add_argument(
        "--errors",
        default="strict",
        help="디코딩/인코딩 에러 처리 방식 (기본: strict, 예: replace, ignore)",
    )
    g = p.add_mutually_exclusive_group()
    g.add_argument(
        "--quiet",
        action="store_true",
        help="진행상황 출력 최소화",
    )
    g.add_argument(
        "--verbose",
        action="store_true",
        help="자세한 진행상황 출력 (본문/부록 구분 표시)",
    )
    return p.parse_args()


def is_appendix_token(token: str) -> bool:
    """m 토큰이 부록(알파벳)인지 여부"""
    return not token.isdigit()


def discover_files(dir_path: Path) -> List[Tuple[int, str, Path]]:
    """
    디렉터리에서 'n-m.typ' 파일을 찾아 (n, m_token, path) 튜플 목록으로 반환.
    m_token은 원문 문자열(숫자 또는 알파벳).
    """
    items: List[Tuple[int, str, Path]] = []
    for p in dir_path.iterdir():
        if not p.is_file():
            continue
        m = FILENAME_RE.match(p.name)
        if not m:
            continue
        n = int(m.group(1))
        m_token = m.group(2)
        items.append((n, m_token, p))
    return items


def sort_key(entry: Tuple[int, str, Path]):
    """
    정렬 키:
      - n: 오름차순
      - 본문(숫자 m) 먼저, 부록(알파벳 m) 나중
      - 본문: m 정수 오름차순
      - 부록: m 소문자 알파벳 사전순
    """
    n, m_token, _ = entry
    if m_token.isdigit():
        return (n, 0, int(m_token), "")
    else:
        return (n, 1, 0, m_token.lower())


def normalized_key(n: int, m_token: str):
    """
    중복 판정을 위한 정규화 키:
      - 본문: ('num', n, int(m))
      - 부록: ('alpha', n, m.lower())
    """
    if m_token.isdigit():
        return ("num", n, int(m_token))
    else:
        return ("alpha", n, m_token.lower())


def ensure_parent_dir(path: Path) -> None:
    if path.parent and not path.parent.exists():
        path.parent.mkdir(parents=True, exist_ok=True)


def main() -> int:
    args = parse_args()
    directory = Path(args.directory).expanduser().resolve()
    output_path = Path(args.output).expanduser().resolve()

    if not directory.exists() or not directory.is_dir():
        print(f"[오류] 디렉터리가 존재하지 않거나 디렉터리가 아닙니다: {directory}", file=sys.stderr)
        return 2

    entries = discover_files(directory)
    if not entries:
        print(f"[오류] 패턴 'n-m.typ' 에 해당하는 파일이 없습니다: {directory}", file=sys.stderr)
        return 1

    # 정렬
    entries.sort(key=sort_key)

    # (n, m) 중복 검사 (대소문자/0채움 무시)
    seen = set()
    dups = []
    for n, m_token, p in entries:
        key = normalized_key(n, m_token)
        if key in seen:
            dups.append((n, m_token, p))
        else:
            seen.add(key)
    if dups:
        msg_lines = ["[오류] 동일한 (n, m) 조합을 가진 파일이 여러 개 발견되었습니다:"]
        for n, m_token, p in dups:
            kind = "부록" if is_appendix_token(m_token) else "본문"
            msg_lines.append(f"  - n={n}, m='{m_token}' ({kind}): {p.name}")
        print("\n".join(msg_lines), file=sys.stderr)
        return 1

    if not args.quiet:
        print(f"[정보] 대상 디렉터리: {directory}")
        print(f"[정보] 출력 파일: {output_path}")
        print(f"[정보] 인코딩: {args.encoding}, 에러 처리: {args.errors}")
        print(f"[정보] 발견 및 정렬된 파일 수: {len(entries)}")
        if args.verbose:
            for idx, (n, m_token, p) in enumerate(entries, 1):
                kind = "부록" if is_appendix_token(m_token) else "본문"
                print(f"  {idx:3d}. {p.name}  →  n={n}, m={m_token} [{kind}]")

    # 병합 수행
    ensure_parent_dir(output_path)

    try:
        with output_path.open("w", encoding=args.encoding, errors=args.errors, newline="") as out_f:
            first = True
            for n, m_token, path in entries:
                try:
                    content = path.read_text(encoding=args.encoding, errors=args.errors)
                except Exception as e:
                    print(f"[오류] 파일 읽기 실패: {path} ({e})", file=sys.stderr)
                    return 1

                # 파일 간 경계에 최소 1개 개행 보장
                if not first:
                    out_f.write("\n")
                else:
                    first = False

                # 현재 파일 내용 기록
                out_f.write(content)
                # 마지막 줄 끝에 개행이 없다면 하나 추가하여 다음 파일과 붙지 않게 함
                if not content.endswith("\n"):
                    out_f.write("\n")

        if not args.quiet:
            print(f"[완료] 병합 성공: {output_path}")
        return 0

    except Exception as e:
        print(f"[오류] 출력 파일 작성 중 오류: {e}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    sys.exit(main())