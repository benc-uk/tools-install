#!/bin/bash
set -e
source _lib.sh

ver="1.14.1"
start "Go $ver"

cd /tmp
curl -fsS https://dl.google.com/go/go${ver}.linux-amd64.tar.gz -o golang.tar.gz

sudo tar -xvf golang.tar.gz
sudo rm -rf /usr/local/go
sudo mv go /usr/local

end 'go' 'version'
