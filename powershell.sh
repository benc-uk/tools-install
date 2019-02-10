#!/bin/bash 
set -e  

echo "Installing Powershell Core"

# Download the Microsoft repository GPG keys
wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb -O /tmp/packages-microsoft-prod.deb

# Register the Microsoft repository GPG keys
sudo dpkg -i /tmp/packages-microsoft-prod.deb

# Update the list of products
sudo apt-get update

# Install PowerShell
sudo apt-get install -y powershell
