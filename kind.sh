#!/bin/bash 
set -e
source <(curl -sSL https://raw.githubusercontent.com/benc-uk/tools-install/master/_lib.sh) # Load libary from remote URL, it's safe!

GITHUB="kubernetes-sigs/kind"
VERSION=${1:-"$(get_latest_release $GITHUB)"}
INSTALL_DIR=${2:-"$HOME/.local/bin"}
CMD=kind
NAME="Kind, run Kubernetes in Docker"

pre_run

curl -sSL https://github.com/$GITHUB/releases/download/v"${VERSION}"/kind-linux-amd64 -o "$INSTALL_DIR"/$CMD
chmod +x "$INSTALL_DIR"/$CMD

post_run