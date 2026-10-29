#!/bin/bash
set -euo pipefail
# shellcheck source=_lib.sh
source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/_lib.sh"

NAME="Bun.js"
CMD=bun
GITHUB="oven-sh/bun"
init_binary "latest" "$@"
PLATFORM=$(asset_arch x64 aarch64)
VERSION=$(github_version "$GITHUB" "$VERSION" bun-v)
require_commands unzip

pre_run
download "https://github.com/$GITHUB/releases/download/bun-v$VERSION/bun-linux-$PLATFORM.zip" "$WORK_DIR/release.zip"
unpack "$WORK_DIR/release.zip"
install_binary "$WORK_DIR/bun-linux-$PLATFORM/$CMD"
post_run
