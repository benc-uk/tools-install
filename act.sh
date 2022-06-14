#!/bin/bash 
set -e
source <(curl -sSL s.benc.dev/lib) # Load libary from remote URL, it's safe!

GITHUB="nektos/act"
VERSION=${1:-"$(get_latest_release $GITHUB)"}
INSTALL_DIR=${2:-"$HOME/.local/bin"}
CMD=act
NAME="Nektos Act"

pre_run

curl -sSL https://github.com/$GITHUB/releases/download/v"${VERSION}"/act_Linux_x86_64.tar.gz | \
     tar -zx -C "$INSTALL_DIR" $CMD

post_run