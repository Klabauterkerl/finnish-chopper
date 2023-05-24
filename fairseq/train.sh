# Train Model
# Usage: bash train.sh $1 $2 $3
# $1: Directory of Fairseq Data
# $2: Directory of Tensorboard Log
# $3: Directory of Model
fairseq-train $1 \
    --arch transformer --share-decoder-input-output-embed \
    --optimizer adam --adam-betas '(0.9, 0.98)' --clip-norm 0.0 \
    --lr 5e-4 --lr-scheduler inverse_sqrt --warmup-updates 4000 \
    --dropout 0.3 --weight-decay 0.0001 \
    --criterion label_smoothed_cross_entropy --label-smoothing 0.1 \
    --max-tokens 8192 \
    --save-interval 1 \
    --keep-last-epochs 5 --log-format simple --log-interval 100 \
    --tensorboard-logdir $2 \
    --save-dir $3 \
    --amp --task translation\
    --eval-bleu \
    --eval-bleu-args '{"beam": 5, "max_len_a": 1.2, "max_len_b": 10}' \
    --eval-bleu-detok moses \
    --eval-bleu-remove-bpe \
    --eval-bleu-print-samples \
    --best-checkpoint-metric bleu --maximize-best-checkpoint-metric