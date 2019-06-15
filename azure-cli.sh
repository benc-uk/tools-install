#!/bin/bash 
set -e 

echo "Installing Azure CLI"

curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

#AZ_REPO=$(lsb_release -cs)
#echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" | \
#    sudo tee /etc/apt/sources.list.d/azure-cli.list

#sudo apt-get update
#sudo apt-get install azure-cli


