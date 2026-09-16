import re
import os
import subprocess
from pyhwpx import Hwp

EQ_RENDER_TEMPLATE = r"""
#import "@preview/physica:0.9.5": *
#import "@preview/alchemist:0.1.4": *
#import "@preview/theorion:0.3.3": *
#import "@preview/rich-counters:0.2.1": *
#import "@preview/cetz:0.3.4"
#import "@preview/cetz-plot:0.1.1"
#import "@preview/mannot:0.3.0": *
#import "@preview/tyipa:0.1.0" as ipa
#import "@preview/rubby:0.10.2": get-ruby

#set page(width: auto, height: auto, margin: 1pt, fill: none)
#set text(size: 10pt, font: ("New Computer Modern", "KoPubWorldBatang_Pro", "Source Han Serif K"))

#let ruby = get-ruby(delimiter: "|")

#show math.equation: set text(
    font: ("new computer modern math", "KoPubWorldBatang_Pro"),
    top-edge: "bounds", 
    bottom-edge: "bounds"
)

#let cal(it) = math.cal(it)
#let scr(it) = math.class("normal", it)
"""

class TypstToHwpConverter:
    def __init__(self):
        self.hwp = Hwp()
        self.allowed_cmds = ['footnote', 'ruby', 'underline']

    def render_math(self, content, is_block=False):
        """typ 수식 -> SVG"""
        if is_block:
            math_source = f"#math.equation(block: true)[$ {content.strip()} $]"
        else:
            math_source = f"${content.strip()}$"
            
        full_src = EQ_RENDER_TEMPLATE + "\n" + math_source
        
        with open("temp_eq.typ", "w", encoding="utf-8") as f:
            f.write(full_src)
        
        out_svg = os.path.abspath("temp_eq.svg")
        try:
            result = subprocess.run(["typst", "compile", "temp_eq.typ", out_svg], capture_output=True, text=True)
            if result.returncode != 0:
                print(f"--- 수식 렌더 에러 ---")
                print(f"수식 내용: {content.strip()}")
                print(f"오류: {result.stderr}")
                return None
            return out_svg
        except Exception as e:
            print(f"실행 오류: {e}")
            return None

    def clean_text_logic(self, text):
        """참조, 라벨, 이스케이프 시퀀스"""
        text = re.sub(r'@[a-zA-Z0-9:-]+\s+(?=[^@\s])', '식', text)
        text = re.sub(r'@[a-zA-Z0-9:-]+', '', text)
        text = re.sub(r'<[a-zA-Z0-9:-]+>', '', text)
        text = re.sub(r'\\(\s)', r'\n', text)
        text = re.sub(r'\\(.)', r'\1', text)
        return text

    def process_content(self, text):
        """텍스트 내부의 수식, 루비, 스타일(굵게/기울임), 각주 분석 및 입력"""
        pattern = r'(\$[\s\S]+?\$(\s*<[a-zA-Z0-9:-]+>)?|\#ruby\[[^\]]*\]\[[^\]]*\]|\*[^*]+\*|_[^_]+_|\#footnote\[[^\]]+\])'
        parts = re.split(pattern, text)

        for part in parts:
            if not part: continue

            if part.startswith('$'):
                first_dollar = part.find('$')
                last_dollar = part.rfind('$')
                math_content = part[first_dollar+1 : last_dollar].strip()
                
                clean_part = re.sub(r'<[a-zA-Z0-9:-]+>\s*$', '', part.strip())
                is_block = ('\n' in part) or (clean_part.startswith('$ ') and clean_part.endswith(' $'))
                
                img = self.render_math(math_content, is_block=is_block)
                if img:
                    if is_block:
                        self.hwp.BreakPara()
                        self.hwp.insert_picture(img, sizeoption=0, treat_as_char=True)
                        self.hwp.ParagraphShapeAlignCenter()
                        self.hwp.BreakPara()
                        self.hwp.ParagraphShapeAlignLeft()
                    else:
                        self.hwp.insert_picture(img, sizeoption=0, treat_as_char=True)

            elif part.startswith('#ruby'):
                m = re.match(r'#ruby\[(.*?)\]\[(.*?)\]', part)
                if m:
                    sub_t = m.group(1).replace("|", "")
                    main_t = m.group(2).replace("|", "")
                    self.hwp.insert_text(f"{main_t}({sub_t})")

            elif part.startswith('*'):
                self.hwp.set_font(Bold=True)
                self.process_content(part[1:-1])
                self.hwp.set_font(Bold=False)

            elif part.startswith('_'):
                self.hwp.set_font(Italic=True)
                self.process_content(part[1:-1])
                self.hwp.set_font(Italic=False)

            elif part.startswith('#footnote'):
                self.hwp.InsertFootnote()
                self.process_content(part[10:-1])
                self.hwp.CloseEx()

            elif part.startswith('#'):
                continue

            else:
                filtered = self.clean_text_logic(part)
                if '\n' in filtered:
                    lines = filtered.split('\n')
                    for i, l in enumerate(lines):
                        self.hwp.insert_text(l)
                        if i < len(lines)-1: self.hwp.BreakPara()
                else:
                    self.hwp.insert_text(filtered)

    def run(self, input_file, output_file):
        """typ -> hwp 매크로"""
        if not os.path.exists(input_file):
            print(f"파일을 찾을 수 없습니다: {input_file}")
            return

        with open(input_file, "r", encoding="utf-8") as f:
            data = f.read()

        # 쓸데없는 구문 제거, 전처리
        data = re.sub(r'#import.*?\n', '', data)
        data = re.sub(r'#quote(?:\(.*?\))?\s*\[(.*?)\]', r'\1', data, flags=re.DOTALL)

        # 문단이랑 헤딩 처리
        paragraphs = re.split(r'\n\s*\n', data)
        for para in paragraphs:
            para = para.strip()
            if not para: continue

            h_match = re.match(r'^(=+)\s+(.*)', para)
            if h_match:
                self.hwp.BreakPara()
                
                level = len(h_match.group(1))
                sizes = {1: 22, 2: 18, 3: 16, 4: 14}
                self.hwp.set_font(Height=sizes.get(level, 12), Bold=True)
                self.process_content(h_match.group(2))
                self.hwp.set_font(Height=10, Bold=False)
                self.hwp.BreakPara()
            else:
                self.process_content(para)
                self.hwp.BreakPara()

        self.hwp.save_as(os.path.abspath(output_file))
        print(f"변환 완료: {output_file}")

if __name__ == "__main__":
    c = TypstToHwpConverter()
    c.run("2.typ", "output.hwp")
