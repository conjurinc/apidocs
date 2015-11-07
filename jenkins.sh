#!/usr/bin/env bash -eu

hercule src/api.md -o api.md

DOCKER_IMAGE="registry.tld/conjur-appliance:4.5-stable"
PORT="61000"
NOKILL=${NOKILL:-"0"}
RCFILE=".conjurrc.testing"

function finish {
    # Stop and remove the Conjur container if env var NOKILL != "1"
    if [ "$NOKILL" != "1" ]; then
        rm ${RCFILE}
        rm *.pem
        docker rm -f ${cid}
    fi
}
trap finish EXIT

# Build the test container
docker build -t apidocs .

# Launch and configure a Conjur container
hostname=$(docker-machine ip default)
password='password'
orgaccount='conjur'

cid=$(docker run -d -p "${PORT}:443" ${DOCKER_IMAGE})

docker exec ${cid} evoke configure master -h ${hostname} -p ${password} ${orgaccount}

printf "yes\nyes\nyes\n" | conjur init -f ${RCFILE} -h ${hostname}:${PORT}
export CONJURRC=${RCFILE}
conjur authn login -u admin -p ${password}
printf "test\npassword\npassword\nno\nn" | conjur bootstrap
unset CONJURRC

./dredd.sh https://${hostname}:${PORT}
