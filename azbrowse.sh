#!/bin/bash 
set -e

get_latest_release() {
  curl --silent "https://api.github.com/repos/$1/releases/latest" |
  grep '"tag_name":' | sed -E 's/.*"v([^"]+)".*/\1/'
}

VERSION=${1:-"$(get_latest_release lawrencegripper/azbrowse)"}
INSTALL_DIR=${2:-"$HOME/.local/bin"}
CMD=azbrowse
NAME="Azbrowse"

echo -e "\e[34m»»» 📦 \e[32mInstalling \e[33m$NAME \e[35mv$VERSION\e[0m ..."

curl -sSL "https://github.com/lawrencegripper/azbrowse/releases/download/v${VERSION}/azbrowse_linux_amd64.tar.gz" -o /tmp/azbrowse.tar.gz
tar -C "$INSTALL_DIR" -zxvf /tmp/azbrowse.tar.gz azbrowse
chmod +x "$INSTALL_DIR/azbrowse"
rm -f /tmp/azbrowse.tar.gz

echo -e "\n\e[34m»»» 💾 \e[32mInstalled to: \e[33m$(which $CMD)"
echo -e "\e[34m»»» 💡 \e[32mVersion details: \e[39m$($CMD version)"