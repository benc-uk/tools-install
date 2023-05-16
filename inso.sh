#!/bin/bash 
set -e
source <(curl -sSL benco.io/lib) # Load libary from remote URL, it's safe!

GITHUB="Kong/insomnia"
VERSION=${1:-"3.15.0"}
INSTALL_DIR=${2:-"$HOME/.local/bin"}
CMD=inso
NAME="Insomnia CLI"

pre_run

echo "$VERSION"

curl -sSL "https://github.com/$GITHUB/releases/download/lib%40${VERSION}/inso-linux-${VERSION}.tar.xz" | \
    tar -xJ -C "$INSTALL_DIR" $CMD

post_run