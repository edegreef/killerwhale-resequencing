#!/bin/bash

### preparing mask file for smcpp
# SMC++ prep originally set up by Matt Thorstensen

# now make vcf of filtered out sites
/home/degreefe/programs/bcftools-1.9/bcftools isec -p isec_filteredout orca_unfiltered_diploid.vcf.gz orca_snps_q30_biallelic_HWE0.005_miss0.4.vcf.gz

# move the isec_filtered out folder into smcpp folder

# isec_filteredout/0000.vcf is the one we want (snps that were filtered out)
cp isec_filteredout/0000.vcf 0000.vcf

# rename for smc input
mv 0000.vcf smcpp_removed_sites.vcf

# making bed file for masking
export PATH=$PATH:/home/degreefe/programs/bedops/bin

# change back to your working directory

# convert to vcf to bed
switch-BEDOPS-binary-type --megarow

vcf2bed --do-not-sort --deletions < smcpp_removed_sites.vcf > foo_deletions.bed
vcf2bed --snvs < smcpp_removed_sites.vcf > foo_snps.bed

# merge bed files
bedops --everything foo_{deletions,snps}.bed > smcpp_removed_sites.bed

# sort bed
sort-bed smcpp_removed_sites.bed > smcpp_removed_sites_sorted.bed

# zip & index
bgzip smcpp_removed_sites_sorted.bed
tabix -p bed smcpp_removed_sites_sorted.bed.gz

# use this final bed file in --mask for SMC++ vcf2smc.