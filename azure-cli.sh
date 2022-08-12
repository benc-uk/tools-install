#!/bin/bash
set -e
source <(curl -sSL benco.io/lib) # Load libary from remote URL, it's safe!

CMD=az
NAME="Azure CLI"

pre_run

curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

post_run