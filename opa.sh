#!/bin/bash 
set -e
source <(curl -sSL benco.io/lib) # Load libary from remote URL, it's safe!

GITHUB="open-policy-agent/opa"
VERSION=${1:-"$(get_latest_release $GITHUB)"}
INSTALL_DIR=${2:-"$HOME/.local/bin"}
CMD=opa
NAME="Open Policy Agent"

pre_run

curl -sSL https://github.com/$GITHUB/releases/download/v"${VERSION}"/opa_linux_amd64 -o "$INSTALL_DIR"/$CMD

post_run version
