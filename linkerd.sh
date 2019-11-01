#!/bin/bash
set -e

ver="2.6.0"
echo "Installing Linkerd $ver into $HOME/.local/bin"

wget -q https://github.com/linkerd/linkerd2/releases/download/stable-$ver/linkerd2-cli-stable-$ver-linux
mv linkerd2-cli-stable-$ver-linux $HOME/.local/bin/linkerd
chmod +x $HOME/.local/bin/linkerd