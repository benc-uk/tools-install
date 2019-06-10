#!/bin/bash
set -e

ver="2.14.0"
echo "Installing Helm $ver into $HOME/.local/bin"

curl -fsS "https://storage.googleapis.com/kubernetes-helm/helm-v${ver}-linux-amd64.tar.gz" -o /tmp/helm.tar.gz
cd /tmp
tar -zxf helm.tar.gz
mv linux-amd64/helm $HOME/.local/bin
rm helm.tar.gz
rm -rf linux-amd64

