#!/bin/bash
set -euo pipefail
# shellcheck source=_lib.sh
source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/_lib.sh"

NAME="PowerShell"
CMD=pwsh
INSTALL_NOTES="Registers Microsoft's distro-specific apt feed and installs its PowerShell package."
init_system "" "$@"
require_commands apt-get dpkg curl

pre_run
microsoft_repo
apt_install powershell
INSTALLED_CMD=/usr/bin/pwsh
post_run
