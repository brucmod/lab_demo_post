#!/bin/bash
# This is only to be used as a prep for a non Pure Test Drive Environment
# Brian Kuebler 4/17/20
# Bruce Modell 7/22/20
# Chris Crow 7/22/20

# Install necessary packages, only python2 installed

echo "#####################################"

#remove password requirement for sudo
echo '%sudo ALL=(ALL) NOPASSWD:ALL' | sudo tee -a /etc/sudoers


echo "install Helm" 
sudo snap install helm --classic

# Install necessary packages, only python2 installed

echo "#####################################"

# Install SDK

echo "####  Installing the Pure Storage SDK  ####"
pip3 install purestorage

# Install the Pure Storage collection


echo "#### Installing the Purestorage Ansible Collection  ####"

ansible-galaxy collection install purestorage.flasharray


# Typing "ansible-playbook" everytime is a hassle...
echo "" >> ~/.bashrc
echo "alias ap='ansible-playbook'" >> ~/.bashrc
echo "alias P='cd ~/newstack_demo/ansible_playbooks'" >> ~/.bashrc


#Install PSO
echo "#### Update helm repos and install PSO ####"
helm repo add pure https://purestorage.github.io/helm-charts
helm repo add stable helm repo add stable https://charts.helm.sh/stable
helm repo update
helm install pure-storage-driver pure/pure-csi --namespace default -f ~/post_k8/kubernetes/pso_values.yaml


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

