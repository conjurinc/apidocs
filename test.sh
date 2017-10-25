#!/bin/bash -eu

CONJUR_VERSION=${CONJUR_VERSION:-"4.9"}
DOCKER_IMAGE=${DOCKER_IMAGE:-"registry.tld/conjur-appliance-cuke-master:$CONJUR_VERSION-stable"}
NOKILL=${NOKILL:-"0"}
PULL=${PULL:-"1"}

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

docker exec -i $cid /opt/conjur/evoke/bin/wait_for_conjur

ssl_certificate=$(docker exec ${cid} cat /opt/conjur/etc/ssl/conjur.pem)

make cli-image

docker run --rm --privileged\
	-v $PWD:/src -w /src \
	-e CONJUR_SSL_CERTIFICATE="${ssl_certificate}" \
	-e CONJUR_AUTHN_LOGIN=admin \
	-e CONJUR_AUTHN_API_KEY=secret \
	--link ${cid}:cuke-master \
	apidocs-conjur-cli conjur rubydsl load ./test/policy.rb

export CONJUR_VERSION

CONJUR_CONTAINER=${cid} make test
