# Simple 2 node Kubernetes cluster

## initial step

first go into root role
```bash
sudo -i
```

to reduce steps you can define variable with public IP
```bash
export K_WORKER_IP=XX.XX.XX.XX
```
run the below command on all nodes
```bash
git clone -b aws https://github.com/AmrMorgan/kube-infra.git && \
    chmod +x kube-infra/ubuntu/* && \
    ./kube-infra/ubuntu/bootstrap-kube.sh
```
on the master node and then run the output of this command on all worker nodes
```bash
./kube-infra/ubuntu/initialize-cluster.sh && \
    kubeadm token create --print-join-command
```

to verify installastion
```bash
kubectl version --short
```

## setup networking
install load balancer ,ingress controller and cert manager
```bash
./kube-infra/ubuntu/install-network.sh
```

expose the load balancer to **public ip**
```bash
./kube-infra/ubuntu/expose-public.sh $K_WORKER_IP
```

## install tools
install rancher on the cluster
```bash
./kube-infra/ubuntu/install-rancher.sh rancher.domain.com
```

## Troubleshooting 
if the node registered wrongly
```bash
# on master node
kubectl drain worker-01 && kubectl delete node worker-01

# on worker node
kubeadm reset
```
see the logs of nginx
```bash
kubectl -n ingress-nginx logs -f ingress-nginx-controller-5cf484d4f7-v6fj8 -n ingress-nginx
```
restart the rancher deployment
```bash
kubectl -n cattle-system rollout status deploy/rancher
```