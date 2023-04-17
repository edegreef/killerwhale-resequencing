# Killer whale site map Arctic

library(ggOceanMaps)
library(tidyverse)

# Quick test, making a quick boundary
test <- data.frame(lon=c(-110, -110, -20, -20), lat=c(45, 85, 73, 45))

# Plot map, can turn bathymetrey on/off
basemap(data=test, bathymetry=TRUE)

# Can also make a full polar map, and add in glaciers
basemap(limits=60, bathymetry=TRUE, glaciers=TRUE)


# Load location coordinates
points <- read.csv("site_est_coords.csv", header=T)

# Making  map
basemap(limits = c(-100, -40, 45, 80),
                   rotate = TRUE,
                   bathymetry=TRUE,
                   grid.col="#e7e7e7",
        bathy.style = "poly_blues",
        land.col="gray80",
        land.border.col="gray30",
        lat.interval=10
        )+
  geom_spatial_point(data=points, 
                     aes(x=est_longitude, y=est_latitude), 
                     pch=21, size=2, stroke=0.7, alpha=1,
                     colour="black", fill="#F5AC1B")+
  labs(x="Longitude", y="Latitude")+
  #scale_fill_discrete()+
  scale_fill_manual(values=c("#F7FBFF","#EAF3FB", "#D3E6F1", "#B9D8E9", "#A4CCE3", "#93C4DE", "#7CB6DA", "#66AAD4"))


# For site point colours let's use inkscape over the old points b/c can't figure it out here (though there must be a way)

ggsave("KW_site_map.png", width=6, height=5, dpi=1200)


### basic polar map
library(rnaturalearth)
library(ggspatial)

cExtent <- c(-180,180,30,90)

worldMap <- ne_countries(scale=10, returnclass="sp")
worldMap <- crop(worldMap,cExtent)

x_lines <- seq(-120,180, by=60)

polar_map <- ggplot() +
  # Plotting land
  geom_polygon(data=worldMap, aes(x=long, y=lat, group=group), fill="gray88", colour="gray50", lwd=0.5) +
  # This makes the map circular/polar
  coord_map("ortho", orientation=c(90, 0, 0))+
  # Theme and axes adjustments
  theme(legend.position="none",
        panel.background=element_blank(), 
        axis.ticks=element_blank()) +
  #scale_y_continuous(breaks = seq(30, 90, by = 5), labels = NULL) +
  scale_x_continuous(breaks = NULL) + 
  xlab("") + 
  ylab("") +
  # Add polar map border line
  geom_hline(aes(yintercept=30), size=0.5, colour="gray")# +
  # Add longitude guidelines
#  geom_segment(size=0.1, aes(y=30, yend=90, x=x_lines, xend=x_lines), linetype="dashed", colour="gray") +
  # Add latitude guidelines
#  geom_segment(size=1.2, aes(y=30, yend=30, x=-180, xend=0), colour="gray") +
 # geom_segment(size=1.2, aes(y=30, yend=30, x=180, xend=0), colour="gray") +
 # geom_segment(size=0.1, aes(y=60, yend=60, x=-180, xend=0), linetype="dashed", colour="gray") +
 # geom_segment(size=0.1, aes(y=60, yend=60, x=180, xend=0), linetype="dashed", colour="gray")

polar_map
ggsave("polar_map.png", width=5, height=5, dpi=600)

