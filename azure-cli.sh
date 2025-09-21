#!/bin/bash
set -e
source <(curl -sSL https://raw.githubusercontent.com/benc-uk/tools-install/master/_lib.sh) # Load libary from remote URL, it's safe!

CMD=az
NAME="Azure CLI"

pre_run

curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

post_run