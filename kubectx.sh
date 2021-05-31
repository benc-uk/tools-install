#!/bin/bash
set -e

get_latest_release() {
  curl --silent "https://api.github.com/repos/$1/releases/latest" |
  grep '"tag_name":' | sed -E 's/.*"v([^"]+)".*/\1/'
}

VERSION=${1:-"$(get_latest_release ahmetb/kubectx)"}
INSTALL_DIR=${2:-"$HOME/.local/bin"}
CMD=kubectx
NAME="kubectx"

curl -Ls "https://github.com/ahmetb/kubectx/releases/download/v${VERSION}/kubectx_v${VERSION}_linux_x86_64.tar.gz" -o /tmp/kubectx.tar.gz
tar -xf /tmp/kubectx.tar.gz -C /tmp kubectx
mkdir -p $INSTALL_DIR
sudo mv /tmp/kubectx $INSTALL_DIR
rm -f /tmp/kubectx.tar.gz
rm -rf tmp/kubectx

echo -e "\n\e[34m»»» 💾 \e[32mInstalled to: \e[33m$(which $CMD)"
echo -e "\e[34m»»» 💡 \e[32mVersion details: \e[39m$($CMD -h)"
