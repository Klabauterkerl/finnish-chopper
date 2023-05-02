import os
import sys
import glob
from bs4 import BeautifulSoup

def sgm_to_text(sgm_file):
    """
    Convert an SGM file to plain text format.
    """
    with open(sgm_file, 'r') as f:
        soup = BeautifulSoup(f, 'html.parser')
        segments = soup.find_all('seg')
        text = [segment.text for segment in segments]
        return '\n'.join(text)

# Set the paths for the input and output directories
input_dir = sys.argv[1]
output_dir =  sys.argv[2]

# Create the output directory if it doesn't exist
os.makedirs(output_dir, exist_ok=True)

# Loop through all the SGM files in the input directory and convert them to plain text format
for sgm_file in glob.glob(os.path.join(input_dir, '*.sgm')):
    text = sgm_to_text(sgm_file)
    output_file = os.path.join(output_dir, os.path.basename(sgm_file).replace('.sgm', '.txt'))
    with open(output_file, 'w') as f:
        f.write(text)
