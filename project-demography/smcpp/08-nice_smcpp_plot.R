# plot killer whale smcpp


library(ggplot2)
library(tidyverse)
library(dplyr)


setwd("~/smcpp_redo/killer_whale_10Mb_scaffolds")

# load in output
smc <- read.csv("smc_combined_run_miss0.4_100iter_10Mb_plot.csv", header=T)

#smc1 <- read.csv("smc_group1_miss0.4_100iter_10Mbscaf_plot.csv", header=T)
#smc2 <- read.csv("smc_group2_miss0.4_100iter_10Mbscaf_plot.csv", header=T)

#smc <- rbind(smc1, smc2)

# add unique id for label+run
smc$plot_id <- paste(smc$label, smc$plot_num, sep="_")

# set generation time (and mutation rate for axis label)
gen=25.7 #Taylor et al. 2007
mu=2.34e-8 #Dornburg et al. 2011?

#group1= canadian low arctic--- mid line + greenland. group2=pond inlet and nf
group_colors <- c(Group1="#B2182B", Group2="#2166AC")

# Extract median run 
# first subset by group
group1 <- subset(smc, label=="Group1")
group2 <- subset(smc, label=="Group2")

group1_prep <- group1 %>% 
   group_by(plot_num) %>% 
   mutate(row=row_number())
group1_med <- aggregate(group1_prep[,c("x","y")], list(group1_prep$row), FUN=median)
colnames(group1_med)[1] <- "row"
group1_med$label <- "Group1"
  
group2_prep <- group2 %>% 
  group_by(plot_num) %>% 
  mutate(row=row_number())
group2_med <- aggregate(group2_prep[,c("x","y")], list(group2_prep$row), FUN=median)
colnames(group2_med)[1] <- "row"
group2_med$label <- "Group2"


## Plot smc++ results

group_colors <- c(Group1="#F4A582", Group2="#92C5DE") #for the iteration lines

ggplot()+
  annotate("rect", xmin = 11700, xmax =115000, ymin=40, ymax=11000, alpha = 0.5, fill = "gray80")+
  geom_line(data=smc, aes(x=(x*gen),y=y, group=plot_id, color=label), alpha=0.6, lwd=1)+
  geom_line(data=group1_med, aes(x=(x*gen),y=y), lwd=1.5, alpha=1,colour="#B2182B")+
  geom_line(data=group2_med, aes(x=(x*gen),y=y), lwd=1.5, alpha=1,colour="#2166AC")+
  scale_color_manual(values=group_colors, labels=c("Group1"="P2", "Group2"="P1"))+
  scale_x_continuous(breaks=c(1e1,1e2,1e3,1e4,1e5,1e6),trans='log10')+
  scale_y_continuous(trans='log10',expand=c(0,0))+
  theme_bw()+
  labs(color="Region")+
  xlab("Years ago")+
  ylab("Effective population size")+
  
  # add in the split time based on the raw smc++ split plot
  geom_vline(xintercept=330*gen, colour="#F6BE00", lwd=1, alpha=0.5)+
  geom_vline(xintercept=380*gen, colour="#F6BE00", lwd=1, alpha=0.5)+
  geom_vline(xintercept=410*gen, colour="#F6BE00", lwd=1.5, alpha=0.5)+
  geom_vline(xintercept=450*gen, colour="#F6BE00", lwd=1.5, alpha=0.5)+
  geom_vline(xintercept=550*gen, colour="#F6BE00", lwd=1.5, alpha=0.5)+
  geom_vline(xintercept=550*gen, colour="#F6BE00", lwd=1.5, alpha=0.5)+
  geom_vline(xintercept=575*gen, colour="#F6BE00", lwd=1.5, alpha=0.5)+
  geom_vline(xintercept=625*gen, colour="#F6BE00", lwd=1.5, alpha=0.5)+
  geom_vline(xintercept=675*gen, colour="#F6BE00", lwd=2, alpha=0.5)+
  geom_vline(xintercept=780*gen, colour="#F6BE00", lwd=1.5, alpha=0.5)+
  
  scale_y_continuous(trans='log10', breaks=c(100,1000,10000), limits=c(40,11000), labels=c("1e+02"=expression(10^2), "1e+03"=expression(10^3), "1e+04"=expression(10^4)), expand=c(0,0))+
  scale_x_continuous(breaks=c(1e1,1e2,1e3,1e4,1e5),trans='log10',labels=c("1e+01"=expression(10^1),"1e+02"=expression(10^2),"1e+03"=expression(10^3), "1e+04"=expression(10^4), "1e+05"=expression(10^5)), limits=c(-1,400000),expand=c(0,0))+
  theme(panel.grid.minor = element_blank(),panel.grid.major = element_blank())+
  annotation_logticks(sides = "lb")

ggsave("KW_10Mb_combined_plot_icebar_color3.png", width=6.5, height=4, dpi=1200)

