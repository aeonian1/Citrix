#! /usr/bin/python3
#
# Script to iterate through system logs and get events newer than last record gathered 

import requests

# get records never than utcTimestamp 
records_date_newer_than = '2023-02-07T15:53:41.9653884Z'

TOKEN_URL = 'https://api-us.cloud.com/cctrustoauth2/root/tokens/clients'

# Obtain bearer token from authorization server
response = requests.post(TOKEN_URL, data={
  'grant_type': 'client_credentials',
  'client_id': '',
  'client_secret': ''
})
print(response)
token = response.json()

# Create a session object with the relevant HTTP headers
session = requests.Session()
session.headers.update({
  'Authorization': f'CwsAuth Bearer={token["access_token"]}',
  'Citrix-CustomerId': '',
  'Accept': 'application/json'
})

# Get a list of machines in the specified catalog
response = session.get(f'https://api-us.cloud.com/systemlog/records')
response.raise_for_status()
systemlogs = response.json()

for systemlog in systemlogs['items']:
  if (systemlog['utcTimestamp'] > records_date_newer_than ):
    print(systemlog)