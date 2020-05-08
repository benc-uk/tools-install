#!/bin/bash
set -e
DIR=$(cd `dirname $0` && pwd)
source $DIR/_lib.sh

start 'foo'
sudo apt update

end 'foo' '--version'
