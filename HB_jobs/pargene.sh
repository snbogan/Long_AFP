#!/bin/bash
#SBATCH --job-name=pargene
#SBATCH --mail-user=snbogan@ucsc.edu
#SBATCH --mail-type=ALL
#SBATCH --output=pargene.out
#SBATCH --error=pargene.err
#SBATCH --time=06:00:00
#SBATCH --ntasks=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=12GB

# Move to working directory
cd /hb/home/snbogan/PolarFish/Long_AFP/output_busco_phylogenomics/gene_trees_single_copy

# Load java
module load java

# Load PARGENE module if available
module load pargene

# Define directory containing .tree files
TREE_DIR="/path/to/tree/files"

# Define output directory
OUTPUT_DIR="/path/to/output"

# Create output directory if it doesn't exist
mkdir -p $OUTPUT_DIR

# Run PARGENE
pargene --input $TREE_DIR --output $OUTPUT_DIR
