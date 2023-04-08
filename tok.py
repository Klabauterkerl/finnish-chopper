import nltk
import sys


# download punkt tokenizer
# nltk.download('punkt')

# read from file
with open(sys.argv[1], "r", encoding="utf-8") as f:
    print("Reading from file: " + sys.argv[1])
    file = f.read()

# split into lines
lines = file.splitlines()

# tokenize each line
tokized_lines = [nltk.word_tokenize(line) for line in lines]

# join tokens with space
tokenized_text = [" ".join(tokens) for tokens in tokized_lines]

# write to file
with open(sys.argv[2], "w", encoding="utf-8") as f:
    print("Writing to file: " + sys.argv[2])
    f.write("\n".join(tokenized_text))
