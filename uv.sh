#!/bin/bash
set -euo pipefail
# shellcheck source=_lib.sh
source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/_lib.sh"

NAME="uv Python Package Manager"
CMD=uv
GITHUB="astral-sh/uv"
INSTALL_NOTES="Installs uv and uvx; does not install Python or modify shell profiles."
init_binary "latest" "$@"
PLATFORM=$(asset_arch x86_64 aarch64)
VERSION=$(github_version "$GITHUB" "$VERSION" "")
require_commands tar

pre_run
download "https://github.com/$GITHUB/releases/download/$VERSION/uv-$PLATFORM-unknown-linux-gnu.tar.gz" "$WORK_DIR/release.tar.gz"
unpack "$WORK_DIR/release.tar.gz"
for tool in uv uvx; do
  [[ -f $WORK_DIR/uv-$PLATFORM-unknown-linux-gnu/$tool && ! -L $WORK_DIR/uv-$PLATFORM-unknown-linux-gnu/$tool ]] ||
    die "Expected binary missing or not a regular file: $tool"
done
for tool in uv uvx; do
  install_binary "$WORK_DIR/uv-$PLATFORM-unknown-linux-gnu/$tool" "$tool"
  CMD=$tool post_run
done
