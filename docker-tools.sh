#!/bin/bash 
set -e 
DIR=$(cd `dirname $0` && pwd)
source $DIR/.lib.sh

machineVer="0.16.2"
composeVer="1.25.5"

mkdir -p  $HOME/.local/bin

start "Docker Machine v$machineVer"
start "Docker Compose v$composeVer"

echo "docker-machine"
curl -sSL https://github.com/docker/machine/releases/download/v$machineVer/docker-machine-`uname -s`-`uname -m` -o /tmp/docker-machine
chmod +x /tmp/docker-machine
cp /tmp/docker-machine $HOME/.local/bin/docker-machine

echo "docker-compose"
curl -sSL https://github.com/docker/compose/releases/download/$composeVer/docker-compose-`uname -s`-`uname -m` -o /tmp/docker-compose
chmod +x /tmp/docker-compose
cp /tmp/docker-compose $HOME/.local/bin/docker-compose

end 'docker-machine' '--version'
end 'docker-compose' '--version'