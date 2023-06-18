#!/bin/bash 
set -e
source <(curl -sSL benco.io/lib) # Load libary from remote URL, it's safe!

GITHUB="cosmtrek/air"
VERSION=${1:-"$(get_latest_release $GITHUB)"}
INSTALL_DIR=${2:-"$HOME/.local/bin"}
CMD=air
NAME="Air - Hot reloader for Go"

pre_run

curl -sSL https://github.com/$GITHUB/releases/download/v"${VERSION}"/air_"${VERSION}"_linux_amd64 -o "$INSTALL_DIR"/$CMD
chmod +x "$INSTALL_DIR"/$CMD

post_run -v