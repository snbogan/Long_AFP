#!/bin/bash
#SBATCH --job-name=busco_assembly_stats_oamb
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
busco -c 16 -i /hb/groups/kelley_training/assemblies/oamb.asm.p_ctg.fa -o busco_assembly_oamb --auto-lineage -m genome -f

