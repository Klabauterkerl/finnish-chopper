#!/bin/bash

# This script applies the learned BPE model and vocabulary to the data

set -e  # Exit immediately if any command fails

if [ ! -d "$1" ]; then
  echo "Directory not found: $1"
  exit 1
fi

if [ ! -f "$1/bpe.codes" ] || [ ! -f "$1/vocab.fi" ] || [ ! -f "$1/vocab.en" ]; then
  echo "Required files not found in directory: $1"
  exit 1
fi

# Iterate over the sets
for set_name in "${sets[@]}"
do
    # Apply the learned BPE model and vocabulary
    subword-nmt apply-bpe -c "$1/bpe.codes" --vocabulary "$1/vocab.fi" < "$1/${set_name}.tok.clean.en" > "$1/${set_name}.bpe.fi"
    subword-nmt apply-bpe -c "$1/bpe.codes" --vocabulary "$1/vocab.en" < "$1/${set_name}.tok.clean.en" > "$1/${set_name}.bpe.en"
done
