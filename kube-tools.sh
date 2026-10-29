#!/bin/bash
set -euo pipefail
# shellcheck source=_lib.sh
source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/_lib.sh"

NAME="kubectx & kubens"
CMD=kubectx
GITHUB="ahmetb/kubectx"
init_binary "latest" "$@"
PLATFORM=$(asset_arch x86_64 arm64)
VERSION=$(github_version "$GITHUB" "$VERSION")
require_commands tar

pre_run
for tool in kubectx kubens; do
  download "https://github.com/$GITHUB/releases/download/v$VERSION/${tool}_v${VERSION}_linux_$PLATFORM.tar.gz" "$WORK_DIR/$tool.tar.gz"
  unpack "$WORK_DIR/$tool.tar.gz"
  [[ -f $WORK_DIR/$tool ]] || die "Missing binary: $tool"
done
for tool in kubectx kubens; do
  install_binary "$WORK_DIR/$tool" "$tool"
  CMD=$tool post_run
done
