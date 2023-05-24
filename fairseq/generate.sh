# Generate translations
# Usage: bash generate.sh $1 $2 $3
# $1: Directory of Fairseq Data
# $2: Directory of Model
fairseq-generate $1 \
    --path $2/checkpoint_best.pt \
    --batch-size 128 --beam 5 --remove-bpe \
    > $3