#!/bin/bash
set -e
source <(curl -sSL https://raw.githubusercontent.com/benc-uk/tools-install/master/_lib.sh) # Load libary from remote URL, it's safe!

GITHUB="grafana/k6"
VERSION=${1:-"$(get_latest_release $GITHUB)"}
INSTALL_DIR=${2:-"$HOME/.local/bin"}
CMD=k6
NAME="k6 Load Tester"

pre_run

curl -sSL https://github.com/$GITHUB/releases/download/v"${VERSION}"/k6-v"${VERSION}"-linux-amd64.tar.gz | \
  tar -zx --strip-components 1 -C "$INSTALL_DIR" k6-v"${VERSION}"-linux-amd64/k6 

post_run version