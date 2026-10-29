#!/bin/bash
set -euo pipefail
# shellcheck source=_lib.sh
source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/_lib.sh"

NAME="Kubectl"
CMD=kubectl
init_binary "latest" "$@"
if [[ $VERSION == latest ]]; then VERSION=$(fetch "https://dl.k8s.io/release/stable.txt"); fi
VERSION=${VERSION#v}
[[ $VERSION =~ ^[0-9]+\.[0-9]+\.[0-9]+([.-][[:alnum:].]+)?$ ]] || die "Invalid Kubernetes version: $VERSION"

pre_run
download "https://dl.k8s.io/release/v$VERSION/bin/linux/$ARCH/kubectl" "$WORK_DIR/$CMD"
install_binary "$WORK_DIR/$CMD"
post_run version --client
