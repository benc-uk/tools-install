#!/bin/bash
set -e
DIR=$(cd `dirname $0` && pwd)
source $DIR/_lib.sh

start "Node.js 12.x LTS"

curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
sudo apt install -y nodejs

echo -e "\nInstalled to: `which node`"
echo -e "\nVersion details: \n`node -v`"

end "node" "--version"
