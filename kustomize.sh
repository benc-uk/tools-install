#!/bin/bash
set -e

get_latest_release() {
  curl --silent "https://api.github.com/repos/$1/releases/latest" |
  grep '"tag_name":' | sed -E 's/.*"kustomize\/v([^"]+)".*/\1/' 
}

GITHUB="kubernetes-sigs/kustomize"
VERSION=${1:-"$(get_latest_release $GITHUB)"}
INSTALL_DIR=${2:-"$HOME/.local/bin"}
CMD=kustomize
NAME="kustomize"

echo -e "\e[34m»»» 📦 \e[32mInstalling \e[33m$NAME \e[35m$VERSION\e[0m ..."

curl -sL "https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv${VERSION}/kustomize_v${VERSION}_linux_amd64.tar.gz" | \
  tar -xz -C "$INSTALL_DIR" kustomize

echo -e "\n\e[34m»»» 💾 \e[32mInstalled to: \e[33m$(which $CMD)"
echo -e "\e[34m»»» 💡 \e[32mVersion details: \e[39m$($CMD version --short)"
