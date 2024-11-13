#!/bin/sh -l

set -e

# Use the correct environment variable for the input
output_folder="${INPUT_OUTPUT-FOLDER}"

# Ensure the output folder exists
mkdir -p "$output_folder"

# Copy generated files to the output folder
cp *.pdf *.html "$output_folder/"

# List files in the output folder and print them
files=$(ls "$output_folder/")
echo -e "Files in the $output_folder folder:\n$files"
