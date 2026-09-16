"""Upright Jamo must match horizontal shaping, across all jsvert modes."""
from pathlib import Path
from tempfile import TemporaryDirectory
import subprocess
import pdfplumber

ROOT = Path(__file__).resolve().parents[1]
with TemporaryDirectory(prefix='old-hangul-') as tmp:
    tmp = Path(tmp)
    signatures = []
    renders = []
    for mode in ('no', 'yes'):
        pdf = tmp / (mode + '.pdf')
        result = subprocess.run(['typst', 'compile', '--root', str(ROOT),
            '--input', 'reference=' + mode, str(ROOT / 'tests/old-hangul.typ'), str(pdf)],
            capture_output=True, encoding='utf-8', timeout=120)
        assert result.returncode == 0 and 'warning:' not in result.stderr, result.stderr
        with pdfplumber.open(pdf) as doc:
            assert len(doc.pages) >= 3
            signatures.append([[(c['text'], c['fontname'].split('+')[-1],
                *[round(c[k], 3) for k in ('x0', 'top', 'x1', 'bottom', 'size')])
                for c in p.chars] for p in doc.pages])
        subprocess.run(['pdftoppm', '-r', '144', '-png', str(pdf), str(tmp / mode)], check=True)
        renders.append([p.read_bytes() for p in sorted(tmp.glob(mode + '-*.png'))])
    assert signatures[0] == signatures[1], 'Jamo positions differ from horizontal shaping'
    assert renders[0] == renders[1], 'Rendered Jamo differ from horizontal shaping'
print('PASS Old Hangul: region, inline, page, heading, strong, ruby; exact 144 dpi reference match')
