#!/bin/bash
set -e

CMD=yarn
NAME="Yarn"

echo -e "\e[34m»»» 📦 \e[32mInstalling \e[33m$NAME\e[0m ..."

npm install -g yarn

echo -e "\n\e[34m»»» 👲 \e[32mYarn is now managed per-project, see https://yarnpkg.com/getting-started/install#per-project-install"
echo -e "\n\e[34m»»» 💾 \e[32mInstalled to: \e[33m$(which $CMD)"
echo -e "\e[34m»»» 💡 \e[32mVersion details: \e[39m$($CMD --version)"
