#!/bin/bash
set -e

ver="1.13"
echo "Installing Go $ver into /usr/local/"

cd /tmp
curl -fsS https://dl.google.com/go/go${ver}.linux-amd64.tar.gz -o golang.tar.gz

sudo tar -xvf golang.tar.gz
sudo rm -rf /usr/local/go
sudo mv go /usr/local
