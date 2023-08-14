#!/bin/bash

# Exit if encountered any error
set -e

# Check if user is running the script as root or not
if [[ $EUID -ne 0 ]]; then
   echo "Error: This script must be run as root user"
   exit 1
fi

# Verify and install docker is not present
if ! command -v docker &> /dev/null; then
   echo "No Docker Installation found. Installing now.."

    # Install Docker
    dnf install docker

    # Start Docker daemon and enable it to start on boot
    systemctl start docker
    systemctl enable docker

else
    echo "Docker is already installed"
fi

# Verify if kind is already https://kind.sigs.k8s.io/docs/user/quick-start/#configuring-your-kind-cluster
if ! command -v kind &> /dev/null; then
   echo "No kind Installation found. Installing now.."

   # Get the lastest stable version of kind
   KIND_VERSION=$(curl -s https://api.github.com/repos/kubernetes-sigs/kind/releases/latest | grep 'tag_name' | cut -d\" -f4)

   # Install kind
    curl -Lo ./kind "https://kind.sigs.k8s.io/dl/$KIND_VERSION/kind-linux-amd64"
    chmod +x ./kind
    mv ./kind /usr/bin/kind
else
    echo "kind is already installed"
fi  

# Creating kind cluster with 1 control plane and 2 worker node
kind create cluster --config ./kind-config.yaml

# Check and install kubectl if not present
if ! command -v kubectl &> /dev/null; then
    echo "kubectl not found! Installing..."
    
    # Install kubectl
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    chmod +x kubectl
    mv kubectl /usr/local/bin/
else
    echo "kubectl is already installed!"
fi