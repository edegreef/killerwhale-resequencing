# Plotting GONE results

library(tidyverse)

setwd("C:/Users/eveli/Dropbox/Whales with Garroway/killer whales/GONE")

# data1 referring to P1, and data2 referring to P2
data1 <- read.delim("with_maf05/Output_Ne_mean500reps_orca_snps_q30_biallelic_HWE0.005_miss0.4.P1.maf05.scafrename", header=T)
data2 <- read.delim("with_maf05/Output_Ne_mean500reps_orca_snps_q30_biallelic_HWE0.005_miss0.4.P2.maf05.scafrename", header=T)

# Quick plot of the means (cut off at 200 generation time)
ggplot()+
  geom_line(data=data1, aes(x=(Generation),y=Geometric_mean), color="#2166AC", lwd=1.5)+
  geom_line(data=data2, aes(x=(Generation),y=Geometric_mean), color="#B2182B", lwd=1.5)+
  theme_bw()+
  xlim(0,200)+
  xlab("generation")

# Use the 500 iterations to make a 95% confidence interval (this is based off of Kardos et al. 2023's script: https://github.com/martykardos/KillerWhaleInbreeding/blob/main/FigureCode/rCode_Fig_ED_1.R)

library(scales)
library(matrixStats)

# P1 first (high arctic)
# load all the iteration files and put it in a matrix
files <- paste("with_maf05/output_gone_tempfiles_P1/outfileLD_TEMP/outfileLD_",1:500,"_GONE_Nebest",sep="")
NeMat <- NULL
for(i in 1:500){
  dat <- read.table(files[i],skip=2)
  NeMat <- cbind(NeMat,dat[,2])
}

# Cet CI for the recent 200 generations
NeCI <- matrix(NA,nrow=200,ncol=2)
for(i in 1:200){
  NeCI[i,] <- quantile(NeMat[i,],probs=c(0.05,0.95))
}

# Set up data to get ready for ggplot
NeCI_dat <- as.data.frame(NeCI)
NeCI_dat$Generation <- 1:nrow(NeCI_dat)

# Median
Ne_med <- as.data.frame(rowMedians(NeMat[1:500,]))
colnames(Ne_med) <- "median"
Ne_med$Generation <- 1:nrow(Ne_med)

# Now for P2 (low arctic)
# Load all the iteration files and put it in a matrix
files2 <- paste("with_maf05/output_gone_tempfiles_P2/outfileLD_TEMP/outfileLD_",1:500,"_GONE_Nebest",sep="")
NeMat2 <- NULL
for(i in 1:500){
  dat2 <- read.table(files2[i],skip=2)
  NeMat2 <- cbind(NeMat2,dat2[,2])
}

# Get CI for the recent 200 generations
NeCI2 <- matrix(NA,nrow=200,ncol=2)
for(i in 1:200){
  NeCI2[i,] <- quantile(NeMat2[i,],probs=c(0.05,0.95))
}

# Set up data to get ready for ggplot
NeCI_dat2 <- as.data.frame(NeCI2)
NeCI_dat2$Generation <- 1:nrow(NeCI_dat2)

# Median
Ne_med_2 <- as.data.frame(rowMedians(NeMat2[1:500,]))
colnames(Ne_med_2) <- "median"
Ne_med_2$Generation <- 1:nrow(Ne_med_2)


# Define generation time b/c we want to plot in years
gen=25.7 #Taylor et al. 2007

ggplot()+
  # High Arctic
  geom_ribbon(data=NeCI_dat, aes(x=Generation*gen, ymin=V1, ymax=V2), fill="#92C5DE", alpha=0.5)+
  geom_line(data=Ne_med, aes(x=(Generation*gen),y=median), color="#4D9BD3", lwd=1.5)+
  # Low Arctic
  geom_ribbon(data=NeCI_dat2, aes(x=Generation*gen, ymin=V1, ymax=V2), fill="#F4A582", alpha=0.5)+
  geom_line(data=Ne_med_2, aes(x=(Generation*gen),y=median), color="#E9503C", lwd=1.5)+
  # Cutting off at 150 generations
  xlim(0,150*gen)+
  ylim(0,8000)+
  theme_bw()+
  xlab("Years ago")+
  ylab(expression(paste("Effective population size (",italic(""*N*"")[e],")",sep="")))+
  theme(panel.grid.minor = element_blank(),panel.grid.major = element_blank())+
  theme(plot.margin = margin(0.2,0.6,0.2,0.3, "cm"))

  
ggsave("GONE_plot_not_logged_polygons_median_color2_maf05_150gen.png", height=3, width=4, dpi=1000) 

