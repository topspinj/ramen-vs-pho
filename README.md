# Ramen vs. Pho

This project investigates the popularity of pho and ramen in major cities across North America.

### Question

Which is more popular: pho or ramen? 

### Data Source

Data will be obtained from Yelp Fusion API for the top 30 metropolitian areas in North America [1](https://factfinder.census.gov/faces/tableservices/jsf/pages/productview.xhtml?src=bkmk), [2](http://www.statcan.gc.ca/pub/91-214-x/2016000/tbl/tbl1.1-eng.htm). 

I used Yelp Fusion's python sample script as a template and modified it to retrieve the top 5 ramen/pho restaurants in each city. The script converts the response into a dataframe and outputs it as a csv file. I also pull the total number of restaurants for each query and store it in a separate csv file. 

See my script [here](https://github.com/topspinj/yelp-fusion/tree/master/fusion/python)

Yelp explains their search results algorithm [here](https://www.yelp-support.com/article/How-does-Yelp-decide-which-reviews-to-feature-in-search-results?l=en_US).


### Hypothesis 

Ramen is more popular than pho in North America. 

### Data Analysis Plan 

- compare number of pho vs. ramen restaurants in 30 cities (use paired t-test)
- compare total number of reviews for top 5 pho and ramen restaurants 
- map pho vs. ramen data for each city on map of North America (ggplot2?)