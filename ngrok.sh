#!/bin/bash
set -e
source <(curl -sSL s.benc.dev/lib) # Load libary from remote URL, it's safe!

CMD=ngrok
NAME="ngrok"
INSTALL_DIR=${2:-"$HOME/.local/bin"}
VERSION="2"

pre_run

wget -q "https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip" -O /tmp/ngrok.zip
unzip -o /tmp/ngrok.zip -d "$INSTALL_DIR" > /dev/null
rm -f /tmp/ngrok.zip

post_run