#!/bin/bash 
set -e

get_latest_release() {
  curl --silent "https://api.github.com/repos/$1/releases/latest" |
  grep '"tag_name":' | sed -E 's/.*"v([^"]+)".*/\1/'
}

VERSION=${1:-"$(get_latest_release stuartleeks/devcontainer-cli)"}
INSTALL_DIR=${2:-"$HOME/.local/bin"}
CMD=devcontainer
NAME="devcontainer CLI"

echo -e "\e[34m»»» 📦 \e[32mInstalling \e[33m$NAME \e[35mv$VERSION\e[0m ..."

curl -sSL "https://github.com/stuartleeks/devcontainer-cli/releases/download/v${VERSION}/devcontainer-cli_linux_amd64.tar.gz" -o /tmp/devcontainer.tar.gz
tar -C "$INSTALL_DIR" -zxvf /tmp/devcontainer.tar.gz devcontainer
chmod +x "$INSTALL_DIR/devcontainer"
rm -f /tmp/devcontainer.tar.gz

echo -e "\n\e[34m»»» 💾 \e[32mInstalled to: \e[33m$(which $CMD)"
echo -e "\e[34m»»» 💡 \e[32mVersion details: \e[39m$($CMD version)"