#!/bin/bash
set -euo pipefail
# shellcheck source=_lib.sh
source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/_lib.sh"

NAME="Docker Engine & CLI"
CMD=docker
INSTALL_NOTES="Installs Docker's apt packages. Group membership is a manual, root-equivalent opt-in."
init_system "" "$@"
[[ -n $DISTRO_CODENAME ]] || die "Cannot determine distribution codename"
require_commands apt-get gpg curl

pre_run
add_apt_repo docker "https://download.docker.com/linux/$DISTRO/gpg" \
  "https://download.docker.com/linux/$DISTRO" "$DISTRO_CODENAME" stable
apt_install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
INSTALLED_CMD=/usr/bin/docker
post_run
log "Optional: sudo usermod -aG docker \"\$USER\", then start a new login session."
warn "The docker group grants root-equivalent access. It has not been changed."
log "On WSL, use systemd where enabled, or start Docker with sudo service docker start."
