#!/bin/bash 
set -e
source <(curl -sSL s.benc.dev/lib) # Load libary from remote URL, it's safe!

GITHUB="cli/cli"
VERSION=${1:-"$(get_latest_release $GITHUB)"}
INSTALL_DIR=${2:-"$HOME/.local/bin"}
CMD=gh
NAME="GitHub CLI"

pre_run

curl -sSL https://github.com/${GITHUB}/releases/download/v"${VERSION}"/gh_"${VERSION}"_linux_amd64.tar.gz | \
  tar -zx -C "$INSTALL_DIR" --strip-components 2 gh_"${VERSION}"_linux_amd64/bin/$CMD

post_run
