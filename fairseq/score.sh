# Compute BLEU score
# Usage: bash score.sh $1 $2
# $1: System Output
# $2: Reference
fairseq-score --sys $1 --ref $2 --sacrebleu
