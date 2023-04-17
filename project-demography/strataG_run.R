# Estimating NE

#devtools::install_github('ericarcher/strataG', build_vignettes = TRUE)

library(vcfR)
library(adegenet)
library(strataG)

# load vcf
snpsR <- read.vcfR("orca_snps_q30_biallelic_HWE0.005.P1.nomiss.maf0.05.thinned25K.set1.vcf", verbose = T)

# convert vcf to genpop
snps_genind <- vcfR2genind(snpsR)
#class(snps_genind)

# convert genind to gtypes
snps_gtypes <- genind2gtypes(snps_genind)
#class(snps_gtypes)

# Estimating Ne using ldNe (from https://github.com/jdalapicolla/Ne_StrataG.R/blob/master/Ne_Estimation.R)
Ne <- ldNe(snps_gtypes, 
           maf.threshold=0, 
           by.strata=TRUE, 
           ci=0.95, 
           drop.missing=TRUE,
           num.cores=4)
Ne

# 25K snps over 16 samples took 4 minutes
# 50K snps over 16 samples start 11:23- after 20 minutes crashed/slowed down computer too much


# Save the results:
write.csv(Ne, "NeResults.P1.25K.set1.csv")
