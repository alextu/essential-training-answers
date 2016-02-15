#!/bin/bash
set -e
set -v
# get api keys
devApiKey=$(curl --fail -u dev-jfrog:dev456 -X POST "$artUrl/api/security/apiKey" | jq -r .apiKey)
qaApiKey=$(curl --fail -u qa-jfrog:qa789 -X POST "$artUrl/api/security/apiKey" | jq -r .apiKey)

# upload resources
curl --fail -v -i -H "X-JFrog-Art-Api: $devApiKey" -T resources/createdb.zip "$artUrl/jfrog-dev/createdb.zip"

# download resources from virtual as dev
curl --fail -H "X-JFrog-Art-Api: $devApiKey" -o /tmp/createdb.zip "$artUrl/jfrog-virtual/createdb.zip"

# download resources from virtual as qa should fail at this point
curl -H "X-JFrog-Art-Api: $qaApiKey" -o /tmp/createdb.zip "$artUrl/jfrog-virtual/createdb.zip"

# move resource from dev to staging
curl -H "X-JFrog-Art-Api: $devApiKey" -X POST "$artUrl/api/move/jfrog-dev/createdb.zip?to=/jfrog-staging/createdb.zip"

# download resources from virtual as qa should now succeed
curl --fail -v -i -H "X-JFrog-Art-Api: $qaApiKey" -o /tmp/createdb.zip "$artUrl/jfrog-virtual/createdb.zip"

# QA can test the package and move it to prod repo
curl --fail -H "X-JFrog-Art-Api: $qaApiKey" -X POST "$artUrl/api/move/jfrog-staging/createdb.zip?to=/jfrog-prod/createdb.zip"

# Ensures that dev cannot delete from prod repo
curl -H "X-JFrog-Art-Api: $devApiKey" -X DELETE "$artUrl/jfrog-prod/createdb.zip"