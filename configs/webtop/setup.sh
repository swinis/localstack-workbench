#!/bin/bash

apt-get update

# install basics
apt-get install -y dialog inetutils-ping wget neovim python3-pip
apt-get install -y gnupg software-properties-common
apt-get install -y apt-transport-https ca-certificates curl

# add helm apt repository
curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list

# add kubectl apt repository
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

# add hashicorp apt repository
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | \
tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null

gpg --no-default-keyring \
--keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg \
--fingerprint

echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
sudo tee /etc/apt/sources.list.d/hashicorp.list

# add microsoft apt repository
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'

apt-get update

# Cloud and IaC stuff
apt-get install -y awscli
apt-get install -y terraform
pip install awsume
pip install terraform-local

# install Visual Studio Code as IDE
apt-get install -y code

# install PyCharm
wget https://download.jetbrains.com/python/pycharm-community-2023.3.4-$(uname -i).tar.gz && \
tar xzvf pycharm-community-2023.3.4-$(uname -i).tar.gz -C /opt/

# install K8s tools
apt-get install -y libnotify4
wget https://github.com/MuhammedKalkan/OpenLens/releases/download/v6.5.2-366/OpenLens-6.5.2-366.arm64.deb
dpkg -i OpenLens-6.5.2-366.arm64.deb
apt-get install -y kubectl

git clone https://github.com/ahmetb/kubectx /usr/local/kubectx
ln -s /usr/local/kubectx/kubectx /usr/local/bin/kubectx
ln -s /usr/local/kubectx/kubens /usr/local/bin/kubens

apt-get install -y helm
curl -s https://fluxcd.io/install.sh | bash
