#!/bin/bash
set -e
DIR=$(cd `dirname $0` && pwd)
source $DIR/_lib.sh

ver="2.7.0"
start "Linkerd v$ver"

mkdir -p  $HOME/.local/bin
wget -q https://github.com/linkerd/linkerd2/releases/download/stable-$ver/linkerd2-cli-stable-$ver-linux
mv linkerd2-cli-stable-$ver-linux $HOME/.local/bin/linkerd
chmod +x $HOME/.local/bin/linkerd

end 'linkerd' 'version'