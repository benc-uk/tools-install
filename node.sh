#!/bin/bash
set -e

echo "Installing Node.js 12.x"

curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
sudo apt install -y nodejs
