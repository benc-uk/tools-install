#!/bin/bash 
set -e

VERSION=${1:-"0.11.1"}
INSTALL_DIR=${2:-"$HOME/.local/bin"}
CMD=kind
NAME=kind

echo -e "\e[34m»»» 📦 \e[32mInstalling \e[33m$NAME v$VERSION\e[0m ..."

curl -sSLo /tmp/kind https://kind.sigs.k8s.io/dl/v${VERSION}/kind-linux-amd64
chmod +x /tmp/kind
mv /tmp/kind ${INSTALL_DIR}/kind

echo -e "\n\e[34m»»» 💾 \e[32mInstalled to: \e[33m$(which $CMD)"
echo -e "\e[34m»»» 💡 \e[32mVersion details: \e[39m$($CMD --version)"