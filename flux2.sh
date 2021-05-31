#!/bin/bash
set -e

get_latest_release() {
  curl --silent "https://api.github.com/repos/$1/releases/latest" |
  grep '"tag_name":' | sed -E 's/.*"v([^"]+)".*/\1/'
}

VERSION=${1:-"$(get_latest_release fluxcd/flux2)"}
INSTALL_DIR=${2:-"$HOME/.local/bin"}
CMD=flux
NAME="flux"

curl -Ls "https://github.com/fluxcd/flux2/releases/download/v${VERSION}/flux_${VERSION}_linux_amd64.tar.gz" -o /tmp/flux2.tar.gz
tar -xf /tmp/flux2.tar.gz -C /tmp flux
mkdir -p $INSTALL_DIR
sudo mv /tmp/flux $INSTALL_DIR
rm -f /tmp/flux.tar.gz
rm -rf tmp/flux

echo -e "\n\e[34m»»» 💾 \e[32mInstalled to: \e[33m$(which $CMD)"
echo -e "\e[34m»»» 💡 \e[32mVersion details: \e[39m$($CMD --version)"
