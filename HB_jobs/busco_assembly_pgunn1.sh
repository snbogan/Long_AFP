#!/bin/bash
#SBATCH --job-name=busco_assembly_stats_pgunn1
#SBATCH --time=0-12:00:00
#SBATCH --partition=Instruction
#SBATCH --mail-user=nsurendr@ucsc.edu
#SBATCH --mail-type=ALL
#SBATCH --output=busco_assembly.out
#SBATCH --error=busco_assembly.err
#SBATCH --ntasks=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=6GB

module load hb hb-gnu busco/busco-5.4.7
busco -c 16 -i /hb/groups/kelley_training/polar_genomes/NCBI_longreads/Pgunn1.2_genomic.fna -o busco_assembly_pgunn1 --auto-lineage -m genome -f

