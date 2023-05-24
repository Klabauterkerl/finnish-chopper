# !/bin/bash
# Usage: bash learn_bpe.sh $1
# $1: Directory of Dataset


# Learn a joint BPE model and vocabulary
subword-nmt learn-joint-bpe-and-vocab \
    --input $1/train.tok.clean.fi $1/train.tok.clean.en -s 32000 \
    -o $1/bpe.codes --write-vocabulary $1/vocab.fi $1/vocab.en