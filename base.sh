#!/bin/bash
set -euo pipefail
# shellcheck source=_lib.sh
source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/_lib.sh"

NAME="Various Linux Utilities"
INSTALL_NOTES="Installs the curated utility list system-wide using apt."
init_system "" "$@"
require_commands apt-get dpkg-query

pre_run
PACKAGES=(
  jq curl make git wget unzip fzf apt-transport-https lsb-release gnupg shellcheck ncdu hey figlet
  ca-certificates xz-utils zstd zip ripgrep fd-find
)
apt_install "${PACKAGES[@]}"
dpkg-query -W -f='${Package} ${Version} ${Status}\n' "${PACKAGES[@]}"
success "Installed $NAME"
