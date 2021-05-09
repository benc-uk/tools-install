#!/bin/bash
set -e

get_latest_release() {
  curl --silent "https://api.github.com/repos/$1/releases/latest" |
  grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/'
}

VERSION=${1:-"$(get_latest_release loophole/cli)"}
INSTALL_DIR=${2:-"$HOME/.local/bin"}
CMD=loophole
NAME="Loophole"

echo -e "\e[34m»»» 📦 \e[32mInstalling \e[33m$NAME \e[35mv$VERSION\e[0m ..."

mkdir -p "$INSTALL_DIR"
curl -sSL "https://github.com/loophole/cli/releases/download/$VERSION/loophole-cli_${VERSION}_linux_64bit.tar.gz" -o /tmp/loophole.tar.gz
tar -zxvf /tmp/loophole.tar.gz --strip-components 1 -C "$INSTALL_DIR" "loophole-cli_${VERSION}_linux_64bit/loophole" > /dev/null
chmod +x "$INSTALL_DIR/loophole"
rm -rf /tmp/loophole.tar.gz

echo -e "\n\e[34m»»» 💾 \e[32mInstalled to: \e[33m$(which $CMD)"
echo -e "\e[34m»»» 💡 \e[32mVersion details: \e[39m$($CMD --version)"