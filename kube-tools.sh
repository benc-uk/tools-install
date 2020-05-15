#!/bin/bash
set -e
DIR=$(cd `dirname $0` && pwd)
source $DIR/.lib.sh

start "kubens & kubectx"

mkdir -p  $HOME/.local/bin

curl -s https://raw.githubusercontent.com/ahmetb/kubectx/master/kubens > ~/.local/bin/kubens
chmod u+x ~/.local/bin/kubens

curl -s https://raw.githubusercontent.com/ahmetb/kubectx/master/kubectx > ~/.local/bin/kubectx
chmod u+x ~/.local/bin/kubectx
