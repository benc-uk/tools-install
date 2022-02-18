#!/bin/bash
set -e

get_latest_release() {
  curl --silent "https://api.github.com/repos/$1/releases/latest" |
  grep '"tag_name":' | sed -E 's/.*"v([^"]+)".*/\1/'
}

GITHUB="mozilla/sops"
VERSION=${1:-"$(get_latest_release $GITHUB)"}
INSTALL_DIR=${2:-"$HOME/.local/bin"}
CMD=sops
NAME="Mozilla Sops"

echo -e "\e[34m»»» 📦 \e[32mInstalling \e[33m$NAME \e[35m$VERSION\e[0m ..."

curl -sL "https://github.com/${GITHUB}/releases/download/v${VERSION}/sops-v${VERSION}.linux" -o "$INSTALL_DIR"/sops
chmod +x "$INSTALL_DIR"/sops

echo -e "\n\e[34m»»» 💾 \e[32mInstalled to: \e[33m$(which $CMD)"
echo -e "\e[34m»»» 💡 \e[32mVersion details: \e[39m$($CMD --version)"
