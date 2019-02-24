# Reuben Avery's DevOps Solution

## Battle plan: 
My solution will start with a [Vagrant Kubernetes box](https://github.com/oracle/vagrant-boxes/tree/master/Kubernetes).  Upon startup, this box will use Docker and kubeadm to bring up a cluster running your application as a service.

In a prod environment, this would be used to hook this repo up to a CI/CD pipeline eg Jenkins and bring in things like Terraform and Puppet.

> "No battle plan survives contact with the enemy"

# Vagrantfile to setup a Kubernetes Cluster on Oracle Linux 7
This Vagrantfile will provision a Kubernetes cluster with one master and _n_
worker nodes (2 by default), along with private Docker registry which will
be pre-loaded with a `teachable/devops-challenge` image, which will then be 
deployed as a Kubernetes service.

## Prerequisites
1. Install [Oracle VM VirtualBox](https://www.virtualbox.org/wiki/Downloads)
1. Install [Vagrant](https://vagrantup.com/)
1. Install [vagrant-hosts](https://github.com/oscar-stack/vagrant-hosts): maintains
   /etc/hosts for the guest VMs. Necessary for the private Docker registry.
   
## Quick start
1. Clone this repository
1. Run `vagrant up`

The cluster is ready!  This Ruby application is built within [Dockerfile](./Dockerfile).

This application is also deployed as Kubernetes service alongside a sidechain Postgres service.  These deployment
descripters are within [k8s/](./k8s/).

## Ta-da

```
# kubectl cluster-info
Kubernetes master is running at https://192.168.99.100:6443
KubeDNS is running at https://192.168.99.100:6443/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy

# kubectl get deployments
NAME              READY   UP-TO-DATE   AVAILABLE   AGE
devops            0/1     1            0           27m
devops-postgres   0/1     1            0           27m

# kubectl get pods
NAME                              READY   STATUS    RESTARTS   AGE
devops-5598cbf789-kmmt7           0/1     Pending   0          22m
devops-postgres-6b8547966-xb88p   0/1     Pending   0          21m

```

- `kubectl get nodes`
- `kubectl get pods --namespace=kube-system`

<a id="note-1"></a>(\*) If you have a password-less local container registry
skip steps 4 and 6  (see [Local Registry](#local-registry)).

## About the Vagrantfile

The Vagrantfile is based upon the [best-practices Vagrant box by Oracle](https://github.com/oracle/vagrant-boxes/tree/master/Kubernetes).
 
 The VMs communicate via a private network:

- Master node: 192.168.99.100 / master.vagrant.vm
- Worker node i: 192.168.99.(100+i) / worker_i_.vagrant.vm

## [reubenavery@gmail.com]
