#!/bin/bash

# concatenates ramen and pho data

# to run: bash _concatenate.sh

cat $1/*_ramen_count.csv > $2/ramen_counts.csv

cat $1/*_pho_count.csv > $2/pho_counts.csv