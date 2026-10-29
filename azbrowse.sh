#!/bin/bash
set -euo pipefail
# shellcheck source=_lib.sh
source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/_lib.sh"

NAME="Azure Browse"
CMD=azbrowse
GITHUB="lawrencegripper/azbrowse"
INSTALL_NOTES="Upstream currently publishes x86_64 Linux builds only."
init_binary "latest" "$@"
PLATFORM=$(asset_arch amd64 "")
VERSION=$(github_version "$GITHUB" "$VERSION")
require_commands tar

pre_run
download "https://github.com/$GITHUB/releases/download/v$VERSION/azbrowse_linux_$PLATFORM.tar.gz" "$WORK_DIR/release.tar.gz"
unpack "$WORK_DIR/release.tar.gz"
install_binary "$WORK_DIR/$CMD"
post_run version
