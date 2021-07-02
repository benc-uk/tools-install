#!/bin/bash
set -e

get_latest_release() {
  curl --silent "https://api.github.com/repos/$1/releases/latest" |
  grep '"tag_name":' | sed -E 's/.*"v([^"]+)".*/\1/'
}

VERSION=${1:-"$(get_latest_release kubernetes-sigs/kustomize)"}
INSTALL_DIR=${2:-"$HOME/.local/bin"}
CMD=kustomize
NAME="kustomize"

curl -sL "https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv4.1.3/kustomize_v4.1.3_linux_amd64.tar.gz" -o /tmp/kustomize.tar.gz
tar -xf /tmp/kustomize.tar.gz -C /tmp kustomize
mkdir -p $INSTALL_DIR
sudo mv /tmp/kustomize $INSTALL_DIR
rm -f /tmp/kustomize.tar.gz
rm -rf tmp/kustomize

echo -e "\n\e[34m»»» 💾 \e[32mInstalled to: \e[33m$(which $CMD)"
echo -e "\e[34m»»» 💡 \e[32mVersion details: \e[39m$($CMD version)"
