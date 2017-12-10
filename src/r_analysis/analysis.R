library(tidyverse)
library(maps)
library(cowplot)
library(reshape2)
library(forcats)
library(RColorBrewer)


count_data = read_csv("../../data/ramen_pho_count.csv")

melted_count_data <- melt(count_data, id=c("city", "state", "country"), value.name="count") 

melted_count_data$variable <- melted_count_data$variable %>% 
  fct_recode("ramen" = "ramen_count", "pho" = "pho_count") 

ggplot(melted_count_data) + 
  geom_bar(aes(x=fct_reorder(city, count, .desc=TRUE), y=count, fill=variable), position="dodge", stat="identity") +
  scale_fill_discrete(name="restaurant type") +
  xlab("city") +
  ggtitle("Ramen and Pho Restaurants by City") +
  theme_classic() +
  theme(legend.justification=c("right", "top"),
        legend.box.just="right",
        legend.position=c(0.95,0.95),
        legend.title=element_text(face="bold"),
        axis.text.x = element_text(angle = 90, hjust = 1, size=8),
        plot.title = element_text(face="bold", size=14))

ggsave("../../results/ramen_pho_restaurants_by_city.png", width = 30, height = 20, units = "cm")


percent_count_data <- count_data %>% 
  mutate(total_count = ramen_count + pho_count) %>% 
  mutate(percent_ramen = ramen_count/total_count) %>% 
  mutate(percent_pho = pho_count/total_count) 

usa <- map_data("usa")
canada <- map_data("world", "canada")
states <- map_data("state")
north_america <- ggplot() + geom_polygon(data=states, aes(x = long, y = lat, group = group), color = "white", size=0.15, fill="#DCDCDC") + geom_polygon(data=canada, aes(x=long, y=lat, group = group), fill="#DCDCDC") +theme_classic() + coord_fixed(1.3)

canada_map <- ggplot() + geom_polygon(data=canada, aes(x = long, y = lat, group = group), color = "white", size=0.15, fill="#DCDCDC")
us_map <- ggplot() + geom_polygon(data=states, aes(x = long, y = lat, group = group), color = "white", size=0.15, fill="#DCDCDC")


cities <- data.frame(
  city = c("San Francisco", "Toronto", "Los Angeles", "Vancouver", "Seattle", "San Diego", "New York", "Washington DC", "Chicago", "Las Vegas", "Boston", "Houston", "Portland", "Atlanta", "Philadelphia", "Phoenix", "Miami", "Denver", "Dallas", "Charlotte", "Minneapolis", "Montreal"),
  lat = c(37.773972, 43.639217, 34.052235, 49.246292, 47.608013, 32.715736, 40.730610, 38.930176, 41.881832, 36.114647, 42.361145, 29.759438, 45.523064, 33.753746, 39.952583, 33.448376, 25.761681, 39.742043, 32.897480, 35.227085, 44.986656, 45.5017),
  long = c(-122.431297, -79.400414, -118.243683, -123.116226, -122.335167, -117.161087, -73.935242, -77.070503, -87.623177, -115.172813, -71.057083, -95.369957, -122.676483, -84.386330, -75.165222, -112.074036, -80.191788, -104.991531, -97.040443, -80.843124, -93.258133, -73.5673),
  stringsAsFactors = FALSE
)

count_data_by_city = inner_join(percent_count_data, cities)

us_count_data <- count_data_by_city %>% 
  filter(country == "USA")

canada_count_data <- count_data_by_city %>% 
  filter(country == "Canada")

count_data_by_city


heatmap <- colorRampPalette((brewer.pal(11, "YlOrRd")), space="Lab")

north_america + 
  geom_point(data=count_data_by_city, aes(x = long, y = lat, color=percent_ramen), size=4, alpha=0.6) +
  ggtitle("Ramen Popularity in North America") +
  scale_colour_gradientn(colours=heatmap(100), name="proportion of \nramen restaurants") +
  theme(legend.justification=c("right", "top"),
        legend.box.just="right",
        legend.title=element_text(face="bold"),
        axis.text.x = element_text(angle = 90, hjust = 1, size=8),
        plot.title = element_text(face="bold", size=14))

ggsave("../../results/ramen_popularity.png", width = 20, height = 20, units = "cm")


heatmap <- colorRampPalette((brewer.pal(11, "YlGnBu")), space="Lab")

north_america + 
  geom_point(data=count_data_by_city, aes(x = long, y = lat, color=percent_pho), size=4, alpha=0.7) +
  ggtitle("Pho Popularity in North America") +
  scale_colour_gradientn(colours=heatmap(100), name="proportion of \npho restaurants") +
  theme(legend.justification=c("right", "top"),
        legend.box.just="right",
        legend.title=element_text(face="bold"),
        axis.text.x = element_text(angle = 90, hjust = 1, size=8),
        plot.title = element_text(face="bold", size=14))

ggsave("../../results/pho_popularity.png", width = 20, height = 20, units = "cm")
