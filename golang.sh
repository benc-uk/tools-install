#!/bin/bash
set -e
source <(curl -sSL s.benc.dev/lib) # Load libary from remote URL, it's safe!

get_latest_release() {
  curl --silent "https://go.dev/dl/" | grep -Po -m 1 '(\d+\.\d+\.\d+)\.linux-amd64' | sed 's/.linux-amd64//'
}

VERSION=${1:-"$(get_latest_release)"}
CMD=go
NAME="Go Language"

pre_run

cd /tmp
curl -fsSL "https://go.dev/dl/go${VERSION}.linux-amd64.tar.gz" -o golang.tar.gz
sudo tar -xvf golang.tar.gz > /dev/null
sudo rm -rf /usr/local/go
rm -rf /tmp/golang.tar.gz
sudo mv go /usr/local

post_run version