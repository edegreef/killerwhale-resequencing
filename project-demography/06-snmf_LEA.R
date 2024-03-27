# Admixture analysis through LEA's sNMF
# and plotting pie chart admixture map using help from Tom Jenkins' tutorial on github (https://github.com/Tom-Jenkins/admixture_pie_chart_map_tutorial)

# Install LEA
#library(devtools)
#devtools::install_github("bcm-uga/LEA")

library(LEA)
library(reshape2)

# for making pie chart map:
library(raster)
library(rworldmap)
library(rworldxtra)
library(ggplot2)
library(ggpubr)

# Note: the snmf function doesn't do well with files on dropbox but can run move files elsewhere after the snmf function if preferred
setwd("C:/Users/eveli/Desktop/LEA_killerwhale")

# 1) Prep and run sNMF
# 2) Set up for pie charts
# 3) Nicer admixture plot

######## 1) Prep and run sNMF
# Convert ped file to geno file (automatically outputs in working directory)
ped2geno("orca_snps_q30_biallelic_HWE0.005_miss0.4_maf0.05_LDprunedr08_n24.ped")

# Run snmf for K 1-5
project=NULL
project=snmf("orca_snps_q30_biallelic_HWE0.005_miss0.4_maf0.05_LDprunedr08_n24.geno", K=1:5, entropy=TRUE, repetitions=10, project="new")

# Can also load snmf project if saved
project=load.snmfProject("orca_snps_q30_biallelic_HWE0.005_miss0.4_maf0.05_LDprunedr08_n24.snmfProject")

# Reading in sample info
sample_info <- read.csv("sample_info_KL_killerwhale.csv", header=T)

# Remove dups and/or close kin from sample info metadata
sample_info <- subset(sample_info, remove!="X")

# Match order to vcf order (needs to have a "vcf_order" column in the sample_info)
sample_info <- sample_info[order(sample_info$vcf_order),]

# Plot cross-entropy
plot(project, col="blue", pch=19, cex=1.5)

# Extract the cross-entropy of runs K1:5
ce_k1 = cross.entropy(project, K = 1)
ce_k2 = cross.entropy(project, K = 2)
ce_k3 = cross.entropy(project, K = 3)
ce_k4 = cross.entropy(project, K = 4)
ce_k5 = cross.entropy(project, K = 5)

# Save values in csv
ce_merged = as.data.frame(cbind(ce_k1, ce_k2, ce_k3, ce_k4, ce_k5))
write.csv(ce_merged, "cross-entropy_K1-5.csv")

# Basic barcharts with LEA, going to do for runs K=2, 3, 4, 5. this is default snmf order, can also just jump to line 99 to skip this
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


######## 2) Setting up data for pie map (using Tom Jenkin's script set up)
best <- which.min(cross.entropy(project, K = 2))
best

# Extract Q-matrix for the best run
qmatrix <- as.data.frame(Q(project, K = 2, run = best))
head(qmatrix)

# Label column names of qmatrix
ncol(qmatrix)
cluster_names = c()
for (i in 1:ncol(qmatrix)){
  cluster_names[i] = paste("Cluster", i)
}
cluster_names
colnames(qmatrix) = cluster_names
head(qmatrix)

# Add individual IDs
qmatrix$Ind = sample_info$vcf_ID

# Add site IDs
qmatrix$Site = sample_info$location_name
head(qmatrix)

#write.csv(qmatrix, "qmatrix_K2.csv", row.names=FALSE)

# convert dataframe to long format
qlong = melt(qmatrix, id.vars=c("Ind","Site"))
head(qlong)

# Define colour palette
pal = colorRampPalette(c("#D6604D", "#4393C3"))
cols = pal(length(unique(qlong$variable)))

# Plot admixture barplot 
admix.bar = ggplot(data=qlong, aes(x=Ind, y=value, fill=variable))+
  geom_bar(stat = "identity")+
  scale_y_continuous(expand = c(0,0))+
  facet_wrap(~Site, scales = "free", ncol = 2)+
  scale_fill_manual(values = cols)+
  ylab("Admixture proportion")+
  xlab("Individual")+
  theme(axis.text.x = element_blank(),
        axis.ticks.x = element_blank(),
        axis.title.x = element_blank(),
        strip.text = element_text(colour="black", size=12),
        panel.grid = element_blank(),
        panel.background = element_blank(),
        legend.position = "top",
        legend.title = element_blank(),
        legend.text = element_text(size = 12))
admix.bar
#ggsave("1.admixture_barplot_sites_K2.png", width=10, height=9, dpi=300)


# Next, making pie chart maps

# Calculate mean admixture proportions for each site
head(qmatrix)
clusters = grep("Cluster", names(qmatrix)) # indexes of cluster columns
avg_admix = aggregate(qmatrix[, clusters], list(qmatrix$Site), mean)

# Order alphabetically by site
avg_admix = avg_admix[order(as.character(avg_admix$Group.1)), ]
avg_admix

# Convert dataframe from wide to long format
avg_admix = melt(avg_admix, id.vars = "Group.1")
head(avg_admix)

# Define a function to plot pie charts using ggplot for each site
pie_charts = function(admix_df, site, cols){
  ggplot(data = subset(admix_df, Group.1 == site),
         aes(x = "", y = value, fill = variable))+
    geom_bar(width = 1, stat = "identity", colour = "black", show.legend = FALSE)+
    coord_polar(theta = "y")+
    scale_fill_manual(values = cols)+
    theme_void()
}

# Run function on one site
pie_charts(avg_admix, site = "Pond Inlet", cols = cols)

# Apply function to all sites using for loop - site names have to match the ones in the sample_info
subsites = sort(c("East Greenland", "Newfoundland", "Pangnirtung", "Pond Inlet", "Repulse Bay"))

pies = list()
for (i in subsites){
  pies[[i]] = pie_charts(admix_df = avg_admix, site = i, cols = cols) 
}
pies

# Import csv file containing coordinates if not already in the sample_info data
#coords = read.csv("F:/NBW-me/reseq/lea_rerun/site_mean_coords.csv", header=T)

# or if using from sample_info df:
coords <- sample_info[,c("location_name", "est_latitude", "est_longitude")]

# Remove duplicates
coords <- coords %>% distinct()

# Order alphabetically by site
coords = coords[order(coords$location_name), ] 
coords

# Check order matches coords order
as.character(avg_admix$Group.1) == as.character(coords$location_name)

## Make base map
# Set map boundary (xmin, xmax, ymin, ymax)
boundary = extent(-105,0, 45, 85)
boundary

# Get map outlines from rworldmap package
map.outline = getMap(resolution = "high")

# Crop to boundary and convert to dataframe
map.outline = crop(map.outline, y = boundary) %>% fortify()

# Plot basemap
basemap = ggplot()+
  geom_polygon(data=map.outline, aes(x=long, y=lat, group=group), fill="grey88",
               colour="black", size=0.5)+
  coord_quickmap(expand=F)+
  ggsn::north(map.outline, symbol = 10, scale = 0.06, location = "topleft")+
  #ggsn::scalebar(data = map.outline, dist = 1000, dist_unit = "km", height = 0.01,
  #               transform = TRUE, model = "WGS84", 
  #               location = "bottomleft", anchor = c(x = -70, y = 55),
  #               st.bottom = FALSE, st.size = 4, st.dist = 0.015)+
  xlab("Longitude")+
  ylab("Latitude")+
  theme(
    axis.text = element_text(colour="black", size=12),
    axis.title = element_text(colour="black", size=14),
    panel.background = element_rect(fill="white"),
    panel.border = element_rect(fill = NA, colour = "black", size = 0.5),
    panel.grid.minor = element_line(colour="grey90", size=0.5),
    panel.grid.major = element_line(colour="grey90", size=0.5),
    legend.text = element_text(size=12),
    legend.title = element_blank(),
    legend.key.size = unit(0.7, "cm"),
    legend.position = "top"
  )
basemap


# Then add pie charts to basemap

# Extract coordinates for each site
coord.list = list()
for (i in subsites){
  coord.list[[i]] = c(subset(coords, location_name == i)$est_longitude, subset(coords, location_name == i)$est_latitude)
}
coord.list

# Define pie chart sizes
radius = 2.5

# Convert ggplot pie charts to annotation_custom layers
pies.ac = list()
for (i in 1:length(subsites)){
  pies.ac[[i]] = annotation_custom(grob = ggplotGrob(pies[[i]]),
                                   xmin = coord.list[[i]][[1]] - radius,
                                   xmax = coord.list[[i]][[1]] + radius,
                                   ymin = coord.list[[i]][[2]] - radius,
                                   ymax = coord.list[[i]][[2]] + radius)
}

# Add layers to basemap
pie.map = basemap + pies.ac
pie.map
ggsave("2.piecharts_map_K2_colours.png", width = 8, height = 10, dpi = 1000)

# Combine ggplots
ggarrange(admix.bar + theme(legend.position = "right") + labs(title = "Individual admixture proportions", tag = "A"),
          pie.map + labs(title = "Mean admixture proportions for each site", tag = "B"))
ggsave("3.admixture_bar_map_K2_colours.png", width = 15, height = 6, dpi = 700)



######## 3) Making nicer admixture plot

# Plot admixture results in order by site (added in value for site/pop order in the outputs from above, and reloaded here)

library(patchwork)
library(reshape2)
library(tidyverse)

# Read in file
qmatrix <- read.csv("qmatrix_K2_poporder.csv")
qmatrix <- subset(qmatrix, select= -c(pop_order))

# Convert to long format
qlong <- melt(qmatrix, id.cars=c("Ind", "Site"))
head(qlong)

# Plot
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
snmf_admix

#ggsave("snmf_K2_ggplot_color2_flat.svg", height=2.1, width=5, dpi=1000)

# need to have "svglite" package installed to save as svg
#ggsave("snmf_K2_ggplot_color2_test2.svg", height=2.5, width=5)
