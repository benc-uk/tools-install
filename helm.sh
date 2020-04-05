#!/bin/bash
set -e
source _lib.sh

ver="3.1.2"

start "Helm v$ver"

curl -fsS "https://get.helm.sh/helm-v$ver-linux-amd64.tar.gz" -o /tmp/helm.tar.gz
cd /tmp
tar -zxf helm.tar.gz
sudo mv linux-amd64/helm /usr/local/bin
rm helm.tar.gz
rm -rf linux-amd64

end 'helm' 'version'
