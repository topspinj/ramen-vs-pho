#! /usr/bin/env Rscript
# map_generator.R
# Jill Cates, Dec 2017
#
# This script reads in the clean pho_ramen_count.csv file and generates two maps that show frequency of pho/ramen restaurants.
#
# Usage: Rscript src/map_generator.R results/pho_ramen_counts_clean.csv data/cities_coords.csv results/pho_restaurants.png results/ramen_restaurants.png

# Input variables 
args <- commandArgs(trailingOnly = TRUE)
input_file <- args[1] 
city_file <- args[2]
pho_png <- args[3]
ramen_png <- args[4]

suppressPackageStartupMessages(library(tidyverse))
suppressPackageStartupMessages(library(readr))
suppressPackageStartupMessages(library(maps))
suppressPackageStartupMessages(library(cowplot))
suppressPackageStartupMessages(library(reshape2))
suppressPackageStartupMessages(library(forcats))
suppressPackageStartupMessages(library(RColorBrewer))


wrangle_data <- function() {
  count_data <- read_csv(input_file, col_types = cols())
  city_data <- read_csv(city_file, col_types = cols())
  percent_count_data <- count_data %>% 
    mutate(total_count = ramen_count + pho_count) %>% 
    mutate(percent_ramen = ramen_count/total_count) %>% 
    mutate(percent_pho = pho_count/total_count) 
  count_data_by_city <- inner_join(percent_count_data, city_data)
  return(count_data_by_city)
}


create_base_map <- function() {
  # create base map of North America using R 'maps' library
  # returns a ggplot of USA and Canada
  usa <- map_data("usa")
  canada <- map_data("world", "canada")
  states <- map_data("state")
  north_america <- ggplot() + geom_polygon(data=states, aes(x = long, y = lat, group = group), color = "white", size=0.15, fill="#DCDCDC") + geom_polygon(data=canada, aes(x=long, y=lat, group = group), fill="#DCDCDC") +theme_classic() + coord_fixed(1.3)
  return(north_america)
}

create_ramen_popularity_map <- function() {
  # generates a "heatmap" of ramen popularity in North America
  count_data_by_city <- wrangle_data()
  basemap <- create_base_map()
  heatmap <- colorRampPalette((brewer.pal(9, "YlOrRd")), space="Lab")
  
  basemap + 
    geom_point(data=count_data_by_city, aes(x = long, y = lat, color=percent_ramen), size=4, alpha=0.6) +
    scale_colour_gradientn(colours=heatmap(100), name="proportion of \nramen restaurants") +
    theme(legend.justification=c("right", "top"),
          legend.box.just="right",
          legend.title=element_text(face="bold"),
          axis.text.x = element_text(angle = 90, hjust = 1, size=8),
          plot.title = element_text(face="bold", size=14))
  ggsave(ramen_png, width = 20, height = 20, units = "cm")
  
}


create_pho_popularity_map <- function() {
  # generates a "heatmap" of pho popularity in North America
  count_data_by_city <- wrangle_data()
  basemap <- create_base_map()
  heatmap <- colorRampPalette((brewer.pal(9, "YlGnBu")), space="Lab")
  
  basemap + 
    geom_point(data=count_data_by_city, aes(x = long, y = lat, color=percent_pho), size=4, alpha=0.7) +
    scale_colour_gradientn(colours=heatmap(100), name="proportion of \npho restaurants") +
    theme(legend.justification=c("right", "top"),
          legend.box.just="right",
          legend.title=element_text(face="bold"),
          axis.text.x = element_text(angle = 90, hjust = 1, size=8),
          plot.title = element_text(face="bold", size=14))
  ggsave(pho_png, width = 20, height = 20, units = "cm")
}

create_pho_popularity_map()
create_ramen_popularity_map()
