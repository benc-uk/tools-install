#!/bin/bash 
set -e 

echo "Installing Docker client tools into $HOME/.local/bin/"

dockerVer="18.09.1"
machineVer="0.16.1"
composeVer="1.23.2"

mkdir -p  $HOME/.local/bin

echo "docker"
curl -sSL https://download.docker.com/linux/static/stable/x86_64/docker-$dockerVer.tgz -o /tmp/docker.tgz
tar -zxvf /tmp/docker.tgz docker/docker
chmod +x docker/docker
mv docker/docker $HOME/.local/bin/docker
rmdir docker/

echo "docker-machine"
curl -sSL https://github.com/docker/machine/releases/download/v$machineVer/docker-machine-`uname -s`-`uname -m` -o /tmp/docker-machine
chmod +x /tmp/docker-machine
cp /tmp/docker-machine $HOME/.local/bin/docker-machine

echo "docker-compose"
curl -sSL https://github.com/docker/compose/releases/download/$composeVer/docker-compose-`uname -s`-`uname -m` -o /tmp/docker-compose
chmod +x /tmp/docker-compose
cp /tmp/docker-compose $HOME/.local/bin/docker-compose

