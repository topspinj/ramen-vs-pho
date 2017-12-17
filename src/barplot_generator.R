#! /usr/bin/env Rscript
# map_generator.R
# Jill Cates, Dec 2017
#
# This script reads in the cleaned csv file with pho and ramen restaurant count data, joins with city latitude/longitude data, and creates plots that represent pho/ramen popularity on a map.
#
# Usage: Rscript src/barplot_generator.R results/pho_ramen_counts_clean.csv ramen_pho_restaurants_by_city.png

#creating input variables 
args <- commandArgs(trailingOnly = TRUE)
input_file <- args[1] 
output_file <- args[2]

suppressPackageStartupMessages(library(tidyverse))
suppressPackageStartupMessages(library(readr))
suppressPackageStartupMessages(library(maps))
suppressPackageStartupMessages(library(reshape2))
suppressPackageStartupMessages(library(forcats))
suppressPackageStartupMessages(library(RColorBrewer))

wrangle_data <- function() {
  count_data <- read_csv(input_file, col_types = cols())
  melted_count_data <- melt(count_data, id=c("city"), value.name="count") 
  melted_count_data$restaurant <- melted_count_data$variable %>% 
    fct_recode("ramen" = "ramen_count", "pho" = "pho_count") 
  return(melted_count_data)
}

create_plot <- function() {
  data <- wrangle_data()
  ggplot(data) + 
    geom_bar(aes(x=fct_reorder(city, count, .desc=TRUE), y=count, fill=restaurant), position="dodge", stat="identity") +
    scale_fill_discrete(name="restaurant type") +
    xlab("city") +
    ggtitle("Ramen and Pho Restaurants by City") +
    theme_classic() +
    theme(legend.justification=c("right", "top"),
          legend.box.just="right",
          legend.position=c(0.95,0.95),
          legend.title=element_text(face="bold"),
          axis.text.x = element_text(angle = 90, hjust = 1, size=8),
          plot.title = element_text(face="bold", size=14))
  ggsave(output_file, width = 30, height = 20, units = "cm") 
}

create_plot()

