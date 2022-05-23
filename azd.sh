#!/bin/bash 
set -e

VERSION=${1:-"0.0.1"}
INSTALL_DIR=${2:-"$HOME/.local/bin"}
CMD=azd
NAME="Azure Dev CLI"

echo -e "\e[34m»»» 📦 \e[32mInstalling \e[33m$NAME v$VERSION\e[0m ..."

curl -SsL https://azuresdkreleasepreview.blob.core.windows.net/azd/standalone/latest/azd-linux-amd64.tar.gz | tar -xz -C "$INSTALL_DIR" azd-linux-amd64
mv "$INSTALL_DIR"/azd-linux-amd64 "$INSTALL_DIR"/azd

echo -e "\n\e[34m»»» 💾 \e[32mInstalled to: \e[33m$(which $CMD)"
echo -e "\e[34m»»» 💡 \e[32mVersion details: \e[39m$($CMD version)"