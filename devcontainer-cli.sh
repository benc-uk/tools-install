#!/bin/bash 
set -e
source <(curl -sSL benco.io/lib) # Load libary from remote URL, it's safe!

GITHUB="stuartleeks/devcontainer-cli"
VERSION=${1:-"$(get_latest_release $GITHUB)"}
INSTALL_DIR=${2:-"$HOME/.local/bin"}
CMD=devcontainer
NAME="Dev Container CLI"

pre_run

curl -sSL "https://github.com/stuartleeks/devcontainer-cli/releases/download/v${VERSION}/devcontainer-cli_linux_amd64.tar.gz" | \
     tar -zx -C "$INSTALL_DIR" $CMD

post_run version