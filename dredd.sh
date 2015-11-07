#!/bin/bash -e

hostname=$1

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
--reporter html \
--reporter apiary \
--output report.html \
--hookfiles hooks.js \
--language nodejs