#!/bin/bash

NAME="Extra Node tools"
echo -e "\e[34m»»» 📦 \e[32mInstalling \e[35m\e[33m$NAME\e[0m ..."

npm install -g --quiet markdownlint-cli
npm install -g --quiet npm-check-updates
npm install -g --quiet prettier
npm install -g --quiet eslint
npm install -g --quiet browser-sync
npm install -g --quiet http-server
npm install -g --quiet nodemon
npm install -g --quiet --force npx 