#!/bin/bash
# This is only to be used as a prep for a non Pure Test Drive Environment
# Brian Kuebler 4/17/20
# Bruce Modell 7/22/20
# Chris Crow 7/22/20

# Install necessary packages, only python2 installed

echo "#####################################"

#remove password requirement for sudo
echo '%sudo ALL=(ALL) NOPASSWD:ALL' | sudo tee -a /etc/sudoers

#makesure all packages are updated
sudo apt-get update
sudo apt install software-properties-common
sudo apt-add-repository ppa:ansible/ansible
sudo apt update
#install PIP3
sudo apt install python3-pip --assume-yes

# Install necessary packages, only python2 installed

echo "#####################################"

# Install SDK

echo "####  Installing the Pure Storage SDK  ####"
sudo apt install purestorage
sudo apt install ansible --assume-yes
# Install the Pure Storage collection


echo "#### Installing the Purestorage Ansible Collection  ####"

ansible-galaxy collection install purestorage.flasharray


#install Iscsi-tools
sudo apt install open-iscsi --assume-yes

#Install Multipath tools
sudo apt install multipath-tools --assume-yes

#install scsi tools
sudo apt install -y scsitools --assume-yes



# Typing "ansible-playbook" everytime is a hassle...
echo "" >> ~/.bashrc
echo "alias ap='ansible-playbook'" >> ~/.bashrc
echo "alias P='cd ~/newstack_demo/ansible_playbooks'" >> ~/.bashrc


#Install PSO
echo "#### Update helm repos and install PSO ####"
helm repo add pure https://purestorage.github.io/helm-charts
helm repo add stable https://kubernetes-charts.storage.googleapis.com/
helm repo update
helm install pure-storage-driver pure/pure-csi --namespace default -f ~/newstack_demo/kubernetes_yaml/pso_values.yaml


#Install PSO EXPLORER
# Add Helm repo for PSO Explorer
echo "#### Add, update helm repos and install PSO Explorer####"
helm repo add pso-explorer 'https://raw.githubusercontent.com/PureStorage-OpenConnect/pso-explorer/master/'
helm repo update
helm search repo pso-explorer -l

# Create namespace
kubectl create namespace psoexpl
kubectl create namespace demo

# Install with default settings
helm install pso-explorer pso-explorer/pso-explorer --namespace psoexpl

