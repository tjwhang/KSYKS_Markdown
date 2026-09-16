"""Check actual PDF font selection, not merely configured family strings."""
from pathlib import Path
from tempfile import TemporaryDirectory
import subprocess
import pdfplumber

ROOT = Path(__file__).resolve().parents[1]
with TemporaryDirectory(prefix='vertical-fonts-') as tmp:
    pdf = Path(tmp) / 'defaults.pdf'
    result = subprocess.run(['typst', 'compile', '--root', str(ROOT),
        str(ROOT / 'tests/vertical-font-defaults.typ'), str(pdf)],
        capture_output=True, encoding='utf-8', timeout=120)
    assert result.returncode == 0 and 'warning:' not in result.stderr, result.stderr
    with pdfplumber.open(pdf) as doc:
        assert len(doc.pages) == 4
        fonts = lambda chars: {c['fontname'].split('+')[-1] for c in chars}
        first = doc.pages[0].chars
        modern = fonts(c for c in first if c['text'] == '가')
        assert any('KoPubWorldBatang' in f for f in modern)
        assert any('KoPubWorldDotum' in f for f in modern)
        archaic = fonts(c for c in first if c['text'] == 'ᅇᅧ')
        assert any('SourceHanSerifK' in f for f in archaic)
        assert any('SourceHanSansK' in f for f in archaic)
        # Horizontal control keeps its existing font.
        horizontal = fonts(c for c in first if c['text'] in ('「', '」', '。'))
        assert horizontal and all('KoPubWorldBatang' in f for f in horizontal)
        # Unicode-fallback vertical forms in region, heading/ruby and page flow.
        puncts = set('﹁﹂︒。')
        for page in doc.pages[:3]:
            vertical = fonts(c for c in page.chars if c['text'] in puncts and
                not (page == doc.pages[0] and c['text'] == '。'))
            assert vertical and all('HiraMinProN' in f for f in vertical), vertical
        override = fonts(c for c in doc.pages[-1].chars if c['text'] in puncts)
        assert override and all('SourceHanSerifK' in f for f in override), override
print('PASS default vertical font routing; horizontal punctuation retained; explicit override retained')
