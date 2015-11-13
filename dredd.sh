#!/bin/bash -e

hostname=$1

# Build the test container
docker build -t apidocs .

docker run --rm -v $PWD:/app \
apidocs \
hercule src/api.md -o api.md

echo "Running tests against ${hostname}"

# Run the tests through Dredd
summon docker run --rm -v $PWD:/app \
-e "NODE_TLS_REJECT_UNAUTHORIZED=0" \
--env-file @SUMMONENVFILE \
apidocs \
dredd \
./api.md \
"${hostname}" \
--reporter junit \
--output report.xml \
--reporter html \
--output report.html \
--reporter apiary \
--hookfiles hooks.js \
--language nodejs
