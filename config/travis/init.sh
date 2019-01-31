#!/bin/bash

set -e

if [ -z $(which wget) ]; then
    # use curl
    GET='curl'
else
    GET='wget -O -'
fi

cd $HOME

# Pull in the server code.
git clone --single-branch --branch 'master' --depth 1 https://github.com/intermine/intermine.git server

cd server/testmine

# We need a running demo webapp
source setup.sh
sleep 20 # wait for tomcat to come on line
# Get messages from 500 errors.
echo 'i.am.a.dev = true' >> dbmodel/resources/testmodel.properties
PSQL_USER=postgres sh setup.sh
sleep 15 # wait for the webapp to come on line


# Start any list upgrades by poking the lists service.
$GET "$TESTMODEL_URL/service/lists?token=test-user-token" > /dev/null
