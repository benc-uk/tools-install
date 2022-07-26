#!/bin/bash

DIR="$( cd "$( dirname "$BASH_SOURCE" )" && pwd )"
source "$DIR"/_lib.sh
cd "$DIR" || exit

echo -e "\e[34m»»» 📦 \e[32mBacking up repo to GitHub\e[0m"

git add .
git commit -m "$(random_fruit) $(date)"
git push
