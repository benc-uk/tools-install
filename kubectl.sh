#!/bin/bash
set -e

VERSION=${1:-"$(curl -L -s https://dl.k8s.io/release/stable.txt)"}
INSTALL_DIR=${2:-"$HOME/.local/bin"}
CMD=kubectl
NAME="Kubectl"

echo -e "\e[34m»»» 📦 \e[32mInstalling \e[33m$NAME \e[35m$VERSION\e[0m ..."

curl -sSL "https://dl.k8s.io/release/${VERSION}/bin/linux/amd64/kubectl" -o $INSTALL_DIR/kubectl
chmod +x $INSTALL_DIR/kubectl

echo -e "\n\e[34m»»» 💾 \e[32mInstalled to: \e[33m$(which $CMD)"
echo -e "\e[34m»»» 💡 \e[32mVersion details: \e[39m$($CMD version --client)"
