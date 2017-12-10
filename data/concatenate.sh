#!/bin/bash

# concatenates ramen and pho data

# to run: bash _concatenate.sh

cat reviews/*_ramen.csv > ramen_reviews.csv

cat reviews/*_pho.csv > pho_reviews.csv