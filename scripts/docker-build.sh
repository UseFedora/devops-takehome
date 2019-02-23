#!/bin/bash

echo "## Building and preloading this registry with teachable/devops-challenge image"

cd /vagrant

echo "- Building devops-challenge image"
/usr/bin/docker build -t devops-challenge --network=host .
/usr/bin/docker tag devops-challenge registry.vagrant.vm:5000/teachable/devops-challenge:latest

echo "- Pushing registry.vagrant.vm:5000/teachable/devops-challenge:latest"
/usr/bin/docker push registry.vagrant.vm:5000/teachable/devops-challenge:latest
