#!/bin/bash
# k8s adm setup for cluster
#common setup on all (Control plane and nodes)

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo add-apt-repository    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
  stable"


curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

cat << EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF

sudo apt-get update

sudo apt-get install -y docker-ce kubelet kubeadm kubectl

sudo apt-mark hold docker-ce kubelet kubeadm kubectl

echo "net.bridge.bridge-nf-call-iptables=1" | sudo tee -a /etc/sysctl.conf

sudo sysctl -p

sudo swapoff -a
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

cd /etc/docker
echo "{\"exec-opts\":[\"native.cgroupdriver=systemd\"]}"  > daemon.json

systemctl daemon-reload
systemctl restart docker
systemctl restart kubelet

#rm /etc/containerd/config.toml	
#systemctl restart containerd
