#!/bin/bash 
set -e

get_latest_release() {
  curl --silent "https://api.github.com/repos/$1/releases/latest" |
  grep '"tag_name":' | sed -E 's/.*"v([^"]+)".*/\1/'
}

GITHUB="golangci/golangci-lint"
VERSION=${1:-"$(get_latest_release $GITHUB)"}
INSTALL_DIR=${2:-"$HOME/.local/bin"}
CMD="golangci-lint"
NAME="Golang CI Lint"

echo -e "\e[34m»»» 📦 \e[32mInstalling \e[33m$NAME v$VERSION\e[0m ..."

mkdir -p "$INSTALL_DIR"
curl -sSL https://github.com/$GITHUB/releases/download/v"${VERSION}"/golangci-lint-"${VERSION}"-linux-amd64.tar.gz | \
     tar -zx -C "$INSTALL_DIR" --strip-components 1 golangci-lint-"${VERSION}"-linux-amd64/$CMD

echo -e "\n\e[34m»»» 💾 \e[32mInstalled to: \e[33m$(which $CMD)"
echo -e "\e[34m»»» 💡 \e[32mVersion details: \e[39m$($CMD --version)"