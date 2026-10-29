#!/bin/bash
set -euo pipefail
# shellcheck source=_lib.sh
source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/_lib.sh"

NAME="Deno JavaScript Runtime"
CMD=deno
GITHUB="denoland/deno"
DEFAULT_INSTALL_DIR="$HOME/.deno/bin"
INSTALL_NOTES="Preserves the existing ~/.deno/bin layout; no shell profile edits."
init_binary "latest" "$@"
PLATFORM=$(asset_arch x86_64 aarch64)
VERSION=$(github_version "$GITHUB" "$VERSION")
require_commands unzip

pre_run
download "https://github.com/$GITHUB/releases/download/v$VERSION/deno-$PLATFORM-unknown-linux-gnu.zip" "$WORK_DIR/release.zip"
unpack "$WORK_DIR/release.zip"
install_binary "$WORK_DIR/$CMD"
post_run
