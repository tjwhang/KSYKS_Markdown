"""Check physical margins, legacy compatibility, and vertical page geometry."""
from pathlib import Path
from tempfile import TemporaryDirectory
import subprocess
import pdfplumber

root = Path(__file__).resolve().parents[1]
with TemporaryDirectory(prefix="page-margins-") as directory:
    for mode in ("physical", "mixed", "legacy", "incomplete"):
        output = Path(directory) / f"{mode}.pdf"
        result = subprocess.run([
            "typst", "compile", "--root", str(root), "--input", f"margin={mode}",
            str(root / "tests/physical-margins.typ"), str(output),
        ], capture_output=True, text=True, encoding="utf-8")
        if mode == "incomplete":
            assert result.returncode and 'requires "right"' in result.stderr, result.stderr
            continue
        assert result.returncode == 0, result.stderr
        with pdfplumber.open(output) as pdf:
            positions = [next(w["x0"] for w in p.extract_words() if w["text"] == "PROBE")
                         for p in pdf.pages]
            expected = (20, 32) if mode == "legacy" else (20, 20)
            assert len(positions) == 2, positions
            for actual, mm in zip(positions, expected):
                assert abs(actual - mm * 72 / 25.4) < 0.2, (mode, positions)
    result = subprocess.run([
        "typst", "compile", "--root", str(root), "--input", "vertical=yes",
        str(root / "tests/physical-margins.typ"), str(Path(directory) / "vertical.pdf"),
    ], capture_output=True, text=True, encoding="utf-8")
    assert result.returncode == 0, result.stderr
print("PASS fixed physical margins, mirrored legacy margins, precedence, validation and vertical geometry")
