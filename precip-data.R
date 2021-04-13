### Build sf version of precip.txt from RSpatial
########################
## Britta Schumacher
## April 13, 2021
########################
# load packages
library(tidyverse)
library(sf)
library(sp)

# load data from data folder
precip <- read.table("./data/precip.txt", sep = ",", header=T)

# add ANNUAL column
p <- precip %>% mutate(ANNUAL = rowSums(.[6:17])) %>% arrange(ANNUAL)
glimpse(precip)

# turn p into sp object
psp <- SpatialPoints(cbind(p$LONG, p$LAT), proj4string=CRS("+proj=longlat +datum=NAD83")) # proj info taken from RSpatial website
psp <- SpatialPointsDataFrame(psp, p)
psp <- spTransform(psp, CRS("+proj=aea +lat_1=34 +lat_2=40.5 +lat_0=0 +lon_0=-120 +x_0=0 +y_0=-4000000 +ellps=GRS80 +datum=NAD83 +units=m +no_defs"))

# create sf object
p_sf <- st_as_sf(psp, coords = c("LAT", "LONG"), crs = ("+proj=aea +lat_1=34 +lat_2=40.5 +lat_0=0 +lon_0=-120 +x_0=0 +y_0=-4000000 +ellps=GRS80 +datum=NAD83 +units=m +no_defs"))

# save sf object to data folder
saveRDS(p_sf, "./data/CA_precip_sf.RDS")