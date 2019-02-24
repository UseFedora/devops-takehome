#!/bin/bash

JoinCommand='/vagrant/scripts/join-k8s-master.sh'

LogFile="kubeadm-setup.log"

if [ ${EUID} -ne 0 ]
then
  echo "$0: This script must be run as root"
  exit 1
fi

if [ "$0" = "${SUDO_COMMAND%% *}" ]
then
  echo "$0: This script should not be called directly with 'sudo'"
  exit 1
fi

if [ ! -f /etc/kubernetes/manifests/kube-apiserver.yaml ]; then
    echo "$0: Initializing Master node -- be patient!"
    kubeadm init \
        --apiserver-advertise-address=192.168.99.100 \
        --pod-network-cidr=192.168.1.0/16 \
        --ignore-preflight-errors=NumCPU \
        > "${LogFile}" 2>&1

    if [ $? -ne 0 ]
    then
      echo "$0: kubeadm init did not complete successfully"
      echo "Last lines of ${LogFile}:"
      tail -10 "${LogFile}"
      exit 1
    fi
else
    echo "$0: Master node already initialized"
fi

echo "$0: Copying admin.conf for vagrant user"
mkdir -p /vagrant/.kube
cp /etc/kubernetes/admin.conf /vagrant/.kube/config
chown -R vagrant:vagrant /vagrant/.kube

mkdir -p $HOME/.kube
cp /etc/kubernetes/admin.conf $HOME/.kube/config
chown -R $(id -u):$(id -g) $HOME/.kube

echo "$0: Copying admin.conf into host directory"
sed -e 's/192.168.99.100/127.0.0.1/' < /etc/kubernetes/admin.conf > /vagrant/admin.conf

if [ ! -f $JoinCommand ]; then
  echo "$0: Creating ${JoinCommand} for worker nodes to join this master"
  # 'token list' doesn't provide token hash, we have re-issue a new token to
  # capture the hash -- See https://github.com/kubernetes/kubeadm/issues/519
  kubeadm token create --print-join-command --ttl=0 | tee $JoinCommand 2>&1
else
  echo "$0: ${JoinCommand} already exists"
fi

echo "$0: Installining Kubernetes Web UI"
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v1.10.1/src/deploy/recommended/kubernetes-dashboard.yaml
echo "$0 See https://github.com/kubernetes/dashboard"

echo "$0: Deployino this application"
cd /vagrant/k8s
kubectl apply -f devops-deployment.yaml
kubectl apply -f postgres-deployment.yaml

