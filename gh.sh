#!/bin/bash

set -e
DIR=$(cd `dirname $0` && pwd)
source $DIR/.lib.sh

start "GitHub CLI"

sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-key C99B11DEB97541F0
sudo apt-add-repository https://cli.github.com/packages
sudo apt update
sudo apt install gh

end 'gh' '--version'
