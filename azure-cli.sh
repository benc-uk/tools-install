#!/bin/bash 
set -e

CMD=az
NAME="Azure CLI"

pre_run

curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

post_run