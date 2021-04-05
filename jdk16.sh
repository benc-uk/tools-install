#!/bin/bash 
set -e 

CMD=java
NAME="Java AdoptOpen JDK 16"

echo -e "\e[34m»»» 📦 \e[32mInstalling \e[33m$NAME\e[0m ..."

wget -qO - https://adoptopenjdk.jfrog.io/adoptopenjdk/api/gpg/key/public | sudo apt-key add -
echo "deb https://adoptopenjdk.jfrog.io/adoptopenjdk/deb $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/adoptopenjdk.list
sudo apt-get update -qq
sudo apt-get install -y adoptopenjdk-16-hotspot

echo -e "\n\e[34m»»» 💾 \e[32mInstalled to: \e[33m$(which $CMD)"
echo -e "\e[34m»»» 💡 \e[32mVersion details: \e[39m$($CMD --version)"
echo -e "\e[34m»»» 💡 \e[32mVersion details: \e[39m$(javac --version)"
