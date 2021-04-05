#!/bin/bash
set -e

get_latest_release() {
  curl --silent "https://api.github.com/repos/$1/releases/latest" |
  grep '"tag_name":' | sed -E 's/.*"v([^"]+)".*/\1/'
}

VERSION=${1:-"$(get_latest_release helm/helm)"}
INSTALL_DIR=${2:-"$HOME/.local/bin"}
CMD=helm
NAME="Helm"

echo -e "\e[34m»»» 📦 \e[32mInstalling \e[33m$NAME \e[35mv$VERSION\e[0m ..."

curl -fsS "https://get.helm.sh/helm-v$VERSION-linux-amd64.tar.gz" -o /tmp/helm.tar.gz
tar -zxf /tmp/helm.tar.gz -C /tmp linux-amd64/helm
mkdir -p $INSTALL_DIR
sudo mv /tmp/linux-amd64/helm $INSTALL_DIR
rm -f /tmp/helm.tar.gz
rm -rf /tmp/linux-amd64

echo -e "\n\e[34m»»» 💾 \e[32mInstalled to: \e[33m$(which $CMD)"
echo -e "\e[34m»»» 💡 \e[32mVersion details: \e[39m$($CMD version)"
