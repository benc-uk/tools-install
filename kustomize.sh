#!/bin/bash
set -e
source <(curl -sSL https://raw.githubusercontent.com/benc-uk/tools-install/master/_lib.sh) # Load libary from remote URL, it's safe!

get_latest_release_kustomize() {
  curl -sSL https://api.github.com/repos/kubernetes-sigs/kustomize/releases | grep browser_download.*"linux"_"amd64" | cut -d '"' -f 4 | sort -V | tail -n 1 | cut -d/ -f 9 | cut -b 2-99
}

GITHUB="kubernetes-sigs/kustomize"
VERSION=${1:-"$(get_latest_release_kustomize $GITHUB)"}
INSTALL_DIR=${2:-"$HOME/.local/bin"}
CMD=kustomize
NAME="kustomize"

pre_run

curl -sL "https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv${VERSION}/kustomize_v${VERSION}_linux_amd64.tar.gz" | \
  tar -xz -C "$INSTALL_DIR" kustomize

post_run version
