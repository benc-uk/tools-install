#!/bin/bash
set -e

get_latest_release() {
  curl --silent "https://api.github.com/repos/$1/releases/latest" |
  grep '"tag_name":' | sed -E 's/.*"v([^"]+)".*/\1/'
}

VERSION=${1:-"$(get_latest_release mozilla/sops)"}
INSTALL_DIR=${2:-"$HOME/.local/bin"}
CMD=sops
NAME="Mozilla Sops"

curl -sL "https://github.com/mozilla/sops/releases/download/v${VERSION}/sops-v${VERSION}.linux" -o /tmp/sops
mkdir -p $INSTALL_DIR
chmod +x /tmp/sops 
mv /tmp/sops $INSTALL_DIR

echo -e "\n\e[34m»»» 💾 \e[32mInstalled to: \e[33m$(which $CMD)"
echo -e "\e[34m»»» 💡 \e[32mVersion details: \e[39m$($CMD --version)"
