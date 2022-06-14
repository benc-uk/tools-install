#!/bin/bash
set -e
source <(curl -sSL s.benc.dev/lib) # Load libary from remote URL, it's safe!

GITHUB="Azure/bicep"
VERSION=${1:-"$(get_latest_release $GITHUB)"}
INSTALL_DIR=${2:-"$HOME/.local/bin"}
CMD=bicep
NAME="Azure Bicep"

pre_run 

curl -sSL https://github.com/$GITHUB/releases/download/v"$VERSION"/bicep-linux-x64 -o "$INSTALL_DIR"/bicep
chmod +x "$INSTALL_DIR"/bicep

post_run