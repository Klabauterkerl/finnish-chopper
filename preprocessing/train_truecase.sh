# Train truecaser model for Finnish and English

# Train truecaser model for Finnish
mosesdecoder/scripts/recaser/train-truecaser.perl -corpus $1/train.fi -model $1/truecase-model.fi

# Train truecaser model for English
mosesdecoder/scripts/recaser/train-truecaser.perl -corpus $1/train.en -model $1/truecase-model.en