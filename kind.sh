#!/bin/bash
set -euo pipefail
# shellcheck source=_lib.sh
source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/_lib.sh"

NAME="Kind, run Kubernetes in Docker"
CMD=kind
GITHUB="kubernetes-sigs/kind"
init_binary "latest" "$@"
VERSION=$(github_version "$GITHUB" "$VERSION")

pre_run
download "https://github.com/$GITHUB/releases/download/v$VERSION/kind-linux-$ARCH" "$WORK_DIR/$CMD"
install_binary "$WORK_DIR/$CMD"
post_run
