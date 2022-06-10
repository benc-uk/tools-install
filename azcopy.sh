#!/bin/bash 
set -e

source <(curl -sSL https://t.ly/toollib) # Load libary from remote URL, it's safe!

VERSION=${1:-"10"}
INSTALL_DIR=${2:-"$HOME/.local/bin"}
CMD=azcopy
NAME="Azure Copy"

pre_run

curl -sSL https://aka.ms/downloadazcopy-v"$VERSION"-linux -o /tmp/azcopy.tar.gz
tar -xzf /tmp/azcopy.tar.gz -C /tmp
mv /tmp/azcopy_linux_amd64_*/azcopy "$INSTALL_DIR"
rm -rf /tmp/azcopy*

post_run 