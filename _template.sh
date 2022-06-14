#!/bin/bash 
set -e
source <(curl -sSL s.benc.dev/lib) # Load libary from remote URL, it's safe!

VERSION=${1:-"0.0.0"}
INSTALL_DIR=${2:-"$HOME/.local/bin"}
CMD=__changeme__
NAME=__Change_Me__

pre_run

# INSTALL STEPS HERE

post_run