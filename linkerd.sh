#!/bin/bash
set -euo pipefail
# shellcheck source=_lib.sh
source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/_lib.sh"

NAME="Linkerd Service Mesh"
CMD=linkerd
GITHUB="linkerd/linkerd2"
VERSION_USAGE="stable release version or latest stable (never edge)"
init_binary "latest" "$@"
if [[ $VERSION == latest ]]; then VERSION=$(github_latest_matching "$GITHUB" "stable-"); fi
VERSION=$(github_version "$GITHUB" "$VERSION" stable-)

pre_run
download "https://github.com/$GITHUB/releases/download/stable-$VERSION/linkerd2-cli-stable-$VERSION-linux-$ARCH" "$WORK_DIR/$CMD"
install_binary "$WORK_DIR/$CMD"
post_run version --client
