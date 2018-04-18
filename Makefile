.PHONY: apidocs-image cli-image

default: apidocs-image cli-image api.md

test: apidocs-image api.md
	echo "Running tests against container '$(CONJUR_CONTAINER)'"
	summon docker run --rm -v $(PWD):/app \
		--link $(CONJUR_CONTAINER):conjur \
		-e NODE_TLS_REJECT_UNAUTHORIZED=0 \
		--env-file @SUMMONENVFILE \
		apidocs \
			./dredd

names: apidocs-image api.md
	echo "Enumerating transaction names"

	docker run --rm -v $(PWD):/app apidocs \
		dredd ./api.md https://conjur --names

preview: api.md
	rvm use --create 2.2.4@apidocs
	bundle
	apiary preview --server --port=8081 --path api.md

api.md: apidocs-image src/* src/partials/*
	docker run --rm -v $(PWD):/app -w /app apidocs \
		hercule src/api.md -o api.md

apidocs-image:
	docker build -t apidocs .
