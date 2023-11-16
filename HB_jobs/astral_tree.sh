#!/bin/bash
#SBATCH --job-name=astral_tree
#SBATCH --mail-user=snbogan@ucsc.edu
#SBATCH --mail-type=ALL
#SBATCH --output=astral_tree.out
#SBATCH --error=astral_tree.err
#SBATCH --time=01:00:00
#SBATCH --ntasks=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=12GB

# Move to working directory
cd /hb/home/snbogan/PolarFish/Long_AFP/output_busco_phylogenomics/gene_trees_single_copy

# Load java
module load java

# Run ASTRAL to create the multigene consensus tree
java -jar /hb/home/snbogan/Astral/astral.5.7.8.jar \
-i /hb/home/snbogan/PolarFish/Long_AFP/output_busco_phylogenomics/gene_trees_single_copy/ALL.tree \
-o /hb/home/snbogan/PolarFish/Long_AFP/output_busco_phylogenomics/gene_trees_single_copy/ASTRAL_out.tree \
2>ASTRAL_out.log

echo "ASTRAL analysis complete."
