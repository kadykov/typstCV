#!/bin/sh -l

set -e
just build
mkdir -p ${INPUTS_OUTPUT_FOLDER}
cp *.pdf *.html ${INPUTS_OUTPUT_FOLDER}/
files=$(ls ${INPUTS_OUTPUT_FOLDER}/)
echo -e "Files in the ${INPUTS_OUTPUT_FOLDER} folder:\n$files"
