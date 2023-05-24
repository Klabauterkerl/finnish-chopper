#!/bin/bash

# This script deletes all files in a directory that don't contain the sequence "fien" or "enfi" in their name

# Check if the directory path is provided as an argument
if [ -z "$1" ]; then
  echo "Please provide a directory path"
  exit 1
fi

# Store the directory path provided as an argument
dir="$1"

# Loop through all files in the directory
for file in "$dir"/*; do
  # Check if the file name contains "fien" or "enfi"
  if [[ $file != *"fien"* && $file != *"enfi"* ]]; then
    # Delete the file if it doesn't contain the required sequence
    rm "$file"
    echo "Deleted file: $file"
  fi
done
