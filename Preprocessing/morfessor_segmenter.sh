morfessor -t data/tokenized-europarl-v9.fi -s data/model_full.bin
morfessor -l data/model.bin -T - < data/tokenized-europarl-v9.fi > data/tokenized-europarl-v9.fi.segmented
morfessor -l data/model.bin -T - --output-newlines --output-format "{analysis}  " --output-format-separator "@@ " < data/tokenized-europarl-v9.fi > data/tokenized-europarl-v9.fi.segmented
