set dotenv-load
filename := "kadykov"
cv := "cv"
letter := "letter"
english := "en"
french := "fr"
output-dir := "."
typst := "typst compile"
pandoc := "pandoc --data-dir=$PANDOC_DATA_DIR --wrap=preserve --pdf-engine=typst --lua-filter=linkify.lua --lua-filter=typst-cv.lua"
pandoc-to-typst := "--to=typst | typst compile -"
private-args := '--input EMAIL="$EMAIL" --input PHONE="$PHONE"'


build:
  just english
  just french

build-private:
  just english-private
  just french-private

english:
  mkdir -p {{output-dir}}
  {{pandoc}} \
  {{filename}}-{{cv}}-{{english}}.md \
  -o {{output-dir}}/{{filename}}-{{cv}}-{{english}}.pdf \
  --template=typst-{{cv}}.typ
  {{pandoc}} \
  {{filename}}-{{letter}}-{{english}}.md \
  -o {{output-dir}}/{{filename}}-{{letter}}-{{english}}.pdf \
  --template=typst-{{letter}}.typ

english-private:
  mkdir -p {{output-dir}}
  {{pandoc}} \
  {{filename}}-{{cv}}-{{english}}.md \
  --template=typst-{{cv}}.typ \
  {{pandoc-to-typst}} \
  {{output-dir}}/{{filename}}-{{cv}}-{{english}}.pdf \
  {{private-args}}
  {{pandoc}} \
  {{filename}}-{{letter}}-{{english}}.md \
  --template=typst-{{letter}}.typ \
  {{pandoc-to-typst}} \
  {{output-dir}}/{{filename}}-{{letter}}-{{english}}.pdf \
  {{private-args}}

french:
  mkdir -p {{output-dir}}
  {{pandoc}} \
  {{filename}}-{{cv}}-{{french}}.md \
  -o {{output-dir}}/{{filename}}-{{cv}}-{{french}}.pdf \
  --template=typst-{{cv}}.typ
  {{pandoc}} \
  {{filename}}-{{letter}}-{{french}}.md \
  -o {{output-dir}}/{{filename}}-{{letter}}-{{french}}.pdf \
  --template=typst-{{letter}}.typ

french-private:
  mkdir -p {{output-dir}}
  {{pandoc}} \
  {{filename}}-{{cv}}-{{french}}.md \
  --template=typst-{{cv}}.typ \
  {{pandoc-to-typst}} \
  {{output-dir}}/{{filename}}-{{cv}}-{{french}}.pdf \
  {{private-args}}
  {{pandoc}} \
  {{filename}}-{{letter}}-{{french}}.md \
  --template=typst-{{letter}}.typ \
  {{pandoc-to-typst}} \
  {{output-dir}}/{{filename}}-{{letter}}-{{french}}.pdf \
  {{private-args}}
