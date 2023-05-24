# Create Fairseq Dataset
# Usage: bash preprocess.sh $1 $2
# $1: Directory of BPE Data
# $2: Directory of Fairseq Data
fairseq-preprocess --source-lang fi --target-lang en \
    --trainpref $1/train.bpe --validpref $1/dev.bpe --testpref $1/test.bpe \
    --destdir $2 --workers 20