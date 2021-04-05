#!/bin/bash
set -e

get_latest_release() {
  curl --silent "https://api.github.com/repos/$1/releases" |
  grep -Po -m 1 '"tag_name": "stable-([\d.]+)"' | sed -E 's/.*"stable-([^"]+)".*/\1/'
}

VERSION=${1:-"$(get_latest_release linkerd/linkerd2)"}
INSTALL_DIR=${2:-"$HOME/.local/bin"}
CMD=linkerd
NAME="Linkerd Service Mesh"

echo -e "\e[34m»»» 📦 \e[32mInstalling \e[33m$NAME \e[35m$VERSION\e[0m ..."

mkdir -p $INSTALL_DIR
curl -sSL https://github.com/linkerd/linkerd2/releases/download/stable-${VERSION}/linkerd2-cli-stable-${VERSION}-linux-amd64 -o $INSTALL_DIR/linkerd
chmod +x $INSTALL_DIR/linkerd

echo -e "\n\e[34m»»» 💾 \e[32mInstalled to: \e[33m$(which $CMD)"
echo -e "\e[34m»»» 💡 \e[32mVersion details: \e[39m$($CMD version)"
