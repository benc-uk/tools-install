#!/bin/bash 
set -e 
source _lib.sh

start "Azure Functions v3 Core Tools"

# Download the Microsoft repository GPG keys
wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb -O /tmp/packages-microsoft-prod.deb
# Register the Microsoft repository GPG keys
sudo dpkg -i /tmp/packages-microsoft-prod.deb

sudo apt-get update
sudo apt-get install -y azure-functions-core-tools-3

end 'func' '--version'