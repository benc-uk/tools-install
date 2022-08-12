#!/bin/bash 
set -e
source <(curl -sSL benco.io/lib) # Load libary from remote URL, it's safe!

GITHUB="kubernetes-sigs/cluster-api"
VERSION=${1:-"$(get_latest_release $GITHUB)"}
INSTALL_DIR=${2:-"$HOME/.local/bin"}
CMD=clusterctl
NAME="K8S Cluster API"

pre_run 

curl -SsL https://github.com/$GITHUB/releases/download/v"${VERSION}"/clusterctl-linux-amd64 -o "$INSTALL_DIR"/clusterctl
chmod +x "$INSTALL_DIR"/clusterctl

post_run version