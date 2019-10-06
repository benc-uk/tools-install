#!/bin/bash 
set -e 

#
# WORKS ON WSL v2 ONLY!
#
echo "Installing Docker CE Engine/server..."
curl -fsSL https://get.docker.com/ | sh
sudo groupadd docker
sudo usermod -aG docker $USER
