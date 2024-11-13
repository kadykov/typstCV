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
  typst compile \
  {{filename}}-{{letter}}-{{english}}.typ

english-private:
  typst compile \
  {{filename}}-{{cv}}-{{english}}.typ \
  --input EMAIL="$EMAIL" \
  --input PHONE="$PHONE"
  typst compile \
  {{filename}}-{{letter}}-{{english}}.typ \
  --input EMAIL="$EMAIL" \
  --input PHONE="$PHONE"

french:
  typst compile \
  {{filename}}-{{cv}}-{{french}}.typ
  typst compile \
  {{filename}}-{{letter}}-{{french}}.typ

french-private:
  typst compile \
  {{filename}}-{{cv}}-{{french}}.typ \
  --input EMAIL="$EMAIL" \
  --input PHONE="$PHONE"
  typst compile \
  {{filename}}-{{letter}}-{{french}}.typ \
  --input EMAIL="$EMAIL" \
  --input PHONE="$PHONE"
