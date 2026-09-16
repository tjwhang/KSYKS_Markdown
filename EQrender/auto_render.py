import os
import re
import subprocess

# Configuration
BASE_DIR = os.path.dirname(os.path.abspath(__file__))
CHAPTERS_DIR = os.path.abspath(os.path.join(BASE_DIR, "../2026CAP/생2_ProteinQC/chapters"))
TEMPLATE_PATH = os.path.join(BASE_DIR, "EQrender.typ")
OUTPUT_DIR = os.path.join(BASE_DIR, "output")
FILES_TO_PROCESS = ["0.typ", "1.typ", "2.typ"]

# Ensure output directory exists
os.makedirs(OUTPUT_DIR, exist_ok=True)

# Read the template
with open(TEMPLATE_PATH, "r", encoding="utf-8") as f:
    template_content = f.read()

# Remove the existing example equation from the template
# Assuming the template ends with a display equation block
# We'll look for the last occurrence of $ ... $ block or just strip it if it's at the end
# A safer approach for the provided EQrender.typ is to remove everything from the last "$" block
# The provided EQrender.typ ends with:
# $
#     Psi = Lambda/A = (H S L)/(A) = 1/A (s (log_2 N - 1.2))/(a l)
# $
# We will remove this block to create a base template.

# Regex to find the last display math block at the end of the file
template_base = re.sub(r"\$\s*\n[\s\S]*?\n\s*\$\s*$", "", template_content).strip()


def extract_equations(file_path):
    with open(file_path, "r", encoding="utf-8") as f:
        content = f.read()

    # Regex to find display math blocks
    # Matches $ followed by newline, content, newline, $
    # This handles the format seen in the user's files
    pattern = r"^\$\s*\n([\s\S]*?)\n\s*\$"
    matches = re.findall(pattern, content, re.MULTILINE)
    return matches


equation_count = 0

for filename in FILES_TO_PROCESS:
    file_path = os.path.join(CHAPTERS_DIR, filename)
    if not os.path.exists(file_path):
        print(f"File not found: {file_path}")
        continue

    print(f"Processing {filename}...")
    equations = extract_equations(file_path)

    for eq_content in equations:
        equation_count += 1
        output_filename = f"eq_{equation_count}.svg"
        output_path = os.path.join(OUTPUT_DIR, output_filename)
        temp_typ_path = os.path.join(BASE_DIR, "temp_render.typ")

        # Construct the new typst file content
        # We append the equation to the template base
        new_content = f"{template_base}\n\n$\n{eq_content}\n$"

        with open(temp_typ_path, "w", encoding="utf-8") as f:
            f.write(new_content)

        # Run typst compiler
        try:
            cmd = ["typst", "c", "-f", "svg", temp_typ_path, output_path]
            subprocess.run(cmd, check=True, capture_output=True)
            print(f"Generated {output_filename}")
        except subprocess.CalledProcessError as e:
            print(f"Failed to render equation {equation_count} from {filename}")
            print(e.stderr.decode())

# Clean up temp file
if os.path.exists(os.path.join(BASE_DIR, "temp_render.typ")):
    os.remove(os.path.join(BASE_DIR, "temp_render.typ"))

print(f"Done. Processed {equation_count} equations.")
