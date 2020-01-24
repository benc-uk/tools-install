#!/bin/bash
set -e

echo "Installing ngrok into $HOME/.local/bin"

wget -q "https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip" -O $HOME/.local/bin/ngrok-stable-linux-amd64.zip
unzip $HOME/.local/bin/ngrok-stable-linux-amd64.zip -d $HOME/.local/bin/
