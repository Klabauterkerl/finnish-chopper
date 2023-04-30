import sys

with open(sys.argv[1], "r") as f:
    sentences = f.read().split("\n")

with open(sys.argv[2], "w") as f:
    for sentence in sentences:
        tokens = sentence.split()
        for token in tokens:
            f.write(token + "\n")
        f.write("\n")
