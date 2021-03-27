#!/bin/bash 
set -e 
DIR=$(cd `dirname $0` && pwd)
source $DIR/.lib.sh

start "Open JDK 16 & Maven"

sudo apt-get -qq update
sudo apt install -y openjdk-16-jdk maven

end 'java' '-version'
end 'mvn' '-version'