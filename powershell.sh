#!/bin/bash 
set -e  
source <(curl -sSL s.benc.dev/lib) # Load libary from remote URL, it's safe!

CMD=pwsh
NAME="PowerShell"
VERSION="7"

pre_run

# Download the Microsoft repository GPG keys
wget -q https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb -O /tmp/packages-microsoft-prod.deb
# Register the Microsoft repository GPG keys
sudo dpkg -i /tmp/packages-microsoft-prod.deb
rm -f /tmp/packages-microsoft-prod.deb

sudo apt-get update -y -qq
sudo apt-get install -y powershell

post_run