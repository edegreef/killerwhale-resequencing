/plink  - - tfile  chr1  - - 
homozyg- snp  50  
homozyg- kb  300 
homozyg- density 50 
homozyg- gap 1000 
homozyg- window- snp 50 
homozyg- window- het  3  
homozyg- window- missing  10
homozyg- window- threshold 0.05

# run2
/home/degreefe/programs/plink --allow-extra-chr --bfile orca_snps_filtered_mid_arc_P2.n8 --set-missing-var-ids @:#\$1,\$2 --homozyg --homozyg-kb 300 --homozyg-snp 50 --homozyg-density 50 --homozyg-gap 1000 --homozyg-window-snp 50 --homozyg-window-het 3 --homozyg-window-missing 10 --homozyg-window-threshold 0.05 --out orca_snps_filtered_mid_arc_P2.n8_run2


orca_snps_filtered_high_arc_P1_n16

orca_snps_filtered_mid_arc_P2.n8


# run 3 used unpruned data

#### notes:: getting sloppy. redoing this.
# prep vcfs, pruned and not pruned
vcftools --vcf orca_snps_q30_biallelic_HWE0.005_miss0.4_maf0.05_LDprunedr08.vcf --keep high_arc_P1 --recode --recode-INFO-all --out orca_snps_q30_biallelic_HWE0.005_miss0.4_maf0.05_LDprunedr08_P1

vcftools --vcf orca_snps_q30_biallelic_HWE0.005_miss0.4_maf0.05_LDprunedr08.vcf --keep mid_arc_P2 --recode --recode-INFO-all --out orca_snps_q30_biallelic_HWE0.005_miss0.4_maf0.05_LDprunedr08_P2

vcftools --vcf orca_snps_q30_biallelic_HWE0.005_miss0.4_maf0.05.vcf --keep high_arc_P1 --recode --recode-INFO-all --out orca_snps_q30_biallelic_HWE0.005_miss0.4_maf0.05_P1

vcftools --vcf orca_snps_q30_biallelic_HWE0.005_miss0.4_maf0.05.vcf --keep mid_arc_P2 --recode --recode-INFO-all --out orca_snps_q30_biallelic_HWE0.005_miss0.4_maf0.05_P2


# bfiles
/home/degreefe/programs/plink --allow-extra-chr --make-bed --vcf orca_snps_q30_biallelic_HWE0.005_miss0.4_maf0.05_LDprunedr08_P1.vcf --set-missing-var-ids @:#\$1,\$2 --out orca_snps_q30_biallelic_HWE0.005_miss0.4_maf0.05_LDprunedr08_P1 --double-id 

/home/degreefe/programs/plink --allow-extra-chr --make-bed --vcf orca_snps_q30_biallelic_HWE0.005_miss0.4_maf0.05_LDprunedr08_P2.vcf --set-missing-var-ids @:#\$1,\$2 --out orca_snps_q30_biallelic_HWE0.005_miss0.4_maf0.05_LDprunedr08_P2 --double-id

/home/degreefe/programs/plink --allow-extra-chr --make-bed --vcf orca_snps_q30_biallelic_HWE0.005_miss0.4_maf0.05_P1.vcf --set-missing-var-ids @:#\$1,\$2 --out orca_snps_q30_biallelic_HWE0.005_miss0.4_maf0.05_P1 --double-id

/home/degreefe/programs/plink --allow-extra-chr --make-bed --vcf orca_snps_q30_biallelic_HWE0.005_miss0.4_maf0.05_P2.vcf --set-missing-var-ids @:#\$1,\$2 --out orca_snps_q30_biallelic_HWE0.005_miss0.4_maf0.05_P2 --double-id

# ROH
/home/degreefe/programs/plink --allow-extra-chr --bfile orca_snps_q30_biallelic_HWE0.005_miss0.4_maf0.05_LDprunedr08_P1 --set-missing-var-ids @:#\$1,\$2 --homozyg --homozyg-kb 300 --homozyg-snp 50 --homozyg-density 50 --homozyg-gap 1000 --homozyg-window-snp 50 --homozyg-window-het 3 --homozyg-window-missing 10 --homozyg-window-threshold 0.05 --out orca_snps_q30_biallelic_HWE0.005_miss0.4_maf0.05_LDprunedr08_P1

/home/degreefe/programs/plink --allow-extra-chr --bfile orca_snps_q30_biallelic_HWE0.005_miss0.4_maf0.05_LDprunedr08_P2 --set-missing-var-ids @:#\$1,\$2 --homozyg --homozyg-kb 300 --homozyg-snp 50 --homozyg-density 50 --homozyg-gap 1000 --homozyg-window-snp 50 --homozyg-window-het 3 --homozyg-window-missing 10 --homozyg-window-threshold 0.05 --out orca_snps_q30_biallelic_HWE0.005_miss0.4_maf0.05_LDprunedr08_P2

/home/degreefe/programs/plink --allow-extra-chr --bfile orca_snps_q30_biallelic_HWE0.005_miss0.4_maf0.05_P1 --set-missing-var-ids @:#\$1,\$2 --homozyg --homozyg-kb 300 --homozyg-snp 50 --homozyg-density 50 --homozyg-gap 1000 --homozyg-window-snp 50 --homozyg-window-het 3 --homozyg-window-missing 10 --homozyg-window-threshold 0.05 --out orca_snps_q30_biallelic_HWE0.005_miss0.4_maf0.05_P1

/home/degreefe/programs/plink --allow-extra-chr --bfile orca_snps_q30_biallelic_HWE0.005_miss0.4_maf0.05_P2 --set-missing-var-ids @:#\$1,\$2 --homozyg --homozyg-kb 300 --homozyg-snp 50 --homozyg-density 50 --homozyg-gap 1000 --homozyg-window-snp 50 --homozyg-window-het 3 --homozyg-window-missing 10 --homozyg-window-threshold 0.05 --out orca_snps_q30_biallelic_HWE0.005_miss0.4_maf0.05_P2