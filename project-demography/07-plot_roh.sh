# Plotting roh using outputs from PLINK
# Ran ROH for each population/group separately
# For one each pop, ran this through plink first (following parameters of Foote et al. 2021):
# plink --allow-extra-chr --bfile orca_snps_q30_biallelic_HWE0.005_miss0.4_maf0.05_LDprunedr08_P1 --set-missing-var-ids @:#\$1,\$2 --homozyg --homozyg-kb 300 --homozyg-snp 50 --homozyg-density 50 --homozyg-gap 1000 --homozyg-window-snp 50 --homozyg-window-het 3 --homozyg-window-missing 10 --homozyg-window-threshold 0.05 --out orca_snps_q30_biallelic_HWE0.005_miss0.4_maf0.05_LDprunedr08_P1

# Then plot in R!
library(ggplot2)
setwd("C:/Users/eveli/Dropbox/Whales with Garroway/killer whales/refilter/ROH_tajd_pi/roh_redo")

# Load the .hom.indiv files for both pops
P1 <- read.table("orca_snps_q30_biallelic_HWE0.005_miss0.4_maf0.05_LDprunedr08_P1.hom.indiv", header=T)
P2 <- read.table("orca_snps_q30_biallelic_HWE0.005_miss0.4_maf0.05_LDprunedr08_P2.hom.indiv", header=T)

# Label both pops
P1$region <- "P1"
P2$region <- "P2"

# Merge together
merge <- rbind(P1, P2)

# Extract the columns we want
set <- merge[, c("NSEG", "KB", "region")]

# Make column for MB
set$MB <- (set$KB)/1000

# Simple plot for total lengths of ROH and number of ROHs
roh <- ggplot(data=set, aes(x=MB,y=NSEG))+
  geom_point(aes(color=region), size=3, alpha=0.8)+
  theme_bw()+
  labs(color= "Region")+
  xlab("Total length of ROHs (Mb)")+
  ylab("Number of ROHs")+
  scale_color_manual(values = c("P2"="#D6604D","P1"="#4393C3"), labels=(c("P2"="P2", "P1"="P1")))+
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())

roh

#ggsave("ROH_hom_indv_pruned.svg", width=3, height=3, dpi=1000)

### Next going to look into FROH

# Adding extra column to data for FROH - fraction of genome as ROH
scafs <- read.csv("C:/Users/eveli/Dropbox/Whales with Garroway/killer whales/scaffold_lengths.csv", header=T)

# Total length of genome
total_length <- sum(scafs$length)
total_length
# 2372903489

# Remember to make it Mb unit to be consistent
# 1 million bp per Mb
total_length_MB <- total_length/1000000
total_length_MB
#2372.903

# Also remember to ust just the 10MB autosomes
scafs_10Mb <- subset(scafs, auto_10MB == "X")
total_length_10Mb_auto <- sum(scafs_10Mb$length)
total_length_10Mb_auto

# 1477050122

# Convert to MB
total_length_10Mb_auto_MB <- total_length_10Mb_auto/1000000
total_length_10Mb_auto_MB
# 1477.05

# Estimate FROH
set$F10MB <- (set$MB/total_length_10Mb_auto_MB)
set$Fall <- (set$MB/total_length_MB)

set$row <- 1:nrow(set)

# Plot it- going to stick with the autosomes only b/c that's how data was mapped
Froh <- ggplot(data=set, aes(x=reorder(row,F10MB),y=F10MB))+
  theme_bw()+
  labs(fill= "Pop")+
  xlab("Individual")+
  ylab(expression(paste(italic("F")["ROH"],sep="")))+
  scale_fill_manual(values = c("P2"="#D6604D","P1"="#4393C3"), labels=(c("P2"="P2", "P1"="P1")))+
  geom_bar(stat = "identity", aes(fill=region), colour="black", linewidth=0.05, width=1)+
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        axis.ticks.x = element_blank(), axis.text.x=element_blank())+
  scale_y_continuous(expand=c(0,0), limits=c(0,0.5))

Froh

# To use ROH > 1.5 Mb then look at the .hom file instead of .hom.indiv.
# load files
P1_hom <- read.table("orca_snps_q30_biallelic_HWE0.005_miss0.4_maf0.05_LDprunedr08_P1.hom", header=T)
P2_hom <- read.table("orca_snps_q30_biallelic_HWE0.005_miss0.4_maf0.05_LDprunedr08_P2.hom", header=T)

# Filter at 1500 KB min length
P1_hom_1.5MB <- subset(P1_hom, KB > 1500)
P2_hom_1.5MB <- subset(P2_hom, KB > 1500)

# Then pull up sums by individual (like making own .hom.indiv file)
P1_hom1.5MB_indiv <- P1_hom_1.5MB %>% group_by(FID) %>% summarize(total_kb = sum(KB))
P2_hom1.5MB_indiv <- P2_hom_1.5MB %>% group_by(FID) %>% summarize(total_kb = sum(KB))

# Use total_length_10Mb_auto_MB as length of autosomes in this dataset.
# Put everything in MB to keep consistent
# Total_length_10Mb_auto_MB
P1_hom1.5MB_indiv$total_MB <- P1_hom1.5MB_indiv$total_kb/1000
P2_hom1.5MB_indiv$total_MB <- P2_hom1.5MB_indiv$total_kb/1000

P1_hom1.5MB_indiv$pop <- "P1"
P2_hom1.5MB_indiv$pop <- "P2"

# Combine into one
set <- rbind(P1_hom1.5MB_indiv, P2_hom1.5MB_indiv)

# Add the proportion (FROH)
set$FROH <- (set$total_MB/total_length_10Mb_auto_MB)

set$row <- 1:nrow(set)

# Plot it
Froh <- ggplot(data=set, aes(x=reorder(row,FROH),y=FROH))+
  theme_bw()+
  labs(fill= "Pop")+
  xlab("Individual")+
  ylab(expression(paste(italic("F")["ROH(>1.5Mb)"],sep="")))+
  scale_fill_manual(values = c("P2"="#E9503C","P1"="#4D9BD3"), labels=(c("P2"="P2", "P1"="P1")))+
  
  geom_bar(stat = "identity", aes(fill=pop), colour="black", linewidth=0.05, width=1)+
  
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        axis.ticks.x = element_blank(), axis.text.x=element_blank())+
  scale_y_continuous(expand=c(0,0), limits=c(0,0.3), breaks=c(0,0.05,0.1,0.15,0.2,0.25,0.3))

Froh

ggsave("FROH_1.5MB_barplot.png", width=3, height=3, dpi=1000)


# Do again with ROHs 1Mb and 10 Mb (from row 95)
