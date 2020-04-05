#!/bin/bash 
set -e
source _lib.sh

start "Oh My Zsh"

sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
