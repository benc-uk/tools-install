#!/bin/bash
set -e

ver="0.3.5-beta.1"
echo "Installing Duffle $ver into $HOME/.local/bin"

wget -q https://github.com/deislabs/duffle/releases/download/$ver/duffle-linux-amd64
mv duffle-linux-amd64 $HOME/.local/bin/duffle
chmod +x $HOME/.local/bin/duffle