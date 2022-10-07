# Simple 2 node Kubernetes cluster

## initial step
run the below command on all nodes
```bash
git clone https://github.com/AmrMorgan/kube-infra.git && \
    chmod +x kube-infra/ubuntu/* && \
    ./kube-infra/ubuntu/bootstrap-kube.sh
```
on the master node
```bash
./kube-infra/ubuntu/initialize-cluster.sh
```

then run the output of this command on all worker nodes
```bash
kubeadm token create --print-join-command
```
to verify installastion
```bash
kubectl version --short
```

install load balancer ,ingress controller and cert manager
```bash
./kube-infra/ubuntu/install-network.sh
```

## Troubleshooting 
if the node registered wrongly
```bash
# on master node
kubectl drain worker-01 && kubectl delete node worker-01

# on worker node
kubeadm reset
```

