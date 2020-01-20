#!/bin/bash
set -e

echo "Installing Porter (latest) into $HOME/.porter/"

curl https://cdn.deislabs.io/porter/latest/install-linux.sh | bash