#!/bin/bash

MAIN=bundler-main

# Run bibtex to generate the bbl file.
bibtex ${MAIN}

# Grab only the TeX source files that are actually used / referenced in another file.
SRC_FILES=(`egrep -h "(include|input)[^\}]*}" *.tex | grep -v "\%" | grep -v "\\use" | sed 's/.*{//' | sed 's/}/.tex/' | tr "\n" " "`)
SRC_FILES+=(
    ${MAIN}.tex
    ${MAIN}.bbl
    acmart.cls
)
# Grab only the graphics referenced in some TeX file. 
SRC_PDFS=(`egrep -h "includegraphics" *.tex | grep -v "%" | sed 's/.*{//' | sed 's/}/.pdf/' | sed 's/pdf.pdf/pdf/g' | tr "\n" " "`)

echo "> Found ${#SRC_FILES[@]} tex files: ${SRC_FILES[@]}" 
echo "> Found ${#SRC_PDFS[@]} graphics: ${SRC_PDFS[@]}"

tar -czvf ${MAIN}-arxiv.tgz ${SRC_FILES[@]} ${SRC_PDFS[@]}
