"""Check local-em and absolute ruby offsets, including real footnotes."""
from pathlib import Path
from tempfile import TemporaryDirectory
import subprocess

import pdfplumber

root = Path(__file__).resolve().parents[1]
with TemporaryDirectory(prefix="ruby-offset-") as temp:
    output = Path(temp) / "ruby.pdf"
    subprocess.run([
        "typst", "compile", "--root", str(root),
        str(root / "tests/ruby-offset.typ"), str(output),
    ], check=True, capture_output=True)
    with pdfplumber.open(output) as pdf:
        chars = pdf.pages[0].chars
        readings = [c for c in chars if c["text"] == "가"]
        assert len(readings) == 16
        gaps = []
        for index in range(0, 16, 4):
            normal, raised, lowered, absolute = readings[index:index + 4]
            em = normal["size"] / 0.55
            assert abs(raised["top"] - normal["top"] + 0.1 * em) < 0.01
            assert abs(lowered["top"] - normal["top"] - 0.05 * em) < 0.01
            assert abs(absolute["top"] - normal["top"] + 1) < 0.01
            base = min((c for c in chars if c["text"] == "漢"),
                       key=lambda c: abs(c["x0"] - normal["x0"]) + abs(c["top"] - normal["bottom"]))
            gaps.append((base["top"] - normal["bottom"]) / em)
        # PDF font boxes include side bearings, so compare normalized placement
        # rather than pretending their bounds are the visible glyph outlines.
        assert max(gaps) - min(gaps) < 0.02, gaps
    print("PASS ruby offsets: body, 8pt text, large leading, footnotes; em and pt")
