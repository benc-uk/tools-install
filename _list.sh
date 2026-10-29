#!/bin/bash
set -euo pipefail
DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)

for script in "$DIR"/[a-z]*.sh; do
  name=$(sed -n 's/^NAME="\([^"]*\)"$/\1/p' "$script")
  [[ -n $name ]] || { printf 'Missing NAME in %s\n' "$script" >&2; exit 1; }
  printf -- '- [%s](./%s) - %s\n' "${script##*/}" "${script##*/}" "$name"
done
