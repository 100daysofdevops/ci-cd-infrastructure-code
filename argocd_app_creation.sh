#!/bin/bash

# Exit if encountered any error
set -e

# Ensure the ARGOCD_TOKEN is provided as an argument
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 ARGOCD_TOKEN"
    exit 1
fi

ARGOCD_TOKEN="$1"

# Configuration
ARGOCD_SERVER="argocd-server-url"  
PROJECT_NAME_PREFIX="my-project"   
DESCRIPTION="My ArgoCD Project"   

# Cluster and source repositories. Adjust these as needed.
CLUSTER_URL="https://kubernetes.default.svc"
SOURCE_REPO_DEV="https://github.com/yourusername/dev-repo.git"
SOURCE_REPO_PROD="https://github.com/yourusername/prod-repo.git"

# Apps allowed to deploy. This example allows all apps.
APP_PATH="*"

# Install ArgoCD CLI
if ! command -v argocd &> /dev/null; then
    echo "Installing argocd CLI..."
    curl -sSL -o /usr/local/bin/argocd https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
    chmod +x /usr/local/bin/argocd
fi

# Log in to ArgoCD
if ! argocd login $ARGOCD_SERVER --auth-token $ARGOCD_TOKEN; then
    echo "Error: Failed to login to ArgoCD."
    exit 1
fi

# Function to create projects
create_project() {
    local env=$1
    local source_repo=$2

    local project_name="${PROJECT_NAME_PREFIX}-${env}"
    local project_description="${DESCRIPTION} (${env^} Environment)"
    
    if ! argocd proj create $project_name \
        --description "$project_description" \
        --src $source_repo \
        --dest $CLUSTER_URL,$project_name \
        --allow-namespace $project_name; then
        echo "Error: Failed to create project $project_name"
        exit 1
    fi

    echo "Project $project_name created successfully!"
}

# Create the projects
create_project "dev" $SOURCE_REPO_DEV
create_project "production" $SOURCE_REPO_PROD