#!/bin/bash 
set -e
source <(curl -sSL https://raw.githubusercontent.com/benc-uk/tools-install/master/_lib.sh) # Load libary from remote URL, it's safe!

GITHUB="microsoft/edit"
VERSION=${1:-"$(get_latest_release $GITHUB)"}
INSTALL_DIR=${2:-"$HOME/.local/bin"}
CMD="edit"
NAME="Edit"

pre_run

curl -sSL https://github.com/$GITHUB/releases/download/v"${VERSION}"/edit-"${VERSION}"-x86_64-linux-gnu.tar.zst -o temp.tar.zst 
tar --zstd -xf temp.tar.zst
rm temp.tar.zst
mv $CMD "$INSTALL_DIR/$CMD"

post_run