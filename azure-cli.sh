#!/bin/bash 
set -e 
source _lib.sh

start 'Azure CLI'

curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

end 'az' 'version'
