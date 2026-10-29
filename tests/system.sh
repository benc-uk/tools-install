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

apt_install --allow-downgrades 'nodejs=24.*'
grep -Fx 'apt-get update -qq' "$TEST_DIR/system-commands"
grep -Fx 'apt-get install -y --allow-downgrades nodejs=24.*' "$TEST_DIR/system-commands"

add_apt_repo fixture https://example.invalid/key \
  'deb [arch=amd64 signed-by=/etc/apt/keyrings/fixture.gpg] https://example.invalid/repo stable main'
grep -F 'signed-by=/etc/apt/keyrings/fixture.gpg' "$WORK_DIR/fixture.list"
grep -F 'install -m 0644' "$TEST_DIR/system-commands"

DISTRO=debian
DISTRO_VERSION=12
microsoft_repo
grep -Fx 'https://packages.microsoft.com/config/debian/12/packages-microsoft-prod.deb' "$TEST_DIR/system-urls"

MOCK_ROOT_FAILURE=yes
if (apt_install fixture); then die "Package failure was ignored"; fi
