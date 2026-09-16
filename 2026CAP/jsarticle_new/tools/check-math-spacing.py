"""Verify deferred equation gaps and Theorion locales. Requires pdfplumber."""
from pathlib import Path
from tempfile import TemporaryDirectory
import subprocess

import pdfplumber

root = Path(__file__).resolve().parents[1]


def samples(page):
    chars = page.chars
    result = []
    for index, char in enumerate(chars):
        if char["text"] != "한":
            continue
        following = [c for c in chars[index + 1:] if c["text"].strip()][:2]
        if len(following) == 2 and following[0]["text"] in ("x", "𝑥") and following[1]["text"] == "글":
            result.append(tuple(c["x0"] - char["x0"] for c in following))
    return result


with TemporaryDirectory(prefix="jsarticle-spacing-") as temp:
    for fixture in ("deferred-math-spacing", "theorion-spacing-locale"):
        outputs = {}
        for gap in ("zero", "large"):
            path = Path(temp) / f"{fixture}-{gap}.pdf"
            subprocess.run([
                "typst", "compile", "--root", str(root), "--input", f"gap={gap}",
                str(root / "tests" / f"{fixture}.typ"), str(path),
            ], check=True, capture_output=True)
            with pdfplumber.open(path) as pdf:
                outputs[gap] = ([samples(page) for page in pdf.pages], [page.extract_text() for page in pdf.pages])
        zero, _ = outputs["zero"]
        large, text = outputs["large"]
        assert len(zero) == len(large)
        for a, b in zip(zero, large):
            assert len(a) == len(b) and a
            for old, new in zip(a, b):
                assert abs(new[0] - old[0] - 11) < 0.1, (fixture, old, new)
                assert abs(new[1] - old[1] - 22) < 0.1, (fixture, old, new)
        if fixture == "theorion-spacing-locale":
            for label in ("물음", "지침", "풀이", "증명", "정리"):
                assert label in text[0], label
            for label in ("解", "証明", "問"):
                assert label in text[1], label
            for label in ("예", "주의", "경고", "연습", "비고", "결론", "CUSTOM"):
                assert label in text[2], label
            assert "Proof" in text[3] and "Problem" in text[3]
            assert "証明" in text[4]
            assert "HIDDEN" not in "\n".join(text)
        print(f"PASS {fixture}: measured gaps and locale checks")
