#!/bin/bash 
set -e
source <(curl -sSL https://raw.githubusercontent.com/benc-uk/tools-install/master/_lib.sh) # Load libary from remote URL, it's safe!

VERSION=${1:-"8.0"}
CMD=dotnet
NAME="Dotnet SDK"

pre_run

#
# 2024 - Removed the Microsoft repo, as the SDK is available in the default Ubuntu sources
#

sudo apt-get update -qq
sudo apt-get install -y -qq dotnet-sdk-"$VERSION"
sudo apt-get install -y -qq aspnetcore-runtime-"$VERSION"
sudo apt-get install -y -qq dotnet-runtime-"$VERSION"

post_run --version