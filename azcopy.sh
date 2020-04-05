#!/bin/bash
set -e
source _lib.sh

ver="10"
start "AzCopy v$ver"

wget -q -O /tmp/azcopy.tar https://aka.ms/downloadazcopy-v$ver-linux
cd /tmp
tar -xf azcopy.tar
cd azcopy_linux_amd64_$ver.*
mv ./azcopy $HOME/.local/bin/azcopy
cd ..
rm azcopy.tar
rm -rf azcopy_linux_amd64_$ver.*

end 'azcopy' '--version'
