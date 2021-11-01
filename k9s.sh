#!/bin/bash
set -e

get_latest_release() {
  curl --silent "https://api.github.com/repos/$1/releases/latest" |
  grep '"tag_name":' | sed -E 's/.*"v([^"]+)".*/\1/'
}

VERSION=${1:-"$(get_latest_release derailed/k9s)"}
INSTALL_DIR=${2:-"$HOME/.local/bin"}
CMD=k9s
NAME="k9s"

echo -e "\e[34m»»» 📦 \e[32mInstalling \e[33m$NAME \e[35mv$VERSION\e[0m ..."

curl -sSL "https://github.com/derailed/k9s/releases/download/v${VERSION}/k9s_Linux_x86_64.tar.gz" -o /tmp/k9s.tar.gz
tar -xf /tmp/k9s.tar.gz -C /tmp k9s 
mkdir -p $INSTALL_DIR
sudo mv /tmp/k9s $INSTALL_DIR
rm -f /tmp/k9s.tar.gz
rm -rf tmp/k9s

echo -e "\n\e[34m»»» 💾 \e[32mInstalled to: \e[33m$(which $CMD)"
echo -e "\e[34m»»» 💡 \e[32mVersion details: \n\e[39m$($CMD version)"
