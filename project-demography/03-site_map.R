# Killer whale site map

setwd("C:/Users/eveli/Dropbox/Whales with Garroway/killer whales/")

# Eastern Canadian Arctic & Western North Atlantic
# Load libraries
library(ggOceanMaps)
library(tidyverse)

# Load location coordinates
points <- read.csv("C:/Users/eveli/Dropbox/Whales with Garroway/killer whales/map/site_est_coords.csv", header=T)

# Making map
basemap(
    limits = c(-95, -43, 40, 85),rotate = TRUE,bathymetry=FALSE,grid.col="#e7e7e7",
        bathy.style = "poly_blues",
        land.col="gray80",
        land.border.col="gray30",
        lat.interval=10
        )+
  geom_spatial_point(data=points, 
                     aes(x=est_longitude, y=est_latitude), 
                     pch=21, size=2, stroke=0.7, alpha=1,
                     colour="black", fill="#F5AC1B")+
  labs(x="Longitude", y="Latitude")


# For site points using inkscape over the yellow points, adding site labels manually too
#ggsave("C:/Users/eveli/Dropbox/Whales with Garroway/Kyle's killer whales/map/KW_site_map_noBATHY2.png", width=5, height=5, dpi=1200)

#############

# polar map for the inset
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
  # Add polar map border line - marking where to crop too
  geom_hline(aes(yintercept=30), size=0.5, colour="gray")

polar_map
#ggsave("polar_map.png", width=5, height=5, dpi=600)
