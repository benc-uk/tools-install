#!/bin/bash
set -e

echo "Installing Node.js 10.x"

curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
sudo apt install -y nodejs
