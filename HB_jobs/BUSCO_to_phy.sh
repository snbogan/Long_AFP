#!/bin/bash
#SBATCH --job-name=BUSCO_to_phy
#SBATCH --time=0-48:00:00
#SBATCH --mail-user=snbogan@ucsc.edu
#SBATCH --mail-type=ALL
#SBATCH --output=BUSCO_to_phy.out
#SBATCH --error=BUSCO_to_phy.err
#SBATCH --ntasks=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=12GB

# Activate BUSCO_to_phylogenomics environment
module load miniconda3
conda activate BUSCO_phylogenomics

# Load BUSCO and parallel
module load busco
module load parallel

# Go to home directory
cd /hb/home/snbogan/

# Make BUSCO_results directory
mkdir /hb/home/snbogan/PolarFish/Long_AFP/BUSCO_results

# Go to folder with .fa genomes
cd /hb/home/snbogan/PolarFish/Long_AFP/

# Run BUSCO in parallel
run_busco() {
    name=$(basename "$1" .fa)
    busco -c 8 -i "$name".fa -o busco_assembly_"$name" --auto-lineage -m genome -f
}

export -f run_busco

find . -maxdepth 1 -name "*.fa" | parallel -j2 run_busco {}

##################################
#### NS should start here ####
##################################

# Move BUSCO outputs to BUSCO_results
mv busco_assembly_* /hb/home/snbogan/PolarFish/Long_AFP/BUSCO_results 

# Run pipeline command
python BUSCO_phylogenomics.py -i BUSCO_results -o output_busco_phylogenomics -t 8

## If data look patchy, run python <python count_buscos.py -i BUSCO_runs>
