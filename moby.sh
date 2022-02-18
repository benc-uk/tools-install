#!/bin/bash 
set -e

CMD=docker
NAME="Moby - Docker CLI & Engine"

echo -e "\e[34m»»» 📦 \e[32mInstalling \e[35m\e[33m$NAME\e[0m ..."

# Weird thing - Microsoft maintains these Moby packages in their own repo
# Download the Microsoft repository GPG keys
wget -q https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb -O /tmp/packages-microsoft-prod.deb
# Register the Microsoft repository GPG keys
sudo dpkg -i /tmp/packages-microsoft-prod.deb
rm -f /tmp/packages-microsoft-prod.deb
sudo apt-get update -qq

# Install moby CLI and engine
sudo apt-get install -y moby-cli moby-buildx moby-compose moby-engine

# Let your account run docker w/o root
sudo usermod -aG docker "$USER"

# Add the System V init script
sudo curl -sSL https://raw.githubusercontent.com/moby/moby/master/contrib/init/sysvinit-debian/docker -o /etc/init.d/docker
sudo chmod +x /etc/init.d/docker

# Start the service
sudo service docker start

echo -e "\n\e[34m»»» 💾 \e[32mInstalled to: \e[33m$(which $CMD)"
echo -e "\e[34m»»» 💡 \e[32mVersion details: \e[39m$($CMD --version)"
