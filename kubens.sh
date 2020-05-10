#!/bin/bash
set -e
DIR=$(cd `dirname $0` && pwd)
source $DIR/_lib.sh

start "kubens & kubectx"

mkdir -p  $HOME/.local/bin

curl https://raw.githubusercontent.com/ahmetb/kubectx/master/kubens > ~/.local/bin/kubens
chmod u+x ~/.local/bin/kubens

curl https://raw.githubusercontent.com/ahmetb/kubectx/master/kubectx > ~/.local/bin/kubectx
chmod u+x ~/.local/bin/kubectx
