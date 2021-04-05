#!/bin/bash 
set -e

CMD=deno
NAME=Deno

echo -e "\e[34m»»» 📦 \e[32mInstalling \e[33m$NAME\e[0m ..."

curl -fsSL https://deno.land/x/install/install.sh | sh

export PATH="$PATH:$HOME/.deno/bin"
echo -e "\n\e[31m»»» 📢 \e[32mNote! '\$HOME/.deno/bin' was temporarily added to your PATH"
echo -e "\e[31m»»» 📢 \e[32mAmend your shell startup scripts to make this change permanent"
echo -e "\e[34m»»» 💾 \e[32mInstalled to: \e[33m$(which $CMD)"
echo -e "\e[34m»»» 💡 \e[32mVersion details: \e[39m$($CMD --version)"