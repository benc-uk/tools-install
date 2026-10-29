#!/bin/bash
set -euo pipefail
# shellcheck source=_lib.sh
source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/_lib.sh"

NAME="mkcert Cert Utility"
CMD=mkcert
GITHUB="FiloSottile/mkcert"
INSTALL_NOTES="Also installs libnss3-tools with apt. Does not create or trust a local CA."
init_binary "latest" "$@"
VERSION=$(github_version "$GITHUB" "$VERSION")
require_commands apt-get

pre_run
download "https://github.com/$GITHUB/releases/download/v$VERSION/mkcert-v$VERSION-linux-$ARCH" "$WORK_DIR/$CMD"
apt_install libnss3-tools
install_binary "$WORK_DIR/$CMD"
post_run
