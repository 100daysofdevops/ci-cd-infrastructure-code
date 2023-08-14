#!/bin/bash

# Exit if encountered any error
set -e

# Check if user is running the script as root or not
if [[ $EUID -ne 0 ]]; then
   echo "Error: This script must be run as root user"
   exit 1
fi


# Update the package repository
dnf update

# Install the java(Jenkins has dependency on java). Here I am using jdk 1.8, please change it based on your environment)
dnf install java-11-amazon-corretto-devel

# Add Jenkins repository and import it key
wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key

# Install Jenkins(https://www.jenkins.io/doc/book/installing/linux/#red-hat-centos)
yum install -y jenkins

# Start Jenkins service
echo "Starting Jenkins Server. Please wait..."
systemctl start jenkins

# Enable the Jenkins service to start at boot
systemctl enable jenkins

# Print the initial admin password for Jenkins
if [[ -f /var/lib/jenkins/secrets/initialAdminPassword ]]; then
   echo "Initial Admin password: "
   echo "========================"
   cat  /var/lib/jenkins/secrets/initialAdminPassword
else
    echo "Failed to retrieve intial admin password for Jenkins"
fi    