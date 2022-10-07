#!/bin/bash

set -e

# update ubuntu
dnf update -y

# disable selinux
setenforce 0
sed -i --follow-symlinks 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux

# enable networking and reload firewall
modprobe br_netfilter
firewall-cmd --add-masquerade --permanent
firewall-cmd --reload   

# Set bridged packets to traverse iptables rules.
cat < /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl --system

# disable swap
swapoff -a

# install docker
dnf config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo
dnf install https://download.docker.com/linux/centos/7/x86_64/stable/Packages/containerd.io-1.2.6-3.3.el7.x86_64.rpm
dnf install docker-ce --nobest -y

# enable docker process
systemctl start docker
systemctl enable docker

# Change docker to use systemd cgroup driver.
echo '{
  "exec-opts": ["native.cgroupdriver=systemd"]
}' > /etc/docker/daemon.json
systemctl restart docker

# install packages
apt install -y docker.io net-tools