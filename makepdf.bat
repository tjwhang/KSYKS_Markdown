@title Build Thesis pdf
@echo off
set /p md = Name of markdown file to render: 
set /p title= Input the output pdf file name: 

echo Building %title%.pdf...
pandoc %md%.md -o %title%.pdf --pdf-engine=xelatex
echo Operation complete.

set \p key=Press any key to continue...

pause
