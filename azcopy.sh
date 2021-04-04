#!/bin/bash 
set -e

VERSION=${1:-"10"}
INSTALL_DIR=${2:-"$HOME/.local/bin"}
CMD=azcopy
NAME="AzCopy"

echo -e "\e[34m»»» 📦 \e[32mInstalling \e[33m$NAME \e[35mv$VERSION\e[0m ..."

curl -sSL https://aka.ms/downloadazcopy-v$VERSION-linux -o /tmp/azcopy.tar.gz
tar -xzf /tmp/azcopy.tar.gz -C /tmp
mkdir -p $INSTALL_DIR
mv /tmp/azcopy_linux_amd64_*/azcopy $INSTALL_DIR
rm -rf /tmp/azcopy*

echo -e "\n\e[34m»»» 💾 \e[32mInstalled to: \e[33m$(which $CMD)"
echo -e "\e[34m»»» 💡 \e[32mVersion details: \e[39m$($CMD --version)"