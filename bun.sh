#!/bin/bash 
set -e
source <(curl -sSL https://raw.githubusercontent.com/benc-uk/tools-install/master/_lib.sh) # Load libary from remote URL, it's safe!

GITHUB="oven-sh/bun"
VERSION=${1:-"$(get_latest_release $GITHUB "bun-v")"}
INSTALL_DIR=${2:-"$HOME/.local/bin"}
CMD=bun
NAME="Bun.js"

pre_run

wget -q https://github.com/$GITHUB/releases/download/"bun-v${VERSION}"/bun-linux-x64.zip -O /tmp/bun.zip
unzip -o /tmp/bun.zip -d /tmp > /dev/null
mv /tmp/bun-linux-x64/bun "$INSTALL_DIR"
rm -f /tmp/bun.zip
rm -rf /tmp/bun-linux-x64

post_run