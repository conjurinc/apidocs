.PHONY: nodejs-image cli-image

default: api.md

test: nodejs-image api.md
	echo "Running tests against container '$(CONJUR_CONTAINER)'"
	summon docker run \
		--rm \
		--link $(CONJUR_CONTAINER):conjur \
		-v $(PWD):/app \
		-e "NODE_TLS_REJECT_UNAUTHORIZED=0" \
		--env-file @SUMMONENVFILE \
		apidocs \
		dredd \
		./api.md \
		conjur \
		--reporter junit \
		--output report.xml \
		--reporter html \
		--output report.html \
		--reporter apiary \
		--hookfiles hooks.js \
		--language nodejs

preview: api.md
	rvm use --create 2.0.0@apidocs
	bundle
	apiary preview --server --port=8081 --path api.md

api.md: nodejs-image src/* src/partials/*
	docker run \
		--rm \
		-v $(PWD):/app \
		apidocs \
		hercule src/api.md -o api.md

nodejs-image:
	docker build -t apidocs .

cli-image:
	docker build -t apidocs-conjur-cli -f Dockerfile.cli .
