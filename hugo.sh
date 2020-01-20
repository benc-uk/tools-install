#!/bin/bash
set -e

ver="0.61.0"
echo "Installing Hugo $ver into $HOME/.local/bin"

wget -q -O /tmp/hugo.tar.gz https://github.com/gohugoio/hugo/releases/download/v${ver}/hugo_extended_${ver}_Linux-64bit.tar.gz
cd /tmp
tar -zxf hugo.tar.gz -C $HOME/.local/bin/
rm /tmp/hugo.tar.gz

