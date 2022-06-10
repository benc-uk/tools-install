#!/bin/bash
set -e
source <(curl -sSL https://t.ly/toollib) # Load libary from remote URL, it's safe!

GITHUB="mozilla/sops"
VERSION=${1:-"$(get_latest_release $GITHUB)"}
INSTALL_DIR=${2:-"$HOME/.local/bin"}
CMD=sops
NAME="Mozilla Sops"

pre_run

curl -sL "https://github.com/${GITHUB}/releases/download/v${VERSION}/sops-v${VERSION}.linux" -o "$INSTALL_DIR"/sops
chmod +x "$INSTALL_DIR"/sops

post_run