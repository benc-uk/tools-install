#!/bin/bash 
set -e
source <(curl -sSL s.benco.io/lib) # Load libary from remote URL, it's safe!

GITHUB="nats-io/nats-server"
VERSION=${1:-"$(get_latest_release $GITHUB)"}
INSTALL_DIR=${2:-"$HOME/.local/bin"}
CMD=nats-server
NAME="NATS Server"

pre_run

curl -sSL https://github.com/${GITHUB}/releases/download/v"${VERSION}"/nats-server-v"${VERSION}"-linux-amd64.tar.gz | \
     tar -zx -C "$INSTALL_DIR" --strip-components 1 nats-server-v"${VERSION}"-linux-amd64/$CMD

post_run