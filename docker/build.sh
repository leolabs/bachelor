#!/bin/sh

ROOT="$(pwd)/src"
TEXTBUNDLE="$ROOT/content.textbundle"
ASSETS="$TEXTBUNDLE/assets"
TEMPLATE="$ROOT/template"

# Move into a folder if it exists,
# else abort the program with error
safe_cd() {
  cd "$1" || (fail_echo "$1 not found.")
}

# Echo in rex text and abort
fail_echo() {
  echo "\e[41m$1\e[39m"
  exit 1
}

# Echo in green text
blue_echo() {
  echo "\e[34m$1\e[39m"
}

cleanup() {
  # Remove Pandoc Output
  safe_cd "$TEXTBUNDLE"
  rm -f -- *.tex *.tex-e

  # Remove convertd images
  safe_cd "$ASSETS"
  rm -f -- *-converted.jpg *-converted-*.jpg

  # Remove LaTeX Output
  safe_cd "$TEMPLATE"
  rm -f -- *.aux *.fdb_latexmk *.fls *.lof *.lot *.log *.out *.synctex.gz *.toc *.bcf *.blg *.dvi *.run.xml *.out.ps
}

# First, clean up
blue_echo "Cleaning directories..."
cleanup

# Build TeX from Markdown
blue_echo "Building TeX from Markdown..."
safe_cd "$TEXTBUNDLE"
pandoc --filter pandoc-citeproc \
  --bibliography ../bibliography/bibliography.bib --biblatex \
  -o text.tex text.md
  #--top-level-division=chapter \

# Convert TIFF Images to JPG
blue_echo "Converting images that are not compatible with pdfLaTeX..."
safe_cd "$ASSETS"
for f in *.tiff *.tif
do
    if [ ! -f "$f" ]; then
      continue
    fi

    filename="$(basename -- "$f")-converted.jpg"
    echo "Converting $f"
    convert "$f" -flatten "$filename" && sed -i -e "s|$f|$filename|g" ../text.tex
done

# Build PDF from TeX
blue_echo "Building PDF from TeX..."
safe_cd "$TEMPLATE"
latexmk -pdf -f --interaction=batchmode index.tex || exit 1

# Copy files
blue_echo "Copying the result to output..."
cp index.pdf /output/bachelors-thesis.pdf

# Cleanup (again)
blue_echo "Cleaning up..."
