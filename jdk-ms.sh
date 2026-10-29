#!/bin/bash
set -euo pipefail
# shellcheck source=_lib.sh
source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/_lib.sh"

NAME="Java JDK (OpenJDK Microsoft)"
CMD=java
VERSION_USAGE="JDK major package channel, for example 11 or 21"
INSTALL_NOTES="Uses Microsoft's apt feed; package scripts may update Java alternatives."
init_system "25" "$@"
[[ $VERSION =~ ^[0-9]+$ ]] || die "Expected a JDK major release number"
require_commands apt-get dpkg-query

pre_run
microsoft_repo
apt_install "msopenjdk-$VERSION"
INSTALLED_CMD=$(dpkg-query -L "msopenjdk-$VERSION" | grep '/bin/java$')
[[ $INSTALLED_CMD == /* && $INSTALLED_CMD != *$'\n'* ]] || die "Cannot identify the installed JDK executable"
post_run -version
