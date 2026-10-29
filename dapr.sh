#!/bin/bash
set -euo pipefail
# shellcheck source=_lib.sh
source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/_lib.sh"

NAME="Dapr CLI"
CMD=dapr
GITHUB="dapr/cli"
init_binary "latest" "$@"
VERSION=$(github_version "$GITHUB" "$VERSION")
require_commands tar

pre_run
download "https://github.com/$GITHUB/releases/download/v$VERSION/dapr_linux_$ARCH.tar.gz" "$WORK_DIR/release.tar.gz"
unpack "$WORK_DIR/release.tar.gz"
install_binary "$WORK_DIR/$CMD"
post_run
