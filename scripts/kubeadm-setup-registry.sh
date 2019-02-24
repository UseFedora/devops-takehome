#!/bin/bash

Registry="container-registry.oracle.com"
Repo="kubernetes"
YumOpts="--disablerepo ol7_developer"

# Parse arguments
while [ $# -gt 0 ]
do
  case "$1" in
    "--from")
      if [ $# -lt 2 ]
      then
	echo "$0: Missing parameter"
	exit 1
      fi
      Registry="$2"
      shift; shift
      ;;
    "--dev")
      # Developper release
      Repo="kubernetes_developer"
      YumOpts=""
      shift
      ;;
    *)
      echo "$0: Invalid parameter"
      exit 1
      ;;
  esac
done

echo "$0: Login to ${Registry}"
docker login ${Registry}
if [ $? -ne 0 ]
then
  echo "$0: Authentication failure"
  exit 1
fi

echo "$0: Installing kubeadm"
sudo yum install -y ${YumOpts} kubeadm

echo "$0: Cloning Kubernetes containers"
/bin/kubeadm-registry.sh --to localhost:5000/kubernetes --from ${Registry}/${Repo}

echo "$0: Clone complete!"