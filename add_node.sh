#-----------------------------------
#
# do not run this script as root
#
#-----------------------------------

#!/bin/bash

# prerequisite
cd ~

# disable firewall
sudo systemctl stop ufw
sudo systemctl disable ufw

# install basic packages
sudo apt update
sudo apt install -y nfs-common

cat <<EOF | sudo tee -a /etc/sysctl.d/99-kubernetes-cri.conf
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF

sudo sysctl --system

# download nerdctl zip file
cd ${HOME}
wget https://github.com/containerd/nerdctl/releases/download/v1.6.2/nerdctl-full-1.6.2-linux-amd64.tar.gz

# install nerdctl
tar Cxzvvf /usr/local nerdctl-full-1.6.2-linux-amd64.tar.gz
