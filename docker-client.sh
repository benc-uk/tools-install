#!/bin/bash 
set -e 
DIR=$(cd `dirname $0` && pwd)
source $DIR/.lib.sh

dockerVer="19.03.8"

start "Docker CLI v$dockerVer"

mkdir -p  $HOME/.local/bin
curl -sSL https://download.docker.com/linux/static/stable/x86_64/docker-$dockerVer.tgz -o /tmp/docker.tgz
tar -zxvf /tmp/docker.tgz docker/docker
chmod +x docker/docker
mv docker/docker $HOME/.local/bin/docker
rmdir docker/

end 'docker' '--version'
