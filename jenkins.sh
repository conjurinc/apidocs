#!/usr/bin/env bash -e

hercule src/api.md -o api.md

DOCKER_IMAGE="registry.tld/conjur-appliance:4.5-stable"

function finish {
    # Stop and remove the Conjur container
#    docker rm -f ${cid}
    echo
}
trap finish EXIT

# Build the test container
docker build -t apidocs .

# Launch and configure a Conjur container
hostname=$(docker-machine ip default)
password='password'
orgaccount='conjur'

cid=$(docker run -d -p "443:443" -p "636:636" conjurinc/appliance)

docker exec ${cid} evoke configure master -h ${hostname} -p ${password} ${orgaccount}

yes yes yes | conjur init -f .conjurrc -h ${hostname}
export CONJURRC=.conjurrc
conjur authn login -u admin -p ${password}
printf "test\npassword\npassword\nno\nn" | conjur bootstrap

# Run the tests
docker run --rm -v $PWD:/app \
-e "NODE_TLS_REJECT_UNAUTHORIZED=0" \
apidocs \
dredd
