#!/bin/bash 
set -e 
DIR=$(cd `dirname $0` && pwd)
source $DIR/_lib.sh

echo "Installing Docker client tools..."

#dockerVer="18.09.3"
machineVer="0.16.2"
composeVer="1.25.4"

mkdir -p  $HOME/.local/bin

start "Docker Machine v$machineVer"
start "Docker Compose v$composeVer"

# **** WSL2: removed client, now installed with Docker engine ****

#echo "docker"
#curl -sSL https://download.docker.com/linux/static/stable/x86_64/docker-$dockerVer.tgz -o /tmp/docker.tgz
#tar -zxvf /tmp/docker.tgz docker/docker
#chmod +x docker/docker
#mv docker/docker $HOME/.local/bin/docker
#rmdir docker/

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