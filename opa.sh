#!/bin/bash
set -euo pipefail
# shellcheck source=_lib.sh
source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/_lib.sh"

NAME="Open Policy Agent"
CMD=opa
GITHUB="open-policy-agent/opa"
init_binary "latest" "$@"
VERSION=$(github_version "$GITHUB" "$VERSION")

pre_run
download "https://github.com/$GITHUB/releases/download/v$VERSION/opa_linux_$ARCH" "$WORK_DIR/$CMD"
install_binary "$WORK_DIR/$CMD"
post_run version
