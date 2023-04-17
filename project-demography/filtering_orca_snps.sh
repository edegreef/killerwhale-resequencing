# Starting with orca_unfiltered_diploid.vcf from Matt (This is 22,198,313 snps)

# need to get rid of the N's in the REF column first. 
# let's extract the first 4 columns so easier to use in R than whole vcf
awk '{print $1, $2, $3, $4}' orca_unfiltered_diploid.vcf > vcf4cols

# in R:
R
cols <- read.table("vcf4cols")
colnames(cols) <- c("CHROM", "POS", "ID", "REF")

refn <- nrow(cols[cols$REF=="N",]) #looks like 7116 snps
n_list <- subset(cols[cols$REF=="N",])
n_list <- n_list[,c("CHROM", "POS")]

# make list of SNPs with "N" in REF column to filter out
write.table(n_list, "REF_N_to_filter.txt", sep = "\t", row.names = FALSE, col.names = FALSE, quote=FALSE)

# exit R

# zip the vcf b/c file size is very big
bgzip orca_unfiltered_diploid.vcf
tabix -p vcf orca_unfiltered_diploid.vcf.gz

# remove the sites with REF as N and remove indels, then look at snp stats 
vcftools --gzvcf orca_unfiltered_diploid.vcf.gz --exclude-positions REF_N_to_filter.txt --remove-indels --recode --recode-INFO-all --out orca_snps

# 21,113,921 snps

# quality and biallelic filters
vcftools --vcf orca_snps.vcf --max-alleles 2 --min-alleles 2 --minGQ 30 --minQ 30 --out orca_snps_q30_biallelic --recode --recode-INFO-all

# 2,236,958 snps

# Proportion of missing data per individual (outputs .imiss file)
vcftools --gzvcf orca_snps_q30_biallelic.vcf.gz --out orca_snps_q30_biallelic --missing-indv 

# Propotion of missing data per site (outputs .lmiss file)
vcftools --gzvcf orca_snps_q30_biallelic.vcf.gz --out orca_snps_q30_biallelic --missing-site

# Filter out HWE 
vcftools --gzvcf orca_snps_q30_biallelic.vcf.gz --hwe 0.005 --recode --recode-INFO-all --out orca_snps_q30_biallelic_HWE0.005
mv orca_snps_q30_biallelic_HWE0.005.recode.vcf orca_snps_q30_biallelic_HWE0.005.vcf
bgzip orca_snps_q30_biallelic_HWE0.005.vcf

# 2,068,239 snps

# Filter missingness (max 0.4 missing)
vcftools --gzvcf orca_snps_q30_biallelic_HWE0.005.vcf.gz --max-missing 0.6 --recode --recode-INFO-all --out orca_snps_q30_biallelic_HWE0.005_miss0.4
mv orca_snps_q30_biallelic_HWE0.005_miss0.4.recode.vcf orca_snps_q30_biallelic_HWE0.005_miss0.4.vcf
bgzip orca_snps_q30_biallelic_HWE0.005_miss0.4.vcf

# 1,351,642 snps

### use orca_snps_q30_biallelic_HWE0.005_miss0.4.vcf.gz for SMCPP!

# continuing filters for pop structure stuff
# then filter for MAF for pop structure
vcftools --gzvcf orca_snps_q30_biallelic_HWE0.005_miss0.4.vcf.gz --recode --recode-INFO-all --maf 0.05 --out orca_snps_q30_biallelic_HWE0.005_miss0.4_maf0.05
mv orca_snps_q30_biallelic_HWE0.005_miss0.4_maf0.05.recode.vcf orca_snps_q30_biallelic_HWE0.005_miss0.4_maf0.05.vcf


# 1,099,768 snps

# LD pruning with r=0.8
./LD_pruning.sh orca_snps_q30_biallelic_HWE0.005_miss0.4_maf0.05


# 421,668 snps

### use orca_snps_q30_biallelic_HWE0.005_miss0.4_maf0.05_LDprunedr08.vcf for kinship analysis in R

# remove kins! at least the 5 close kins
vcftools --vcf orca_snps_q30_biallelic_HWE0.005_miss0.4_maf0.05_LDprunedr08.vcf --remove-indv MM406_2 --remove-indv ARPI_2013_4004 --remove-indv OO_02 --remove-indv OO_10 --remove-indv OO_15 --recode --recode-INFO-all --out orca_snps_q30_biallelic_HWE0.005_miss0.4_maf0.05_LDprunedr08_n24

# convert to bfile
/home/degreefe/programs/plink --allow-extra-chr --make-bed --vcf orca_snps_q30_biallelic_HWE0.005_miss0.4_maf0.05_LDprunedr08_n24.vcf --set-missing-var-ids @:#\$1,\$2 --out orca_snps_q30_biallelic_HWE0.005_miss0.4_maf0.05_LDprunedr08_n24 --double-id 


# and convert to ped/map for LEA
/home/degreefe/programs/bcftools-1.9/bcftools view -H orca_snps_q30_biallelic_HWE0.005_miss0.4_maf0.05_LDprunedr08_n24.vcf | cut -f 1 | uniq | awk '{print $0"\t"$0}' > chrom-map.txt
vcftools --vcf orca_snps_q30_biallelic_HWE0.005_miss0.4_maf0.05_LDprunedr08_n24.vcf --plink --chrom-map chrom-map.txt --out orca_snps_q30_biallelic_HWE0.005_miss0.4_maf0.05_LDprunedr08_n24

