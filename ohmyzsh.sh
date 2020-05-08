#!/bin/bash 
set -e
DIR=$(cd `dirname $0` && pwd)
source $DIR/_lib.sh

start "Oh My Zsh + Powerlevel10k"

sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $HOME/.oh-my-zsh/custom/themes/powerlevel10k