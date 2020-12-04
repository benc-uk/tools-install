#!/bin/bash
set -e

DIR=$(cd `dirname $0` && pwd)
source $DIR/.lib.sh

start "AzCopy"

wget https://aka.ms/downloadazcopy-v10-linux -O /tmp/azcopy.tar.gz
tar -xzf /tmp/azcopy.tar.gz -C /tmp
mkdir -p $HOME/.local/bin
mv /tmp/azcopy_linux_amd64_*/azcopy $HOME/.local/bin
rm -rf /tmp/azcopy*

end 'azcopy' '--version'
