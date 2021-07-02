#!/bin/bash
set -e

CMD=telepresence
NAME="telepresence"

echo -e "\e[34m»»» 📦 \e[32mInstalling \e[33m$NAME\e[0m ..."

curl -s https://packagecloud.io/install/repositories/datawireio/telepresence/script.deb.sh | sudo bash
sudo apt install --no-install-recommends telepresence

echo -e "\n\e[34m»»» 💾 \e[32mInstalled to: \e[33m$(which $CMD)"
echo -e "\e[34m»»» 💡 \e[32mVersion details: \e[39m$($CMD --version)"