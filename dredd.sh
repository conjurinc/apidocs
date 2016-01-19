#!/bin/bash -e

if [ -z "$CONJUR_VERSION" ]; then
	echo CONJUR_VERSION is required
	exit 1
fi

transaction_list_file=/transactions-"$CONJUR_VERSION".txt
if [ ! -f $transaction_list_file ]; then
	echo $transaction_list_file does not exist
	exit 1
fi

only=""
while read line; do
	only=$(printf '%s --only "%s"' "$only" "$line")
done < $transaction_list_file

set -x

dredd \
	./api.md \
	https://conjur \
	"$only" \
	--reporter junit \
	--output report.xml \
	--reporter html \
	--output report.html \
	--reporter apiary \
	--hookfiles hooks.js \
	--language nodejs
