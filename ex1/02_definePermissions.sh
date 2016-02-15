#!/bin/bash
set -e
set -v
# get adm api key
apiKey=$(curl --fail -s -u adm-jfrog:adm123 -X GET "$artUrl/api/security/apiKey" | jq -r .apiKey)

# create permissions for dev
curl --fail -v -H "X-JFrog-Art-Api:$apiKey" -X PUT $artUrl/api/security/permissions/JfrogDev -H 'Content-Type: application/json' -d '
{
    "name": "JfrogDev",
    "repositories": ["jfrog-dev", "jfrog-staging"],
    "principals": {
        "users" : {
          "dev-jfrog": ["d", "w", "n", "r"]
        }
    }
}'

# create permissions for dev specially on prod repo
curl --fail -v -H "X-JFrog-Art-Api:$apiKey" -X PUT $artUrl/api/security/permissions/JfrogDevProd -H 'Content-Type: application/json' -d '
{
    "name": "JfrogDevProd",
    "repositories": ["jfrog-prod"],
    "principals": {
        "users" : {
          "dev-jfrog": ["w", "r"]
        }
    }
}'

# create permissions for qa
curl --fail -v -H "X-JFrog-Art-Api:$apiKey" -X PUT $artUrl/api/security/permissions/JfrogQA -H 'Content-Type: application/json' -d '
{
    "name": "JfrogQA",
    "repositories": ["jfrog-prod", "jfrog-staging"],
    "principals": {
        "users" : {
          "qa-jfrog": ["d", "w", "n", "r"]
        }
    }
}'

