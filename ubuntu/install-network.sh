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
helm repo add jetstack https://charts.jetstack.io
helm repo update
helm upgrade --install \
  cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --create-namespace \
  --version v1.9.1 \
  --set installCRDs=true \
  --set startupapicheck.timeout=10m

set +x