#!/bin/bash
set -euo pipefail
# shellcheck source=_lib.sh
source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/_lib.sh"

NAME="Edit"
CMD=edit
GITHUB="microsoft/edit"
init_binary "latest" "$@"
PLATFORM=$(asset_arch x86_64 aarch64)
if [[ $VERSION == latest ]]; then
  RELEASE_URL=$(fetch "https://github.com/$GITHUB/releases/latest" --head --output /dev/null --write-out '%{url_effective}')
  [[ $RELEASE_URL == "https://github.com/$GITHUB/releases/tag/v"* ]] ||
    die "Cannot resolve latest release of $GITHUB"
  VERSION=${RELEASE_URL##*/}
fi
VERSION=$(github_version "$GITHUB" "$VERSION")
FORMAT=tar.gz
if [[ $VERSION == 1.* ]]; then FORMAT=tar.zst; fi
URL="https://github.com/$GITHUB/releases/download/v$VERSION/edit-$VERSION-$PLATFORM-linux-gnu.$FORMAT"
require_commands tar
if [[ $URL == *.zst ]]; then require_commands zstd; fi

pre_run
download "$URL" "$WORK_DIR/${URL##*/}"
unpack "$WORK_DIR/${URL##*/}"
install_binary "$WORK_DIR/$CMD"
post_run
