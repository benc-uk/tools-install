#!/bin/bash
set -e
DIR=$(cd `dirname $0` && pwd)
source $DIR/.lib.sh

start "K6"

sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 379CE192D401AB61
echo "deb https://dl.bintray.com/loadimpact/deb stable main" | sudo tee /etc/apt/sources.list.d/loadimpact.list
sudo apt-get update
sudo apt-get install k6

end 'k6' 'version'
