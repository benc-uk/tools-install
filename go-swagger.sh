#!/bin/bash

#
# This installs 'go-swagger'
# https://github.com/go-swagger/go-swagger
#

set -e
DIR=$(cd `dirname $0` && pwd)
source $DIR/.lib.sh

start 'go-swagger'

mkdir -p $HOME/.local/bin
download_url=$(curl -s https://api.github.com/repos/go-swagger/go-swagger/releases/latest | \
  jq -r '.assets[] | select(.name | contains("'"$(uname | tr '[:upper:]' '[:lower:]')"'_amd64")) | .browser_download_url')
curl -o $HOME/.local/bin/swagger -L'#' "$download_url"
chmod +x $HOME/.local/bin/swagger

end 'swagger' 'version'
