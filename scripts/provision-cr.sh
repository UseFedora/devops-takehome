#!/bin/bash

echo "Installing and configuring Docker Engine"

# Install Docker dependencies
yum install -y yum-utils device-mapper-persistent-data lvm2

# Setup Docker repository
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

# Install Docker
yum install -y docker-ce

# Add vagrant user to docker group
usermod -a -G docker vagrant

# Enable and start Docker
systemctl enable docker
systemctl start docker

echo "Run docker registry"
/usr/bin/docker run \
        --detach \
        --restart unless-stopped \
        --name registry \
        --publish 5000:5000 \
        registry:2

echo "Your Registry VM is ready to use!"