#!/bin/bash

set -x

# create namespace
kubectl create namespace devops-tools

# create permissions for jenkins
kubectl apply -f ./kube-infra/ubuntu/kubernetes-jenkins/serviceAccount.yaml

# create persistent volume
kubectl create -f ./kube-infra/ubuntu/kubernetes-jenkins/volume.yaml

# create deployment
kubectl apply -f ./kube-infra/ubuntu/kubernetes-jenkins/deployment.yaml

# create service for networking
kubectl apply -f ./kube-infra/ubuntu/kubernetes-jenkins/service.yaml

# create ingress to communicate with service
kubectl apply -f ./kube-infra/ubuntu/kubernetes-jenkins/ingress.yaml

set +x