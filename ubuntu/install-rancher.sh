#!/bin/bash

set -x

# check for the public IP
if [ $# -eq 0 ]
  then
    echo "Please provide the rancher domain"
    exit 0
fi

# define variables
export K_RANCHER_DOMAIN="$1"
export K_CONFIGS=/etc/kubernetes/custom

# write rancher configs file
cat > $K_CONFIGS/rancher-config.yaml << EOF
replicas: 1
EOF

# fix issue
kubectl delete -A ValidatingWebhookConfiguration ingress-nginx-admission

# inatall rancher
helm repo add rancher-latest https://releases.rancher.com/server-charts/latest
helm install rancher rancher-latest/rancher --debug \
  --namespace cattle-system --create-namespace \
  --set hostname=$K_RANCHER_DOMAIN \
  --set bootstrapPassword=admin \
  --set ingress.tls.source=rancher \
  --set ingress.ingressClassName=nginx \
  -f $K_CONFIGS/rancher-config.yaml
