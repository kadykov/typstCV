set dotenv-load
cv-name := "kadykov-cv"
letter-name := "kadykov-letter"

build:
  typst compile \
  {{cv-name}}.typ

build-private:
  typst compile \
  {{cv-name}}.typ \
  --input EMAIL="$EMAIL" \
  --input PHONE="$PHONE"

build-letter:
  typst compile \
  {{letter-name}}.typ \
  --input EMAIL="$EMAIL" \
  --input PHONE="$PHONE"
