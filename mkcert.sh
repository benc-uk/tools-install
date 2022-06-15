#!/bin/bash 
set -e
source <(curl -sSL benco.io/lib) # Load libary from remote URL, it's safe!

VERSION=${1:-"Latest"}
INSTALL_DIR=${2:-"$HOME/.local/bin"}
CMD=mkcert
NAME=mkcert

pre_run

sudo apt install -y -q libnss3-tools
curl -sSL "https://dl.filippo.io/mkcert/latest?for=linux/amd64" -o "$INSTALL_DIR"/mkcert
chmod +x "$INSTALL_DIR"/mkcert

post_run

# Instructions for use with WSL - https://gist.githubusercontent.com/benc-uk/54b663b7e2443d5fbfeaa1b30391436b/raw/50bcae5047f72c277e177428d531748401f54d93/mkcert.md