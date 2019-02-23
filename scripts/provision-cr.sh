#!/bin/bash
#
# LICENSE UPL 1.0
#
# Copyright (c) 1982-2018 Oracle and/or its affiliates. All rights reserved.
#
# Since: June, 2018
# Author: philippe.vanhaesendonck@oracle.com
# Description: Installs Docker Engine and runs a registry container
#
# DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS HEADER.
#

echo "Installing and configuring Docker Engine"

# Install Docker
yum install -y docker-engine btrfs-progs

# Create and mount a BTRFS partition for docker.
docker-storage-config -f -s btrfs -d /dev/sdb

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