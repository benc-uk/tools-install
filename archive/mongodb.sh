#!/bin/bash
set -e

#
# DOES NOT WORK WITH WSL2 - I GAVE UP
#

VERSION=${1:-"4.4"}
CMD=mongod
NAME="MongoDB Server"

echo -e "\e[34m»»» 📦 \e[32mInstalling \e[33m$NAME\e[0m ..."

wget -qO - https://www.mongodb.org/static/pgp/server-${VERSION}.asc | sudo apt-key add -
echo "deb [ arch=amd64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/${VERSION} multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org.list
sudo apt-get update -qq
sudo apt-get install -y mongodb-org

echo -e "\n\e[34m»»» 💾 \e[32mInstalled to: \e[33m$(which $CMD)"
echo -e "\e[34m»»» 💡 \e[32mVersion details: \e[39m$($CMD --version)"
