#!/bin/bash 
set -e

source <(curl -sSL benco.io/lib) # Load libary from remote URL, it's safe!

GITHUB="lawrencegripper/azbrowse"
VERSION=${1:-"$(get_latest_release $GITHUB)"}
INSTALL_DIR=${2:-"$HOME/.local/bin"}
CMD=azbrowse
NAME="Azure Browse"

pre_run

curl -sSL "https://github.com/$GITHUB/releases/download/v${VERSION}/azbrowse_linux_amd64.tar.gz" | \
     tar -zx -C "$INSTALL_DIR" $CMD

post_run version