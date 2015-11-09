#!/usr/bin/env bash

# Publish APIdoc to Apiary

# Build the output container and generate HTML
docker build -t apidocs-publish -f Dockerfile.publish .

summon docker run --rm -v $PWD:/app \
--env-file @SUMMONENVFILE \
apidocs-publish \
apiary publish --api-name conjur --path api.md --message "$(git log -1 --pretty=%B)"
