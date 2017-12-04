import pandas as pd

data = pd.read_csv("https://s3.ca-central-1.amazonaws.com/ramenvspho/ramen_pho_count.csv")

data.to_csv("../data/ramen_pho_count.csv")

major_city_data = pd.read_csv("https://s3.ca-central-1.amazonaws.com/ramenvspho/major_city_data_2015.csv")

major_city_data.to_csv("../data/major_city_data_2015.csv")