#!/bin/bash
set -e

ver="10"
echo "Installing Azcopy $ver into $HOME/.local/bin"

wget -q -O /tmp/azcopy.tar https://aka.ms/downloadazcopy-v$ver-linux
cd /tmp
tar -xf azcopy.tar
cd azcopy_linux_amd64_$ver.*
mv ./azcopy $HOME/.local/bin
cd ..
rm azcopy.tar
rm -rf azcopy_linux_amd64_$ver.*
