# Yelp Fusion API Python Code Sample

## Overview
This program demonstrates the capability of the Yelp Fusion API
by using the Search API to query for businesses by a search term and location,
and the Business API to query additional information about the top result
from the search query.

Please refer to [API documentation](https://www.yelp.com/developers/documentation/v3)
for more details.

**Note:** This script was modified by [Jill](https://github.com/topspinj) to output top 5 results as a csv file.

## Steps to run

To install the dependencies, run:
`pip install -r requirements.txt`.

Run the code sample without specifying any arguments:
`python sample.py`

Run the code sample by specifying the optional arguments:
`python get_restos.py --term="bars" --location="San Francisco, CA --file="san_fran_bars"`
