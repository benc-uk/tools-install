#!/bin/bash 
set -e
source <(curl -sSL benco.io/lib) # Load libary from remote URL, it's safe!

VERSION=${1:-"stable"}
INSTALL_DIR=${2:-"$HOME/.local/bin"}
CMD=$INSTALL_DIR/code
NAME=VS Code CLI

pre_run

curl -sSL https://code.visualstudio.com/sha/download\?build\=stable\&os\=cli-alpine-x64 | tar -xz -C "$INSTALL_DIR" 

post_run