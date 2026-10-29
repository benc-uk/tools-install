#!/bin/bash
set -euo pipefail
# shellcheck source=_lib.sh
source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/_lib.sh"

NAME="Azure Copy"
CMD=azcopy
VERSION_USAGE="major channel 10, or an exact 10.x.y release"
init_binary "10" "$@"
VERSION=${VERSION#v}
if [[ $VERSION == 10 ]]; then
  URL="https://aka.ms/downloadazcopy-v10-linux"
  if [[ $ARCH == arm64 ]]; then URL+="-arm64"; fi
elif [[ $VERSION =~ ^10\.[0-9]+\.[0-9]+$ ]]; then
  URL="https://github.com/Azure/azure-storage-azcopy/releases/download/v$VERSION/azcopy_linux_${ARCH}_$VERSION.tar.gz"
else
  die "Expected channel 10 or an exact 10.x.y release"
fi
require_commands tar

pre_run
download "$URL" "$WORK_DIR/release.tar.gz"
unpack "$WORK_DIR/release.tar.gz"
shopt -s nullglob
BINARIES=("$WORK_DIR"/azcopy_linux_"$ARCH"_*/azcopy)
((${#BINARIES[@]} == 1)) || die "Expected exactly one AzCopy binary in the archive"
install_binary "${BINARIES[0]}"
post_run
