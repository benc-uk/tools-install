#!/bin/bash
set -e
source <(curl -sSL s.benco.io/lib) # Load libary from remote URL, it's safe!

get_latest_release_linkerd() {
  curl --silent "https://api.github.com/repos/$1/releases" |
  grep -Po -m 1 '"tag_name": "stable-([\d.]+)"' | sed -E 's/.*"stable-([^"]+)".*/\1/'
}

GITHUB="linkerd/linkerd2"
VERSION=${1:-"$(get_latest_release_linkerd $GITHUB)"}
INSTALL_DIR=${2:-"$HOME/.local/bin"}
CMD=linkerd
NAME="Linkerd Service Mesh"

pre_run

curl -sSL https://github.com/linkerd/linkerd2/releases/download/stable-"${VERSION}"/linkerd2-cli-stable-"${VERSION}"-linux-amd64 -o "$INSTALL_DIR"/linkerd
chmod +x "$INSTALL_DIR"/linkerd

post_run version --client
