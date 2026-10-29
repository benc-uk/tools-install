#!/bin/bash
set -euo pipefail
# shellcheck source=_lib.sh
source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/_lib.sh"

NAME="Azure CLI"
CMD=az
INSTALL_NOTES="Configures Microsoft's Azure CLI apt repository and installs the available package."
init_system "" "$@"
[[ -n $DISTRO_CODENAME ]] || die "Cannot determine distribution codename"
require_commands apt-get gpg curl

pre_run
add_apt_repo azure-cli "https://packages.microsoft.com/keys/microsoft.asc" \
  "https://packages.microsoft.com/repos/azure-cli/" "$DISTRO_CODENAME"
apt_install azure-cli
INSTALLED_CMD=/usr/bin/az
post_run version
