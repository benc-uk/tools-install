#!/bin/bash 
set -e

VERSION=${1:-"0.3.19"}
INSTALL_DIR=${2:-"$HOME/.local/bin"}
CMD=clusterctl
NAME="K8S Cluster API"

echo -e "\e[34m»»» 📦 \e[32mInstalling \e[33m$NAME v$VERSION\e[0m ..."

curl -SsL https://github.com/kubernetes-sigs/cluster-api/releases/download/v${VERSION}/clusterctl-linux-amd64 -o /tmp/clusterctl
chmod +x /tmp/clusterctl
sudo mv /tmp/clusterctl $INSTALL_DIR/clusterctl

echo -e "\n\e[34m»»» 💾 \e[32mInstalled to: \e[33m$(which $CMD)"
echo -e "\e[34m»»» 💡 \e[32mVersion details: \e[39m$($CMD version)"