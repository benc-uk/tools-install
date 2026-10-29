#!/bin/bash
set -euo pipefail
# shellcheck source=_lib.sh
source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/_lib.sh"

NAME="ngrok"
CMD=ngrok
VERSION_USAGE="legacy major channel 2 only (not an exact version)"
INSTALL_NOTES="Preserves the v2 distribution channel; upgrading the catalogue to v3 is deferred."
init_binary "2" "$@"
[[ $VERSION == 2 ]] || die "This installer supports only the legacy channel 2"
require_commands unzip

pre_run
download "https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-$ARCH.zip" "$WORK_DIR/release.zip"
unpack "$WORK_DIR/release.zip"
install_binary "$WORK_DIR/$CMD"
post_run version
