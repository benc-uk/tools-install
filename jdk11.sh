#!/bin/bash 
set -e 
source _lib.sh

start "Open JDK"

sudo apt-get update
sudo apt install openjdk-11-jdk

end 'java' '-version'