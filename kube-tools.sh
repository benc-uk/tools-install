#!/bin/bash 
set -e

get_latest_release() {
  curl --silent "https://api.github.com/repos/$1/releases/latest" |
  grep '"tag_name":' | sed -E 's/.*"v([^"]+)".*/\1/'
}

GITHUB="ahmetb/kubectx"
VERSION=${1:-"$(get_latest_release $GITHUB)"}
INSTALL_DIR=${2:-"$HOME/.local/bin"}
CMD=kubectx
NAME="kubectx & kubens"

echo -e "\e[34m»»» 📦 \e[32mInstalling \e[33m$NAME \e[35mv$VERSION\e[0m ..."

mkdir -p "$INSTALL_DIR"
curl -sSL https://github.com/${GITHUB}/releases/download/v"${VERSION}"/kubectx_v"${VERSION}"_linux_x86_64.tar.gz | \
  tar -zx -C "$INSTALL_DIR" kubectx
curl -sSL https://github.com/${GITHUB}/releases/download/v"${VERSION}"/kubens_v"${VERSION}"_linux_x86_64.tar.gz | \
  tar -zx -C "$INSTALL_DIR" kubens

echo -e "\n\e[34m»»» 💾 \e[32mInstalled to: \e[33m$(which $CMD)"
