library(vcfR)
library(adegenet)
library(StAMPP)
library(poppr)
library(ape)
library(StAMPP)
library(RColorBrewer)
library(parallel)
library(ggplot2)
library(reshape2)

# load snps
snps <- read.vcfR("orca_snps_q30_biallelic_HWE0.005_miss0.4_maf0.05_LDprunedr08_n24.vcf") #orca_newfound_filtered.vcf")

snps <- addID(snps, sep = "_")

# convert to genlight
gl <- vcfR2genlight(snps)

# load sample info
sample_info <- read.csv("sample_info_KL_killerwhale.csv", header=T)

# match order to vcf order
sample_info <- sample_info[order(sample_info$vcf_order),]

# remove the 5 close kin pairs
sample_info <- subset(sample_info, remove!="X")

# add pop info to gl
gl@pop <- as.factor(sample_info$location_name)

# run pca
pca <- glPca(gl, nf =10, n.cores = 20)

# barplot of eigenvalues
barplot(100*pca$eig/sum(pca$eig), col=heat.colors(50), main="PCA Eigenvalues")
title(ylab="% variance")
title(xlab="Eigenvalues")

# get the proportion of variance
var_frac <- pca$eig/sum(pca$eig)

# double check that it adds up to 1
sum(var_frac)

# prepare pca scores for plot
pca.scores <- as.data.frame(pca$scores)

# maybe add in pop through meta data file instead..
gl@pop <- as.factor(sample_info$location_name)

pca.scores$pop <- sample_info$location_name #pop(gl)
#cols <- brewer.pal(n = nPop(gl), name = "Dark2")

ggplot(pca.scores, aes(x=PC1, y=PC2))+
    geom_hline(yintercept=0, colour="gray88")+
  geom_vline(xintercept=0, colour="gray88")+
  geom_point(aes(color=sample_info$location_name), size=3, alpha=0.9)+
  scale_color_manual(values=c("#440254","#414487ff", "#2a788eff", "#22a884ff", "#7ad151ff","#fce624ff"),
                     breaks=c("Arctic Bay","Pond Inlet", "Repulse Bay", "Pangnirtung", "East Greenland", "Newfoundland"))+

  labs(color="Location")+
  theme_bw()+
  theme(panel.grid.minor=element_blank(), panel.grid.major=element_blank())+
  xlab(paste("PC1 (",round((var_frac[1]*100), digits=2), "%)",sep=""))+
  ylab(paste("PC2 (",round((var_frac[2]*100), digits=2), "%)",sep=""))


ggsave("figures/PCA_plot_SVG.svg", width=4.5, height=3, dpi=500)

# phylogenetic tree
tree <- aboot(gl, tree = "upgma", distance = bitwise.dist, sample = 100, showtree = F, cutoff = 50, quiet = T)

png("phylo_tree_withkin.png", width=2200,height=2200,res=400)
plot.phylo(tree, cex = 0.8, font = 2, adj = 0, tip.color =  cols[pop(gl)])
legend('topright', legend = c("Arctic Bay", "East Greenland","Newfoundland", "Pangnirtung", "Pond Inlet", "Repulse Bay"), fill = cols, border = FALSE, bty = "n", cex = 0.6)
axis(side = 1)
dev.off()

# Run fst between P1 and P2
# load sample info
sample_info <- read.csv("sample_info_KL_killerwhale.csv", header=T)

# match order to vcf order
sample_info <- sample_info[order(sample_info$vcf_order),]

# remove the 5 close kin pairs
sample_info <- subset(sample_info, remove!="X")

# add pop info to gl
gl@pop <- as.factor(sample_info$pgroup)
gl1 <-gl

# run fst
pwfst <- stamppFst(gl1, nboots=100, percent=95, nclusters=45)

