import sys

with open(sys.argv[0], 'r') as f:
    column1 = open('data/column1.txt', 'w')
    column2 = open('data/column2.txt', 'w')
    for line in f:
        fields = line.strip().split('\t')
        if len(fields) != 2:
            continue
        column1.write(fields[0] + '\n')
        column2.write(fields[1] + '\n')
    column1.close()
    column2.close()
