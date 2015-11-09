#!/bin/bash -eu

# Build the test container
docker build -t apidocs .

docker run --rm -v $PWD:/app \
apidocs \
hercule src/api.md -o api.md

DOCKER_IMAGE="registry.tld/conjur-appliance:4.5-stable"
PORT="61000"
NOKILL=${NOKILL:-"0"}
RCFILE=".conjurrc.testing"

function finish {
    # Stop and remove the Conjur container if env var NOKILL != "1"
    if [ "$NOKILL" != "1" ]; then
        rm -f ${RCFILE}
        rm -f *.pem
        docker rm -f ${cid}
    fi
}
trap finish EXIT

# Launch and configure a Conjur container
cid=$(docker run -d -p "${PORT}:443" ${DOCKER_IMAGE})

if [ "$USER" == "jenkins" ]; then
    # Use the IP address of the container as the hostname, port collision no more!
    hostname=$(docker inspect $cid | jsonfield 0.NetworkSettings.IPAddress)
else
    hostname=$(docker-machine ip default)
fi

password='password'
orgaccount='conjur'

docker exec ${cid} evoke configure master -h ${hostname} -p ${password} ${orgaccount}

if [ "$USER" != "jenkins" ]; then
    hostname="${hostname}:${PORT}"
fi

printf "yes\nyes\nyes\n" | sudo conjur init -f ${RCFILE} -h ${hostname}
CONJURRC=${RCFILE} sudo -E conjur authn login -u admin -p ${password}
printf "test\npassword\npassword\nno\n" | CONJURRC=${RCFILE} sudo -E conjur bootstrap

./dredd.sh https://${hostname}

./publish.sh
