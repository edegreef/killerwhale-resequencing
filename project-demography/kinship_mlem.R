# Kinship stuff, following SNPRelate vignette: https://www.bioconductor.org/packages/devel/bioc/vignettes/SNPRelate/inst/doc/SNPRelate.html

#library(BiocManager)
#BiocManager::install("SNPRelate")
library(SNPRelate)
library(tidyverse)
library(reshape2)
library(ggplot2)

# Estimating kins in separate populations

# name the snp file
vcf.fn <- "orca_snps_q30_biallelic_HWE0.005_miss0.4_maf0.05_LDprunedr08_higharcP1.vcf"

# convert vcf to gds
snpgdsVCF2GDS(vcf.fn, "snps_higharcP1.gds", method="biallelic.only")
snpgdsSummary("snps_higharcP1.gds")

genofile <- snpgdsOpen("snps_higharcP1.gds")
#genofile <- snpgdsOpen(snpgdsExampleFileName())

# MoM IBD analysis
ibd.mom <- snpgdsIBDMoM(genofile, snp.id=NULL, maf=0.05, 
                        missing.rate=0.05, num.thread=2, autosome.only=F)

# get table of IBD coefficients
ibd.coeff.mom <- snpgdsIBDSelection(ibd.mom)

# plot MoM
plot(ibd.coeff.mom$k0, ibd.coeff.mom$k1, xlim=c(0,1), ylim=c(0,1),
     xlab="k0", ylab="k1", main="samples (MoM)")
lines(c(0,1), c(1,0), col="red", lty=2)


# MLE IBD analysis
ibd.mle <- snpgdsIBDMLE(gdsobj=genofile, snp.id=NULL, maf=0.05, 
                        missing.rate=0.05, autosome.only=F) 

# get table of IBD coefficients
ibd.coeff.mle <- snpgdsIBDSelection(ibd.mle) 

# plot MLE
plot(ibd.coeff.mle$k0, ibd.coeff.mle$k1, xlim=c(0,1), ylim=c(0,1),
     xlab="k0", ylab="k1", main="samples (MLE)")
lines(c(0,1), c(1,0), col="red", lty=2)

# save coefficients output
#write.csv(ibd.coeff.mle, "kin/snps_higharcP1_ibd.coeff.mle.csv")
#save.image("kin/snps_higharcP1_mom_mle.RData")

# convert to matrix (using MLE) to make heatmap
ibd.coeff.mle.cols <- ibd.coeff.mle[,c("ID1", "ID2", "kinship")]
ibd.mat <- spread(ibd.coeff.mle.cols, ID2, kinship)

### Make nice heatmap
# convert matrix to melted dataframe to use in geom_tile
ibd.mat.melt <- melt(ibd.mat)

ggplot(ibd.mat.melt, aes(x=ID1, y=variable, fill=value)) + 
  geom_tile()+
  scale_fill_gradient2( high="#f5382e", mid="#4c8de2", na.value="white")+
  xlab("")+
  ylab("")+
 # scale_fill_distiller(palette="Reds",trans="reverse", na.value = "white")+
  theme_minimal()+
  theme(axis.text.x=element_text(angle=90, hjust=0),
        plot.background=element_rect(color="white"))+
  scale_x_discrete(position="top")+
  geom_text(aes(label = round(value, 2)),size=3, colour="white")
#  labs(fill="Kinship coeff.")

ggsave("kin/higharcP1_kinplot.png", width=8, height=7.5, dpi=400)

