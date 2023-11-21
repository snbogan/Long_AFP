#!/bin/bash
#SBATCH --job-name=SAS_AFP_blast
#SBATCH --time=0-12:00:00
#SBATCH --mail-user=snbogan@ucsc.edu
#SBATCH --mail-type=ALL
#SBATCH --output=SAS_AFP_blast.out
#SBATCH --error=SAS_AFP_blast.err
#SBATCH --ntasks=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=12GB

# Move to directory of query and alignment fasta's
cd /hb/home/snbogan/PolarFish/Long_AFP/SAS_AFP

# Load modules (example, depends on your system)
module load blast
module load samtools

# Define genes and species
genes=("SASA" "SASB" "AFPIII")

species=("alupus.asm.p_ctg" "aminor.asm.p_ctg" "bsig.asm.p_ctg" \
"byu.asm.p_ctg" "Cviol1.0.p_genomic" "Gacul_UGA_v5_genomic" \
"Lmac1_p1.0_genomic" "Lpac_genomic" "Melgel1.1_genomic" \
"norway.asm.p_ctg" "oamb.asm.p_ctg" "Pgunn1.2_genomic")

# Create directories
mkdir -p blast_dbs

# Create BLAST databases for each genome
for sp in "${species[@]}"; do
    makeblastdb -in "${sp}.fa" -dbtype nucl -out "blast_dbs/${sp}"
done

# Blast for each gene in each species
for gene in "${genes[@]}"; do
    for sp in "${species[@]}"; do
        blastn -query "${gene}.fa" \
               -db "blast_dbs/${sp}" \
               -out "blast_results/${gene}_${sp}.out" \
               -outfmt "6 std sstart send"
    done
done

# Extract fasta sequences using blastdbcmd
for gene in "${genes[@]}"; do
    for sp in "${species[@]}"; do
        while read -r sseqid sstart send; do
            blastdbcmd -db "blast_dbs/${sp}" -entry "$sseqid" -range "$sstart"-"$send" >> "fasta_sequences/${gene}_${sp}.fasta"
        done < <(awk '{print $2,$9,$10}' "blast_results/${gene}_${sp}.out")
    done
done
