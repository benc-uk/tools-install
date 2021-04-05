#!/bin/bash 
set -e 

CMD=java
NAME="Java OpenJDK 11"

echo -e "\e[34m»»» 📦 \e[32mInstalling \e[33m$NAME\e[0m ..."

sudo apt-get -qq update
sudo apt install -y openjdk-11-jdk maven

echo -e "\n\e[34m»»» 💾 \e[32mInstalled to: \e[33m$(which $CMD)"
echo -e "\e[34m»»» 💡 \e[32mVersion details: \e[39m$($CMD --version)"
