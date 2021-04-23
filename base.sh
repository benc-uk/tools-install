#!/bin/bash
set -e

# Basic base/core packages

echo -e "\e[34m»»» 📦 \e[32mInstalling \e[33mBase Core Packages\e[0m ..."

sudo apt-get update -y -qq
sudo apt-get install -y \
  jq \
  curl \
  wget \
  unzip \
  apt-transport-https \
  lsb-release \
  gnupg \
  shellcheck
