#!/bin/bash
set -euo pipefail
# shellcheck source=_lib.sh
source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/_lib.sh"

NAME="Hugo Static Site Generator"
CMD=hugo
GITHUB="gohugoio/hugo"
init_binary "latest" "$@"
VERSION=$(github_version "$GITHUB" "$VERSION")
if [[ $ARCH == amd64 ]]; then
  ASSET="hugo_extended_${VERSION}_Linux-64bit.tar.gz"
else
  ASSET="hugo_extended_${VERSION}_linux-arm64.tar.gz"
fi
require_commands tar

pre_run
download "https://github.com/$GITHUB/releases/download/v$VERSION/$ASSET" "$WORK_DIR/release.tar.gz"
unpack "$WORK_DIR/release.tar.gz"
install_binary "$WORK_DIR/$CMD"
post_run version
