#!/bin/bash

# Target directory containing .fa files
TARGET_DIR="/Users/sambogan/Documents/GitHub/Long_AFP/Hand_Annot/GetFasta"

# Output file
OUTPUT_FILE="combined.fa"

# Navigate to target directory
cd "$TARGET_DIR"

# Check if output file already exists
if [ -f "$OUTPUT_FILE" ]; then
    echo "Output file $OUTPUT_FILE already exists. Removing it."
    rm "$OUTPUT_FILE"
fi

# Concatenate all .fa files into one
for file in *.fa; do
    cat "$file" >> "$OUTPUT_FILE"
    echo "Concatenated $file"
done

echo "All .fa files have been concatenated into $OUTPUT_FILE."
