AFP_LongRead_Notebook
================
Sam Bogan and Nathan Surendran

\#Summary

This is an R markdown lab notebook for all research, wet lab work, and
analyses related to a study on type AFP III evolution revealed by long
read sequencing and genome assembly in Zoarcoid fishes. The 11 Zoarcoid
species included in the study and Scorpaeiformes outgroups
(sticklebacks) are indexed

File registry 1. Metadata + LongRead_SpeciesIDs.csv (index of species
names and genome IDs)

Below is a quick visual representation of the species’ relatedness using
the rfishtree time-calibrated phylogeny

What genomes are we working with?

``` r
# Read in list of species
Species_df <- read.csv("LongRead_SpeciesIDs.csv")

# Print list to show which genomes came from public source vs. Kelley Lab
Species_df
```

    ##                   Species_ID Abbreviation     X.Sub.Order          Family
    ## 1           Anarhichas lupus       Alupus      Zoarcoidei  Anarhichadidae
    ## 2           Anarhichas minor       Aminor      Zoarcoidei  Anarhichadidae
    ## 3       Bathymaster signatus         Bsig      Zoarcoidei Bathymasteridae
    ## 4        Lycodes platyrhinus       Norway      Zoarcoidei       Zoarcidae
    ## 5          Lycodes diapterus          BYU      Zoarcoidei       Zoarcidae
    ## 6   Melanostigma gelatinosum         Mgel      Zoarcoidei       Zoarcidae
    ## 7          Lycodes pacificus         Lpac      Zoarcoidei       Zoarcidae
    ## 8  Ophthalmolycus amberensis         Oamb      Zoarcoidei       Zoarcidae
    ## 9           Pholis gunnellus        Pgunn      Zoarcoidei        Pholidae
    ## 10    Cebidichthys violaceus        Cviol      Zoarcoidei     Stichaeidae
    ## 11     Leptoclinus maculatus         Lmac      Zoarcoidei     Stichaeidae
    ## 12    Gasterosteus aculeatus        Gacul Scorpaeniformes  Gasterosteidae
    ## 13       Pungitius pungitius        Ppung Scorpaeniformes  Gasterosteidae
    ##    Location Kelley_Lab
    ## 1        HB        Yes
    ## 2        HB        Yes
    ## 3        HB        Yes
    ## 4        HB        Yes
    ## 5        HB        Yes
    ## 6      NCBI         No
    ## 7      NCBI         No
    ## 8        HB        Yes
    ## 9      NCBI         No
    ## 10     NCBI         No
    ## 11     NCBI         No
    ## 12     NCBI         No
    ## 13     NCBI         No

Extract and plot species phylogeny with important metadata

``` r
# Extract eelpout phylogeny
species_phy <- fishtree_phylogeny(species = Species_df$Species_ID, type=c("chronogram"))

# How many species in phy object? 94
length(species_phy$tip.label)

## Import habitat metadata from FishBase
species_list <- tolower(gsub("_", " ", species_phy$tip.label))
  
species_dist <- data.frame(tip.label = tolower(distribution(species_list(Family = 
                                                                           c("Zoarcidae", "Anarhichadidae",
                                                                             "Bathymasteridae", "Pholidae",
                                                                             "Stichaeidae", "Gasterosteidae")))$Species),
                           Region = distribution(species_list(Family = c("Zoarcidae", "Anarhichadidae",
                                                                             "Bathymasteridae", "Pholidae",
                                                                             "Stichaeidae", "Gasterosteidae")))$FAO,
                           Lat = distribution(species_list(Family = c("Zoarcidae", "Anarhichadidae",
                                                                             "Bathymasteridae", "Pholidae",
                                                                             "Stichaeidae", "Gasterosteidae")))$LatDeg,
                           NS = distribution(species_list(Family = c("Zoarcidae", "Anarhichadidae",
                                                                             "Bathymasteridae", "Pholidae",
                                                                             "Stichaeidae", "Gasterosteidae")))$N_S)
distribution(species_list(Family = "Zoarcidae"))

# Create variable for whether row is Antarctic, Arctic, polar
species_dist$Polar <- ifelse(grepl("Arctic", species_dist$Region) == TRUE, "Arctic",
                             ifelse(grepl("Antarctic", species_dist$Region) == TRUE, "Antarctic",
                                    "Subpolar"))

## Combine latitude with Zoarcid phylogeny object and plot
species_phy$tip.label <- tolower(gsub("_", " ", species_phy$tip.label))

species_dist_filt <- filter(species_dist, tip.label %in% species_phy$tip.label)

#Summarize latitude
species_dist_sum <- summarySE(measurevar = "Lat",
                              groupvars = c("tip.label", "Polar"),
                              data = species_dist_filt)

# Colored plot
max_y <- max(species_phy$edge.length)

ggtree(species_phy, layout = "rectangular", 
       aes(color = Lat), size = .75) %<+% species_dist_sum +
  geom_tippoint(aes(shape = Polar), size = 3) +
  geom_tiplab(hjust = -0.05) +
  scale_shape_manual(values = c(19,1,NA), na.translate = F) +
  theme_tree() +
  geom_treescale(width = 20) +
  scale_color_viridis_c(direction = -1) +
  theme_classic(base_size = 20) +
  xlim(0, 100) +
  theme(legend.background = element_rect(fill = "transparent"),
        panel.background = element_rect(fill = "transparent"),
        strip.background = element_rect(fill = "transparent"),
        plot.background = element_rect(fill = "transparent", color = NA),
        axis.line = element_blank(),
        axis.text = element_blank(),
        axis.ticks = element_blank(),
        legend.text = element_text(size = 8)) +
  labs(color = "Latitude", shape = "Region") +
  geom_rect(xmin = max_y-2, xmax = max_y-3, ymin = -Inf, ymax = Inf, fill = "skyblue", alpha = 0.01, lty = 0) +
  geom_rect(xmin = max_y-10, xmax = max_y-15, ymin = -Inf, ymax = Inf, fill = "pink", alpha = 0.01, lty = 0)
```

# HB SLURM Scripts

### 10/26/2023

NS: Ran a BUSCO analysis on the fasta genome data for eelpouts and
zoarcoids. Single seq files then compressed using tar.gz

The slurm job script below was ran for the following species: \* alupus
\* aminor \* bsig \* byu \* cviol1 \* gacul \* lmac1 \* lpac \* melgel1
\* norway \* oamb \* pgunn1

``` bash


#!/bin/bash
#SBATCH --job-name=busco_assembly_stats_alupus
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
busco -c 16 -i /hb/groups/kelley_training/assemblies/alupus.asm.p_ctg.fa -o busco_assembly_alupus --auto-lineage -m genome -f
```

### 10/29/2023

SB ran reran BUSCO on the 12 assemblies above using his HB allocation
and input the BUSCO output to BUSCO_to_phylogeny pipeline described
here: <https://github.com/jamiemcg/BUSCO_phylogenomics>

NS’s BUSCO job’s per species were moved to Archive directory

The job script below has an annotation for where NS would start the
script since he has already run BUSCO on the 12 assemblies

``` bash

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
###### NS should start here ######
##################################

# Move BUSCO outputs to BUSCO_results
mv busco_assembly_* /hb/home/snbogan/PolarFish/Long_AFP/BUSCO_results 

# Run pipeline command
python BUSCO_phylogenomics.py -i BUSCO_results -o output_busco_phylogenomics -t 8

## If data look patchy, run python <python count_buscos.py -i BUSCO_runs>
```
