#!/bin/bash
set -euo pipefail
# shellcheck source=_lib.sh
source "$ROOT/_lib.sh"

as_root() {
  if [[ ${MOCK_COMMAND_FAILURE:-} == "$1" ]]; then
    printf 'Simulated %s failure\n' "$1" >&2
    return 1
  fi
  command "$@"
}

DIR="$TEST_DIR/apt-sources"
mkdir -p "$DIR"
SOURCE="$DIR/generated.sources"
printf 'Types: deb\nURIs: https://example.invalid/node_26.x\nSuites: nodistro\nComponents: main\n' > "$SOURCE"
printf 'Unrelated repository configuration\n' > "$DIR/unrelated.list"

for state in fresh legacy modern both; do
  mkdir -p "$DIR/$state"
  target="$DIR/$state/fixture.sources"
  legacy="$DIR/$state/fixture.list"
  if [[ $state == legacy || $state == both ]]; then
    printf 'deb https://example.invalid/node_24.x nodistro main\n' > "$legacy"
    cp "$legacy" "$DIR/$state/expected.list"
  fi
  if [[ $state == modern || $state == both ]]; then
    printf 'Types: deb\nURIs: https://example.invalid/node_24.x\nSuites: nodistro\nComponents: main\n' > "$target"
    cp "$target" "$DIR/$state/expected.sources"
  fi
  install_apt_source "$SOURCE" "$target"
  cmp "$SOURCE" "$target"
  [[ ! -e $legacy ]] || die "Legacy source was not retired"
  [[ $(stat -c %a "$target") == 644 ]] || die "Incorrect source permissions"
  if [[ $state == legacy || $state == both ]]; then cmp "$DIR/$state/expected.list" "$legacy.bak"; fi
  if [[ $state == modern || $state == both ]]; then cmp "$DIR/$state/expected.sources" "$target.bak"; fi
  before=$(find "$DIR/$state" -type f -print | sort)
  install_apt_source "$SOURCE" "$target"
  [[ $(find "$DIR/$state" -type f -print | sort) == "$before" ]] || die "Rerun created unnecessary backups"
done

target="$DIR/both/fixture.sources"
cp "$SOURCE" "$DIR/previous.sources"
printf 'Types: deb\nURIs: https://example.invalid/node_28.x\nSuites: nodistro\nComponents: main\n' > "$SOURCE"
install_apt_source "$SOURCE" "$target"
cmp "$DIR/previous.sources" "$target.bak"
cmp "$DIR/both/expected.sources" "$target.bak.~1~"

for failure in cp install mv; do
  mkdir -p "$DIR/fail-$failure"
  target="$DIR/fail-$failure/fixture.sources"
  legacy="$DIR/fail-$failure/fixture.list"
  printf 'Previous source\n' > "$target"
  printf 'Previous legacy source\n' > "$legacy"
  if (MOCK_COMMAND_FAILURE=$failure install_apt_source "$SOURCE" "$target"); then
    die "Failed $failure was ignored"
  fi
  grep -Fx 'Previous source' "$target"
  grep -Fx 'Previous legacy source' "$legacy"
  [[ -z $(find "$DIR/fail-$failure" -name 'fixture.sources.??????' -print) ]] || die "Staging file left behind"
done

mkdir -p "$DIR/symlink"
ln -s "$DIR/unrelated.list" "$DIR/symlink/fixture.list"
if (install_apt_source "$SOURCE" "$DIR/symlink/fixture.sources"); then die "Replaced a symlink"; fi
[[ ! -e "$DIR/symlink/fixture.sources" ]] || die "Changed sources before rejecting a symlink"
grep -Fx 'Unrelated repository configuration' "$DIR/unrelated.list"
