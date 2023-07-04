#!/bin/bash

# Prepare snps to use in strataG for estimating comtemporary Ne

# Starting with orca_snps_q30_biallelic_HWE0.005_miss0.4.vcf.gz

# Separate by pops
vcftools --gzvcf orca_snps_q30_biallelic_HWE0.005_miss0.4.vcf.gz --keep high_arc_P1 --recode --recode-INFO-all --out orca_snps_q30_biallelic_HWE0.005_miss0.4.P1
vcftools --gzvcf orca_snps_q30_biallelic_HWE0.005_miss0.4.vcf.gz --keep mid_arc_P2 --recode --recode-INFO-all --out orca_snps_q30_biallelic_HWE0.005_miss0.4.P2

mv orca_snps_q30_biallelic_HWE0.005_miss0.4.P1.recode.vcf orca_snps_q30_biallelic_HWE0.005_miss0.4.P1.vcf
mv orca_snps_q30_biallelic_HWE0.005_miss0.4.P2.recode.vcf orca_snps_q30_biallelic_HWE0.005_miss0.4.P2.vcf

# Remove snps with missing data and also include maf filter
vcftools --vcf orca_snps_q30_biallelic_HWE0.005_miss0.4.P1.vcf --max-missing 1.0 --maf 0.05 --recode --recode-INFO-all --out orca_snps_q30_biallelic_HWE0.005.P1.nomiss.maf0.05
vcftools --vcf orca_snps_q30_biallelic_HWE0.005_miss0.4.P2.vcf --max-missing 1.0 --maf 0.05 --recode --recode-INFO-all --out orca_snps_q30_biallelic_HWE0.005.P2.nomiss.maf0.05

mv orca_snps_q30_biallelic_HWE0.005.P1.nomiss.maf0.05.recode.vcf orca_snps_q30_biallelic_HWE0.005.P1.nomiss.maf0.05.vcf
mv orca_snps_q30_biallelic_HWE0.005.P2.nomiss.maf0.05.recode.vcf orca_snps_q30_biallelic_HWE0.005.P2.nomiss.maf0.05.vcf

# select random 25 K snps - run this step for different sets (sets 1-3 and for each pop)
/home/degreefe/programs/plink --thin-count 25000 --allow-extra-chr --make-bed --vcf orca_snps_q30_biallelic_HWE0.005.P1.nomiss.maf0.05.vcf --set-missing-var-ids @:#\$1,\$2 --out orca_snps_q30_biallelic_HWE0.005.P1.nomiss.maf0.05.thinned25K.set1 --double-id
/home/degreefe/programs/plink --thin-count 25000 --allow-extra-chr --make-bed --vcf orca_snps_q30_biallelic_HWE0.005.P2.nomiss.maf0.05.vcf --set-missing-var-ids @:#\$1,\$2 --out orca_snps_q30_biallelic_HWE0.005.P2.nomiss.maf0.05.thinned25K.set1 --double-id

# convert bfile back to vcf
/home/degreefe/programs/plink --bfile orca_snps_q30_biallelic_HWE0.005.P1.nomiss.maf0.05.thinned25K.set1 --recode vcf --out orca_snps_q30_biallelic_HWE0.005.P1.nomiss.maf0.05.thinned25K.set1 --allow-extra-chr
/home/degreefe/programs/plink --bfile orca_snps_q30_biallelic_HWE0.005.P2.nomiss.maf0.05.thinned25K.set1 --recode vcf --out orca_snps_q30_biallelic_HWE0.005.P2.nomiss.maf0.05.thinned25K.set1 --allow-extra-chr

# use the vcf in R to run strataG
