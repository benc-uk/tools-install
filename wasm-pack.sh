#!/bin/bash
set -euo pipefail
# shellcheck source=_lib.sh
source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/_lib.sh"

NAME="WASM Pack"
CMD=wasm-pack
GITHUB="rustwasm/wasm-pack"
init_binary "latest" "$@"
PLATFORM=$(asset_arch x86_64 aarch64)
VERSION=$(github_version "$GITHUB" "$VERSION")
require_commands tar

pre_run
download "https://github.com/$GITHUB/releases/download/v$VERSION/wasm-pack-v$VERSION-$PLATFORM-unknown-linux-musl.tar.gz" "$WORK_DIR/release.tar.gz"
unpack "$WORK_DIR/release.tar.gz"
install_binary "$WORK_DIR/wasm-pack-v$VERSION-$PLATFORM-unknown-linux-musl/$CMD"
post_run
