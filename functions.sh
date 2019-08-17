#!/bin/bash 
set -e 

echo "Installing Azure Functions Core Tools"

# Download the Microsoft repository GPG keys
wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb -O /tmp/packages-microsoft-prod.deb
# Register the Microsoft repository GPG keys
sudo dpkg -i /tmp/packages-microsoft-prod.deb

sudo apt-get update
sudo apt-get install azure-functions-core-tools
