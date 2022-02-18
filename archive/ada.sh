#!/bin/bash 
set -e 

CMD=gnat
NAME="Ada: GNAT, GPRBuild, Alire"

echo -e "\e[34m»»» 📦 \e[32mInstalling \e[33m$NAME\e[0m ..."

sudo apt-get update -qq
sudo apt-get install -y gnat gprbuild libgnutls28-dev

# Alire
get_latest_release() {
  curl --silent "https://api.github.com/repos/$1/releases/latest" |
  grep '"tag_name":' | sed -E 's/.*"v([^"]+)".*/\1/'
}

VERSION=${1:-"$(get_latest_release alire-project/alire)"}
INSTALL_DIR=${2:-"$HOME/.local/bin"}

curl -sSL "https://github.com/alire-project/alire/releases/download/v${VERSION}/alr-${VERSION}-bin-linux.zip" -o /tmp/alire.zip
unzip -o /tmp/alire.zip -d /tmp
mkdir -p $INSTALL_DIR
sudo mv /tmp/bin/alr $INSTALL_DIR
rm -rf /tmp/alr.zip

# Done...
echo -e "\n\e[34m»»» 💾 \e[32mInstalled to: \e[33m$(which $CMD)"
echo -e "\e[34m»»» 💡 \e[32mGNAT Version details: \e[39m$(gnat --version)"
echo -e "\e[34m»»» 💡 \e[32mGPRBuild Version details: \e[39m$(gprbuild --version)"
echo -e "\e[34m»»» 💡 \e[32mALR Version details: \e[39m$(alr version)"
