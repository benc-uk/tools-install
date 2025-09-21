#!/bin/bash
set -e
source <(curl -sSL https://raw.githubusercontent.com/benc-uk/tools-install/master/_lib.sh) # Load libary from remote URL, it's safe!

GITHUB="derailed/k9s"
VERSION=${1:-"$(get_latest_release $GITHUB)"}
INSTALL_DIR=${2:-"$HOME/.local/bin"}
CMD=k9s
NAME="k9s terminal UI for Kubernetes"

pre_run

curl -sSL "https://github.com/$GITHUB/releases/download/v${VERSION}/k9s_Linux_amd64.tar.gz" | \
  tar -zx -C "$INSTALL_DIR" $CMD

post_run version