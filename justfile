set dotenv-load
filename := "kadykov"
cv := "cv"
letter := "letter"
english := "en"
french := "fr"

build:
  just english
  just french

build-private:
  just english-private
  just french-private

english:
  typst compile \
  {{filename}}-{{cv}}-{{english}}.typ
  pandoc \
  {{filename}}-{{letter}}-{{english}}.md \
  -o {{filename}}-{{letter}}-{{english}}.pdf \
  --pdf-engine=typst \
  --wrap=preserve \
  --template=typst-{{letter}}.typ

english-private:
  typst compile \
  {{filename}}-{{cv}}-{{english}}.typ \
  --input EMAIL="$EMAIL" \
  --input PHONE="$PHONE"
  pandoc \
  {{filename}}-{{letter}}-{{english}}.md \
  -o {{filename}}-{{letter}}-{{english}}.typ \
  --wrap=preserve \
  --template=typst-{{letter}}.typ
  typst compile \
  {{filename}}-{{letter}}-{{english}}.typ \
  --input EMAIL="$EMAIL" \
  --input PHONE="$PHONE"
  rm {{filename}}-{{letter}}-{{english}}.typ

french:
  typst compile \
  {{filename}}-{{cv}}-{{french}}.typ
  pandoc \
  {{filename}}-{{letter}}-{{french}}.md \
  -o {{filename}}-{{letter}}-{{french}}.pdf \
  --pdf-engine=typst \
  --wrap=preserve \
  --template=typst-{{letter}}.typ

french-private:
  typst compile \
  {{filename}}-{{cv}}-{{french}}.typ \
  --input EMAIL="$EMAIL" \
  --input PHONE="$PHONE"
  pandoc \
  {{filename}}-{{letter}}-{{french}}.md \
  -o {{filename}}-{{letter}}-{{french}}.typ \
  --wrap=preserve \
  --template=typst-{{letter}}.typ
  typst compile \
  {{filename}}-{{letter}}-{{french}}.typ \
  --input EMAIL="$EMAIL" \
  --input PHONE="$PHONE"
  rm {{filename}}-{{letter}}-{{french}}.typ

typst:
  pandoc \
  {{filename}}-{{letter}}-{{english}}.md \
  -o {{filename}}-{{letter}}-{{english}}.typ \
  --wrap=preserve \
  --template=typst-{{letter}}.typ

letter:
  pandoc \
  {{filename}}-{{letter}}-{{english}}.md \
  -o {{filename}}-{{letter}}-{{english}}.pdf \
  --pdf-engine=typst \
  --wrap=preserve \
  --template=typst-{{letter}}.typ

letter-private:
  pandoc \
  {{filename}}-{{letter}}-{{english}}.md \
  -o {{filename}}-{{letter}}-{{english}}.typ \
  --wrap=preserve \
  --template=typst-{{letter}}.typ
  typst compile \
  {{filename}}-{{letter}}-{{english}}.typ \
  --input EMAIL="$EMAIL" \
  --input PHONE="$PHONE"
  rm {{filename}}-{{letter}}-{{english}}.typ

cv:
  pandoc \
  test-{{cv}}-{{english}}.md \
  -o test-{{cv}}-{{english}}.typ \
  --template=typst-{{cv}}.typ \
  --lua-filter=typst-cv.lua

cv-pdf:
  pandoc \
  test-{{cv}}-{{english}}.md \
  -o test-{{cv}}-{{english}}.pdf \
  --template=typst-{{cv}}.typ \
  --pdf-engine=typst \
  --lua-filter=typst-cv.lua
