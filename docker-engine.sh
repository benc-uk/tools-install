#!/bin/bash 
set -e 
source _lib.sh

#
# WORKS ON WSL v2 ONLY!
#
start 'Docker Engine'

curl -fsSL https://get.docker.com/ | sh
sudo groupadd docker || true
sudo usermod -aG docker $USER

end 'docker' '--version'
