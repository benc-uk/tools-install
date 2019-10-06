#!/bin/bash 
set -e  

ver="2.2"
echo "Installing .NET Core SDK $ver"

# Download the Microsoft repository GPG keys
wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb -O /tmp/packages-microsoft-prod.deb
# Register the Microsoft repository GPG keys
sudo dpkg -i /tmp/packages-microsoft-prod.deb

sudo add-apt-repository universe
sudo apt-get install apt-transport-https
sudo apt-get update -y
sudo apt-get install dotnet-sdk-$ver -y
