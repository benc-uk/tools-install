#!/bin/bash 
set -e
source <(curl -sSL https://t.ly/toollib) # Load libary from remote URL, it's safe!

VERSION=${1:-"0.0.1"}
INSTALL_DIR=${2:-"$HOME/.local/bin"}
CMD=azd
NAME="Azure Dev CLI"

pre_run

curl -SsL https://azuresdkreleasepreview.blob.core.windows.net/azd/standalone/latest/azd-linux-amd64.tar.gz | tar -xz -C "$INSTALL_DIR" azd-linux-amd64
mv "$INSTALL_DIR"/azd-linux-amd64 "$INSTALL_DIR"/azd

post_run version