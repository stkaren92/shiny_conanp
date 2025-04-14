setwd("~/Dropbox/JANO/2016/Conabio/hexagonsGrid_inR/")

library(ggplot2)
library(dplyr)
library(readr)
library(rgeos)
library(maptools)
library(rgdal)
library(scales)
library(downloader)

#download the hex grid map
#download("~/Dropbox/JANO/2016/Conabio/hexagonsGrid_inR/", "mx_hexgrid.json")
map <- readOGR("mx_hexgrid.json", "OGRGeoJSON")
map
#state abbreviations
centers <- coordinates(map)
centers <- cbind(centers, map@data)
names(centers)[1:3] <- c("lat", "long", "id")

#Hex Grid Map
mapStates <- function(map, party, low = "gray90", high, title = "") {
  map@data <- left_join(map@data, party)
  mx_map <- fortify(map, region="state_abbr")
  ggplot() + 
    geom_map(map=mx_map, data = mx_map, color="black", 
      aes(map_id=id, x = long, y = lat)) +
    geom_map(map=mx_map, data = map@data, color="white", 
      aes(map_id = state_abbr, fill = per)) +
    coord_map() +
    geom_text(data = centers, 
      aes(label=id, x=lat, y=long), color="white", size=4.5) +
    scale_fill_gradient("valores", low = low, high = high) +
    theme_bw() +
    ggtitle(title) +
    theme(panel.border=element_blank()) +
    theme(panel.grid=element_blank()) +
    theme(axis.ticks=element_blank()) +
    theme(axis.text=element_blank()) + 
    labs(x=NULL, y=NULL)
}
