#!/bin/bash
set -euo pipefail
# shellcheck source=_lib.sh
source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/_lib.sh"

NAME="Node.js"
CMD=node
VERSION_USAGE="major release channel, for example 24 (not an exact patch version)"
INSTALL_NOTES="Configures the NodeSource apt repository; installs Node.js and its bundled npm."
init_system "24" "$@"
[[ $VERSION =~ ^[0-9]+$ ]] || die "Expected a Node.js major release number"
require_commands apt-get gpg curl

pre_run
add_apt_repo nodesource "https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key" \
  "deb [arch=$ARCH signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$VERSION.x nodistro main"
printf 'Package: nodejs\nPin: origin deb.nodesource.com\nPin-Priority: 600\n' > "$WORK_DIR/nodejs"
as_root install -m 0644 "$WORK_DIR/nodejs" /etc/apt/preferences.d/nodejs
apt_install --allow-downgrades "nodejs=$VERSION.*"
INSTALLED_CMD=/usr/bin/node
post_run
INSTALLED_CMD=/usr/bin/npm post_run
