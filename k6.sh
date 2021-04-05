#!/bin/bash
set -e

get_latest_release() {
  curl --silent "https://api.github.com/repos/$1/releases/latest" |
  grep '"tag_name":' | sed -E 's/.*"v([^"]+)".*/\1/'
}

VERSION=${1:-"$(get_latest_release k6io/k6)"}
INSTALL_DIR=${2:-"$HOME/.local/bin"}
CMD=k6
NAME="k6 Load Testing"

echo -e "\e[34m»»» 📦 \e[32mInstalling \e[33m$NAME \e[35mv$VERSION\e[0m ..."

mkdir -p $INSTALL_DIR
curl -sSL https://github.com/k6io/k6/releases/download/v${VERSION}/k6-v${VERSION}-linux64.tar.gz -o /tmp/k6.tar.gz
tar -zxvf /tmp/k6.tar.gz --strip-components 1 -C $INSTALL_DIR k6-v${VERSION}-linux64/k6 > /dev/null
chmod +x $INSTALL_DIR/k6
rm -rf /tmp/k6.tar.gz

echo -e "\n\e[34m»»» 💾 \e[32mInstalled to: \e[33m$(which $CMD)"
echo -e "\e[34m»»» 💡 \e[32mVersion details: \e[39m$($CMD version)"
