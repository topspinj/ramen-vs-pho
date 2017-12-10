# Ramen vs. Pho

This project investigates the popularity of pho and ramen in major cities across North America.

### Question

Which is more popular: pho or ramen? 

### Data Source

The dataset is obtained from Yelp Fusion API for 18 metropolitan cities in North America. 

I used Yelp Fusion's python sample script as a template and modified it to retrieve the top 5 ramen and pho restaurants in each city. The script converts the response into a dataframe and outputs it as a csv file. I also pull the total number of restaurants for each query and store it in a separate csv file. Further detail on how these scripts work can be found [here](src/yelp_fusion/README.md).

These python scripts fetch data for each city individually, which generates a separate csv for each city. To concatenate these csv's into a unified file, run this shell script [**data/concatenate.sh**](data/concatenate.sh). 

Yelp explains their search results algorithm [here](https://www.yelp-support.com/article/How-does-Yelp-decide-which-reviews-to-feature-in-search-results?l=en_US).


### Make Tasks

Run tasks in [Makefile](Makefile) to clean up intermediate data and knit analysis/report Rmarkdown files. 

### Hypothesis 

Ramen is more popular than pho in North America. 

### Data Analysis Plan 

- compare number of pho vs. ramen restaurants in 18 North American cities 
- map proporition of pho vs. ramen restaurants for each city using ggplot


### Results

You can see a report of the analysis [here](doc/report.md).

![](data/battle-of-pho-vs-ramen.png)
