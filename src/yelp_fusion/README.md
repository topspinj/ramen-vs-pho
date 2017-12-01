# Yelp Fusion API

## Overview

This program is adapted from the [Yelp Fusion API](https://github.com/Yelp/yelp-fusion) repository and uses the Search API to query for businesses by a search term and location,
and the Business API to query additional information about the top result
from the search query.

The purpose of the [get_reviews.py script](get_reviews.py) is to collect Yelp review data from 20 cities in the United States and Canada. Upon fetching the data, the script creates csv files and saves those files in **data/reviews/...**. 

Please refer to [API documentation](https://www.yelp.com/developers/documentation/v3)
for more details.

## Steps to run

To install the dependencies, run:
`pip install -r requirements.txt`.

Run the code sample without specifying any arguments:
`python get_reviews.py`