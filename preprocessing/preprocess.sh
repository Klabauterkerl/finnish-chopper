#!/bin/bash

# This script preprocesses the data for the NMT model

# Array of set names
sets=("test" "train" "dev")

# Iterate over the sets
for set_name in "${sets[@]}"
do
    # Normalize punctuation and tokenize Finnish text
    cat $1/${set_name}.fi | mosesdecoder/scripts/tokenizer/normalize-punctuation.perl fi | mosesdecoder/scripts/tokenizer/tokenizer.perl -threads 8 -no-escape -l fi > $1/${set_name}.tok.fi

    # Normalize punctuation and tokenize English text
    cat $1/${set_name}.en | mosesdecoder/scripts/tokenizer/normalize-punctuation.perl en | mosesdecoder/scripts/tokenizer/tokenizer.perl -threads 8 -no-escape -l en > $1/${set_name}.tok.en

    # Truecase the tokenized Finnish text
    mosesdecoder/scripts/recaser/truecase.perl -model $1/truecase-model.fi < $1/${set_name}.tok.fi > $1/${set_name}.tok.truecase.fi

    # Truecase the tokenized English text
    mosesdecoder/scripts/recaser/truecase.perl -model $1/truecase-model.en < $1/${set_name}.tok.en > $1/${set_name}.tok.truecase.en

    # Clean the corpus
    mosesdecoder/scripts/training/clean-corpus-n.perl $1/${set_name}.tok.truecase en fi $1/${set_name}.tok.clean 1 50
done
