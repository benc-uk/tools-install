#!/bin/bash
set -euo pipefail
# shellcheck source=_lib.sh
source "$ROOT/_lib.sh"

NAME="Fixture"
VERSION=1.2.3
read_distribution
[[ $NAME == Fixture && $VERSION == 1.2.3 ]] || die "os-release overwrote installer metadata"
WORK_DIR=$(mktemp -d)
trap cleanup EXIT
ARCH=amd64

as_root() {
  printf '%s\n' "$*" >> "$TEST_DIR/system-commands"
  [[ ${MOCK_ROOT_FAILURE:-} != yes ]]
}

dpkg() {
  [[ $* == --print-architecture ]] || die "Unexpected dpkg invocation"
  printf 'amd64\n'
}

download() {
  printf '%s\n' "$1" >> "$TEST_DIR/system-urls"
  printf 'fixture key\n' > "$2"
}

gpg() {
  [[ $* == "--batch --yes --dearmor --output $WORK_DIR/fixture.gpg $WORK_DIR/fixture.asc" ]] ||
    die "Unexpected key conversion"
  printf 'fixture binary key\n' > "$WORK_DIR/fixture.gpg"
}

install_apt_source() {
  [[ $2 == /etc/apt/sources.list.d/fixture.sources ]] || die "Unexpected source destination"
  cp "$1" "$TEST_DIR/fixture.sources"
}

apt_install --allow-downgrades 'nodejs=24.*'
grep -Fx 'apt-get update -qq' "$TEST_DIR/system-commands"
grep -Fx 'apt-get install -y --allow-downgrades nodejs=24.*' "$TEST_DIR/system-commands"

add_apt_repo fixture https://example.invalid/key https://example.invalid/repo stable
printf 'Types: deb\nURIs: https://example.invalid/repo\nSuites: stable\nComponents: main\nArchitectures: amd64\nSigned-By: /etc/apt/keyrings/fixture.gpg\n' > "$TEST_DIR/expected.sources"
cmp "$TEST_DIR/expected.sources" "$TEST_DIR/fixture.sources"
ARCH=arm64
add_apt_repo fixture https://example.invalid/key https://example.invalid/repo stable custom
grep -Fx 'Architectures: arm64' "$TEST_DIR/fixture.sources"
grep -Fx 'Components: custom' "$TEST_DIR/fixture.sources"
ARCH=amd64
grep -F 'install -m 0644' "$TEST_DIR/system-commands"

DISTRO=debian
DISTRO_VERSION=12
microsoft_repo
grep -Fx 'https://packages.microsoft.com/config/debian/12/packages-microsoft-prod.deb' "$TEST_DIR/system-urls"

MOCK_ROOT_FAILURE=yes
if (apt_install fixture); then die "Package failure was ignored"; fi
