#!/bin/bash
set -e
DIR=$(cd `dirname $0` && pwd)
source $DIR/_lib.sh

start "kubectl"

curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubectl

echo -e "\nInstalled to: `which kubectl`"
echo -e "\nVersion details: \n`kubectl version`"

end 'kubectl' 'version'