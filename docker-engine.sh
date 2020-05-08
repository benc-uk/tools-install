#!/bin/bash 
set -e 
DIR=$(cd `dirname $0` && pwd)
source $DIR/_lib.sh

#
# Only use on WSL v2 or real Linux system/VM 
#
start 'Docker Engine'

curl -fsSL https://get.docker.com/ | sh
sudo groupadd docker || true
sudo usermod -aG docker $USER

end 'docker' '--version'
