#!/bin/bash
set -euo pipefail
# shellcheck source=_lib.sh
source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/_lib.sh"

NAME="Dotnet SDK"
CMD=dotnet
VERSION_USAGE="SDK major.minor channel, for example 10.0"
INSTALL_NOTES="Uses configured apt sources; on Debian, configure a suitable .NET package source first."
init_system "10.0" "$@"
[[ $VERSION =~ ^[0-9]+\.[0-9]+$ ]] || die "Expected a .NET SDK major.minor channel"
require_commands apt-get

pre_run
apt_install "dotnet-sdk-$VERSION" "aspnetcore-runtime-$VERSION" "dotnet-runtime-$VERSION"
INSTALLED_CMD=/usr/bin/dotnet
post_run --list-sdks