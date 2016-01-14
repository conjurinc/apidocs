#!/bin/bash -eu

DOCKER_IMAGE="registry.tld/conjur-appliance-cuke-master:4.6-stable"
NOKILL=${NOKILL:-"0"}
PUBLISH=${PUBLISH:-"0"}
CMD_PREFIX=""

make

docker pull $DOCKER_IMAGE

function finish {
	# Stop and remove the Conjur container if env var NOKILL != "1"
    if [ "$NOKILL" != "1" ]; then
        docker rm -f ${cid}
    fi
}
trap finish EXIT

# Launch and configure a Conjur container
cid=$(docker run -d -P -v $PWD:/src ${DOCKER_IMAGE})
>&2 echo "Container id:"
>&2 echo $cid

docker run --rm --link ${cid}:conjur registry.tld/wait-for-conjur

ssl_certificate=$(docker exec ${cid} cat /opt/conjur/etc/ssl/conjur.pem)

if [ "$USER" == "jenkins" ]; then
    # Only publish from the master branch
    if [ "$GIT_BRANCH" == "origin/master" ]; then
        PUBLISH="1"
    fi
fi

docker run --rm \
	-v $PWD:/src \
	-e CONJUR_SSL_CERTIFICATE="${ssl_certificate}" \
	-e CONJUR_AUTHN_LOGIN=admin \
	-e CONJUR_AUTHN_API_KEY=secret \
	--link ${cid}:cuke-master \
	apidocs-conjur-cli conjur policy load /src/test/policy.rb

CONJUR_CONTAINER=${cid} make test

if [ "${PUBLISH}" == "1" ]; then
    echo "Publishing docs to Apiary"
    ./publish.sh
fi
