#!/bin/sh -l

set -e
just build
mkdir -p public
cp *.pdf *.html public/
files=$(ls public/)
echo -e "Files in the public folder:\n$files"
