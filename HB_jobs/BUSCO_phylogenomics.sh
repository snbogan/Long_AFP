#!/bin/bash
#SBATCH --job-name=BUSCO_phylogenomics
#SBATCH --time=0-3:00:00
#SBATCH --mail-user=snbogan@ucsc.edu
#SBATCH --mail-type=ALL
#SBATCH --output=BUSCO_phylogenomics.out
#SBATCH --error=BUSCO_phylogenomics.err
#SBATCH --ntasks=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=12GB

##################################
#### NS should start here ####
##################################

# Activate BUSCO_phylogenomics conda env
module load miniconda3.9
conda activate /hb/home/snbogan/BUSCO_phylogenomics_supp

# Go to working directory
cd /hb/home/snbogan/PolarFish/Long_AFP/

# Run pipeline command
python /hb/home/snbogan/BUSCO_phylogenomics/BUSCO_phylogenomics.py \
 -i BUSCO_results -o output_busco_phylogenomics -t 8

## If data look patchy, run python <python count_buscos.py -i BUSCO_runs>
