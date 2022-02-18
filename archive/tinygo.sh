#!/bin/bash 
set -e

get_latest_release() {
  curl --silent "https://api.github.com/repos/$1/releases/latest" |
  grep '"tag_name":' | sed -E 's/.*"v([^"]+)".*/\1/'
}

VERSION=${1:-"$(get_latest_release tinygo-org/tinygo)"}
CMD=tinygo
NAME=TinyGo

echo -e "\e[34m»»» 📦 \e[32mInstalling \e[33m$NAME v$VERSION\e[0m ..."

curl -fsSL "https://github.com/tinygo-org/tinygo/releases/download/v$VERSION/tinygo_${VERSION}_amd64.deb" -o /tmp/$CMD.deb
sudo dpkg -i /tmp/$CMD.deb
rm -rf /tmp/$CMD.deb

echo -e "\n\e[34m»»» 💾 \e[32mInstalled to: \e[33m$(which $CMD)"
echo -e "\e[34m»»» 💡 \e[32mVersion details: \e[39m$($CMD version)"