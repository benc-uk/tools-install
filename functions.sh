#!/bin/bash 
set -e 
source <(curl -sSL https://raw.githubusercontent.com/benc-uk/tools-install/master/_lib.sh) # Load libary from remote URL, it's safe!

VERSION=${1:-"4"}
CMD=func
NAME="Azure Functions Core Tools"

pre_run

# Download the Microsoft repository GPG keys
wget -q https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb -O /tmp/packages-microsoft-prod.deb

# Register the Microsoft repository GPG keys
sudo dpkg -i /tmp/packages-microsoft-prod.deb
rm -f /tmp/packages-microsoft-prod.deb

sudo apt-get update -qq
sudo apt-get install -y -qq azure-functions-core-tools-"$VERSION"

post_run