#!/bin/bash 
set -e 
DIR=$(cd `dirname $0` && pwd)
source $DIR/_lib.sh

start 'Azure CLI'

curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

end 'az' 'version'
