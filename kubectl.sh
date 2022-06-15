#!/bin/bash
set -e
source <(curl -sSL benco.io/lib) # Load libary from remote URL, it's safe!

VERSION=${1:-"$(curl -L -s https://dl.k8s.io/release/stable.txt)"}
INSTALL_DIR=${2:-"$HOME/.local/bin"}
CMD=kubectl
NAME="Kubectl"

pre_run

curl -sSL "https://dl.k8s.io/release/${VERSION}/bin/linux/amd64/kubectl" -o "$INSTALL_DIR"/kubectl
chmod +x "$INSTALL_DIR"/kubectl

post_run version
