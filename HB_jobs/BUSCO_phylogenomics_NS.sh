#!/bin/bash
#SBATCH --job-name=BUSCO_phylogenomics_NS
#SBATCH --time=0-6:00:00
#SBATCH --mail-user=nsurendr@ucsc.edu
#SBATCH --mail-type=ALL
#SBATCH --output=BUSCO_phylogenomics_NS.out
#SBATCH --error=BUSCO_phylogenomics_NS.err
#SBATCH --ntasks=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=12GB


# Activate BUSCO_phylogenomics conda env
module load miniconda3.9
conda activate /hb/groups/kelley_training/nathan/BUSCO_phylogenomics_supp

# Go to working directory
cd /hb/home/nsurendr/6_22assembly

# Run pipeline command
python /hb/groups/kelley_training/nathan/BUSCO_phylogenomics/BUSCO_phylogenomics.py \
 -i BUSCO_results -o output_busco_phylogenomics -t 8

## If data look patchy, run python <python count_buscos.py -i BUSCO_runs>
