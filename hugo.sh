#!/bin/bash
set -e
source _lib.sh

ver="0.68.3"
start "Hugo $ver"

wget -q -O /tmp/hugo.tar.gz https://github.com/gohugoio/hugo/releases/download/v${ver}/hugo_extended_${ver}_Linux-64bit.tar.gz
cd /tmp
tar -zxf hugo.tar.gz -C $HOME/.local/bin/
rm /tmp/hugo.tar.gz

end 'hugo' 'version'
