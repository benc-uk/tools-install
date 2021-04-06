#!/bin/bash 
set -e

get_latest_release() {
  curl --silent "https://api.github.com/repos/$1/releases/latest" |
  grep '"tag_name":' | sed -E 's/.*"v([^"]+)".*/\1/'
}

VERSION=${1:-"$(get_latest_release ahmetb/kubectx)"}
INSTALL_DIR=${2:-"$HOME/.local/bin"}
CMD=kubectx
NAME="kubectx & kubens"

echo -e "\e[34m»»» 📦 \e[32mInstalling \e[33m$NAME \e[35mv$VERSION\e[0m ..."

mkdir -p $INSTALL_DIR
curl -sSL https://github.com/ahmetb/kubectx/releases/download/v${VERSION}/kubectx_v${VERSION}_linux_x86_64.tar.gz -o /tmp/tmp.tar.gz
tar -zxvf /tmp/tmp.tar.gz -C $INSTALL_DIR > /dev/null
chmod +x $INSTALL_DIR/kubectx
rm -rf /tmp/tmp.tar.gz
curl -sSL https://github.com/ahmetb/kubectx/releases/download/v${VERSION}/kubens_v${VERSION}_linux_x86_64.tar.gz -o /tmp/tmp.tar.gz
tar -zxvf /tmp/tmp.tar.gz -C $INSTALL_DIR > /dev/null
chmod +x $INSTALL_DIR/kubens
rm -rf /tmp/tmp.tar.gz

echo -e "\n\e[34m»»» 💾 \e[32mInstalled to: \e[33m$(which $CMD)"
