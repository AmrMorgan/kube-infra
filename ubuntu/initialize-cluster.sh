#!/bin/bash

set -x

# initialize the kubernates cluster
kubeadm init --pod-network-cidr=10.244.0.0/16 \
  --apiserver-advertise-address=$K_PRIVATE_IP \
  --ignore-preflight-errors=NumCPU,Mem

# set base 
mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config

# install calico CNI
kubectl apply -f \
  https://raw.githubusercontent.com/projectcalico/calico/v3.24.1/manifests/calico.yaml && \

# install helm
curl -fsSL -o get_helm.sh \
	https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh

set +x
