#!/bin/bash 
set -e 
DIR=$(cd `dirname $0` && pwd)
source $DIR/_lib.sh

start 'Docker Engine'

curl -fsSL https://get.docker.com/ | sh
sudo groupadd docker || true
sudo usermod -aG docker $USER

end 'docker' '--version'
