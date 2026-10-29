#!/bin/bash
set -euo pipefail
# shellcheck source=_lib.sh
source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/_lib.sh"

NAME="Sops"
CMD=sops
GITHUB="getsops/sops"
init_binary "latest" "$@"
VERSION=$(github_version "$GITHUB" "$VERSION")
ASSET="sops-v$VERSION.linux.$ARCH"
if [[ $ARCH == amd64 ]]; then
  URL=$(github_asset "$GITHUB" "v$VERSION" "$ASSET" "sops-v$VERSION.linux")
else
  URL=$(github_asset "$GITHUB" "v$VERSION" "$ASSET")
fi

pre_run
download "$URL" "$WORK_DIR/$CMD"
install_binary "$WORK_DIR/$CMD"
post_run
