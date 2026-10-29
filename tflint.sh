#!/bin/bash
set -euo pipefail
# shellcheck source=_lib.sh
source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/_lib.sh"

NAME="Tflint Terraform Linter"
CMD=tflint
GITHUB="terraform-linters/tflint"
init_binary "latest" "$@"
VERSION=$(github_version "$GITHUB" "$VERSION")
require_commands unzip

pre_run
download "https://github.com/$GITHUB/releases/download/v$VERSION/tflint_linux_$ARCH.zip" "$WORK_DIR/release.zip"
unpack "$WORK_DIR/release.zip"
install_binary "$WORK_DIR/$CMD"
post_run
