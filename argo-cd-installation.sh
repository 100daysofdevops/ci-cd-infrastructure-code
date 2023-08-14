#!/bin/bash

# Exit if encountered any error
set -e

# Check if user is running the script as root or not
if [[ $EUID -ne 0 ]]; then
   echo "Error: This script must be run as root user"
   exit 1
fi

# Creating namespace for ArgoCD
echo "Creating namespace for argocd..."
kubectl create namespace argocd

if [[ $? -ne 0 ]]; then
   echo "Error: failed to create the namespace"
   exit 1
fi   

# ArgoCD installation
echo "Installing ArgoCD..."
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

if [[ $? -ne 0 ]]; then
   echo "Error: failed to deploy ArgoCD..."
   exit 1
fi 

echo "ArgoCD installation completed. It may take a few moments for all components to be up and running."

