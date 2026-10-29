#!/bin/bash
set -euo pipefail
# shellcheck source=_lib.sh
source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/_lib.sh"

NAME="Go Language"
CMD=go
VERSION_USAGE="exact Go release or latest"
INSTALL_NOTES="Replaces the SDK tree in /usr/local/go using root/sudo; never edits shell profiles."
init_system "latest" "$@"
if [[ $VERSION == latest ]]; then
  require_commands jq
  VERSION=$(fetch "https://go.dev/dl/?mode=json" | jq -er '[.[] | select(.stable == true)][0].version | select(. != null)') ||
    die "Cannot resolve the latest stable Go release"
fi
VERSION=${VERSION#go}
[[ $VERSION =~ ^[0-9]+\.[0-9]+(\.[0-9]+)?$ ]] || die "Expected an exact Go release"
require_commands tar
GO_STAGE=""

cleanup_go() {
  local status=$?
  if [[ -n $GO_STAGE ]]; then
    if [[ -e $GO_STAGE/previous && ! -e /usr/local/go ]]; then
      as_root mv -T "$GO_STAGE/previous" /usr/local/go || {
        error "Restore the previous SDK from $GO_STAGE/previous"
        cleanup
        return 1
      }
    fi
    if [[ -e $GO_STAGE/previous ]]; then
      warn "Previous SDK retained at $GO_STAGE/previous"
    else
      as_root rm -rf -- "$GO_STAGE"
    fi
  fi
  cleanup
  return "$status"
}
trap cleanup_go EXIT

pre_run
download "https://go.dev/dl/go$VERSION.linux-$ARCH.tar.gz" "$WORK_DIR/release.tar.gz"
unpack "$WORK_DIR/release.tar.gz"
[[ -x $WORK_DIR/go/bin/go ]] || die "Go SDK executable missing"
"$WORK_DIR/go/bin/go" version
[[ ! -L /usr/local/go ]] || die "Refusing to replace a symlink at /usr/local/go"
as_root mkdir -p /usr/local
GO_STAGE=$(as_root mktemp -d /usr/local/.go-install.XXXXXX)
# The staging directory must be traversable for rollback checks by this user.
as_root chmod 0755 "$GO_STAGE"
as_root cp -a "$WORK_DIR/go" "$GO_STAGE/new"
if [[ -e /usr/local/go ]]; then as_root mv -T /usr/local/go "$GO_STAGE/previous"; fi
as_root mv -T "$GO_STAGE/new" /usr/local/go
INSTALL_DIR=/usr/local/go/bin
post_run version
as_root rm -rf -- "$GO_STAGE"
GO_STAGE=""
