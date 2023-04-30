# Tokenize and lowercase the data
for lang in en fi; do
    for f in data/europarl-v9.fi-en.${lang}; do
        cat $f | mosesdecoder/scripts/tokenizer/lowercase.perl | \
        mosesdecoder/scripts/tokenizer/tokenizer.perl -threads 8 -l $lang > $f.tok.${lang}
    done
done

# Create train, valid, and test splits
for lang in en fi; do
    awk "NR%100!=0{print > \"train.tok.$lang\"} NR%100==0{print > \"data/tmp.tok.$lang\"}" data/europarl-v9.fi-en.tok.${lang}
    awk "NR%10!=0{print > \"valid.tok.$lang\"} NR%10==0{print > \"test.tok.$lang\"}" tmp.tok.${lang}
    rm tmp.tok.${lang}
done

# Learn BPE
subword-nmt learn-joint-bpe-and-vocab --input train.tok.fi train.tok.en -s 32000 -o bpe.codes --write-vocabulary vocab.fi vocab.en

# Apply BPE
for split in train valid test; do
    for lang in en fi; do
        subword-nmt apply-bpe -c bpe.codes --vocabulary vocab.${lang} < ${split}.tok.${lang} > ${split}.bpe.${lang}
    done
done

# Create fairseq dataset
fairseq-preprocess --source-lang fi --target-lang en --trainpref train.bpe --validpref valid.bpe --testpref test.bpe --destdir data-bin/fi-en --joined-dictionary --workers 8