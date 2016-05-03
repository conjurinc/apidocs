#!/bin/bash -eu

CONJUR_VERSION=${CONJUR_VERSION:-"5.0"}
DOCKER_IMAGE=${DOCKER_IMAGE:-"registry.tld/conjur-appliance-cuke-master:$CONJUR_VERSION-stable"}
NOKILL=${NOKILL:-"0"}
PUBLISH=${PUBLISH:-"0"}
PULL=${PULL:-"1"}
CMD_PREFIX=""

make

if [ "$PULL" == "1" ]; then
    docker pull $DOCKER_IMAGE
fi

function finish {
	# Stop and remove the Conjur container if env var NOKILL != "1"
    if [ "$NOKILL" != "1" ]; then
        docker rm -f ${cid}
    fi
}
trap finish EXIT

# Launch and configure a Conjur container
cid=$(docker run -d --privileged -P -v $PWD:/src ${DOCKER_IMAGE})
>&2 echo "Container id:"
>&2 echo $cid

docker run --rm --privileged \
--link ${cid}:conjur \
registry.tld/wait-for-conjur

ssl_certificate=$(docker exec ${cid} cat /opt/conjur/etc/ssl/conjur.pem)

docker run --rm --privileged\
	-v $PWD:/src \
	-e CONJUR_SSL_CERTIFICATE="${ssl_certificate}" \
	-e CONJUR_AUTHN_LOGIN=admin \
	-e CONJUR_AUTHN_API_KEY=secret \
	--link ${cid}:cuke-master \
	apidocs-conjur-cli conjur script execute /src/test/policy.rb

export CONJUR_VERSION

CONJUR_CONTAINER=${cid} make test

if [ "$USER" == "jenkins" ]; then
    # Only publish from the master branch
    if [ "$GIT_BRANCH" == "origin/master" ]; then
        PUBLISH="1"
    fi
fi

if [ "${PUBLISH}" == "1" ]; then
    echo "Publishing docs to Apiary"
    ./publish.sh
fi
