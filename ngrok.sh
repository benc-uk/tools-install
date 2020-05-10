#!/bin/bash
set -e
DIR=$(cd `dirname $0` && pwd)
source $DIR/_lib.sh

start 'ngrok'

mkdir -p  $HOME/.local/bin
wget -q "https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip" -O $HOME/.local/bin/ngrok-stable-linux-amd64.zip
unzip $HOME/.local/bin/ngrok-stable-linux-amd64.zip -d $HOME/.local/bin/

end 'ngrok' 'version'
