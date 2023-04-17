
#library(devtools)
#devtools::install_github("bcm-uga/LEA")
library(LEA)
library(reshape2)

# convert ped file to geno file (automatically outputs in working directory)
ped2geno("orca_snps_q30_biallelic_HWE0.005_miss0.4_maf0.05_LDprunedr08_n24.ped")

# run snmf for K 1-5
project=NULL
project=snmf("orca_snps_q30_biallelic_HWE0.005_miss0.4_maf0.05_LDprunedr08_n24.geno", K=1:5, entropy=TRUE, repetitions=10, project="new")

# can also load snmf project if saved
project=load.snmfProject("orca_snps_q30_biallelic_HWE0.005_miss0.4_maf0.05_LDprunedr08_n24.snmfProject")

# reading in sample info
sample_info <- read.csv("sample_info_KL_killerwhale.csv", header=T)

# narwhal - remove close kin
sample_info <- subset(sample_info, remove!="X")

# match order to vcf order
sample_info <- sample_info[order(sample_info$vcf_order),]

# plot cross-entropy
png("cross_entropy.png", height=800, width=800, res=200)
plot(project, col="blue", pch=19, cex=1.5)
dev.off()

# extract the cross-entropy of runs K1:5
ce_k1 = cross.entropy(project, K = 1)
ce_k2 = cross.entropy(project, K = 2)
ce_k3 = cross.entropy(project, K = 3)
ce_k4 = cross.entropy(project, K = 4)
ce_k5 = cross.entropy(project, K = 5)

# save values in csv
ce_merged = as.data.frame(cbind(ce_k1, ce_k2, ce_k3, ce_k4, ce_k5))
write.csv(ce_merged, "cross-entropy_K1-5.csv")

# basic barcharts, going to do for runs K=2, 3, 4, 5. this is default snmf orders, can also just jump to line 86 to skip this
# K2
best = which.min(cross.entropy(project, K = 2))
best
my.colors <- c("tomato", "lightblue",
               "olivedrab", "gold", "gray")
barchart(project, K = 2, run = best,
         border = NA, space = 0, col = my.colors,
         xlab = "Individuals", ylab = "Ancestry proportions", main = "Ancestry matrix") -> bp
axis(1, at = 1:length(bp$order),
     labels = bp$order, las=1,
     cex.axis = .6)

# K3
best = which.min(cross.entropy(project, K = 3))
best
barchart(project, K = 3, run = best,
         border = NA, space = 0, col = my.colors,
         xlab = "Individuals", ylab = "Ancestry proportions", main = "Ancestry matrix") -> bp
axis(1, at = 1:length(bp$order),
     labels = bp$order, las=1,
     cex.axis = .6)

# K4
best = which.min(cross.entropy(project, K = 4))
best
barchart(project, K = 4, run = best,
         border = NA, space = 0, col = my.colors,
         xlab = "Individuals", ylab = "Ancestry proportions", main = "Ancestry matrix") -> bp
axis(1, at = 1:length(bp$order),
     labels = bp$order, las=1,
     cex.axis = .6)

# K5
best = which.min(cross.entropy(project, K = 5))
best
barchart(project, K = 5, run = best,
         border = NA, space = 0, col = my.colors,
         xlab = "Individuals", ylab = "Ancestry proportions", main = "Ancestry matrix") -> bp
axis(1, at = 1:length(bp$order),
     labels = bp$order, las=1,
     cex.axis = .4)


# resume here if skipping LEA-default plots
best = which.min(cross.entropy(project, K = 2))
best

# extract Q-matrix for the best run
qmatrix = as.data.frame(Q(project, K = 2, run = best))
head(qmatrix)

# label column names of qmatrix
ncol(qmatrix)
cluster_names = c()
for (i in 1:ncol(qmatrix)){
  cluster_names[i] = paste("Cluster", i)
}
cluster_names
colnames(qmatrix) = cluster_names
head(qmatrix)

# add individual IDs
qmatrix$Ind = sample_info$vcf_ID

# add site IDs
qmatrix$Site = sample_info$location_name
head(qmatrix)

write.csv(qmatrix, "qmatrix_K2.csv", row.names=FALSE)

# convert dataframe to long format
#qlong = melt(qmatrix, id.vars=c("Ind","Site"))
#head(qlong)

#write.csv(qlong, "qmatrix_K2_qlong.csv", row.names=FALSE)

##
# plot admixture results in order by site (added in value for site/pop order in the outputs from above, and reloaded here)

library(patchwork)
library(reshape2)
library(tidyverse)

# read in file
qmatrix <- read.csv("qmatrix_K2_poporder.csv")
qmatrix <- subset(qmatrix, select= -c(pop_order))

# conver to long format
qlong <- melt(qmatrix, id.cars=c("Ind", "Site"))
head(qlong)

snmf_admix <- ggplot(data=qlong, aes(x=fct_inorder(Ind), y=value, fill=variable))+
  geom_bar(stat = "identity",position = position_stack(reverse = TRUE),width=1)+
  scale_y_continuous(expand = c(0,0))+
  ylab("Ancestry")+
  xlab("")+
  theme_classic()+
  scale_fill_manual(values = c("Cluster.1" = "#D6604D", "Cluster.2" = "#4393C3"))+
  theme(legend.position = "none")+
  coord_cartesian(expand=FALSE)+
  theme(plot.title=element_text(hjust=0.5),axis.text.x = element_text(angle = 90))
snmf_admix_K2

ggsave("snmf_K2_ggplot_color2_flat.svg", height=2.1, width=5, dpi=1000)

# need to have "svglite" package installed to save as svg
ggsave("snmf_K2_ggplot_color2_test2.svg", height=2.5, width=5)

