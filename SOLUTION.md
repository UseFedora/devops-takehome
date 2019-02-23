# Reuben Avery's DevOps Solution - Initial Draft

## Battle plan: 
My solution will start with a [Vagrant Kubernetes box](https://github.com/oracle/vagrant-boxes/tree/master/Kubernetes).  Upon startup, this box will use Docker and kubeadm to bring up a cluster running your application as a service.

In a prod environment, this would be used to hook this repo up to a CI/CD pipeline eg Jenkins and bring in things like Terraform and Puppet.

> "No battle plan survives contact with the enemy"

# Vagrantfile to setup a Kubernetes Cluster on Oracle Linux 7
This Vagrantfile will provision a Kubernetes cluster with one master and _n_
worker nodes (2 by default), along with private Docker registry which will
be pre-loaded with a `teachable/devops-challenge` image..

## Prerequisites
1. Install [Oracle VM VirtualBox](https://www.virtualbox.org/wiki/Downloads)
1. Install [Vagrant](https://vagrantup.com/)
1. Install [vagrant-hosts](https://github.com/oscar-stack/vagrant-hosts): maintains
   /etc/hosts for the guest VMs. Necessary for the private Docker registry.
   
## Quick start
1. Clone this repository
1. Run `vagrant up registry`
1. Run `vagrant up master; vagrant ssh master`
1. Within the master guest, run as `root`: <sup>[(\*)](#note-1)</sup>  
`/vagrant/scripts/kubeadm-setup-master.sh`  
You will be asked to log in to the Oracle Container Registry
1. Run `vagrant up worker1; vagrant ssh worker1`
1. Within the worker1 guest, run as `root`: <sup>[(\*)](#note-1)</sup>  
`/vagrant/scripts/kubeadm-setup-worker.sh`  
You will be asked to log in to the Oracle Container Registry
1. Repeat the last 2 steps for worker2

Your cluster is ready!  
Within the master guest you can check the status of the cluster (as the
`vagrant` user). E.g.:
- `kubectl cluster-info`
- `kubectl get nodes`
- `kubectl get pods --namespace=kube-system`

<a id="note-1"></a>(\*) If you have a password-less local container registry
skip steps 4 and 6  (see [Local Registry](#local-registry)).

## About the Vagrantfile

The Vagrantfile is based upon the [best-practices Vagrant box by Oracle](https://github.com/oracle/vagrant-boxes/tree/master/Kubernetes).
 
 The VMs communicate via a private network:

- Master node: 192.168.99.100 / master.vagrant.vm
- Worker node i: 192.168.99.(100+i) / worker_i_.vagrant.vm

The Vagrant provisioning script pre-loads Kubernetes and satisfies the
pre-requisites.


## Optional plugins
You might want to install the following Vagrant plugins:
- [vagrant-env](https://github.com/gosuri/vagrant-env): loads environment
variables from .env files;
- [vagrant-hosts](https://github.com/oscar-stack/vagrant-hosts): maintains
/etc/hosts for the guest VMs;
- [vagrant-proxyconf](https://github.com/tmatilai/vagrant-proxyconf): set
proxies in the guest VMs if you need to access Internet through proxy. See
plugin documentation for the configuration.
