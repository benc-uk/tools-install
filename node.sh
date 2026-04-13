#!/bin/bash
source <(curl -sSL https://raw.githubusercontent.com/benc-uk/tools-install/master/_lib.sh) # Load libary from remote URL, it's safe!

VERSION=${1:-"24"}
CMD=node
NAME="Node.js"

pre_run

curl -sL "https://deb.nodesource.com/setup_${VERSION}.x" | sudo -E bash -
sudo apt install -y nodejs

post_run --version
echo -e "\e[34m»»» 💡 \e[32mNPM version details: \e[39m$(npm --version)"
