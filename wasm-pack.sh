#!/bin/bash 
set -e

get_latest_release() {
  curl --silent "https://api.github.com/repos/$1/releases/latest" |
  grep '"tag_name":' | sed -E 's/.*"v([^"]+)".*/\1/'
}

GITHUB="rustwasm/wasm-pack"
VERSION=${1:-"$(get_latest_release $GITHUB)"}
INSTALL_DIR=${2:-"$HOME/.local/bin"}
CMD=wasm-pack
NAME="WASM Pack"

echo -e "\e[34m»»» 📦 \e[32mInstalling \e[33m$NAME v$VERSION\e[0m ..."

curl -fsSL "https://github.com/rustwasm/wasm-pack/releases/download/v$VERSION/wasm-pack-v${VERSION}-x86_64-unknown-linux-musl.tar.gz" | \
  tar -zx -C "$INSTALL_DIR" --strip-components 1 wasm-pack-v"${VERSION}"-x86_64-unknown-linux-musl/$CMD
# mkdir -p "$INSTALL_DIR"
# sudo mv /tmp/$CMD "$INSTALL_DIR"
# rm -f /tmp/$CMD.tar.gz
# rm -rf /tmp/$CMD

echo -e "\n\e[34m»»» 💾 \e[32mInstalled to: \e[33m$(which $CMD)"
echo -e "\e[34m»»» 💡 \e[32mVersion details: \e[39m$($CMD --version)"