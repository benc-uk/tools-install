#!/bin/bash
set -e

ver="3.0.0-rc.1"
echo "Installing latest version of Helm 3 into /usr/local/bin"

#curl -L https://git.io/get_helm.sh | bash

curl -fsS "https://get.helm.sh/helm-v$ver-linux-amd64.tar.gz" -o /tmp/helm.tar.gz
cd /tmp
tar -zxf helm.tar.gz
sudo mv linux-amd64/helm /usr/local/bin/helm3
rm helm.tar.gz
rm -rf linux-amd64
