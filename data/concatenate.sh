#!/bin/bash

# concatenates ramen and pho data

# to run: bash _concatenate.sh

cat reviews/*_ramen.csv > ramen_reviews.csv

cat reviews/*_pho.csv > pho_reviews.csv

cat restaurant_counts/*_ramen_count.csv > ramen_counts.csv

cat restaurant_counts/*_pho_count.csv > pho_counts.csv