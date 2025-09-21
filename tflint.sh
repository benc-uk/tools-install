#!/bin/bash 
set -e
source <(curl -sSL https://raw.githubusercontent.com/benc-uk/tools-install/master/_lib.sh) # Load libary from remote URL, it's safe!

GITHUB="terraform-linters/tflint"
VERSION=${1:-"$(get_latest_release $GITHUB)"}
INSTALL_DIR=${2:-"$HOME/.local/bin"}
CMD=tflint
NAME="Tflint Terraform Linter"

pre_run

curl -sSL "https://github.com/${GITHUB}/releases/download/v${VERSION}/tflint_linux_amd64.zip" -o /tmp/tflint.zip
unzip /tmp/tflint.zip -d /tmp > /dev/null
mkdir -p "$INSTALL_DIR"
mv /tmp/tflint "$INSTALL_DIR"
rm -f /tmp/tflint.zip

post_run
