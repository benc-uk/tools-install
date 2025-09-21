#!/bin/bash 
set -e
source <(curl -sSL https://raw.githubusercontent.com/benc-uk/tools-install/master/_lib.sh) # Load libary from remote URL, it's safe!

GITHUB="rustwasm/wasm-pack"
VERSION=${1:-"$(get_latest_release $GITHUB)"}
INSTALL_DIR=${2:-"$HOME/.local/bin"}
CMD=wasm-pack
NAME="WASM Pack"

pre_run

curl -fsSL "https://github.com/rustwasm/wasm-pack/releases/download/v$VERSION/wasm-pack-v${VERSION}-x86_64-unknown-linux-musl.tar.gz" | \
  tar -zx -C "$INSTALL_DIR" --strip-components 1 wasm-pack-v"${VERSION}"-x86_64-unknown-linux-musl/$CMD

post_run
