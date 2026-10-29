#!/bin/bash
set -euo pipefail
# shellcheck source=_lib.sh
source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/_lib.sh"

NAME="Nektos Act"
CMD=act
GITHUB="nektos/act"
init_binary "latest" "$@"
PLATFORM=$(asset_arch x86_64 arm64)
VERSION=$(github_version "$GITHUB" "$VERSION")
require_commands tar

pre_run
download "https://github.com/$GITHUB/releases/download/v$VERSION/act_Linux_$PLATFORM.tar.gz" "$WORK_DIR/release.tar.gz"
unpack "$WORK_DIR/release.tar.gz"
install_binary "$WORK_DIR/$CMD"
post_run
