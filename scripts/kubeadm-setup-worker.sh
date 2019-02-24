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

if [ ! -f $JoinCommand ]
then
  echo "$0: ${JoinCommand} not found. Is the master already configured?"
  exit 1
fi

echo "$0: Setup Worker node"
source $JoinCommand

echo "$0: Worker node ready"