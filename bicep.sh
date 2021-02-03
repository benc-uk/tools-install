#!/bin/bash
set -e
DIR=$(cd `dirname $0` && pwd)
source $DIR/.lib.sh

start "bicep"
VER="0.2.328"

mkdir -p  $HOME/.local/bin

wget -Lq --show-progress https://github.com/Azure/bicep/releases/download/v$VER/bicep-linux-x64 -O $HOME/.local/bin/bicep
chmod +x $HOME/.local/bin/bicep

end 'bicep' '--version'