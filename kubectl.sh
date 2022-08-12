#!/bin/bash
set -e
source <(curl -sSL s.benco.io/lib) # Load libary from remote URL, it's safe!

VERSION=${1:-"$(curl -L -s https://dl.k8s.io/release/stable.txt)"}
VERSION=${VERSION:1} # Remove the leading 'v'
INSTALL_DIR=${2:-"$HOME/.local/bin"}
CMD=kubectl
NAME="Kubectl"

pre_run

curl -sSL "https://dl.k8s.io/release/v${VERSION}/bin/linux/amd64/kubectl" -o "$INSTALL_DIR"/kubectl
chmod +x "$INSTALL_DIR"/kubectl

post_run version
