#!/bin/bash
set -e
source <(curl -sSL https://raw.githubusercontent.com/benc-uk/tools-install/master/_lib.sh) # Load libary from remote URL, it's safe!

GITHUB="loophole/cli"
VERSION=${1:-"$(get_latest_release $GITHUB "")"}
INSTALL_DIR=${2:-"$HOME/.local/bin"}
CMD=loophole
NAME="Loophole"

pre_run

curl -sSL "https://github.com/${GITHUB}/releases/download/$VERSION/loophole-cli_${VERSION}_linux_64bit.tar.gz" | \
  tar -zx --strip-components 1 -C "$INSTALL_DIR" "loophole-cli_${VERSION}_linux_64bit/loophole"

post_run