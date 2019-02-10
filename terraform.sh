#!/bin/bash 
set -e

ver="0.11.11"
echo "Installing Terraform $ver into $HOME/.local/bin"

cd /tmp
curl -fsS "https://releases.hashicorp.com/terraform/${ver}/terraform_${ver}_linux_amd64.zip" -o tf.zip

unzip tf.zip
mv terraform $HOME/.local/bin
