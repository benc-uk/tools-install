#!/bin/bash 
set -e
source <(curl -sSL https://t.ly/toollib) # Load libary from remote URL, it's safe!

GITHUB="__changeme__/__changeme__"
VERSION=${1:-"$(get_latest_release $GITHUB)"}
INSTALL_DIR=${2:-"$HOME/.local/bin"}
CMD=__changeme__
NAME=__changeme__

pre_run

curl -sSL https://github.com/$GITHUB/releases/download/v"${VERSION}"/__changeme__"${VERSION}"__changeme__.tar.gz | \
     tar -zx -C "$INSTALL_DIR" $CMD
# You many need to use strip components if the command is in sub-folder
#    tar -zx -C "$INSTALL_DIR" --strip-components 1 some_sub_folder/$CMD

post_run