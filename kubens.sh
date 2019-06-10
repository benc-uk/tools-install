#!/bin/bash
set -e

echo "Installing kubens & kubectx"

curl https://raw.githubusercontent.com/ahmetb/kubectx/master/kubens > ~/.local/bin/kubens
chmod u+x ~/.local/bin/kubens

curl https://raw.githubusercontent.com/ahmetb/kubectx/master/kubectx > ~/.local/bin/kubectx
chmod u+x ~/.local/bin/kubectx

