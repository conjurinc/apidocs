#!/bin/bash -eu

DOCKER_IMAGE="registry.tld/conjur-appliance:4.5-stable"
PORT="61000"
NOKILL=${NOKILL:-"0"}
PUBLISH=${PUBLISH:-"0"}
CMD_PREFIX=""
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
    hostname=$(docker inspect ${cid} | jsonfield 0.NetworkSettings.IPAddress)
    CMD_PREFIX="sudo -E"

    # Only publish from the master branch
    if [ "$GIT_BRANCH" == "origin/master"]; then
        PUBLISH="1"
    fi
else
    hostname="$(docker-machine ip default)"
fi

password='password'
orgaccount='conjur'

docker exec ${cid} evoke configure master -h ${hostname} -p ${password} ${orgaccount}

if [ "$USER" != "jenkins" ]; then
    hostname="${hostname}:${PORT}"
fi

# Init and bootstrap the Conjur appliance
printf "yes\nyes\nyes\n" | ${CMD_PREFIX} conjur init -f ${RCFILE} -h ${hostname}
CONJURRC=${RCFILE} ${CMD_PREFIX} conjur authn login -u admin -p ${password}
printf "test\npassword\npassword\nno\n" | CONJURRC=${RCFILE} ${CMD_PREFIX} conjur bootstrap

# Create this variable so variable#values route can be really tested
CONJURRC=${RCFILE} ${CMD_PREFIX} conjur variable create -v 8912dbp9bu1pub dev/redis/password
CONJURRC=${RCFILE} ${CMD_PREFIX} conjur group create --as-group security_admin developers

./dredd.sh https://${hostname}

if [ "${PUBLISH}" == "1" ]; then
    echo "Publishing docs to Apiary"
    ./publish.sh
fi
