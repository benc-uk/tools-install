#!/bin/bash 
set -e  
DIR=$(cd `dirname $0` && pwd)
source $DIR/_lib.sh

start "Installing Powershell Core"

# Download the Microsoft repository GPG keys
wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb -O /tmp/packages-microsoft-prod.deb

# Register the Microsoft repository GPG keys
sudo dpkg -i /tmp/packages-microsoft-prod.deb

# Update the list of products
sudo apt-get update -y

# Install PowerShell
sudo apt-get install -y powershell

end 'pwsh' '--version'