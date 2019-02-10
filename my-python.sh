#!/bin/bash 
set -e

if [[ -z "${VIRTUAL_ENV}" ]]; then
  echo "ERROR! Please run inside a virtual environment" 
  exit
fi

echo "Installing my Python 3 packages"
sudo apt install python3-pip
pip3 install numpy
pip3 install pandas
pip3 install jupyter
pip3 install databricks-cli
pip3 install flask
pip3 install azure-storage
