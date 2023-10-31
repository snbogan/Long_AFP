#!/bin/bash
#SBATCH --job-name=IQtree_supermatrix
#SBATCH --time=0-12:00:00
#SBATCH --mail-user=snbogan@ucsc.edu
#SBATCH --mail-type=ALL
#SBATCH --output=IQtree_supermatrix.out
#SBATCH --error=IQtree_supermatrix.err
#SBATCH --ntasks=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=12GB

# Activate BUSCO_phylogenomics conda env
module load miniconda3.9
conda activate /hb/home/snbogan/BUSCO_phylogenomics_supp

# Go to BUSCO_phylogenomics directory w/ supermatrix alignment
cd /hb/home/snbogan/PolarFish/Long_AFP/output_busco_phylogenomics/supermatrix

# Run phyml on supermatrix alignment
iqtree -s SUPERMATRIX.phylip -m MFP


