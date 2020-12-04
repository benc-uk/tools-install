#!/bin/bash 
set -e
DIR=$(cd `dirname $0` && pwd)
source $DIR/.lib.sh

#ver="3.1"
ver="5.0"
start ".NET Core SDK $ver"

# Download the Microsoft repository GPG keys
wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb -O /tmp/packages-microsoft-prod.deb
# Register the Microsoft repository GPG keys
sudo dpkg -i /tmp/packages-microsoft-prod.deb

sudo add-apt-repository universe
sudo apt-get install apt-transport-https
sudo apt-get update -y
sudo apt-get install dotnet-sdk-$ver -y

end 'dotnet' '--version'