#!/bin/bash
set -e
DIR=$(cd `dirname $0` && pwd)
source $DIR/.lib.sh

ver="3.5.3"

start "Helm v$ver"

curl -fsS "https://get.helm.sh/helm-v$ver-linux-amd64.tar.gz" -o /tmp/helm.tar.gz
cd /tmp
tar -zxf helm.tar.gz
sudo mv linux-amd64/helm $HOME/.local/bin
rm helm.tar.gz
rm -rf linux-amd64

end 'helm' 'version --short'
