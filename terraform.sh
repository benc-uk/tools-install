#!/bin/bash
set -euo pipefail
# shellcheck source=_lib.sh
source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/_lib.sh"

NAME="Terraform"
CMD=terraform
GITHUB="hashicorp/terraform"
init_binary "latest" "$@"
VERSION=$(github_version "$GITHUB" "$VERSION")
require_commands unzip

pre_run
download "https://releases.hashicorp.com/terraform/$VERSION/terraform_${VERSION}_linux_$ARCH.zip" "$WORK_DIR/release.zip"
unpack "$WORK_DIR/release.zip"
install_binary "$WORK_DIR/$CMD"
post_run
