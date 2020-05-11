#!/bin/bash 
set -e 
DIR=$(cd `dirname $0` && pwd)
source $DIR/.lib.sh

start "Open JDK"

sudo apt-get update
sudo apt install openjdk-11-jdk

end 'java' '-version'