#!/bin/bash 
set -e
source <(curl -sSL https://raw.githubusercontent.com/benc-uk/tools-install/master/_lib.sh) # Load libary from remote URL, it's safe!

CMD=dockerd
NAME="Docker Engine & CLI"
VERSION=$(apt_version docker-ce)

pre_run

curl -fsSL https://get.docker.com/ | sh
sudo groupadd docker || true
sudo usermod -aG docker "$USER"

echo -e "\n\e[34m»»» 💾 \e[32mInstalled to: \e[33m$(which $CMD)"
echo -e "\e[34m»»» 💡 \e[32mVersion details: \e[39m$($CMD --version)"
echo -e "\e[34m»»» 📜 \e[32mNOTE 1: Please close this shell and open a new one to run docker without sudo"
echo -e "\e[34m»»» 📜 \e[32mNOTE 2: Docker will NOT auto start on WSL, you must run 'sudo service docker start'"
