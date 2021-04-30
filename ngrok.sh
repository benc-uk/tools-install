#!/bin/bash
set -e

CMD=ngrok
NAME="ngrok"
INSTALL_DIR=${2:-"$HOME/.local/bin"}

echo -e "\e[34m»»» 📦 \e[32mInstalling \e[33m$NAME\e[0m ..."

mkdir -p $INSTALL_DIR
wget -q "https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip" -O /tmp/ngrok.zip
unzip -o /tmp/ngrok.zip -d $INSTALL_DIR
rm -f /tmp/ngrok.zip

echo -e "\n\e[34m»»» 💾 \e[32mInstalled to: \e[33m$(which $CMD)"
echo -e "\e[34m»»» 💡 \e[32mVersion details: \e[39m$($CMD --version)"
