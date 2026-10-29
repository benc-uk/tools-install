#!/bin/bash
set -euo pipefail
# shellcheck source=_lib.sh
source "$ROOT/_lib.sh"

if [[ ${1:-} == --sample ]]; then
  NAME=Fixture
  VERSION=1.2.3
  INSTALL_DIR=/fixture/bin
  trap cleanup EXIT
  pre_run
  log "Preparing fixture"
  success "Installed: fixture"
  warn "Fixture warning"
  error "Fixture error"
  exit 0
fi
if [[ ${1:-} == --die ]]; then die "Fixture failure"; fi

assert_contains() { grep -F -- "$2" "$1" >/dev/null || die "Missing output: $2"; }
assert_plain() {
  if LC_ALL=C grep -q $'[^\r -~]' "$1"; then die "Unexpected terminal styling in $1"; fi
}

env -u NO_COLOR TERM=xterm-256color bash "$ROOT/tests/output.sh" --sample \
  > "$TEST_DIR/status-stdout" 2> "$TEST_DIR/status-stderr"
assert_plain "$TEST_DIR/status-stdout"
assert_plain "$TEST_DIR/status-stderr"
assert_contains "$TEST_DIR/status-stdout" ">> Installing Fixture (1.2.3)"
assert_contains "$TEST_DIR/status-stdout" ">> Target: /fixture/bin"
assert_contains "$TEST_DIR/status-stdout" ">> Installed: fixture"
assert_contains "$TEST_DIR/status-stderr" "WARNING: Fixture warning"
assert_contains "$TEST_DIR/status-stderr" "Error: Fixture error"
if grep -E 'WARNING:|Error:' "$TEST_DIR/status-stdout"; then die "Diagnostics leaked into stdout"; fi
if [[ $(wc -l < "$TEST_DIR/status-stderr") != 2 ]]; then die "Unexpected stderr output"; fi

# The command is interpreted by the child shell, preserving paths with spaces.
# shellcheck disable=SC2016
SAMPLE_COMMAND='bash "$ROOT/tests/output.sh" --sample'
env -u NO_COLOR TERM=xterm-256color script -qefc "$SAMPLE_COMMAND" /dev/null > "$TEST_DIR/status-tty"
assert_contains "$TEST_DIR/status-tty" $'\033[1;35m📦 Installing Fixture'
assert_contains "$TEST_DIR/status-tty" $'\033[34m📂 Target:'
assert_contains "$TEST_DIR/status-tty" $'\033[36mℹ️ Preparing fixture'
assert_contains "$TEST_DIR/status-tty" $'\033[32m✅ Installed:'
assert_contains "$TEST_DIR/status-tty" $'\033[33m⚠️ WARNING: Fixture warning'
assert_contains "$TEST_DIR/status-tty" $'\033[31m❌ Error: Fixture error'
assert_contains "$TEST_DIR/status-tty" $'\033[0m'

for no_colour in "" 1; do
  NO_COLOR=$no_colour TERM=xterm-256color script -qefc "$SAMPLE_COMMAND" /dev/null > "$TEST_DIR/status-no-colour"
  assert_plain "$TEST_DIR/status-no-colour"
  assert_contains "$TEST_DIR/status-no-colour" ">> Installed: fixture"
done
env -u NO_COLOR TERM=dumb script -qefc "$SAMPLE_COMMAND" /dev/null > "$TEST_DIR/status-dumb"
assert_plain "$TEST_DIR/status-dumb"

# shellcheck disable=SC2016
env -u NO_COLOR TERM=xterm-256color script -qefc 'bash "$ROOT/tests/output.sh" --sample > "$TEST_DIR/status-stdout-only"' \
  /dev/null > "$TEST_DIR/status-stderr-tty"
assert_plain "$TEST_DIR/status-stdout-only"
assert_contains "$TEST_DIR/status-stderr-tty" $'\033[33m⚠️ WARNING:'
# shellcheck disable=SC2016
env -u NO_COLOR TERM=xterm-256color script -qefc 'bash "$ROOT/tests/output.sh" --sample 2> "$TEST_DIR/status-stderr-only"' \
  /dev/null > "$TEST_DIR/status-stdout-tty"
assert_plain "$TEST_DIR/status-stderr-only"
assert_contains "$TEST_DIR/status-stdout-tty" $'\033[32m✅ Installed:'

if bash "$ROOT/tests/output.sh" --die > "$TEST_DIR/status-die-out" 2> "$TEST_DIR/status-die-err"; then
  die "die did not exit with a failure"
fi
[[ ! -s "$TEST_DIR/status-die-out" ]] || die "Failure message leaked into stdout"
assert_contains "$TEST_DIR/status-die-err" "Error: Fixture failure"
