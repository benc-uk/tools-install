#!/bin/bash
set -euo pipefail
# shellcheck source=_lib.sh
source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/_lib.sh"

NAME="Helm"
CMD=helm
GITHUB="helm/helm"
init_binary "latest" "$@"
VERSION=$(github_version "$GITHUB" "$VERSION")
require_commands tar

pre_run
download "https://get.helm.sh/helm-v$VERSION-linux-$ARCH.tar.gz" "$WORK_DIR/release.tar.gz"
unpack "$WORK_DIR/release.tar.gz"
install_binary "$WORK_DIR/linux-$ARCH/$CMD"
post_run version
