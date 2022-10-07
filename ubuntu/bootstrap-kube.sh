#!/bin/bash

set -e

# update ubuntu
apt update && apt upgrade -y

# install packages
apt install -y docker.io net-tools

# enable services
systemctl enable docker

# define variable for private IP to use as node IP
export K_VERS=1.24.6-00
export K_PRIVATE_IP=$(ifconfig eth1 | grep 'inet ' | awk '{print $2}')

# install kubernates 
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add
apt-add-repository "deb http://apt.kubernetes.io/ kubernetes-xenial main"
apt install -y kubeadm=$K_VERS kubelet=$K_VERS kubectl=$K_VERS

# update the kubelet IP with private one
sed -i -e "s/KUBELET_CONFIG_ARGS=/KUBELET_CONFIG_ARGS=--node-ip=$K_PRIVATE_IP /" \
    /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
systemctl daemon-reload && systemctl restart kubelet

# disable swap
swapoff -a