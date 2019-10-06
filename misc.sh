#!/bin/bash
set -e

sudo apt update
sudo apt install jq
sudo apt install pv
sudo apt install unzip

# Bat
wget -q https://github.com/sharkdp/bat/releases/download/v0.12.1/bat_0.12.1_amd64.deb -O /tmp/bat.deb
sudo dpkg -i /tmp/bat.deb
sudo rm /tmp/bat.deb