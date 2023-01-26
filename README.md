# Kubernetes Cluster Build Using Ansible Roles

## Kubernetes cluster built using Virtualbox, Vagrant and Ansible roles.

### Network Layout For Cluster
  - Private Network 192.168.60.xxx
  - Public Network 10.0.1.xxx
  - Calico Pod Network CIDR 10.240.0.0/16

### Ansible Playbooks Used To Build Kubernetes Cluster
  - playbooks/controlplane-playbook.yml
  - playbooks/worker-playbook.yml

### Update playbooks/roles/common/vars/main.yml to change version(s) of containerd, kubernetes, enable or disable calico network overlay
  - containerd_version: 1.6.8-1
  - k8s_version: 1.25.0-00

