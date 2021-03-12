#!/bin/bash
set -e
DIR=$(cd `dirname $0` && pwd)
source $DIR/.lib.sh

start "Node.js 14.x LTS"

curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
sudo apt install -y nodejs

echo -e "\nInstalled to: `which node`"
echo -e "\nVersion details: \n`node -v`"

end "node" "--version"
