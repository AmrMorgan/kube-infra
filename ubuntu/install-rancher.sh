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

# write rancher configs file
cat > $K_CONFIGS/rancher-config.yaml << EOF
replicas: 1
EOF

# inatall rancher
helm repo add rancher-latest https://releases.rancher.com/server-charts/latest
kubectl create namespace cattle-system
helm install rancher rancher-latest/rancher \
  --namespace cattle-system \
  --set hostname=rancher.$K_LOAD_BALANCER.sslip.io \
  --set bootstrapPassword=admin \
  --set ingress.tls.source=rancher
  -f $K_CONFIGS/rancher-config.yaml
