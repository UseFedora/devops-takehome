# Reuben Avery's DevOps Solution - Initial Draft

## Battle plan: 
My solution will start with a [Vagrant Kubernetes box](https://github.com/oracle/vagrant-boxes/tree/master/Kubernetes).  Upon startup, this box will use Docker and kubeadm to bring up a cluster running your application as a service.

In a prod environment, this would be used to hook this repo up to a CI/CD pipeline eg Jenkins and bring in things like Terraform and Puppet.

> "No battle plan survives contact with the enemy"
