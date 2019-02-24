#!/bin/bash

echo "## Building and preloading this registry with ${APP_IMAGE_TAG} image"

cd /vagrant

echo "- Building devops-challenge image"
/usr/bin/docker build -t devops-challenge --network=host .
/usr/bin/docker tag devops-challenge ${REGISTRY}/${APP_IMAGE_TAG}:latest

echo "- Pushing ${REGISTRY}/${APP_IMAGE_TAG}:latest"
/usr/bin/docker push ${REGISTRY}/${APP_IMAGE_TAG}:latest
