"""Measure IPA fonts, bracket clearance, scaled leading and footnote joins."""
from pathlib import Path
from tempfile import TemporaryDirectory
import subprocess

import pdfplumber

root = Path(__file__).resolve().parents[1]


def bracket_samples(chars):
    result = []
    for index, char in enumerate(chars):
        group = chars[index:index + 5]
        if len(group) == 5 and [c["text"] for c in group[::2]] == ["가", "나", "다"]:
            result.append(group)
    return result


with TemporaryDirectory(prefix="horizontal-typography-") as temp:
    samples = {}
    for gap in ("zero", "normal"):
        output = Path(temp) / f"{gap}.pdf"
        subprocess.run([
            "typst", "compile", "--root", str(root), "--input", f"gap={gap}",
            str(root / "tests/horizontal-typography.typ"), str(output),
        ], check=True, capture_output=True)
        with pdfplumber.open(output) as pdf:
            assert len(pdf.pages) == 2
            samples[gap] = bracket_samples(pdf.pages[0].chars)
            # First three lines are regular, bold and explicitly marked IPA.
            ipa = [c for c in pdf.pages[0].chars if c["top"] < 145]
            footnote_ipa = [c for c in ipa if c["top"] < 125]
            assert footnote_ipa
            for c in footnote_ipa:
                if c["text"] in ("ˈ", "ˌ"):
                    assert "NewCM" in c["fontname"], c
                elif c["text"] in "vanɡʁtə" or c["text"] == "ɪ̯":
                    assert "ChosunilboNM" in c["fontname"], c
            assert any("Bold" in c["fontname"] for c in ipa)
            chars = pdf.pages[1].chars
            letters = [c for c in chars if c["text"] == "A"]
            assert len(letters) == 6
            ratios = [(letters[i + 1]["top"] - letters[i]["top"]) / letters[i]["size"]
                      for i in (0, 2, 4)]
            assert max(ratios) - min(ratios) < 0.02, ratios
            markers = [c for c in chars if c["text"] == "*" and c["top"] < 600]
            assert len(markers) == 5
            for marker in markers:
                assert any(c["text"] == "다" and -0.05 <= marker["x0"] - c["x1"] < 2
                           and abs(marker["top"] - c["top"]) < 8 for c in chars), marker
    assert len(samples["normal"]) == len(samples["zero"]) == 18
    for old, new in zip(samples["zero"], samples["normal"]):
        for bracket, neighbour, side in ((1, 0, "open"), (3, 4, "close")):
            glyph = old[bracket]
            narrow = glyph["text"] in "()[]{}<>" or glyph["x1"] - glyph["x0"] < 0.8 * 11
            expected = 2.2 if narrow else 0
            if side == "open":
                delta = (new[bracket]["x0"] - new[neighbour]["x1"]) - (old[bracket]["x0"] - old[neighbour]["x1"])
            else:
                delta = (new[neighbour]["x0"] - new[bracket]["x1"]) - (old[neighbour]["x0"] - old[bracket]["x1"])
            assert abs(delta - expected) < 0.15, (glyph["text"], glyph["fontname"], delta, expected)
    print("PASS selective IPA repair, font-aware brackets, proportional leading and attached footnote markers")
