#!/bin/bash 
set -e
source <(curl -sSL https://raw.githubusercontent.com/benc-uk/tools-install/master/_lib.sh) # Load libary from remote URL, it's safe!

GITHUB="casey/just"
VERSION=${1:-"$(get_latest_release $GITHUB '')"}
INSTALL_DIR=${2:-"$HOME/.local/bin"}
CMD=just
NAME="Just Command Runner"

pre_run

curl -sSL https://github.com/$GITHUB/releases/download/"${VERSION}"/just-"${VERSION}"-x86_64-unknown-linux-musl.tar.gz | \
     tar -zx -C "$INSTALL_DIR" $CMD

post_run