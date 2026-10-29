#!/bin/bash
set -euo pipefail
# shellcheck source=_lib.sh
source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/_lib.sh"

NAME="Azure Functions Core Tools"
CMD=func
VERSION_USAGE="major package channel, for example 4"
INSTALL_NOTES="Registers Microsoft's distro-specific package feed and installs Core Tools using apt."
init_system "4" "$@"
[[ $VERSION =~ ^[0-9]+$ ]] || die "Expected a Core Tools major release number"
require_commands apt-get dpkg curl

pre_run
microsoft_repo
apt_install "azure-functions-core-tools-$VERSION"
INSTALLED_CMD=/usr/bin/func
post_run
