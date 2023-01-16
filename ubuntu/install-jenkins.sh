#!/bin/bash

set -x

# create namespace
kubectl create namespace devops-tools

# create permissions for jenkins
kubectl apply -f ./kubernetes-jenkins/serviceAccount.yaml

# create persistent volume
kubectl create -f ./kubernetes-jenkins/volume.yaml

# create deployment
kubectl apply -f ./kubernetes-jenkins/deployment.yaml

# create service for networking
kubectl apply -f ./kubernetes-jenkins/service.yaml

# create ingress to communicate with service
kubectl apply -f ./kubernetes-jenkins/ingress.yaml

set +x