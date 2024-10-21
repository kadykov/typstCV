set dotenv-load

build:
  typst compile \
  kadykov-cv.typ

build-private:
  typst compile \
  kadykov-cv.typ \
  --input EMAIL='{{env_var("EMAIL")}}' \
  --input PHONE='{{env_var("PHONE")}}'
