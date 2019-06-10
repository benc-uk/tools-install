#!/bin/bash
set -e

ver="0.54.0"
echo "Installing Hugo $ver into $HOME/.local/bin"

wget "https://github.com/gohugoio/hugo/releases/download/v0.54.0/hugo_${ver}_Linux-64bit.tar.gz" -O /tmp/hugo.tar.gz
cd /tmp
tar -zxf hugo.tar.gz
mv hugo $HOME/.local/bin
rm hugo.tar.gz

