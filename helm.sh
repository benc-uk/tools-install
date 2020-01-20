#!/bin/bash
set -e
# echo "Installing latest version of Helm into /usr/local/bin"
# curl -L https://git.io/get_helm.sh | bash

ver="3.0.2"
curl -fsS "https://get.helm.sh/helm-v$ver-linux-amd64.tar.gz" -o /tmp/helm.tar.gz
cd /tmp
tar -zxf helm.tar.gz
sudo mv linux-amd64/helm /usr/local/bin
rm helm.tar.gz
rm -rf linux-amd64
