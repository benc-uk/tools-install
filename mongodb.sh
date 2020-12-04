#!/bin/bash
set -e
DIR=$(cd `dirname $0` && pwd)
source $DIR/.lib.sh

start "MongoDB Server"

#wget -qO - https://www.mongodb.org/static/pgp/server-4.4.asc | sudo apt-key add -
#echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/4.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.4.list
sudo apt-get update -y
sudo apt-get install -y mongodb

sudo mkdir -p /data/db
sudo mkdir -p /var/log/mongodb

end 'mongod' '--version'
