#!/bin/bash
set -euo pipefail
# shellcheck source=_lib.sh
source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/_lib.sh"

NAME="Rust and Cargo"
CMD=rustc
VERSION_USAGE="rustup toolchain: stable, beta, nightly or an exact Rust release"
INSTALL_NOTES="Runs the official rustup-init executable, preserving CARGO_HOME/RUSTUP_HOME; no profile edits."
init_system "stable" "$@"
case $VERSION in
  stable | beta | nightly) ;;
  *) [[ $VERSION =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]] || die "Expected stable, beta, nightly or an exact Rust release" ;;
esac
PLATFORM=$(asset_arch x86_64 aarch64)
INSTALL_DIR="${CARGO_HOME:-$HOME/.cargo}/bin"

pre_run
download "https://static.rust-lang.org/rustup/dist/$PLATFORM-unknown-linux-gnu/rustup-init" "$WORK_DIR/rustup-init"
chmod +x "$WORK_DIR/rustup-init"
log "Delegating toolchain installation to the official rustup bootstrap executable."
"$WORK_DIR/rustup-init" -y --no-modify-path --default-toolchain "$VERSION"
post_run
