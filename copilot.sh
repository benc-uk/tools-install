#!/bin/bash
set -euo pipefail
# shellcheck source=_lib.sh
source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/_lib.sh"

NAME="GitHub Copilot CLI"
CMD=copilot
GITHUB="github/copilot-cli"
INSTALL_NOTES="Installs the standalone CLI without Node.js or npm. Authentication is a manual step."
init_binary "latest" "$@"
PLATFORM=$(asset_arch x64 arm64)
VERSION=$(github_version "$GITHUB" "$VERSION")
require_commands tar

pre_run
download "https://github.com/$GITHUB/releases/download/v$VERSION/copilot-linux-$PLATFORM.tar.gz" "$WORK_DIR/release.tar.gz"
unpack "$WORK_DIR/release.tar.gz"
install_binary "$WORK_DIR/$CMD"
post_run
log "Run copilot, then enter /login to authenticate with GitHub."
