import pandas as pd

ramen = pd.read_csv("https://s3.ca-central-1.amazonaws.com/ramenvspho/ramen_reviews.csv")
pho = pd.read_csv("https://s3.ca-central-1.amazonaws.com/ramenvspho/pho_reviews.csv")

ramen.to_csv("../data/ramen_reviews.csv")
pho.to_csv("../data/pho_reviews.csv")