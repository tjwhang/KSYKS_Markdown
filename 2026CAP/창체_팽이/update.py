import sys

with open(r'c:\Users\tonyw\AppData\Local\typst\packages\preview\physica\0.9.5\physica.typ', 'r', encoding='utf-8') as f:
    text = f.read()

with open('physica_git.typ', 'r', encoding='utf-8') as f:
    git_text = f.read()

def get_block(t, st, en):
    start = t.find(st)
    if start == -1: return ''
    end = t.find(en, start)
    if end == -1: return ''
    return t[start:end]

git_dd = get_block(git_text, '#let differential', '#let dd = differential\n')
user_dd = get_block(text, '#let differential', '#let dd = differential\n')
if user_dd and git_dd:
    text = text.replace(user_dd, git_dd)

git_dv = get_block(git_text, '#let __derivative_display', '#let dv = derivative\n')
user_dv = get_block(text, '#let __derivative_display', '#let dv = derivative\n')
if user_dv and git_dv:
    text = text.replace(user_dv, git_dv)

git_pdv = get_block(git_text, '#let partialderivative', '#let pdv = partialderivative\n')
user_pdv = get_block(text, '#let partialderivative', '#let pdv = partialderivative\n')
if user_pdv and git_pdv:
    text = text.replace(user_pdv, git_pdv)

git_sig = get_block(git_text, '  } else if e == "X" {', '  } else {\n')
user_sig = get_block(text, '  } else if e == "X" {', '  } else {\n')
if user_sig and git_sig:
    text = text.replace(user_sig, git_sig)

with open(r'c:\Users\tonyw\AppData\Local\typst\packages\preview\physica\0.9.5\physica.typ', 'w', encoding='utf-8') as f:
    f.write(text)

print('Updated successfully')
