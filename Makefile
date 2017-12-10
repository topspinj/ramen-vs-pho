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