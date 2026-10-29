#!/bin/bash
set -euo pipefail
# shellcheck source=_lib.sh
source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/_lib.sh"

NAME="Podman Container Engine"
CMD=podman
INSTALL_NOTES="Installs Podman, the docker shim, podman-compose and uidmap. Warns about existing docker commands and refuses automatic package removal."
init_system "" "$@"
require_commands apt-get dpkg

if DOCKER_CMD=$(command -v docker); then
  printf 'WARNING: An existing docker command was found at %s (possibly an existing Podman shim).\n' "$DOCKER_CMD" >&2
  printf 'The Podman shim provides /usr/bin/docker and may conflict with Docker packages or be shadowed on PATH.\n' >&2
fi
log "Apt will refuse to remove packages. Resolve any Docker package conflicts manually before retrying."

pre_run
apt_install --no-remove podman podman-docker podman-compose uidmap
INSTALLED_CMD=/usr/bin/podman
post_run
CMD=docker INSTALLED_CMD=/usr/bin/docker post_run
CMD=podman-compose INSTALLED_CMD=/usr/bin/podman-compose post_run
log "Use podman-compose for Compose projects. Newer Podman releases also support podman compose and docker compose."
log "Rootless use requires subordinate UID/GID ranges in /etc/subuid and /etc/subgid."
log "No user mappings, shell aliases or services have been configured by this script."
