concatenate_csv:
	bash src/concatenate_csv.sh data/restaurant_counts data

clean_data: 
	Rscript src/csv_cleaner.R data/pho_counts.csv data/ramen_counts.csv results/pho_ramen_counts_clean.csv

barplot:
	Rscript src/barplot_generator.R results/pho_ramen_counts_clean.csv results/ramen_pho_restaurants_by_city.png

maps:
	Rscript src/map_generator.R results/pho_ramen_counts_clean.csv data/cities_coords.csv results/pho_restaurants.png results/ramen_restaurants.png
	
doc/analysis.md: src/r_analysis/analysis.Rmd 
	Rscript -e 'ezknitr::ezknit("src/r_analysis/analysis.Rmd", out_dir="doc")'

doc/report.md: src/r_analysis/report.Rmd
	Rscript -e 'ezknitr::ezknit("src/r_analysis/report.Rmd", out_dir="doc")'




# clean up intermediate files
clean_counts:
	rm -f data/restaurant_counts/*.csv
clean_reviews:
	rm -f data/reviews/*.csv

# delete imgs in results folder
clean_imgs:
	rm -f results/*.png