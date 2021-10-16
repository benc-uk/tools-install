#!/bin/bash 
set -e

get_latest_release() {
  curl --silent "https://api.github.com/repos/$1/releases/latest" |
  grep '"tag_name":' | sed -E 's/.*"v([^"]+)".*/\1/'
}

VERSION=${1:-"$(get_latest_release deislabs/wagi)"}
INSTALL_DIR=${2:-"$HOME/.local/bin"}
CMD=wagi
NAME=wagi

echo -e "\e[34m»»» 📦 \e[32mInstalling \e[33m$NAME v$VERSION\e[0m ..."

curl -fsSL "https://github.com/deislabs/wagi/releases/download/v$VERSION/wagi-v$VERSION-linux-amd64.tar.gz" -o /tmp/wagi.tar.gz
tar -zxf /tmp/wagi.tar.gz -C /tmp
mkdir -p "$INSTALL_DIR"
sudo mv /tmp/wagi "$INSTALL_DIR"
rm -f /tmp/wagi.tar.gz
rm -rf /tmp/wagi

echo -e "\n\e[34m»»» 💾 \e[32mInstalled to: \e[33m$(which $CMD)"
echo -e "\e[34m»»» 💡 \e[32mVersion details: \e[39m$($CMD --version)"