#!/bin/bash

set -e

# update ubuntu
apt update && apt upgrade -y

# install openvpn 
wget https://git.io/vpn -O openvpn-install.sh
chmod +x openvpn-install.sh
bash openvpn-install.sh