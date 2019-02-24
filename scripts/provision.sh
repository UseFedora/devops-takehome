#!/bin/bash

# Install the yum-utils package for repo selection
yum install -y yum-utils

# Disable Preview and Developer channels
yum-config-manager --disable ol7_preview ol7_developer\* > /dev/null

# Parse arguments
while [ $# -gt 0 ]
do
  case "$1" in
    "--preview")
      yum-config-manager --enable ol7_preview > /dev/null
      shift
      ;;
    "--dev")
      yum-config-manager --enable ol7_developer > /dev/null
      shift
      ;;
    "--insecure")
      if [ $# -lt 2 ]
      then
        echo "Missing parameter"
	exit 1
      fi
      Insecure="$2"
      shift; shift
      ;;
    *)
      echo "Invalid parameter"
      exit 1
      ;;
  esac
done

echo "Installing and configuring Docker Engine"

# Install Docker dependencies
yum install -y yum-utils device-mapper-persistent-data lvm2

# Setup Docker repository
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

# Install Docker
yum install -y docker-ce

# Add vagrant user to docker group
usermod -a -G docker vagrant

# Enable,configure and start Docker
systemctl enable docker
systemctl start docker

# Configure insecure (non-ssl) registry if needed
if [ -n "${REGISTRY}" ]
then
  #sed -i "s/\"$/\",\n    \"insecure-registries\": [\"${Insecure}\"]/" /etc/docker/daemon.json
  cat <<-EOF > /etc/docker/daemon.json
    {
        "insecure-registries" : ["${REGISTRY}"]
    }
EOF
systemctl restart docker
fi

echo "Installing and configuring Kubernetes packages"
cat <<-EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg
        https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF

# Install Kubernetes packages from the "preview" channel fulfil pre-requisites
yum install -y  kubeadm kubelet kubectl

# Disable SELinux
setenforce 0
sed -i --follow-symlinks 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux

# Disable Swap
swapoff -a
if [ -e /dev/centos/swap ]; then
  # remove it to free-up space.
  lvremove -Ay /dev/centos/swap
  # of course reassign it to /dev/centos/root
  lvextend -l +100%FREE centos/root
fi
# disable it in /etc/fstab
sed -i '/swap/s/^/# /g' /etc/fstab

# CGROUP Changes"
sed -i 's/cgroup-driver=systemd/cgroup-driver=cgroupfs/g' /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
systemctl daemon-reload
systemctl restart kubelet

# Ensure kubelet uses the right IP address
IP=$(ip addr | awk -F'[ /]+' '/192.168.99.255/ {print $3}')
KubeletNode="/etc/systemd/system/kubelet.service.d/90-node-ip.conf"
ExecStart=$(grep ExecStart=/ /etc/systemd/system/kubelet.service.d/10-kubeadm.conf | sed -e 's/\$KUBELET_EXTRA_ARGS/\$KUBELET_EXTRA_ARGS \$KUBELET_NODE_IP_ARGS/')
cat <<-EOF >${KubeletNode}
	[Service]
	Environment="KUBELET_NODE_IP_ARGS=--node-ip=${IP}"
	ExecStart=
	${ExecStart}
EOF
chmod 644 ${KubeletNode}
systemctl daemon-reload

echo "Your Kubernetes VM is ready to use!"
