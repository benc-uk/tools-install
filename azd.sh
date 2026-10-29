#!/bin/bash
set -euo pipefail
# shellcheck source=_lib.sh
source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/_lib.sh"

NAME="Azure Dev CLI"
CMD=azd
VERSION_USAGE="stable, latest, daily, or an exact release version"
INSTALL_NOTES="Keeps the executable in ~/.local/share/azd and links it into install-dir."
init_binary "stable" "$@"
VERSION=${VERSION#v}
case $VERSION in
  stable | latest | daily) ;;
  *) [[ $VERSION =~ ^[0-9]+\.[0-9]+\.[0-9]+([.-][[:alnum:].]+)?$ ]] || die "Invalid azd release or channel" ;;
esac
require_commands tar

pre_run
download "https://azuresdkartifacts.z5.web.core.windows.net/azd/standalone/release/$VERSION/azd-linux-$ARCH.tar.gz" "$WORK_DIR/release.tar.gz"
unpack "$WORK_DIR/release.tar.gz"
install_binary "$WORK_DIR/azd-linux-$ARCH" "azd-linux-$ARCH" "$HOME/.local/share/azd"
install_link "$HOME/.local/share/azd/azd-linux-$ARCH" "$INSTALL_DIR/azd"
post_run version