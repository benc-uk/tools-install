#!/bin/bash
set -euo pipefail
# shellcheck source=_lib.sh
source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/_lib.sh"

NAME="Edit"
CMD=edit
GITHUB="microsoft/edit"
init_binary "latest" "$@"
PLATFORM=$(asset_arch x86_64 aarch64)
VERSION=$(github_version "$GITHUB" "$VERSION")
URL=$(github_asset "$GITHUB" "v$VERSION" "edit-$VERSION-$PLATFORM-linux-gnu.tar.gz" "edit-$VERSION-$PLATFORM-linux-gnu.tar.zst")
require_commands tar
if [[ $URL == *.zst ]]; then require_commands zstd; fi

pre_run
download "$URL" "$WORK_DIR/${URL##*/}"
unpack "$WORK_DIR/${URL##*/}"
install_binary "$WORK_DIR/$CMD"
post_run
