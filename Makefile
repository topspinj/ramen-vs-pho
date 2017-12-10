
doc/analysis.md: src/r_analysis/exploratory_data_analysis.Rmd 
	Rscript -e 'ezknitr::ezknit("src/r_analysis/exploratory_data_analysis.Rmd", out_dir="doc")'



# clean up intermediate files
clean_counts:
	rm -rf data/restaurant_counts/*.csv
clean_reviews:
	rm -rf data/reviews/*.csv