#!/bin/bash
set -euo pipefail
# shellcheck source=_lib.sh
source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/_lib.sh"

NAME="age File Encryption"
CMD=age
GITHUB="FiloSottile/age"
INSTALL_NOTES="Installs age and age-keygen only; does not generate keys or configure SOPS."
init_binary "latest" "$@"
VERSION=$(github_version "$GITHUB" "$VERSION")
require_commands tar

pre_run
download "https://github.com/$GITHUB/releases/download/v$VERSION/age-v$VERSION-linux-$ARCH.tar.gz" "$WORK_DIR/release.tar.gz"
unpack "$WORK_DIR/release.tar.gz"
for tool in age age-keygen; do
  [[ -f $WORK_DIR/age/$tool && ! -L $WORK_DIR/age/$tool ]] || die "Expected binary missing or not a regular file: $tool"
done
for tool in age age-keygen; do
  install_binary "$WORK_DIR/age/$tool" "$tool"
  CMD=$tool post_run
done
