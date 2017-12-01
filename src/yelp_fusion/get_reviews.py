# -*- coding: utf-8 -*-
"""
Yelp Fusion API code
Modified by Jill Cates November 2017.

This program demonstrates the capability of the Yelp Fusion API
by using the Search API to query for businesses by a search term and location,
and the Business API to query additional information about the top result
from the search query.

Please refer to http://www.yelp.com/developers/v3/documentation for the API
documentation.

This program requires the Python requests library, which you can install via:
`pip install -r requirements.txt`.

Sample usage of the program:
`python get_reviews.py --term="bars" --location="San Francisco, CA --file="san_fran_bars"`
"""
from __future__ import print_function

import argparse
import json
import pprint
import requests
import sys
import urllib
import pandas as pd
import config

# This client code can run on Python 2.x or 3.x.  Your imports can be
# simpler if you only need one of those.
try:
    # For Python 3.0 and later
    from urllib.error import HTTPError
    from urllib.parse import quote
    from urllib.parse import urlencode
except ImportError:
    # Fall back to Python 2's urllib2 and urllib
    from urllib2 import HTTPError
    from urllib import quote
    from urllib import urlencode


CLIENT_ID = config.client_id
CLIENT_SECRET = config.client_secret

# API constants
API_HOST = 'https://api.yelp.com'
SEARCH_PATH = '/v3/businesses/search'
BUSINESS_PATH = '/v3/businesses/'  # Business ID will come after slash.
TOKEN_PATH = '/oauth2/token'
GRANT_TYPE = 'client_credentials'


# Defaults
DEFAULT_TERM = 'dinner'
DEFAULT_LOCATION = 'San Francisco, CA'
DEFAULT_FILE_NAME = 'san_fran_dinner'
SEARCH_LIMIT = 10


def obtain_bearer_token(host, path):
    """Given a bearer token, send a GET request to the API.

    Args:
        host (str): The domain host of the API.
        path (str): The path of the API after the domain.
        url_params (dict): An optional set of query parameters in the request.

    Returns:
        str: OAuth bearer token, obtained using client_id and client_secret.

    Raises:
        HTTPError: An error occurs from the HTTP request.
    """
    url = '{0}{1}'.format(host, quote(path.encode('utf8')))
    assert CLIENT_ID, "Please supply your client_id."
    assert CLIENT_SECRET, "Please supply your client_secret."
    data = urlencode({
        'client_id': CLIENT_ID,
        'client_secret': CLIENT_SECRET,
        'grant_type': GRANT_TYPE,
    })
    headers = {
        'content-type': 'application/x-www-form-urlencoded',
    }
    response = requests.request('POST', url, data=data, headers=headers)
    bearer_token = response.json()['access_token']
    return bearer_token


def request(host, path, bearer_token, url_params=None):
    """Given a bearer token, send a GET request to the API.

    Args:
        host (str): The domain host of the API.
        path (str): The path of the API after the domain.
        bearer_token (str): OAuth bearer token, obtained using client_id and client_secret.
        url_params (dict): An optional set of query parameters in the request.

    Returns:
        dict: The JSON response from the request.

    Raises:
        HTTPError: An error occurs from the HTTP request.
    """
    url_params = url_params or {}
    url = '{0}{1}'.format(host, quote(path.encode('utf8')))
    headers = {
        'Authorization': 'Bearer %s' % bearer_token,
    }

    response = requests.request('GET', url, headers=headers, params=url_params)

    return response.json()


def search(bearer_token, term, location):
    """Query the Search API by a search term and location.

    Args:
        term (str): The search term passed to the API.
        location (str): The search location passed to the API.

    Returns:
        dict: The JSON response from the request.
    """

    url_params = {
        'term': term.replace(' ', '+'),
        'location': location.replace(' ', '+'),
        'limit': SEARCH_LIMIT
    }
    return request(API_HOST, SEARCH_PATH, bearer_token, url_params=url_params)


def get_business(bearer_token, business_id):
    """Query the Business API by a business ID.

    Args:
        business_id (str): The ID of the business to query.

    Returns:
        dict: The JSON response from the request.
    """
    business_path = BUSINESS_PATH + business_id

    return request(API_HOST, business_path, bearer_token)


def query_api(term, location, file_name):
    """Queries the API by the input values from the user.

    Args:
        term (str): The search term to query.
        location (str): The location of the business to query.
        file_name (str): File name of output csv.
    """
    bearer_token = obtain_bearer_token(API_HOST, TOKEN_PATH)

    response = search(bearer_token, term, location)

    businesses = response.get('businesses')

    if not businesses:
        print(u'No businesses for {0} in {1} found.'.format(term, location))
        return

    resto_name = []
    rating = []
    latitude = []
    longitude = []
    review_count = []
    rank = []
    city = []
    food_type = []

    for i in range(0,5):

        business_id = businesses[i]['id']

        print(u'Result {0}: "{1} ...'.format(i, business_id))
        response = get_business(bearer_token, business_id)

        print(u'Result for business "{0}" found:'.format(business_id))

        rank.append(i)
        resto_name.append(business_id)
        latitude.append(response['coordinates']['latitude'])
        longitude.append(response['coordinates']['longitude'])
        review_count.append(response['review_count'])
        rating.append(response['rating'])
        city.append(location)
        food_type.append(term)

    restos = {
        'rating': rating,
        'review_count': review_count,
        'latitude': latitude,
        'longitude': longitude,
        'name': resto_name,
        'rank': rank,
        'city': city,
        'food_type': food_type
    }
    pd.DataFrame(restos).to_csv(u'../../data/reviews/{0}.csv'.format(file_name))



def main():
    parser = argparse.ArgumentParser()

    parser.add_argument('-q', '--term', dest='term', default=DEFAULT_TERM,
                        type=str, help='Search term (default: %(default)s)')
    parser.add_argument('-l', '--location', dest='location',
                        default=DEFAULT_LOCATION, type=str,
                    help='Search location (default: %(default)s)')
    parser.add_argument('-f', '--file', dest='file_name',
                    default=DEFAULT_FILE_NAME, type=str,
                    help='Name of csv file (default: %(default)s)')

    input_values = parser.parse_args()

    city_args = [
        {'city': 'San Francisco, CA', 'name': 'san_fran'},
        {'city': 'Toronto, Ontario', 'name': 'toronto'},
        {'city': 'Vancouver, British Columbia', 'name': 'vancouver'},
        {'city': 'Montreal, Quebec', 'name': 'montreal'},
        {'city': 'Los Angeles, CA', 'name': 'los_angeles'},
        {'city': 'San Diego, CA', 'name': 'san_diego'},
        {'city': 'Miami, Florida', 'name': 'miami'},
        {'city': 'Denver, Colorado', 'name': 'denver'},
        {'city': 'New York, New York', 'name': 'new_york'},
        {'city': 'Chicago, Illinois', 'name': 'chicago'},
        {'city': 'Seattle, Washington', 'name': 'seattle'},
        {'city': 'Washington, DC', 'name': 'washington_dc'},
        {'city': 'Minneapolis, Minnesota', 'name': 'minnieapolis'},
        {'city': 'Houston, Texas', 'name': 'houston'},
        {'city': 'Phoenix, Arizona', 'name': 'phoenix'},
        {'city': 'Portland, Oregon', 'name': 'portland'},
        {'city': 'Philadelphia, Pennsylvania', 'name': 'philadelphia'},
        {'city': 'Atlanta, Georgia', 'name': 'atlanta'},
        {'city': 'Boston, Massachussetts', 'name': 'boston'},
        {'city': 'Las Vegas, Nevada', 'name': 'las_vegas'}
        ]

    try:
        for i in city_args:
            for j in ['ramen', 'pho']:
                location = i['city']
                file_name = i['name']+"_"+j
                term = j
                query_api(term, location, file_name)
    except HTTPError as error:
        sys.exit(
            'Encountered HTTP error {0} on {1}:\n {2}\nAbort program.'.format(
                error.code,
                error.url,
                error.read(),
            )
        )


if __name__ == '__main__':
    main()
