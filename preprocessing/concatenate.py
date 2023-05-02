import os
import sys

# Create dictionaries to hold the contents of each file
enfi_ref_files = {}
fien_ref_files = {}
enfi_src_files = {}
fien_src_files = {}

# Set the directory path where the text files are located
dir_path = sys.argv[1]

# Get a sorted list of all text files in the directory
text_files = sorted([f for f in os.listdir(dir_path) if f.endswith('.txt')])

# Loop through all text files in the directory
for filename in text_files:
    # Open the file and read its contents
    with open(os.path.join(dir_path, filename), 'r') as file:
        text = file.read()
        
    # Add the text to the appropriate dictionary based on the filename
    if 'enfi-ref' in filename:
        if filename in enfi_ref_files:
            enfi_ref_files[filename] += '\n' + text
        else:
            enfi_ref_files[filename] = text
    elif 'fien-ref' in filename:
        if filename in fien_ref_files:
            fien_ref_files[filename] += '\n' + text
        else:
            fien_ref_files[filename] = text
    elif 'enfi-src' in filename:
        if filename in enfi_src_files:
            enfi_src_files[filename] += '\n' + text
        else:
            enfi_src_files[filename] = text
    elif 'fien-src' in filename:
        if filename in fien_src_files:
            fien_src_files[filename] += '\n' + text
        else:
            fien_src_files[filename] = text

# Write the contents of each dictionary to a separate file, preserving the order of the input files
with open('enfi-ref.txt', 'w') as file:
    for filename in text_files:
        if filename in enfi_ref_files:
            text = enfi_ref_files[filename]
            file.write(text + '\n')

with open('fien-ref.txt', 'w') as file:
    for filename in text_files:
        if filename in fien_ref_files:
            text = fien_ref_files[filename]
            file.write(text + '\n')

with open('enfi-src.txt', 'w') as file:
    for filename in text_files:
        if filename in enfi_src_files:
            text = enfi_src_files[filename]
            file.write(text + '\n')

with open('fien-src.txt', 'w') as file:
    for filename in text_files:
        if filename in fien_src_files:
            text = fien_src_files[filename]
            file.write(text + '\n')
