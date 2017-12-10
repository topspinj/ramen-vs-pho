# Yelp Fusion API

## Overview

This program is adapted from the [Yelp Fusion API](https://github.com/Yelp/yelp-fusion) repository and uses the Search API to query for businesses by a search term and location,
and the Business API to query additional information about the top result
from the search query.

The purpose of the [get_reviews.py script](get_reviews.py) is to collect Yelp review data from 20 cities in the United States and Canada. Upon fetching the data, the script creates csv files and saves those files in **data/reviews/...**. 

Please refer to [API documentation](https://www.yelp.com/developers/documentation/v3)
for more details.

## Steps to run

### To install the dependencies, run:
`pip install -r requirements.txt`.

### Run script:

* Important: you will need to create a config file to store your Yelp API client ID and secret in order for the API to work


To get top 5 ramen and pho restaurant data for each city, run this script:

```
python get_reviews.py
```

The output csv files are located in **../../data/reviews/**.

To get with ramen and pho restaurant count data for each city, run this script:

```
python get_restaurant_count.py
```

The output csv files are located in **../../data/restaurant_counts/**.

In both python scripts, `city_args` is an array which contains all of the cities to be queried. This array gets looped over and fetches data for each city. If you would like to remove or add cities in these queries, you simply need to modify the `city_args` array.