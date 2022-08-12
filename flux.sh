#!/bin/bash 
set -e
source <(curl -sSL s.benco.io/lib) # Load libary from remote URL, it's safe!

GITHUB="fluxcd/flux2"
VERSION=${1:-"$(get_latest_release $GITHUB)"}
INSTALL_DIR=${2:-"$HOME/.local/bin"}
CMD=flux
NAME="FluxCD v2"

pre_run

curl -sSL https://github.com/$GITHUB/releases/download/v"${VERSION}"/flux_"${VERSION}"_linux_amd64.tar.gz | \
     tar -zx -C "$INSTALL_DIR" $CMD

post_run