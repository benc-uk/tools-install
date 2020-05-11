#!/bin/bash

#
# Template file, this installs 'foo'
#

set -e
DIR=$(cd `dirname $0` && pwd)
source $DIR/.lib.sh

start 'foo'
sudo apt update

end 'foo' '--version'
