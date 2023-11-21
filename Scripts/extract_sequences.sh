#!/bin/bash

# Script to extract sequences from BLAST results

species=("alupus.asm.p_ctg" "aminor.asm.p_ctg" "bsig.asm.p_ctg" \
"byu.asm.p_ctg" "Cviol1.0.p_genomic" "Gacul_UGA_v5_genomic" \
"Lmac1_p1.0_genomic" "Lpac_genomic" "Melgel1.1_genomic" \
"norway.asm.p_ctg" "oamb.asm.p_ctg" "Pgunn1.2_genomic")

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 blast_output genome_fasta"
    exit 1
fi

BLAST_OUTPUT=$1
GENOME_FASTA=$2

# Check if genome fasta is indexed
if [ ! -f "/blast_dbs/${species[@]}.fai" ]; then
    echo "Indexing genome fasta..."
    samtools faidx $${species[@]}
fi

# Function to extract sequence
extract_sequence() {
    local region=$1
    samtools faidx ${species[@]} "$region"
}

# Process BLAST output
awk 'BEGIN {OFS="\t"} {print $2, $9, $10}' $BLAST_OUTPUT | \
while read -r contig start end; do
    # Adjust for zero-based, half-open interval used by samtools
    start=$((start - 1))

    # Ensure correct ordering of start and end
    if [ $start -gt $end ]; then
        tmp=$start
        start=$end
        end=$tmp
    fi

    # Extract sequence
    region="${contig}:${start}-${end}"
    extract_sequence $region
done

exit 0
