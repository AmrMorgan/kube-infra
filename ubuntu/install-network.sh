#!/bin/bash

set -x

# install metallb
kubectl apply -f \
  https://raw.githubusercontent.com/metallb/metallb/v0.13.5/config/manifests/metallb-native.yaml

# update metallb configs
kubectl get configmap kube-proxy -n kube-system -o yaml | \
  sed -e "s/strictARP: false/strictARP: true/" | \
  sed -e "s/mode: \"\"/mode: \"ipvs\"/" | \
  kubectl apply -f - -n kube-system

# add memberlist secret
kubectl create secret generic -n metallb-system memberlist \
  --from-literal=secretkey="$(openssl rand -base64 128)"

# install nginx ingress
helm upgrade --install ingress-nginx ingress-nginx \
  --repo https://kubernetes.github.io/ingress-nginx \
  --namespace ingress-nginx --create-namespace \
  --set controller.watchIngressWithoutClass=true

# install cert manager
kubectl apply -f \
  https://github.com/cert-manager/cert-manager/releases/download/v1.9.1/cert-manager.crds.yaml
kubectl apply -f \
  https://github.com/cert-manager/cert-manager/releases/download/v1.9.1/cert-manager.yaml

set +x