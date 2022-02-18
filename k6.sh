#!/bin/bash
set -e

get_latest_release() {
  curl --silent "https://api.github.com/repos/$1/releases/latest" |
  grep '"tag_name":' | sed -E 's/.*"v([^"]+)".*/\1/'
}

GITHUB="grafana/k6"
VERSION=${1:-"$(get_latest_release $GITHUB)"}
INSTALL_DIR=${2:-"$HOME/.local/bin"}
CMD=k6
NAME="k6 Load Testing"

echo -e "\e[34m»»» 📦 \e[32mInstalling \e[33m$NAME \e[35mv$VERSION\e[0m ..."

mkdir -p "$INSTALL_DIR"
curl -sSL https://github.com/$GITHUB/releases/download/v"${VERSION}"/k6-v"${VERSION}"-linux-amd64.tar.gz | \
  tar -zx --strip-components 1 -C "$INSTALL_DIR" k6-v"${VERSION}"-linux-amd64/k6 

echo -e "\n\e[34m»»» 💾 \e[32mInstalled to: \e[33m$(which $CMD)"
echo -e "\e[34m»»» 💡 \e[32mVersion details: \e[39m$($CMD version)"
