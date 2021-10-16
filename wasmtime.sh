#!/bin/bash 
set -e

get_latest_release() {
  curl --silent "https://api.github.com/repos/$1/releases/latest" |
  grep '"tag_name":' | sed -E 's/.*"v([^"]+)".*/\1/'
}

VERSION=${1:-"$(get_latest_release bytecodealliance/wasmtime)"}
INSTALL_DIR=${2:-"$HOME/.local/bin"}
CMD=wasmtime
NAME=wasmtime

echo -e "\e[34m»»» 📦 \e[32mInstalling \e[33m$NAME v$VERSION\e[0m ..."

curl -fsSL "https://github.com/bytecodealliance/wasmtime/releases/download/v$VERSION/wasmtime-v$VERSION-x86_64-linux.tar.xz" -o /tmp/wasmtime.tar.xz
tar -xf /tmp/wasmtime.tar.xz --strip-components 1 -C /tmp wasmtime-v"${VERSION}"-x86_64-linux/wasmtime
mkdir -p "$INSTALL_DIR"
sudo mv /tmp/wasmtime "$INSTALL_DIR"
rm -f /tmp/wasmtime.tar.xz
rm -rf /tmp/wasmtime

echo -e "\n\e[34m»»» 💾 \e[32mInstalled to: \e[33m$(which $CMD)"
echo -e "\e[34m»»» 💡 \e[32mVersion details: \e[39m$($CMD --version)"