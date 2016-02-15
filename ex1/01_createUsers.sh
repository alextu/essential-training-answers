#!/bin/bash
# Script will fail as soon as one command fails
set -e
set -v
#
# Use curl options :
#
# --fail will return exit code > 0 if http answer is not 20x
# -s will not output details
# -X specify the HTTP method
# -H specify additional headers, here the Content-Type of the request
#

# Create all users
curl --fail -v -u admin:password -X PUT $artUrl/api/security/users/adm-jfrog -H 'Content-Type: application/json' -d '
{
  "email" : "admjfrog@jfrogtraining.local",
  "admin" : true,
  "password" : "adm123"
}'

curl --fail -v -u admin:password -X PUT $artUrl/api/security/users/dev-jfrog -H 'Content-Type: application/json' -d '
{
  "email" : "devjfrog@jfrogtraining.local",
  "password" : "dev456"
}'

curl --fail -v -u admin:password -X PUT $artUrl/api/security/users/qa-jfrog -H 'Content-Type: application/json' -d '
{
  "email" : "qajfrog@jfrogtraining.local",
  "password" : "qa789"
}'

# Create API key for the new admin and store it in a variable
apiKey=$(curl --fail -s -u adm-jfrog:adm123 -X POST $artUrl/api/security/apiKey | jq -r .apiKey)

# Create repositories with this new API key
curl --fail -v -H "X-JFrog-Art-Api:$apiKey" -X PUT $artUrl/api/repositories/jfrog-dev -H 'Content-Type: application/json' -d '
{
  "packageType" : "generic",
  "rclass" : "local"
}'

curl --fail -v -H "X-JFrog-Art-Api:$apiKey" -X PUT $artUrl/api/repositories/jfrog-staging -H 'Content-Type: application/json' -d '
{
  "packageType" : "generic",
  "rclass" : "local"
}'

curl --fail -v -H "X-JFrog-Art-Api:$apiKey" -X PUT $artUrl/api/repositories/jfrog-prod -H 'Content-Type: application/json' -d '
{
  "packageType" : "generic",
  "rclass" : "local"
}'

curl --fail -v -H "X-JFrog-Art-Api:$apiKey" -X PUT $artUrl/api/repositories/jfrog-virtual -H 'Content-Type: application/json' -d '
{
  "packageType" : "generic",
  "rclass" : "virtual",
  "repositories": ["jfrog-dev", "jfrog-staging", "jfrog-prod"]
}'
