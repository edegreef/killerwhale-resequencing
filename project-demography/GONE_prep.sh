#!/bin/bash

# Notes on running GONE program for demographic history

#downloaded program from git
#https://github.com/esrud/GONE

# Basing INPUT_PARAMETERS_FILE off Kardos et al. 2023 (https://github.com/martykardos/KillerWhaleInbreeding/tree/main/GONE)

# Using these files (running the two populations separately): orca_snps_q30_biallelic_HWE0.005_miss0.4.P1.maf05.vcf, orca_snps_q30_biallelic_HWE0.005_miss0.4.P2.maf05.vcf
# and this file for the scaffold naming stuff: orca_snps_q30_biallelic_HWE0.005_miss0.4.vcf 

### Notes on the program
# GONE takes max 200 chr/scaffolds
# Each scaffold have to be numbered 1 through max 200 (and in this order...)
# So for killer whales we are using 85 scaffolds, will have to number them 1-85
# Can have missing data
# Best to use plink to convert vcf to ped/map instead of vcftools b/c of the format with 0 0 0 -9 in some of the columns
###

# Using 85 scaffolds in the killer whale dataset. Need to name each scaffold from 1-85 to make format compatible with GONE
# Pull out all the scaffold names from file before we split to P1 and P2:
grep -v "^#" orca_snps_q30_biallelic_HWE0.005_miss0.4.vcf | cut -f1 | sort | uniq > scaf_list_check.txt

# add row number to become the new scaffold names:
awk '{print $0,NR}' scaf_list_check.txt > rename_scaffolds.txt

# Note for bowhead whale stuff later when we will be using more scaffolds: add a "s" for each number (the --allow-extra-chr in plink doesn't work for raw numbers...) will remove this later because then GONE only takes number values ... ugh.
# Would be fine if plink doesn't max number chr at 95 -- specific to bowhead maybe??
# Dont need to worry about that for KW or narwhal since below 95 scaffolds.
#awk '$2="s"$2' rename_scaffolds.txt > rename_scaffolds2.txt

# Rename scaffolds-- in hindsight, better do to this step before separating vcfs into each pop.
/home/degreefe/programs/bcftools-1.9/bcftools annotate --rename-chrs rename_scaffolds.txt orca_snps_q30_biallelic_HWE0.005_miss0.4.P1.maf05.vcf -Oz -o orca_snps_q30_biallelic_HWE0.005_miss0.4.P1.maf05.scafrename.vcf.gz

/home/degreefe/programs/bcftools-1.9/bcftools annotate --rename-chrs rename_scaffolds.txt orca_snps_q30_biallelic_HWE0.005_miss0.4.P2.maf05.vcf -Oz -o orca_snps_q30_biallelic_HWE0.005_miss0.4.P2.maf05.scafrename.vcf.gz

# Convert to ped/map format (*important to do this with plink and not vcftools)
/home/degreefe/programs/plink --vcf orca_snps_q30_biallelic_HWE0.005_miss0.4.P1.maf05.scafrename.vcf.gz --recode --out orca_snps_q30_biallelic_HWE0.005_miss0.4.P1.maf05.scafrename --double-id --chr-set 85

/home/degreefe/programs/plink --vcf orca_snps_q30_biallelic_HWE0.005_miss0.4.P2.maf05.scafrename.vcf.gz --recode --out orca_snps_q30_biallelic_HWE0.005_miss0.4.P2.maf05.scafrename --double-id --chr-set 85

# P1: 1,064,409 snps
# P2: 601,198 snps

# Now ready to run GONE!
