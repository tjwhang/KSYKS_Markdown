"""Measure additive math clearance under justification. Requires pdfplumber."""
from pathlib import Path
from tempfile import TemporaryDirectory
import subprocess

import pdfplumber

root = Path(__file__).resolve().parents[1]


def samples(page):
    chars = [c for c in page.chars if c["text"].strip()]
    result = []
    for a, b, c in zip(chars, chars[1:], chars[2:]):
        if (a["text"], b["text"], c["text"]) == ("한", "𝑥", "글"):
            if abs(a["top"] - c["top"]) < 1:
                result.append((b["x0"] - a["x1"], c["x0"] - b["x1"]))
    return result


with TemporaryDirectory(prefix="justified-spacing-") as temp:
    outputs = {}
    for gap in ("normal", "zero"):
        output = Path(temp) / f"{gap}.pdf"
        subprocess.run([
            "typst", "compile", "--root", str(root), "--input", f"gap={gap}",
            str(root / "tests/justified-math-spacing.typ"), str(output),
        ], check=True, capture_output=True)
        with pdfplumber.open(output) as pdf:
            assert len(pdf.pages) == 2
            outputs[gap] = [samples(page) for page in pdf.pages]
            if gap == "normal":
                # In the narrow block, 글 must wrap and start at the same
                # left edge as 한, not after a stranded clearance.
                chars = pdf.pages[1].chars
                starts = [i for i, c in enumerate(chars) if c["text"] == "한"]
                start = starts[5]
                first = chars[start]
                following = next(c for c in chars[start + 1:] if c["text"] == "글")
                assert following["top"] > first["top"] + 10
                assert abs(following["x0"] - first["x0"]) < 0.15
    normal, zero = outputs["normal"], outputs["zero"]
    for index in range(0, 12, 3):
        attached, spaced, ragged = normal[0][index:index + 3]
        for side in (0, 1):
            assert abs(attached[side] - ragged[side]) < 0.15
            assert spaced[side] > attached[side] + 0.5
    # At ragged, styled, linked, explicit-text and double-pass boundaries,
    # 0.15em at 11pt must add exactly 1.65pt on each side, not replace a space.
    for old, new in zip(zero[1][:5], normal[1][:5]):
        for side in (0, 1):
            assert abs(new[side] - old[side] - 1.65) < 0.15, (old, new)
    assert all(abs(a - b) < 0.15 for a, b in zip(normal[1][0], normal[1][4]))
    print("PASS justified spacing: fixed clearance, additive word spaces, styles, idempotence and line-edge trimming")
