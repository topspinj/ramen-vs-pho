concatenate_csv:
	bash src/concatenate_csv.sh data/restaurant_counts data

clean_data: 
	Rscript src/csv_cleaner.R data/pho_counts.csv data/ramen_counts.csv results/pho_ramen_counts_clean.csv

barplot:
	Rscript src/barplot_generator.R results/pho_ramen_counts_clean.csv results/ramen_pho_restaurants_by_city.png

maps:
	Rscript src/map_generator.R results/pho_ramen_counts_clean.csv data/cities_coords.csv results/pho_restaurants.png results/ramen_restaurants.png

doc/report.md: src/report.Rmd
	Rscript -e 'ezknitr::ezknit("src/report.Rmd", out_dir="doc")'


# clean up intermediate files
clean_intermediate:
	rm -f data/pho_counts.csv
	rm -f data/ramen_counts.csv
	rm -f data/pho_reviews.csv
	rm -f data/ramen_reviews.csv
	rm -f data/ramen_pho_count.csv

# clean up raw files, data obtained from Yelp API 
clean_raw: 
	rm -f data/restaurant_counts/*.csv
	rm -f data/reviews/*.csv
	