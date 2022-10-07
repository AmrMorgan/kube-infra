#!/bin/bash

set -x

# check for the public IP
if [ $# -eq 0 ]
  then
    echo "Please provide the public IP"
    exit 0
fi

# define variables
export K_LOAD_BALANCER="$1"
export K_CONFIGS=/etc/kubernetes/custom

# patch nginx controller
mkdir -p $K_CONFIGS

# copy nginx configs
kubectl get svc ingress-nginx-controller -n ingress-nginx -o yaml > $K_CONFIGS/ingress-service.yaml

# update configs file
sed -i -e "s/type: LoadBalancer/type: LoadBalancer\n  externalIPs:\n  - $K_LOAD_BALANCER/" \
    $K_CONFIGS/ingress-service.yaml

# restart the service with new configs
kubectl apply -f $K_CONFIGS/ingress-service.yaml
kubectl rollout restart deployment ingress-nginx-controller -n ingress-nginx

set +x
