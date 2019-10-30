#!/bin/bash
set -e

echo "Installing Dapr CLI..."
wget -q https://raw.githubusercontent.com/dapr/cli/master/install/install.sh -O - | /bin/bash
