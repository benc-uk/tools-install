#!/bin/bash
set -euo pipefail
# shellcheck source=_lib.sh
source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/_lib.sh"

NAME="Yarn"
CMD=yarn
INSTALL_NOTES="Installs the global Yarn bootstrap using npm as root; project Yarn versions are separate."
init_system "" "$@"
require_commands npm

pre_run
as_root npm install -g yarn
NPM_PREFIX=$(as_root npm prefix -g)
INSTALLED_CMD="$NPM_PREFIX/bin/yarn"
post_run
log "For project-managed Yarn versions, see https://yarnpkg.com/getting-started/install"
