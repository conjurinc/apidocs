#!/usr/bin/env bash -e

usage() {
    echo "Given a username and password, returns a Conjur auth token for API use."
    echo
    echo "Usage:"
    echo $(basename "$0") "endpoint ssl_cert username password"
}

endpoint=$1
ssl_cert=$2
username=$3
password=$4

if [ "$1" == "-h" ]; then
    usage
    exit 0
fi

if [ -z "$endpoint" ] || [ -z "$ssl_cert" ] || [ -z "$username" ] || [ -z "$password" ]; then
    echo "Missing arguments!"
    echo
    usage
    exit 1
fi

apikey=$(curl --silent --cacert $ssl_cert  \
--user $username:$password \
"${endpoint}/api/authn/users/login")


rawtoken=$(curl --silent --cacert $ssl_cert  \
--data "${apikey}" \
"${endpoint}/api/authn/users/${username}/authenticate")

token=$(echo -n ${rawtoken} | base64 | tr -d '\r\n')

echo "Authorization: Token token=\"${token}\""
