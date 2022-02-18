#!/bin/bash 
set -e

CMD=dockerd
NAME="Docker Engine"

echo -e "\e[34m»»» 📦 \e[32mInstalling \e[35m\e[33m$NAME\e[0m ..."

curl -fsSL https://get.docker.com/ | sh
sudo groupadd docker || true
sudo usermod -aG docker $USER

echo -e "\n\e[34m»»» 💾 \e[32mInstalled to: \e[33m$(which $CMD)"
echo -e "\e[34m»»» 💡 \e[32mVersion details: \e[39m$($CMD --version)"
