---
title: "Exploratory Data Analysis"
author: "Jill Cates"
date: '2017-11-27'
output: html_document
---




```r
count_data = read_csv("../../data/ramen_pho_count.csv")
```

```
## Error: '../../data/ramen_pho_count.csv' does not exist in current working directory ('/Users/jillcates/Dev/mds/block3/DSCI-522/labs/ramen-vs-pho').
```

```r
usa <- map_data("usa")
canada <- map_data("world", "canada")
states <- map_data("state")
north_america <- ggplot() + geom_polygon(data=states, aes(x = long, y = lat, group = group), color = "white", size=0.15, fill="#DCDCDC") + geom_polygon(data=canada, aes(x=long, y=lat, group = group), fill="#DCDCDC") +theme_classic() + coord_fixed(1.3)

canada_map <- ggplot() + geom_polygon(data=canada, aes(x = long, y = lat, group = group), color = "white", size=0.15, fill="#DCDCDC")
us_map <- ggplot() + geom_polygon(data=states, aes(x = long, y = lat, group = group), color = "white", size=0.15, fill="#DCDCDC")
```


```r
cities <- data.frame(
  city = c("San Francisco", "Toronto", "Los Angeles", "Vancouver", "Seattle", "San Diego", "New York", "Washington DC", "Chicago", "Las Vegas", "Boston", "Houston", "Portland", "Atlanta", "Philadelphia", "Phoenix", "Miami", "Denver", "Dallas", "Charlotte", "Minneapolis", "Montreal"),
  lat = c(37.773972, 43.639217, 34.052235, 49.246292, 47.608013, 32.715736, 40.730610, 38.930176, 41.881832, 36.114647, 42.361145, 29.759438, 45.523064, 33.753746, 39.952583, 33.448376, 25.761681, 39.742043, 32.897480, 35.227085, 44.986656, 45.5017),
  long = c(-122.431297, -79.400414, -118.243683, -123.116226, -122.335167, -117.161087, -73.935242, -77.070503, -87.623177, -115.172813, -71.057083, -95.369957, -122.676483, -84.386330, -75.165222, -112.074036, -80.191788, -104.991531, -97.040443, -80.843124, -93.258133, -73.5673),
  stringsAsFactors = FALSE
)

count_data_by_city = inner_join(count_data, cities)
```

```
## Error in inner_join(count_data, cities): object 'count_data' not found
```

```r
us_count_data <- count_data_by_city %>% 
  filter(country == "USA")
```

```
## Error in eval(lhs, parent, parent): object 'count_data_by_city' not found
```

```r
canada_count_data <- count_data_by_city %>% 
  filter(country == "Canada")
```

```
## Error in eval(lhs, parent, parent): object 'count_data_by_city' not found
```


```r
north_america + 
  geom_point(data=count_data_by_city, aes(x = long, y = lat, size=ramen_count), color="dark red", alpha=0.4) + theme(legend.position="none") + ggtitle("Ramen Restaurants in Various North American Cities") 
```

```
## Error in fortify(data): object 'count_data_by_city' not found
```

```r
ggsave("../../results/north_america_map.png", width = 20, height = 20, units = "cm")
```

```
## Error in grDevices::dev.off(): QuartzBitmap_Output - unable to open file '../../results/north_america_map.png'
```

```r
us_ramen <- us_map + 
  geom_point(data=us_count_data, aes(x = long, y = lat, size=ramen_count), color="dark red", alpha=0.4) + 
  theme_bw() + 
  theme(legend.position="none") + 
  ggtitle("Ramen Restaurants in the US") 
```

```
## Error in fortify(data): object 'us_count_data' not found
```

```r
us_pho <- us_map + 
  geom_point(data=us_count_data, aes(x = long, y = lat, size=pho_count), color="dark blue", alpha=0.4) + 
  theme_bw() + 
  theme(legend.position="none") + 
  ggtitle("Pho Restaurants in the US") 
```

```
## Error in fortify(data): object 'us_count_data' not found
```

```r
canada_ramen <- canada_map + geom_point(data=canada_count_data, aes(x = long, y = lat, size=ramen_count), color="dark red", alpha=0.4) + 
  theme_bw() + 
  theme(legend.position="none") + 
  ggtitle("Ramen Restaurants in Canada") 
```

```
## Error in fortify(data): object 'canada_count_data' not found
```

```r
canada_pho <- canada_map + geom_point(data=canada_count_data, aes(x = long, y = lat, size=pho_count), color="dark blue", alpha=0.4) + 
  theme_bw() + 
  theme(legend.position="none") + 
  ggtitle("Pho Restaurants in Canada") 
```

```
## Error in fortify(data): object 'canada_count_data' not found
```

```r
plot_grid(us_ramen, us_pho, canada_ramen, canada_pho)
```

```
## Error in plot_grid(us_ramen, us_pho, canada_ramen, canada_pho): object 'us_ramen' not found
```

```r
ggsave("../../results/north_america_ramen_pho.png", width = 20, height = 20, units = "cm")
```

```
## Error in grDevices::dev.off(): QuartzBitmap_Output - unable to open file '../../results/north_america_ramen_pho.png'
```


```r
t.test(x=count_data$ramen_count, y=count_data$pho_count, paired=TRUE)
```

```
## Error in t.test(x = count_data$ramen_count, y = count_data$pho_count, : object 'count_data' not found
```



```r
library(reshape2)
```

```
## 
## Attaching package: 'reshape2'
```

```
## The following object is masked from 'package:tidyr':
## 
##     smiths
```

```r
percent_count_data <- count_data %>% 
  mutate(total_count = ramen_count + pho_count) %>% 
  mutate(percent_ramen = ramen_count/total_count) %>% 
  mutate(percent_pho = pho_count/total_count) 
```

```
## Error in eval(lhs, parent, parent): object 'count_data' not found
```

```r
melted_count_data <- melt(count_data, id=c("city", "state", "country"), value.name="count")
```

```
## Error in melt(count_data, id = c("city", "state", "country"), value.name = "count"): object 'count_data' not found
```

```r
ggplot(melted_count_data) + 
  geom_bar(aes(x=city, y=count, fill=variable), position="dodge", stat="identity") +
  scale_fill_discrete(name="noodle type") +
  theme(legend.justification=c("right", "top"),
        legend.box.just="right",
        legend.position=c(0.95,0.95),
        legend.title=element_text(face="bold"),
        axis.text.x = element_text(angle = 90, hjust = 1, size=8))
```

```
## Error in ggplot(melted_count_data): object 'melted_count_data' not found
```





```r
pho_reviews = read_csv("../../data/pho_reviews.csv")
```

```
## Error: '../../data/pho_reviews.csv' does not exist in current working directory ('/Users/jillcates/Dev/mds/block3/DSCI-522/labs/ramen-vs-pho').
```

```r
pho_reviews <- pho_reviews %>% 
  filter(city != 'city') %>% 
  select(city, review_count, food_type)
```

```
## Error in eval(lhs, parent, parent): object 'pho_reviews' not found
```

```r
ramen_reviews = read_csv("../../data/ramen_reviews.csv")
```

```
## Error: '../../data/ramen_reviews.csv' does not exist in current working directory ('/Users/jillcates/Dev/mds/block3/DSCI-522/labs/ramen-vs-pho').
```

```r
ramen_reviews <- ramen_reviews %>% 
  filter(city != 'city') %>% 
  select(city, review_count, food_type)
```

```
## Error in eval(lhs, parent, parent): object 'ramen_reviews' not found
```
