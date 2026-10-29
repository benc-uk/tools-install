#!/bin/bash
set -euo pipefail
# shellcheck source=_lib.sh
source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/_lib.sh"

NAME="Azure Bicep"
CMD=bicep
GITHUB="Azure/bicep"
INSTALL_NOTES="Requires the distribution's libicu runtime package; it is not installed automatically."
init_binary "latest" "$@"
VERSION=$(github_version "$GITHUB" "$VERSION")
PLATFORM=$(asset_arch x64 arm64)

pre_run
download "https://github.com/$GITHUB/releases/download/v$VERSION/bicep-linux-$PLATFORM" "$WORK_DIR/$CMD"
install_binary "$WORK_DIR/$CMD"
post_run
