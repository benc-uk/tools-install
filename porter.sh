#!/bin/bash
set -e
source <(curl -sSL benco.io/lib) # Load libary from remote URL, it's safe!

CMD=porter
NAME="Porter"
VERSION="0.0"
INSTALL_DIR="$HOME/.porter"

pre_run

curl -sSL https://cdn.porter.sh/latest/install-linux.sh | bash

post_run
