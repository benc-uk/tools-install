#!/bin/bash
set -euo pipefail
ROOT=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
cd "$ROOT"
SCRIPTS=(_lib.sh _list.sh [a-z]*.sh tests/*.sh tests/fixtures/*)
for script in "${SCRIPTS[@]}"; do bash -n "$script"; done
shellcheck -x "${SCRIPTS[@]}"
bash tests/run.sh
