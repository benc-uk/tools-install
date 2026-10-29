#!/bin/bash
set -euo pipefail
# shellcheck source=_lib.sh
source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/_lib.sh"

NAME="NATS Server"
CMD=nats-server
GITHUB="nats-io/nats-server"
init_binary "latest" "$@"
VERSION=$(github_version "$GITHUB" "$VERSION")
require_commands tar

pre_run
download "https://github.com/$GITHUB/releases/download/v$VERSION/nats-server-v$VERSION-linux-$ARCH.tar.gz" "$WORK_DIR/release.tar.gz"
unpack "$WORK_DIR/release.tar.gz"
install_binary "$WORK_DIR/nats-server-v$VERSION-linux-$ARCH/$CMD"
post_run
