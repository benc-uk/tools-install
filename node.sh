#!/bin/bash
set -e
source _lib.sh

start "Node.js 12.x LTS"

curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
sudo apt install -y nodejs

echo -e "\nInstalled to: `which node`"
echo -e "\nVersion details: \n`node -v`"

end "node" "--version"
