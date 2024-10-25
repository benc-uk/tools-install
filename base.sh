#!/bin/bash
set -e
NAME="Various Linux Utilities"

# Basic base/core packages

echo -e "\e[34m»»» 📦 \e[32mInstalling \e[33mBase Core Tools & Packages\e[0m ..."

sudo apt-get update -y -qq
sudo apt-get install -y \
  jq \
  curl \
  make \
  git \
  wget \
  unzip \
  fzf \
  apt-transport-https \
  lsb-release \
  gnupg \
  shellcheck \
  ncdu \
  hey \
  figlet
