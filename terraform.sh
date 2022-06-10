#!/bin/bash 
set -e
source <(curl -sSL https://t.ly/toollib) # Load libary from remote URL, it's safe!

GITHUB="hashicorp/terraform"
VERSION=${1:-"$(get_latest_release $GITHUB)"}
INSTALL_DIR=${2:-"$HOME/.local/bin"}
CMD=terraform
NAME=Terraform

pre_run

curl -sSL "https://releases.hashicorp.com/terraform/${VERSION}/terraform_${VERSION}_linux_amd64.zip" -o /tmp/tf.zip
unzip /tmp/tf.zip -d /tmp > /dev/null
mkdir -p "$INSTALL_DIR"
mv /tmp/terraform "$INSTALL_DIR"
rm -f /tmp/tf.zip

post_run
