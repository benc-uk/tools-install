#!/bin/bash

# All scripts should source this, to check installation directory and PATH

echo -e "\e[34m»»» 📂 \e[32mWill install into: $1"
mkdir -p "$1"

if [[ :$PATH: == *:"$1":* ]] ; then
  echo -e "\e[34m»»» ✅ \e[32mPATH is good"
else
  echo -e "\e[34m»»» 😓 \e[31mInstall directory in not in PATH !"
  echo -e "\e[34m»»» 🔨 \e[31mWill temporarily ammend PATH...\n       Add 'export PATH=\$PATH:$1' to your ~/.bashrc or ~/.zshrc"
  export PATH="$PATH:$1"
fi