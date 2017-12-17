#! /usr/bin/env Rscript
# csv_cleaner.R
# Jill Cates, Dec 2017
#
# This script reads in the untidyed ramen_count and pho_count csv files, merges both csv files, creates a tidy dataframe, and outputs a cleaned csv file.
#
# Usage: Rscript src/csv_cleaner.R data/pho_counts.csv data/ramen_counts.csv results/pho_ramen_counts_clean.csv

#creating input variables 
args <- commandArgs(trailingOnly = TRUE)
ramen_input <- args[1] 
pho_input <- args[2]
output_file <- args[3]


suppressPackageStartupMessages(library(tidyverse))
suppressPackageStartupMessages(library(readr))
  ramen_input <- "../../data/ramen_counts.csv"
  pho_input <- "../../data/pho_counts.csv"
main <- function(){
  pho = read_csv(ramen_input, col_types = cols())
  ramen = read_csv(pho_input, col_types = cols())
  
  ramen_pho <- full_join(pho, ramen, by="city")
  pho_ramen_count_clean <- ramen_pho %>% 
    select(city, pho_count = restaurant_count.x, ramen_count = restaurant_count.y) %>% 
    filter(city != 'city') %>% 
    separate(col=city, into=c("city", "state"), sep=", ")
  
  pho_ramen_count_clean$state<-as.factor(pho_ramen_count_clean$state) %>%
    fct_recode("California" = "CA")

  write_csv(pho_ramen_count_clean, path = output_file)
}

main()