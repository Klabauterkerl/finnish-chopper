import re
import sys

def pos_tag_morfessor(morfessor_text):
    pos_tags = []

    noun_suffixes = ['kauden', 'ssa', 'ssä', 'sta', 'stä', 'lle', 'lta', 'ltä', 'ine', 'one']
    verb_suffixes = ['aa', 'ää', 'an', 'än', 'asi', 'äsi', 'asi', 'ämme', 'ette', 'ivat', 'ivät', 'in', 'isin', 'isi', 'isimme', 'isitte', 'isivat', 'isivät', 'nut', 'nyt', 'neet', 'ma', 'mä', 'va', 'vä']
    adjective_suffixes = ['inen', 'llinen', 'mpi', 'in', 'ton', 'tön', 'llinen']

    lines = morfessor_text.split('\n')


    for line in lines:
        line = line.strip()
        if not line:
            continue

        if any(line.endswith(suffix) for suffix in noun_suffixes):
            pos_tag = 'N'
        elif any(line.endswith(suffix) for suffix in verb_suffixes):
            pos_tag = 'V'
        elif any(line.endswith(suffix) for suffix in adjective_suffixes):
            pos_tag = 'A'
        else:
            pos_tag = 'UNK'

        pos_tags.append((re.sub('@@', '', line), pos_tag))

    pos_tagged_text = '\n'.join([f'{token}\t{tag}' for token, tag in pos_tags])
    return pos_tagged_text

morfessor_text = sys.argv[1]