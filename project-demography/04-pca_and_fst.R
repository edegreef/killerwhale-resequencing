library(vcfR)
library(adegenet)
library(StAMPP)
library(ggplot2)

setwd("C:/Users/eveli/Dropbox/Whales with Garroway/killer whales/")

# Load snps
snps <- read.vcfR("refilter/orca_snps_q30_biallelic_HWE0.005_miss0.4_maf0.05_LDprunedr08_n24.vcf")
snps <- addID(snps, sep = "_")
gl <- vcfR2genlight(snps)

# Load sample info
sample_info <- read.csv("sample_info_KL_killerwhale.csv", header=T)

# Match order to vcf order
sample_info <- sample_info[order(sample_info$vcf_order),]

# Remove the 5 close kin pairs
sample_info <- subset(sample_info, remove!="X")

# Add pop info to gl
gl@pop <- as.factor(sample_info$location_name)

# Run pca
pca <- glPca(gl, nf =10, n.cores = 20)

# Barplot of eigenvalues
barplot(100*pca$eig/sum(pca$eig), col=heat.colors(50), main="PCA Eigenvalues")
title(ylab="% variance")
title(xlab="Eigenvalues")

# Get the proportion of variance
var_frac <- pca$eig/sum(pca$eig)

# Double check that it adds up to 1
sum(var_frac)

# Prepare pca scores for plot
pca.scores <- as.data.frame(pca$scores)

# Add pop info to pca output
pca.scores$pop <- sample_info$location_name

# Plot PCA
ggplot(pca.scores, aes(x=PC1, y=PC2))+
  geom_hline(yintercept=0, colour="gray88")+
  geom_vline(xintercept=0, colour="gray88")+
  geom_point(aes(color=sample_info$location_name), size=3, alpha=0.9)+
  #scale_color_manual(values=c("#440254","#414487ff", "#2a788eff", "#22a884ff", "#7ad151ff","#fce624ff"),
  scale_color_manual(values=c("#ffaa00ff","#0c56beff", "#ff6200ff", "#e3001bff", "#9b1212ff","#56b7f3ff"),
                     breaks=c("Arctic Bay","Pond Inlet", "Repulse Bay", "Pangnirtung", "East Greenland", "Newfoundland"), labels=c("Arctic Bay", "Pond Inlet", "Naujaat", "Pangnirtung", "East Greenland", "Newfoundland"))+
  
  labs(color="Location")+
  theme_bw()+
  theme(panel.grid.minor=element_blank(), panel.grid.major=element_blank())+
  xlab(paste("PC1 (",round((var_frac[1]*100), digits=2), "%)",sep=""))+
  ylab(paste("PC2 (",round((var_frac[2]*100), digits=2), "%)",sep=""))

#ggsave("figures/PCA_plot_color3.png", width=4.5, height=3, dpi=500)



######## Estimate FST

# Load sample info
sample_info <- read.csv("sample_info_KL_killerwhale.csv", header=T)

# Match order to vcf order
sample_info <- sample_info[order(sample_info$vcf_order),]

# Remove the 5 close kin pairs
sample_info <- subset(sample_info, remove!="X")

# Add pop info to gl (the pgroup column has the info for which individual belongs to P1 (high arctic) or P2 (low arctic). stamppFst will output a matrix so can use however many pops/regions at a time.
gl@pop <- as.factor(sample_info$pgroup)
gl1 <-gl
pwfst <- stamppFst(gl1, nboots=100, percent=95, nclusters=45)
pwfst
